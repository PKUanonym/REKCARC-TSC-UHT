# MNIST Digit Classification with MLP

## 参数选择

为了方便比较，本次报告无特殊说明，均采用如下参数：

```js
config = {
    'learning_rate': 0.1,
    'weight_decay': 0,
    'momentum': 0,
    'batch_size': 100,
    'max_epoch': 100,
    'disp_freq': 300,
    'test_epoch': 1
}
```

`learning_rate` 较大，一方面是因为实现的线性层中反向传播使用了平均而不是求和，常数上要乘以`1/batch_size`，另一方面经过测试这个`learning_rate`能保证快速收敛，并且相较于更小的`learning_rate`对训练拟合结果无明显差异。

Hinge Loss 的`margin`设为`0.5`，一开始由于使用默认的`5`导致了一些问题。

隐藏层大小选择为`100X100`，双隐藏层则再增加大小为`256X256`的一层。

优化 `run_mlp.py` 方便批量训练。

```bash
> python3 run_mlp.py -h
usage: run_mlp.py [-h] [--layer LAYER] [--batch BATCH] [--epoch EPOCH] [--activation ACTIVATION]
                  [--loss LOSS]

optional arguments:
  -h, --help            show this help message and exit
  --layer LAYER         count of hidden layers
  --batch BATCH         count of hidden layers
  --epoch EPOCH         count of hidden layers
  --activation ACTIVATION
                        (R)Relu/(S)Sigmoid/(G)Gelu
  --loss LOSS           E(EuclideanLoss)/S(SoftmaxCrossEntropyLoss)/H(HingeLoss)
```

## Single Hidden Layer MLP

### 训练

```bash
> cat train.sh
python3 run_mlp.py --activation G --loss E
python3 run_mlp.py --activation G --loss S
python3 run_mlp.py --activation G --loss H
python3 run_mlp.py --activation R --loss E
python3 run_mlp.py --activation R --loss S
python3 run_mlp.py --activation R --loss H
python3 run_mlp.py --activation S --loss E
python3 run_mlp.py --activation S --loss S
python3 run_mlp.py --activation S --loss H
> sh train.sh
```

网络架构为

```
Image(768)
Linear(768->100)
Activation
Linear(100->10)
Loss
```

### 数据

#### 比较表格

##### 训练集准确率（%）

| 激活函数\损失函数 | EuclideanLoss      | **SoftmaxCrossEntropyLoss** | HingeLoss              |
| ----------------- | ------------------ | --------------------------- | ---------------------- |
| Relu              | 0.9836333333333335 | **0.9999333333333333**      | 0.9635999999999999     |
| Sigmoid           | 0.9565333333333332 | 0.9887999999999999          | 0.9936333333333335     |
| Gelu              | 0.9800666666666666 | **0.9998**                  | **0.9978666666666667** |

##### 训练集Loss

| 激活函数\损失函数 | EuclideanLoss        | **SoftmaxCrossEntropyLoss** | HingeLoss           |
| ----------------- | -------------------- | --------------------------- | ------------------- |
| Relu              | 0.03245183104056564  | 0.003718301291387246        | 0.1826615979806519  |
| Sigmoid           | 0.051790117122938926 | 0.04478277936694891         | 0.04405447016171317 |
| Gelu              | 0.03721945680266789  | 0.004468202671948444        | 0.18879977064320258 |

##### 测试集准确率（%）

| 激活函数\损失函数 | EuclideanLoss      | **SoftmaxCrossEntropyLoss** | HingeLoss          |
| ----------------- | ------------------ | --------------------------- | ------------------ |
| Relu              | 0.9727000000000001 | **0.978**                   | 0.9533000000000001 |
| Sigmoid           | 0.9547000000000003 | 0.9749000000000001          | 0.9731000000000002 |
| Gelu              | 0.9726             | **0.9770000000000002**      | 0.9714999999999999 |

##### 测试集Loss

| 激活函数\损失函数 | EuclideanLoss        | **SoftmaxCrossEntropyLoss** | HingeLoss           |
| ----------------- | -------------------- | --------------------------- | ------------------- |
| Relu              | 0.0443127187212732   | 0.08022679303687924         | 0.2231040125306122  |
| Sigmoid           | 0.053668094819627095 | 0.07873228832396637         | 0.06507242253475932 |
| Gelu              | 0.043198286610261684 | 0.09227399562407555         | 0.22495735127343672 |

