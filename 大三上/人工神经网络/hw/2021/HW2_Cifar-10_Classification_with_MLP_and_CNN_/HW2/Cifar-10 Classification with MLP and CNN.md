# Cifar-10 Classification with MLP and CNN

## self.training

self.training 作为标记在 `nn.Module`中使用，在测试集中不需要使用Dropout层，这样可以不损失训练的信息；同时BN层需要使用使用动量训练出的参数，一方面利用训练信息，另一方面测试集不能用于训练。

## 实验过程

在BN层设置`weight=1,bias=0,momentum=1e-2,eps=1e-5` 其他参数保持默认（简单修改发现默认参数能保持较好的效果，例如drop_posibility提高会导致结果下降），下面是实验模型构成和结果。运行参数均为`python3 main.py --num_epochs 50`。其中MLP模型验证集准确度为54.08%，CNN模型验证集准确度为67.15%。

### MLP

```
Model(
  (linear1): Linear(in_features=3072, out_features=512, bias=True)
  (bn): BatchNorm1d()
  (relu): ReLU()
  (dropout): Dropout()
  (linear2): Linear(in_features=512, out_features=10, bias=True)
  (loss): CrossEntropyLoss()
)

Epoch 50 of 50 took 1.428589105606079s
  learning rate:                 0.001
  training loss:                 1.0290685239434243
  training accuracy:             0.639924985691905
  validation loss:               2.0886429595947265
  validation accuracy:           0.5205999863147736
  best epoch:                    49
  best validation accuracy:      0.5408999845385551
  test loss:                     1.8274000895023346
  test accuracy:                 0.5300999864935875
```

![result12](https://i.loli.net/2021/10/19/6Cgzc8hEfw5Vdrs.png)



## 实验结果

### CNN

```
Model(
  (conv1): Conv2d(3, 8, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1))
  (bn1): BatchNorm2d(8, eps=1e-05, momentum=0.1, affine=True, track_running_stats=True)
  (relu1): ReLU()
  (dropout1): Dropout()
  (maxpool1): MaxPool2d(kernel_size=2, stride=2, padding=0, dilation=1, ceil_mode=False)
  (conv2): Conv2d(8, 16, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1))
  (bn2): BatchNorm2d(16, eps=1e-05, momentum=0.1, affine=True, track_running_stats=True)
  (relu2): ReLU()
  (dropout2): Dropout()
  (maxpool2): MaxPool2d(kernel_size=2, stride=2, padding=0, dilation=1, ceil_mode=False)
  (linear): Linear(in_features=1024, out_features=10, bias=True)
  (loss): CrossEntropyLoss()
)
Epoch 50 of 50 took 1.792809009552002s
  learning rate:                 0.0009990002500000002
  training loss:                 0.9676271015405655
  training accuracy:             0.6617249843478202
  validation loss:               1.1218822890520095
  validation accuracy:           0.6525999861955643
  best epoch:                    45
  best validation accuracy:      0.6714999842643737
  test loss:                     1.054015880227089
  test accuracy:                 0.6668999826908112
```

![result11](https://i.loli.net/2021/10/19/HRmXW4KdbUpaOct.png)

## 训练集和验证集的差异

本质上验证集和训练集的数据有差异，不考虑超参数，模型只可能学会训练集的特征，如果验证集的

特征有所差异，则会出现训练集拟合后，验证集的准确度相对较低的情况，甚至出现过拟合。

在选择超参数时，我会尽量选择训练集和验证集的准确度相对较高、且差值相对较小的情况。

## 实验结果

MLP模型验证集准确度为54.08%，CNN模型验证集准确度为67.15%。

CNN的表现更优，可能是因为CNN的卷积结构更适合提取图像特征。但两者差异不大，我猜测是由于CNN中卷积核数较少（无池化层，需要能够直接被全连接层接受）导致的。

另外注意到CNN模型的训练集过拟合相比而言严重一些（训练集准确度和验证集准确度相差15%），这可能是由于CNN模型隐藏层参数更多导致的。

两者网络都较为简单、参数相对较少，因此训练速度无太大差异。

## Without BN

删除 MLP 的 `BatchNorm1d` 层和 CNN 的 `BatchNorm2d` 层，其他参数不变，和前面的实验结果进行对比。BatchNorm 主要可以防止梯度消失和梯度爆炸的问题，从结果上看在本实验中影响较小。

### MLP

验证集准确率为53.28%，比使用 `BatchNorm1d` 层的略好一点，从实验结果来说BN层用处不大。

![result3](https://i.loli.net/2021/10/19/N2ZlMsj8QDSCFo4.png)

### CNN

验证集准确率为64.11%，比使用 `BatchNorm2d` 层的准确度低了3%，从实验结果来说BN层对CNN模型有一定的增益效果。

![result4](https://i.loli.net/2021/10/19/aBIJ2TU1hX3grp7.png)

## Without Dropout

删除 MLP 和 CNN 的 `Dropout` 层，其他参数不变，和前面的实验结果进行对比。Dropout 层能通过主动遗忘，让网络学到更多的局部特征。

### MLP

MLP模型验证集准确度为52.84%，比使用Dropout层的准确度低了1.5%。

![result13](https://i.loli.net/2021/10/19/oYUuahs1gqS82Ft.png)

### CNN

CNN模型验证集准确度为66.16%，比使用Dropout层的准确度低了1%。

![result1](https://i.loli.net/2021/10/19/W8tL7EObvNQCKFV.png)

整体而言，缺少BN层和Dropout层会使准确率略微降低。

## 对超参数的观测

### dropout rate

实验 `dropout rate` 对结果的影响，在CNN模型下测试 `dropout rate=0.0,0.2,0.4,0.6,0.8,1.0`的情况，其他条件与基础实验相同。

| dropout rate       | best validation accuracy |
| ------------------ | ------------------------ |
| 0.0                | 64.98%                   |
| 0.2                | 66.63%                   |
| 0.4                | 65.57%                   |
| 0.6                | 60.81%                   |
| 0.8                | 47.21%                   |
| 1.0 (cannot learn) | 10.07%                   |

可以看出 `dropout rate` 在较低时能增加少量准确率，但较高时会对结果有较大的负面影响。

### batch size

实验 `batch size` 对结果的影响，在CNN模型下测试 `batch size=10,20,50,100,200,500`的情况，`training epoch` 设置为20，其他条件与基础实验相同。

| batch size | best validation accuracy |
| ---------- | ------------------------ |
| 10         | 64.69%                   |
| 50         | 64.47%                   |
| 100        | 64.48%                   |
| 1000       | 61.62%                   |
| 10000      | 47.59%                   |

发现 `batch size` 大小与实验速度成反比（但每轮速度存在最小瓶颈，大约为1s），并且说明在合理范围内，增大 `batch size` 有助于利用内存与并行化优势提速。但过大的`batch size` 会使内存占用率提高，并且由于每轮迭代次数变少，结果收敛更慢。

## 参考

在实验过程中参考了pytorch 的源码，发现底层算子是用C++实现的。

