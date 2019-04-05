# Individual Project for Foundation of OOP 2017

## Delaunay triangulation for calculating Euclidean distance minimum spanning tree

> created by n+e	2017-04-26

在 *Ubuntu 16.04* 下测试通过。

### 依赖

Cmake、OpenCV2、CGAL、Boost、libcgal-qt5-dev

### Usage

解压缩后，运行下列命令：

```bash
cd src/build
cmake -G"Unix Makefiles" .. # 如果不行的话，试试 'cmake -G"Unix Makefiles" -DCGAL_DIR=$你的cgal路径 ..'
make -j4
```

得到可执行文件 *main*



运行

```bash
./main -h
```

可查看具体使用方法

