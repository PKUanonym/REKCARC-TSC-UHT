# 软工协作 Tips 及平台配置方法

> 当时在几乎无有用文档的情况下（2022 春），经过一番折腾后总结的软工平台使用方法，仅供参考。某些内容可能因为软工平台升级而失效，请注意。

## 创建项目

#### 在软工平台上新建仓库

如果需要部署仓库内容到服务器上，必须要在软工平台（SECoder）上的 `项目管理 - 仓库管理` 中新建，否则之后无法使用 `deployer` 部署到提供的服务器上。

#### 分支管理

仓库中应该有如下分支：

- `master`（或 `main`）：主分支，用于部署生产环境
- `dev`：开发分支，所有最新的改动合并到此分支，定期合并到 `master` 分支
- 其他开发分支（例如 `feat/login`）：开发某一新功能时新建的分支，开发完成后合并到 `dev` 分支

需要注意 `master` 和 `dev` 只能通过 merge request 由其他分支合并，不能直接 push。另外，新建开发分支时一定要从 `dev` 分支上新建，不能从其他开发分支上新建。

#### 仓库配置

GitLab 中有几项设置对后续协作开发有不小的帮助，值得花点时间配置一下：

1. 在 `General - Merge request` 中取消选择 `Merge options` 下的 `Enable 'Delete source branch' option by default`。课程需要保留开发过程中的分支，需要避免不小心删除分支的情况。
2. 在 `Repository - Default Branch` 中将 `Default Branch` 设置为 `dev`，使得进行 merge request 时默认合并到 `dev` 分支。
3. 在 `Repository - Protected Branches` 中添加 `master` 和 `dev` 都设置为受保护的分支，并禁止任何人直接 push 到这两个分支上。

#### 增加 issue template 和 merge request template

在仓库目录下新建文件夹 `.gitlab/issue_templates/`，并在其中添加若干 Markdown 文件，这些文件将可用作新建 issue 时作为模版供选择。例如，针对 bug 的 issue：

```markdown
<!-- Title 格式：[bug] Bug 描述 -->
## 复现过程

1. 
2. 

## 当前的行为
<!-- 当前版本存在的问题行为 -->

## 预期的行为
<!-- 正常应当有怎样的行为 -->
```

添加模版之后，在新建 issue 时可以选择其中之一作为模版，保证 issue 的规范和质量。

