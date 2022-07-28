# 使用方法

## 文档目标

关于大一小学期一些形而上学的课程体验，请参考计算机系的[课程攻略文档](https://docs.qq.com/doc/DZGp6VW5kUVZUWWtD)。与之不同，本文档的目标非常具体。

此文档参考了自 2019 年到 2021 年三年 Python 小学期的要求，综合了暑培课程讲义、往年优秀作业与本人所参与的多个应用爬虫与数据分析的 SRT 工作汇编而成，**希望能够为一字班选修了 Python 小学期的同学提供有力的自学预习材料，也之后需要使用相关 Python 工具的同学提供支持。**

**与暑培内容重叠的部分，汇编者进行了修订，例如为网页爬虫提供了包括 Facebook，Twitter，Youtube 等高强度反爬网页的实例。如果你参与了暑培的部分内容，仍然建议你阅读经过汇编者补充的例子。**

**暑培课程之外，汇编者扩充更多相应的文档，主要是 BeatifulSoup4，Pandas，Matplotlib，做到了对于小学期内容的全覆盖与降维打击。**

## 内容概述

```shell
.
├── CodeReview.md
├── DS_tutorial.pdf
├── Python
│   ├── Numpy.ipynb
│   └── Python\ Advanced\ Topics.ipynb
├── backend
│   ├── Django.md
│   ├── Django_preparation.pdf
│   └── SQL.pdf
├── crawler
│   └── crawler.ipynb
├── readme.md
├── soup
│   ├── BeatifulSoup4.ipynb
│   ├── Pandas.ipynb
│   ├── Pandas_refined.ipynb
│   └── README.md
└── visualize
    ├── Matplotlib.ipynb
    └── README.md

5 directories, 15 files
```

1. Python 路径下：[Python 基础语法](https://docs.net9.org/languages/python/)与 Python 进阶（IPython）、Numpy
2. Crawler 路径下：crawler
3. soup 路径下：BeautifulSoup4 与 Pandas
4. backend 路径下：Django
5. visualize 路径下：Matplotlib

### Python 语法基础
Python入门与基础语法，见 [Python 基础语法](https://docs.net9.org/languages/python/)。

### Python 进阶
Python Advanced Topics 文档主要分享一些 Python 的进阶内容，介绍一些实用技能栈。该文档涵盖 IPython 这一实用的 Python的交互式接口，以及 tqdm, argparse, pathlib 等实用 Python 库。

### Numpy
Numpy(Numerical Python 的简称) 几乎是整个 Python 科学计算生态系统的核心，它提供了高效存储和操作密集数据缓存的接口。这部分文档介绍了 Numpy 的用法，尤其强调了以下重点内容：
+ Numpy 和 Python 的效率区别
+ Numpy 广播机制的规则
+ Numpy Fancy Index
+ 传统索引的视图问题

### crawler
Crawler 文档主要讲述 Python 爬虫的基本用法以及实操建议，主要内容包括：
+ 最基本的 HTTP 知识以及如何利用浏览器 inspect 功能；
+ 解爬取网页的两大方式：利用 requests 发送请求，以及利用 selenium 模拟浏览器访问网页；
+ 实际操作过程中的注意事项；
+ 以不同类型的网页为例讲解什么情况下具体应当使用哪种方式。

### BeautifulSoup4
BeautifulSoup4 可以帮助我们来处理请求获得的 HTML 页面中的数据，进行过滤、筛选、查找，是 Python 爬虫的重要工具。这部分文档以大量实例介绍了 BeautifulSoup4 的 API 和基本用法。

### Pandas
Pandas 是在 NumPy 基础上建立的新程序库，提供了一种高效的 DataFrame 数据结构。DataFrame 本质上是一种带行标签和列标签、支持相同类型数据和缺失值的多维数组。Pandas 文档重点介绍该包中 Series、DataFrame 和其他相关数据结构的高效使用方法。

### Django
Django 是一个由 Python 编写的一个开放源代码的 Web 应用框架。 使用 Django，只要很少的代码，Python 程序开发人员就可以轻松地完成一个正式网站所需要的大部分内容，并进一步开发出全功能的 Web 服务。
Django 部分教程旨在帮助大家：
+ 了解如何使用 Django 开发一个简单应用程序；
+ 了解前后端分离的开发模式，学习如何使用 Django 搭建一个后端；
+ 掌握一种在服务器上部署 Django 的方式 （Django + Nginx + uWSGI 部署）。

### Matplotlib
Matplotlib 是建立在 NumPy 数组基础上的多平台数据可视化程序库，这部分讲义将详细介绍使用 Python 的 Matplotlib 工具实现数据可视化的方法，涵盖线形图、散点图、直方图等，包含了大量实例。

## 额外注意

Pandas 与 Numpy 小学期并不必用，但是熟练的使用这两个工具会使得你的工作更加优雅。

## 下载

若要下载单个文件夹，复制该文件夹的网址，粘贴入 [DownGit](https://minhaskamal.github.io/DownGit/#/home) 中，选择 download 即可。

## 使用方法

文档全部由 markdown 与 Jupyter Notebook 写成。

### Local Jupyter

你可以将仓库 clone 到本地使用，顺带练习你的 Git 技能，毕竟 QT 开发不使用 Git 会极度痛苦。同时，关于 Jupyter Notebook 和 Python 基础环境的配置请参考[此链接](https://zhaochen20.notion.site/Python-2f9538e9f6024827b55abbeb48025b30)。

### Google Colab

你也可以使用 Google Colab 服务。

* 首先打开 Google Colab 为 Github 适配的界面。点击此[链接](https://colab.research.google.com/github/)，在对应位置输入该仓库链接：

  ```tex
  https://github.com/zhaochenyang20/Sino-Japanese-Relations-analysis
  ```
  
  然后 Enter，Colab 便会自动爬取该仓库的全部 ipynb 文件，并以列表形式显示在下面。点击对应文件右侧图标，便可以在新标签页打开该笔记本。
  
  ![colab.jpg](https://wkphoto.cdn.bcebos.com/48540923dd54564e2f51075fa3de9c82d1584fa4.jpg)

**注意事项**

1. 由于 Colab 自带的包的版本都很低，可能会出现部分 API 不兼容的情况。所以在使用下列笔记本时，建议在运行前先进行包的安装和更新，创建一个新的代码框，在对应的笔记本下运行如下指令即可。

    **Numpy.ipynb**

    ```bash
    ! pip install --upgrade numpy
    ```

    **BeatifulSoup4.ipynb**

    ```bash
    ! pip install --upgrade beautifulsoup4
    ```

    **Pandas.ipynb**

    ```bash
    ! pip install --upgrade pandas
    ! pip install --upgrade pandas-datareader
    ```

    **Matplotlib.ipynb**

    ```bash
    ! pip install --upgrade matplotlib
    ! pip install --upgrade basemap
    ! pip install basemap-data-hires
    ```

    在安装和更新完毕后，Colab 会输出如下 log：

    ```
    WARNING: The following packages were previously imported in this runtime:
      [···]
    You must restart the runtime in order to use newly installed versions.
    ```

    此时需要点击 log 下方的 `RESTART RUNTIME` 按钮即可将更新应用，接下来你便可以正常使用笔记本了。

  2. 如果你发现有部分系统命令（即在 Jupyter Notebook 中以 ! 开头）无法运行，请尝试点击界面中的“复制到云端硬盘”，在 Google Drive 中的副本中运行。

## 学习顺序

建议小学期选择了 Python 的同学，按照[基础语法](https://docs.net9.org/languages/python/)，IPython，Crawler，BeautifulSoup4，Matplotlib，DJango 的顺序进行学习。而其余两块内容 Numpy，Pandas 在小学期使用并不多，可以留作个人兴趣衍生。

## 补充说明

由于时间仓促，错误在所难免，如若文档出现问题，请及时在本仓库的 [Issue](https://github.com/zhaochenyang20/Sino-Japanese-Relations-analysis/issues) 界面提出。

# 为何而写

## 初起

暑假初期，我在处理暑培课程安排时，王导突然来找我，询问科协是否有课程指引方向的资料，类似 [docs9](https://docs.net9.org/) 的风格。

>  一字班同学在问有没有零字班好哥哥好姐姐帮忙介绍介绍大一小学期，包括新雅那边他们也准备搞…

作为技能文档的参与者，我不得不说，技能文档的初衷本身即是希望大家收获课程之外的一些能力，能够在课程当中使用到，而并不是刻意针对课程的。比如暑假之后我们会更新 Numpy，Pandas，IPython 的内容，这些内容绝非课程必须，只是在课程作业中使用会让你的作业更加优雅有效。更何况，科协的一大初衷也是希望能够带大家认知到除了课业之外还有广阔的计算机科学与技术的天地，而绝非课程的一亩三分地。

因此，暑假结束前科协恕难提供这方面的支持，毕竟即便是暑培现有资料的整合，也需要有非常多后续的整理修改工作。为了打造臻于完美，服务后人的技能文档，网络部相关的同学们用心可谓良苦。

我只能回复王导，关于小学期的课程指南，可以参考计算机系的[课程攻略文档](https://docs.qq.com/doc/DZGp6VW5kUVZUWWtD)。然而，类似 docs9 这类的文档，困难太大，恕难从命。

如此想来，这件事情的确与我无关。**作为技能文档组的编写者与计算机系课咨委的一员，我尽到了我的责任。而且我已经度过了许多让我体验不佳的课程，按说这辈子我不可能再受这些课程的苦，下辈子我也不会再学计算机这专业。一切都与我无关，不妨如同大多数麻木的人一样，事不关己，高高挂起。**

## 转折

然而，之后几天，我的良知却不免惴惴难安。

这真的是我渴望的生活吗？

参加课咨委的工作一整年了，我逐渐感知到，我之所以对于推动系内的课程改革有如此热忱，何尝不是不抱有薪火相传的初衷？

在我入学之前，就有杰哥等贵系的先辈们，积极地推动体系结构课程的改革，才能够让如今系内体系结构课程的体验有了大幅提升。之后，九字班学长学姐对小学期课程的提议和反馈得到了老师们的认可，才让零字班小学期压力控制在了合理的高压范围内，而非九字班所经历的魔鬼夏天。如果没有这些先辈学长学姐对于课改的探索，如果没有他们点亮了课改的火炬，我们现在又会经历怎样难堪的课程体验？

更何况，如果没有改革和参与改革的意识，每个人都安于现状，要么觉得事不关己高高挂起，要么觉得经历过的折磨一辈子不会有第二次，就选择对于任何意义的改革作壁上观，那么现在我们所生活的国家至今还是**大清**，绝非现在的中国。诚然我也激烈地批判着当下中国社会的种种弊病，然而我没谁也不愿意回到生产力落后，文化闭塞的清朝。社会改革促进了生产力的伟大进步，即便前人为了改革做出的牺牲已经让大多阅读到此处的人过上了衣食无忧的生活，然而我仍然坚信改革的火炬将会薪火相传。

于是乎，我再次想到了王导的问题。难道科协除了内容广泛的暑培外，暂时无法提供细致专业服务于小学期的指导，就不得不让同学们经历以往的前辈们在大一暑假曾经经历过的那些折磨吗？

绝不，至少我们还可以抱团自救。

>  **星星之火，可以燎原。**

虽然目前计算机系的部分课程质量仍然堪忧，**但是我们每提出一次课改意见，每贡献一次开源资料，都会为计算机系课程质量提升留下不可磨灭的贡献**。我们会帮助到之后的学弟学妹，更高年级学长学姐也会如此帮助我们。

## 尾声

于是乎，就有了你看到的此份文档。这份文档是我个人邀请三位一字班计算机系或者软院的同学们一同参考暑培讲义所编写的。基本涵盖了小学期 Python 课程的所有需求。在暑培课程之外，我们扩充了相应的文档和资料。从[语法基础](https://docs.net9.org/languages/python/)，到 IPython，Numpy，Pandas，BeautifulSoup4，Matplotlib，Django 等全部资料。

<img src="https://raw.githubusercontent.com/zhaochenyang20/zhaochenyang20.github.io/master/img/profile_7.jpg" style="zoom:15%;" />

# 致谢

## 汇编者

- [lurf21](https://github.com/lurf21)

- [QuentinHsuow](https://github.com/QuentinHsuow)

- [luohaowen2003](https://github.com/luohaowen2003)

## 暑培讲师

- [Eren Zhao](https://zhaochenyang20.github.io/about/)

- [c7w](https://github.com/c7w)
- [lambda](https://github.com/Btlmd)
- [ayf](https://github.com/ayf19)

## 打工仔

- [learning Rate](https://github.com/lr-tsinghua11)