#### 训练图表

##### fc_gelu_fc_Euclidean

![fc_gelu_fc_Euclidean](https://i.loli.net/2021/10/04/sopf97UC8hMkEBa.png)

##### fc_gelu_fc_Hinge

![fc_gelu_fc_Hinge](https://i.loli.net/2021/10/04/Vmlsv8tUoq9g1Gc.png)

##### fc_gelu_fc_SoftmaxCrossEntropy

![fc_gelu_fc_SoftmaxCrossEntropy](https://i.loli.net/2021/10/04/R2pCxZhDMKQaiOA.png)

##### fc_relu_fc_Euclidean

![fc_relu_fc_Euclidean](https://i.loli.net/2021/10/04/8MX2yLafoiVrsnk.png)

##### fc_relu_fc_Hinge

![fc_relu_fc_Hinge](https://i.loli.net/2021/10/04/42y5wIGO7DrUKpd.png)

##### fc_relu_fc_SoftmaxCrossEntropy

![fc_relu_fc_SoftmaxCrossEntropy](https://i.loli.net/2021/10/04/CkJKdymoOlEbsYg.png)

##### fc_sigmoid_fc_Euclidean

![fc_sigmoid_fc_Euclidean](https://i.loli.net/2021/10/04/svEicpb9LHDPqSe.png)

##### fc_sigmoid_fc_Hinge

![fc_sigmoid_fc_Hinge](https://i.loli.net/2021/10/04/LrkhlWMXHeIyDg1.png)

##### fc_sigmoid_fc_SoftmaxCrossEntropy

![fc_sigmoid_fc_SoftmaxCrossEntropy](https://i.loli.net/2021/10/04/khnpSutHLKbPB5M.png)

### 结果分析

#### 计算效率

从数学推导和运行实际可以得出不同函数的计算效率（速度）：

- 激活函数：$Gelu > Sigmoid > Relu$
- 损失函数：$Hinge Loss \ge Softmax CrossEntropy > Euclidean Loss$

他们速度的差异是常数倍的。

#### 分类效果

从最终的准确率与Loss结果和图像可以得出在 MNIST Digit Classification 这一工作中不同函数的分类效果：

- 激活函数：$Gelu > Relu > Sigmoid$
- 损失函数：$Softmax CrossEntropy \approx Hinge Loss > Euclidean Loss$

整体上说都能在单隐藏层下取得较好成绩。

无明显过拟合现象。

#### 训练速度

即收敛到稳定值需要的轮数，我认为由于每个函数的实现有区别，实际的 `learning_rate` 并不相同，因此无法比较不同函数在这一项上的区别。

#### 抖动

部分图像收敛后存在抖动应该也是由实际 `learning_rate` 过大引起。

另一方面`Gelu`和`Hinge`对变化比较敏感，这很可能是`fc_gelu_fc_Hinge`抖动最为明显的原因。

## Two Hidden Layer MLP

选择单隐藏层中结果最好的 `Relu` 与 `SoftmaxCrossEntropy` 组合进行双隐藏层测试。

```python
python3 run_mlp.py --activation R --loss S --layer 2
```

网络架构为

```
Image(768)
Linear(768->256)
Relu
Linear(256->100)
Relu
Linear(100->10)
SoftmaxCrossEntropy
```

### 数据

#### 结果

```
fc_relu_fc_relu_fc_SoftmaxCrossEntropy
training_acc:1.0
training_loss:0.00038202421591634135
testing_acc:0.9798999999999998
testing_loss:0.09982166265407472
```

#### 训练图表

##### fc_relu_fc_relu_fc_SoftmaxCrossEntropy

![fc_relu_fc_relu_fc_SoftmaxCrossEntropy](https://i.loli.net/2021/10/04/L8fBeIETkanYAqS.png)

### 结果分析

使用双隐藏层无明显增强（相比单隐藏层增强了0.19%，这可能和单隐藏层的准确率已接近饱和有关），也不存在过拟合的现象。但是明显感知模型训练和收敛速度变慢，因此该任务更适合使用单隐藏层。

## 总结

本次试验需要手推反向传播公式并正确使用，并直接使用它们构建神经网络，加深了我对全连接层、各种激活函数与损失函数的理解。

同时不同的对比调参和隐藏层数的选择让我对选择合适的神经网络这一命题有了初步的认识。
