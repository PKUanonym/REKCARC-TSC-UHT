# 使用方法

```bash
cd problem
make -j4
```

然后会生成`main`，执行`./main kmp`或者`./main kr`即可运行。

-------

模板可以手动添加，只要在`problem/data.txt`下添加文件路径即可。

需要匹配的字符集加进`problem/pattern.txt`中，**第一行为分隔字符串**，比如下面就是一个例子：

```txt
// this is a seperator
#include <cstdio>
int main()
{
  return 0;
}
// this is a seperator
a
// this is a seperator
Your GPA is 4.0!
```

上面就说明了需要匹配的三个pattern。当然，可以把`// this is a seperator`改成任意的字符串。