同理，可以为 merge request 添加模版，可以参考 [Quick-Red 的模版](https://github.com/prnake/Quick-Red/blob/master/frontend/.gitlab/merge_request_templates/CodeReview.md)。

## CI/CD

CI/CD 简单来说就是在服务器上执行一系列命令，从而自动化地在每次提交代码之后完成测试、检查、构建等工作，并在需要时完成部署。

#### Stage 和 job

Stage 指的是 CI/CD 的不同阶段，用来完成不同阶段的工作，一般情况下**顺序执行**。你可以使用 GitLab 的 DAG 功能使得没有依赖关系的 stage 并行运行以加快速度，具体可以参考 [官方文档](https://docs.gitlab.com/ee/ci/directed_acyclic_graph/)。

在软工项目中的 stage 通常包括：

- pre：准备阶段，完成依赖库缓存的拉取和保存等
- build：构建 Docker 镜像
- test：单元测试、代码风格检查、上传代码质量报告（sonar）
- deploy：将镜像部署到服务器上

在 `.gitlab-ci.yml` 开头声明 stage：

```yml
stages:
  - pre
  - build
  - test
  - deploy
```

需要注意的是，不同 stage 之间的环境是相互隔离的。比如，在前面的 stage 中如果安装了项目依赖（如 `npm install`），在后面的 stage 中仍然需要安装这些依赖。在后面将会介绍加快这一过程的方法。

Job 指的是 stage 内部的若干个任务单元，执行具体的命令，同一个 stage 的所有 jobs 是**并行执行**的，环境也是相互隔离的。

Job 一些常用的属性有：

- `stage`：指定这个 job 所属的 stage；若不指定，默认为 `test`
- `script`：这个 job 执行的命令行命令
- `before_script`：在执行 `script` 之前执行的命令，一般用于环境配置
- `after_script`：在执行 `script` 之后执行的指令，比如使用 `sonar-scanner` 上传在 `script` 中得到的覆盖率报告
- `only` 和 `except`：用于指定运行此 job 的条件，比如生产环境的部署对应的 job 只在 `master` 分支上进行

具体的用法可以参考 GitLab 文档。

#### Hidden jobs 与继承

如果多个 job 有大量相同的配置，可以使用继承的方法避免重复编写相同配置。比如，我们对 Node.js 项目分别进行单元测试和代码风格检查，而它们都需要安装相同的依赖、都属于 `test` stage。

首先，定义一个以 `.` 开头的 job，这个 job 为 hidden job，不会被执行：

```yml
.test:
  stage: test
  before_script:
    - npm config set registry http://mirrors.cloud.tencent.com/npm/
    - npm install
```

> 第一条命令用于将 npm 使用的源设置为国内腾讯云镜像，这将大大加快加载速度。

然后，在真正的 job 中，使用 `extends` 继承此 job：

```yml
lint-test:
  extends: .test
  script:
    - npm run lint

unit-test:
  extends: .test
  script:
    - npm run test:ci
```

这两个 job 因此拥有了与 `.test` 相同的 `stage` 和 `before_script` 属性。

你还可以继承多个 hidden job，具体行为可以查阅有关文档。

#### 加快速度：cache

对于使用如 Node.js 这样的需要安装大量依赖库的项目，如果在每个 stage 中、每次 CI/CD 都重新安装一次依赖，CI/CD 的效率将会非常低。对这个问题，我们可以使用 GitLab 的 cache 功能将这些依赖缓存起来供重复利用。

因为每个 job 的环境都是独立的，因此每个 job 都需要定义缓存。我们使用 hidden job 完成统一配置：

```yml
.cache:
  cache:
    key: ${CI_COMMIT_REF_SLUG}
    paths:
      - node_modules/
      - package-lock.json
    policy: pull
```

其中，`key` 使用分支名（`${CI_COMMIT_REF_SLUG}`），即不同的分支使用不同的缓存，而同一分支下的所有 job 共享这份缓存。`paths` 指定了缓存项的路径，这里我们将 Node.js 的依赖文件缓存起来。`policy` 设置为 `pull` 的目的是，每次只从服务器上拉取缓存，而不需要在结束之后将此缓存上传到服务器上。这很重要，因为我们不希望每个 job 都重复地上传相同的缓存。

我们在 `pre` 阶段中添加一个 job 用来更新缓存：

```yml
node-cache:
  stage: pre
  extends: .cache
  cache:
    policy: pull-push
  script:
    - npm config set registry http://mirrors.cloud.tencent.com/npm/
    - npm install
```

注意到，我们将 cache policy 更改为了 `pull-push`，这是因为我们需要将此缓存上传到服务器上供其他 job 和 pipeline 使用。

然后，在需要用到此缓存的 job 中，继承 `.cache` 即可：

```yml
build:
  stage: build
  extends: .cache
  script:
    - npm config set registry http://mirrors.cloud.tencent.com/npm/
    - npm install
    - ...
```

这个 job 将会从服务器上拉取最新的缓存，从而无需重新下载。

当然，以防万一，还是加上一句 `npm install`，虽然正常情况下这条命令并不会从网络上下载依赖，因为在 `pre` 阶段我们已经下载好了需要的依赖。

## Sonar 与单元测试的配置

课程要求使用 Sonar 对源代码进行静态分析。既然是静态分析，那么 Sonar 需要测试工具执行测试生成测试报告，才能进行分析。因此，测试与报告的流程为：

1. 测试工具执行测试，并输出测试结果
2. 使用 `sonar-scanner` 对测试结果和源代码进行分析并上传分析结果

#### 使用测试工具生成测试报告

Sonar 需要提供 xml 格式的测试报告，对于不同语言、框架的方法不同，可以到搜索引擎上搜索生成报告的方法。在这里分享一下我们项目使用的框架（Django、React（create-react-app）、Go）适用的方法。

**Django**

如果直接使用 `pytest`，可以参考 [Quick-Red](https://github.com/prnake/Quick-Red/tree/master/backend)。

如果使用 Django 自带的测试框架 `django.test`：

需要安装以下依赖：

```text
pytest
coverage
unittest-xml-reporting
```

在 `settings.py` 中，添加如下配置：

```python
# 指定 test runner 为 xmlrunner
TEST_RUNNER = 'xmlrunner.extra.djangotestrunner.XMLTestRunner'
# 指定报告输出目录
TEST_OUTPUT_DIR = 'xunit-reports/'
# 指定报告文件名
TEST_OUTPUT_FILE_NAME = 'xunit-result.xml'
```

然后，运行

```bash
python -m coverage run --source path1,path2,...,pathn manage.py test
python -m coverage xml -o coverage-reports/coverage.xml
```

其中，`path1`、`path2` 等替换为包括在覆盖率报告中的文件/文件夹路径。

这样，分别生成了测试报告 `xunit-reports/xunit-result.xml` 和覆盖报告 `coverage-reports/coverage.xml`。

这些命令仅完成了最基本的测试报告的配置。关于可选的命令行参数，请参考 [官方文档](https://coverage.readthedocs.io/en/6.3.2/cmd.html)。

**React（create-react-app）**

create-react-app 预置了 Jest，无需手动安装。

安装 `jest-sonar`：

```bash
npm install --save-dev jest-sonar
```

在 `package.json` 的 `scripts` 中添加：

```json
"test:ci": "CI=true react-scripts test --coverage --reporters=jest-sonar --collectCoverageFrom=src/**/*.js"
```

然后，执行：

```bash
npm run test:ci
```

这样，在 `coverage` 目录下会生成测试报告。

这条命令仅完成了最基本的测试报告的配置。关于可选的命令行参数，请参考 [官方文档](https://jestjs.io/docs/cli#options)。

#### Golang

执行

```bash
go test -cover -race -v -coverprofile=coverage.out ./...
```

#### 配置 sonar-project.properties 文件

我们通过项目根目录下的 `sonar-project.properties` 文件对 Sonar 进行配置。一些配置如下：

```conf
# 源代码所在目录
sonar.sources=src
# 包含测试文件的路径，sonar 将会寻找其中的所有测试文件
sonar.tests=src
# 包含在测试分析内的测试文件
sonar.test.inclusions=src/**/__tests__/*.test.js
# 排除在所有分析之外的路径
sonar.exclusions=node_modules/**,coverage/**
# 覆盖率分析时排除在外的路径
sonar.coverage.exclusions=src/utils/**/*.js
```

另外，还需要提供已经得到的测试报告的路径。对于 JavaScript：

```conf
sonar.javascript.lcov.reportPaths=coverage/lcov.info
sonar.testExecutionReportPaths=coverage/sonar-report.xml
```

对于使用 `coverage` 进行分析的 Python 代码：

```conf
sonar.python.coverage.reportPaths=coverage-reports/coverage.xml
sonar.python.xunit.reportPath=xunit-reports/xunit-result.xml
```

对于 Go：

```conf
sonar.go.coverage.reportPaths=coverage.out
```

这里路径需要改成上面一步所设置的覆盖报告和测试报告的路径。

#### 设置 CI

在 CI 中，定义一个 job 用来执行测试和上传报告：

```yml
unit-test:
  ...
  script:
    # 执行测试的命令
  after_script:
    - SUFFIX=$RANDOM
    - curl "http://10.0.0.11/sonar-scanner.tar.gz" -s -o "/tmp/sonar-$SUFFIX.tar.gz"
    - tar -xf "/tmp/sonar-$SUFFIX.tar.gz"  -C /opt
    - /opt/sonar-scanner/bin/sonar-scanner
```

## Dockerfile

> 可参考科协暑培文档：https://liang2kl.github.io/2022-summer-training-docker-tutorial/

将代码部署在服务器上需要配置环境、编译应用、安装应用、开启服务等一系列操作，而 Docker 使得我们可以预先完成或指定这些操作，从而能够实现自动部署；Dockerfile 就是我们定义这些操作的地方。

在软工平台上使用 `deployer` 构建、上传 Docker 镜像，并使用此镜像进行部署。大概的逻辑是：

1. 通过 Dockerfile 内的一系列语句预先配置好所需的环境并打包成镜像
2. 将镜像上传到软工平台的镜像站上
3. 部署时，拉取之前构建好的镜像，并在一个容器中运行，这样就完成了部署

这个过程在 `.gitlab-ci.yml` 中使用多个 job 完成：

```yml
# 构建 Docker 镜像
build:
  stage: build
  script: 
    - export BUILD_IMAGE_NAME=$CI_REGISTRY_IMAGE
    - export BUILD_IMAGE_TAG=$CI_COMMIT_REF_SLUG
    - export BUILD_IMAGE_USERNAME=$CI_REGISTRY_USER
    - export BUILD_IMAGE_PASSWORD=$CI_REGISTRY_PASSWORD
    - deployer build

# 使用镜像部署
deploy:
  stage: deploy
  script:
    - deployer dyno replace $CI_PROJECT_NAME "$CI_REGISTRY_IMAGE:$CI_COMMIT_REF_SLUG" "$REGISTRY_USER" "$REGISTRY_PWD"
```

`build` 的多个 `export` 指定了上传时使用的镜像名、tag、使用的用户名和密码；`deployer build` 命令完成了 (1) 使用 `docker build` 根据 Dockerfile 进行镜像构建，(2) 将镜像上传到平台上；`deploy` 工作将 `build` 中上传的镜像部署到服务器上。这样就完成了整个部署过程。

所以，我们需要做的，就是在 Dockerfile 中描述配置容器的过程。

#### 配置 Dockerfile

首先，指定一个“基础镜像”，即使用一个预先配置好的镜像，在这个镜像的基础上配置我们的镜像。比如，对于 Node.js 应用，我们使用官方的 `node` 镜像：

```dockerfile
FROM node:latest
```

在这之后，我们就在一个配置好了 Node.js 的环境中了。

接下来，无非就是执行一系列语句来编译我们的应用，并将其拷贝到合适的位置。这部分内容可以参考软工课程给出的样例文件。

比如，编译 React 应用：

```dockerfile
# 第一个阶段：使用 node 镜像编译 React 应用；将此阶段命名为 build
FROM node:latest as build

# 设置环境变量 HOME
ENV HOME=/opt/app

# 将工作目录设为 HOME，并拷贝当前目录（项目代码）到 HOME 中
WORKDIR $HOME
COPY . $HOME

# 安装依赖
RUN npm config set registry http://mirrors.cloud.tencent.com/npm/
RUN npm install
# 执行 React 的 build，获得网页文件
RUN npm run build

# 第二个阶段：配置使用 nginx 容器，使得可以通过 HTTP 访问
FROM nginx:1.19

# 从第一个阶段（build）拷贝文件
# 拷贝编译后的网页文件到 nginx 的目录下
COPY --from=build /opt/app/build /usr/share/nginx/html
# 拷贝 nginx 配置文件（储存在源代码中）
# 对于 nginx 的配置和使用，你可能需要查阅相关文档，也可以直接使用已有的样例
COPY --from=build /opt/app/nginx.conf /etc/nginx/nginx.conf

# 暴露容器的 80 端口
EXPOSE 80

# 这里定义了容器启动时执行的命令（开启 Nginx 服务），注意并不是在构建镜像时执行
CMD ["nginx", "-g", "daemon off;"]
```

有关 Dockerfile 的语句，可以参考 [Docker - 从入门到实践](https://yeasy.gitbook.io/docker_practice/image/build)（中文）或 [Dockerfile 官方文档](https://docs.docker.com/engine/reference/builder/)（英文）。

#### 在 CI 中向 Dockerfile 传递环境变量

有时候，我们需要向 Dockerfile 中传递环境变量，比如使用不同的环境部署生产环境和开发环境的代码。但是，`deployer` 并不会向 `docker build` 传递环境变量，因此在 Dockerfile 中是无法获取到我们希望传递的环境变量的。

一种不太优雅的解决办法是：使用不同的 Dockerfile，直接在 Dockerfile 中用 `ENV` 语句设置环境变量。

比如，当前项目根目录下有两个文件：用于生产环境的 `Dockerfile`，以及用于开发环境的 `Dockerfile-dev`，它们的唯一区别是，`Dockerfile-dev` 设置了一个名为 `REACT_APP_IS_DEV_SERVER` 的环境变量，在我们的 React 应用中需要根据此环境变量判断所处的是否为生产环境：

```dockerfile
ENV REACT_APP_IS_DEV_SERVER=true
```

但是，因为 `deployer` 无法指定构建镜像所使用的 Dockerfile 而只能使用文件名为 `Dockerfile` 的文件，我们需要将文件更名为 `Dockerfile`。在 CI 中，分别为生产环境和开发环境定义 build 的 job：

```yml
build:
  extends: .build
  only:
    - master

build-dev:
  extends: .build
  before_script:
    - rm Dockerfile
    - mv Dockerfile-dev Dockerfile
  except:
    - master
```

我们用 `Dockerfile-dev` 替代了 `Dockerfile`，实现了根据条件传递环境变量的目的。

## 数据库配置

对于需要使用 Client/Server 通信模式数据库的情况，需要部署一个独立的数据库服务器。下面以 MySQL 为例。

对于其他数据库，过程大同小异，只需要完成：

- 创建仓库并设置好 CI/CD
- 将持久卷挂载到数据库储存文件的位置
- 设置好数据库访问的用户名和密码、创建数据库、授予权限等初始化工作
- 在后端上配置好访问数据库的信息

#### 建立仓库、配置持久卷和端口

在软工平台上创建数据库所用的仓库，并在软工平台 `项目管理 - 部署管理 - 持久储存` 中新建一个持久卷。

之后，在上方 `容器` 中打开数据库容器，在 `挂载` 一栏中选择此持久卷，挂载点设置为 `/var/lib/mysql`。这是因为 MySQL 所有的数据库文件均储存在此目录下，将持久卷挂载到此目录上可以保持数据库文件不因重新部署而丢失。

在容器的 `端口` 中添加 MySQL 使用的 `3306` 端口。

#### 配置 CI/CD

`.gitlab-ci.yml` 和 Dockerfile 直接使用 [Quick-Red](https://github.com/prnake/Quick-Red/tree/master/mysql) 的配置即可。

#### 初始化数据库

初次部署完成后，需要进入容器初始化 MySQL。在软工平台数据库容器下打开 `管理 - 终端`，进入容器。

然后，执行 `mysql` 命令进入 MySQL。

首先，设置数据库 `root` 用户的密码（`<password_root>` 设置为你想要设置的密码）：

```sql
ALTER USER 'root'@'localhost' IDENTIFIED BY '<password_root>';
```

接下来，创建供外部访问的账号（`<password_remote>` 设置为外部访问时使用的密码）：

```sql
CREATE USER 'django'@'%' IDENTIFIED BY '<password_remote>';
```

在这里，`'django'@'%'` 的意思是，创建一个从任意 IP 访问（`%`）、用户名为 `django` 的账户。`django` 可以设置为你想设置的用户名。注意用户名尽量不要使用 `root`，会产生冲突。
然后，创建一个空的数据库（`db_name` 更改为你想要设置的名称）：

```sql
CREATE DATABASE db_name;
```

将此数据库的访问权限授予远程用户（注意修改 `db_name` 和 `django`）：

```sql
GRANT ALL PRIVILEGES ON db_name.* TO 'django'@'%';
```

最后，更新权限：

```sql
FLUSH PRIVILEGES;
```

这样，我们就可以在后端服务器上访问此数据库了。

#### 配置 Django

这里以 Django 为例配置使用上面已经配置好的 MySQL 数据库。

在软工平台中，创建一个“配置”，并上传一个包含数据库访问信息的 JSON 文件：

```json
{ 
    // 在 MySQL 中新建的数据库名
    "MYSQL_NAME": "db_name",
    // 配置数据库时设置的远程访问用户名
    "MYSQL_USER": "root",
    // 配置数据库时设置的远程访问密码
    "MYSQL_PASSWORD": "<password_remote>",
    // 数据库服务器的本地地址，在软工平台上可以找到
    "MYSQL_HOST": "example-app.secoder.local",
    // MySQL 端口
    "MYSQL_PORT": 3306
}
```

然后，在软工平台的后端容器中将此文件（配置）挂载到源代码所在的子目录下（这里你可能需要查看你的 Dockerfile 来获取容器中源代码所在的目录）。注意，这个操作会将此目录的所有内容替换为上面配置的内容，因此**不要将其挂载到源代码根目录下，也不要将其挂载到任何一个原有的子目录下**。

在 settings.py 中，读取配置文件（这里，我们把配置文件目录挂载到了 代码目录/config，文件名为 ‌config.json）：

```python
if os.path.isfile("config/config.json"):
    with open("config/config.json", "r") as file:
        env = json.load(file)
```

然后，将 `DATABASES` 更改为：

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': env["MYSQL_NAME"],
        'USER': env["MYSQL_USER"],
        'PASSWORD': env["MYSQL_PASSWORD"],
        'HOST': env["MYSQL_HOST"],
        'PORT': env["MYSQL_PORT"],
        'OPTIONS': {'charset': 'utf8mb4'},
    },
}
```

至此，Django 就可以使用 MySQL 服务器了。注意，你应该避免在开发环境中使用生产环境的 MySQL 服务器，这个问题可以通过挂载不同的配置文件解决。
