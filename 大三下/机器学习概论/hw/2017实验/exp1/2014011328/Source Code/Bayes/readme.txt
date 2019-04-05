本程序由java语言编写，源代码在src文件夹内，可执行文件在out文件夹内。
src中三个源文件说明:
	Sample.java : 为训练数据和测试数据编写的类
	Test.java : 利用朴素贝叶斯方法实现的分类器实现与测试
	Exercise.java : 在编写过程中一些小的编程问题的调试代码，可忽略不看

注：助教在运行时需要修改Test.java中16和84行的数据文件路径，如下:
	File file = new File("/Users/steven/Desktop/exp1/data1/train.txt");
	File file2 = new File("/Users/steven/Desktop/exp1/data1/test.txt");