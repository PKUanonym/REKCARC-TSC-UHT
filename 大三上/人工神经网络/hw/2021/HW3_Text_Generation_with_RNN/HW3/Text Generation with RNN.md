# Text Generation with RNN

## RNNCells

为保证相对统一，所有数据采用零初始化策略，除 RNNCells 参数外，超参数均采用初始值。

### RNNCell

![rnn](https://i.loli.net/2021/11/01/uNfg9Hra8pjSQRX.png)

```
Epoch 20 of 20 took 75.1513729095459s
  training loss:                 2.5716894913329753
  validation loss:               3.165958212721797
  validation perplexity:         23.71145376736739
  best epoch:                    18
  best validation perplexity:    23.664422343423354
Example 0: A group of commercial boards on the passenger jet .
Example 1: The electronic can see onto machine buildings trucks pass off .
Example 2: Two people pushing a baby to the the ground .
Example 3: A person on a motorcycle that is white standing in the background .
Example 4: People on a city bus driving near a traffic light .
rnn.png saved successfully

test_set, perplexity 20.47, forward BLEU 0.278, backward BLEU 0.305, harmonic BLEU 0.291
        test_set, write inference results to rnn_output.txt
```

### GRUCell

![gruzero](https://i.loli.net/2021/11/01/zfPCF9Itukd8SQA.png)

```
Epoch 20 of 20 took 52.29065489768982s
  training loss:                 2.2536406933880055
  validation loss:               3.086415800888282
  validation perplexity:         21.89844874798445
  best epoch:                    16
  best validation perplexity:    21.575128188132485
Example 0: A group of park benches benches in open area with a baby bear .
Example 1: The wing , an airplane flying over the statue on the tarmac .
Example 2: A cat is sitting on a car that are looking at his skateboard with a hangar .
Example 3: A herd of elephants standing on top of their tasty washing .
Example 4: The show a picture of various giraffes eating leaves out on eating .
gruzero.png saved successfully

test_set, perplexity 18.74, forward BLEU 0.288, backward BLEU 0.302, harmonic BLEU 0.295
        test_set, write inference results to gruzero_output.txt
```

### LSTMCell

![lstmzero](https://i.loli.net/2021/11/01/5q3Vd8RCBlPYWXi.png)

```
Epoch 20 of 20 took 54.92784023284912s
  training loss:                 2.3430654443403296
  validation loss:               3.1049986621101944
  validation perplexity:         22.309189128019156
  best epoch:                    20
  best validation perplexity:    22.309189128019156
Example 0: A blue couch sits on top of a red light .
Example 1: A street light that is in the snow with a mountainous road .
Example 2: A sandwich with golden , limes , pans and refrigerator and a spoon .
Example 3: A group of giraffes wearing a tree trunk near a crosswalk .
Example 4: A man standing on a park bench in front of a crowd with trees and a gas commercial car .
lstmzero.png saved successfully

test_set, perplexity 19.23, forward BLEU 0.287, backward BLEU 0.312, harmonic BLEU 0.299
        test_set, write inference results to lstmzero_output.txt
```

### 比较和分析

|          | perplexity | forward BLEU | backward BLEU | harmonic BLEU |
| -------- | ---------- | ------------ | ------------- | ------------- |
| RNNCell  | 20.47      | 0.278        | 0.305         | 0.291         |
| GRUCell  | 18.74      | 0.288        | 0.302         | 0.295         |
| LSTMCell | 19.23      | 0.287        | 0.312         | 0.299         |

从整体效果上看，单层 GRUCell > LSTMCell > RNNCell；从收敛速度上看，GRUCell $\approx$ RNNCell > LSTMCell。这可能是由于 LSTMCell 相对 GRUCell 而言更加复杂，结构更多；GRUCell 和 LSTMCell 相比 RNNCell 结构上更有优势。总体来看，GRUCell 效果最好，后续实验在 GRUCell 上进行。

## 初始化策略

在单层 GRUCell 上尝试正交初始化状态向量（有[文章](https://smerity.com/articles/2016/orthogonal_init.html)提到适合防止梯度问题），结果如下。

![gruorth](https://i.loli.net/2021/11/01/Mrj2pg8U3kHKmOI.png)

```
test_set, perplexity 18.73, forward BLEU 0.280, backward BLEU 0.308, harmonic BLEU 0.293
        test_set, write inference results to gruorth_output.txt
```

|      | perplexity | forward BLEU | backward BLEU | harmonic BLEU |
| ---- | ---------- | ------------ | ------------- | ------------- |
| zero | 18.74      | 0.288        | 0.302         | 0.295         |
| orth | 18.73      | 0.280        | 0.308         | 0.293         |

初始化方式对结果影响不大，但注意到正交初始化使拥有更快的收敛速度，并且能够减少训练可能出现的问题，因此后续实验均采用**正交初始化**。

## 解码策略

采用正交初始化，单层 GRUCell 结构进行测试。

### 温度为 1 的随机抽样

见上一节「初始化策略」。

### 温度为 0.8 的随机抽样

![gru_random_temp0_8](https://i.loli.net/2021/11/01/Z6it1ajlMR5bmor.png)

```
test_set, perplexity 18.82, forward BLEU 0.450, backward BLEU 0.340, harmonic BLEU 0.387
        test_set, write inference results to gru_random_temp0_8_output.txt
```

### p 为 0.8 的 top-p 抽样

![gru_top_p_p_0_8](https://i.loli.net/2021/11/01/LHW5zKTMkOXeldC.png)

```
test_set, perplexity 18.82, forward BLEU 0.290, backward BLEU 0.315, harmonic BLEU 0.302
        test_set, write inference results to gru_top_p_p_0_8_output.txt
```

### p 为 0.8 温度为 0.8 的 top-p 抽样

![gru_top_p_p_0_8_temp0_8](https://i.loli.net/2021/11/01/v3zZRdaCKBF6DPh.png)

```
test_set, perplexity 18.94, forward BLEU 0.457, backward BLEU 0.339, harmonic BLEU 0.389
        test_set, write inference results to gru_top_p_p_0_8_temp0_8_output.txt
```

|                                   | perplexity | forward BLEU | backward BLEU | harmonic BLEU |
| --------------------------------- | ---------- | ------------ | ------------- | ------------- |
| 温度为 1 的随机抽样               | 18.73      | 0.280        | 0.308         | 0.293         |
| 温度为 0.8 的随机抽样             | 18.82      | 0.450        | 0.340         | 0.387         |
| p 为 0.8 的 top-p 抽样            | 18.82      | 0.290        | 0.315         | 0.302         |
| p 为 0.8 温度为 0.8 的 top-p 抽样 | 18.94      | 0.457        | 0.339         | 0.389         |
| p 为 0.5 温度为 0.8 的 top-p 抽样 | 18.71      | 0.464        | 0.337         | 0.390         |

首先注意到 `perplexity` 基本相同，但 `BLEU` 指标相差较大，这说明 `perplexity` 指标测试性能的能力有限。

温度超参数影响随机抽样选择的概率分布，当温度大的时候，概率分布趋向平均，随机性增大；当温度小的时候，概率密度趋向于集中；因此温度为 0.8 的采样相比温度为 1 的采样能在保证随机性的同时相对降低低概率词语的采样频率，从结果上看各项 BLEU 参数均有较大提升。

Top-p 策略同样是为了使低概率词语不被采样，p 为 0.8 的 top-p 抽样能够做到这点，从结果上看各项 BLEU 参数均有小幅提升。

p 为 0.5/0.8 温度为 0.8 的 top-p 抽样这一综合策略在各项 BLEU 参数上取得了最好的成绩。

## 句子

取生成的前 10 个句子。

### 温度为 1 的随机抽样

```
A cat horse a motorcycle on the curb of a street .
A giraffe is walking in the big to clearing a field near a truck .
A clean vase decorated filled with white sinks lined - up .
Two five giraffes inside a dirt hanger on a sunny day .
A someone ' propped at a light over to feed of some motorcycles .
A dog sleeping at a bench sitting next to a large tree in a park .
A propeller plane pointing at a plane flies in neon sky .
Two people standing around a double decker bus stopped on a bus stop .
Several men and woman posing in a kitchen in the kitchen .
A motor cycle moving along a street with a parked motorcycles .
```

### 温度为 0.8 的随机抽样

```
A large airplane parked on a runway under a cloudy sky .
A couple of kids are standing in a park bench .
A group of people who are left on a sidewalk .
The city bus is pulling its head under a building .
A very cool toilet with a cross that is to a bathtub .
A stuffed animal sitting on a white toilet seat .
A toilet with a sink in a glass yard .
A large jetliner with a blue painted photographer parked in the sky .
A black and white photo of a white toilet and sink .
A white and blue plane sitting on it ' s wings above a bridge .
```

### p 为 0.8 的 top-p 抽样

```
A man and a out woman on a motorcycle at a crosswalk .
The wooden table shelf with the cowboy uses hood , laundry and bag wrap up on it .
A parking lot sitting on a road down the old car .
Woman nine school buses being safe off to loading passengers .
A white fire hydrant with a blue on on it on a track .
A group of tall white eyed sheep grazing in a field outside .
A blue bench on the water of a fire hydrant .
A bathroom that has white counter tops tops and closed .
A person is standing on a park filled box with orange cones and sitting on the beach .
A bunch of oranges in a scenic boats on the sidewalk .
```

### p 为 0.8 温度为 0.8 的 top-p 抽样

```
A group of people on motor cycles in a parking lot .
The back of a plane can be displayed on the ground .
A group of traffic in London down a building .
Three people are sitting on a wooden bench with a big door .
A person in a kitchen counter to separate a window and a desk .
Man and black poles and a motorcycle on the side of the road while another use a red light .
A white toilet next to a clock tower in the middle of a area .
A picture of a bathroom with a toilet and a large bath tub .
A fire hydrant in a field near a tree filled with mountains .
A group of geese flying in the sky with green clouds .
```

### p 为 0.5 温度为 0.8 的 top-p 抽样

```
A kitchen with a living room has a stove , cabinets , and a wood refrigerator .
A man is standing by a toilet seat window .
A white toilet sitting next to a window in a room .
Black and white photograph of a man in a bathroom near a toilet .
A small building with a space shuttle on top of it .
A bathroom with a toilette , sink , and bathtub .
A cat looks on a laptop set in a desk .
A man rides a motorcycle down a street next to a building , bus .
The man is standing at the back of a motorcycle .
A black and white photo of a woman on a dirt road .
```

### 分析

生成的数据在语句结构上基本没有错误，比如基本的主谓宾和动宾结构，以及整个句子能保证完整性。主要的语法错误为结构堆叠（比如`Two five giraffes`）和搭配不当（比如`A cat horse a motorcycle`），更多的还是句子的语义不合常理，比如`A cat horse a motorcycle on the curb of a street .`和`Three people are sitting on a wooden bench with a big door .`。

综合来看，p 为 0.8/0.5 温度为 0.8 的 top-p 抽样结果最好，温度为 0.8 的随机抽样次之（不合常理的语义更多），Perplexity 看不出优劣， Forward BLEU, Backward BLEU, Harmonic BLEU 三者在不同解码策略中的相对顺序是一致的，它们的顺序与我的判断一致。

p 为 0.5 温度为 0.8 的 top-p 抽样结果句型较为单一，`with` 结构常常出现，与 `p` 较小，选择有限相关。

## 最终网络、超参数和解码策略

最终选择正交初始化，单层 GRUCell 结构， p 为 0.8 温度为 0.8 的 top-p 抽样的解码策略，其他超参数为预设，4个指标的结果如下：

```
test_set, perplexity 18.94, forward BLEU 0.457, backward BLEU 0.339, harmonic BLEU 0.389
        test_set, write inference results to gru_top_p_p_0_8_temp0_8_output.txt
```

`output.txt` 见文件。

