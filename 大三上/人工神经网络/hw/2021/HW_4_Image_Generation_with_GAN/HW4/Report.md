
# HW4

## 默认超参数的GAN实验
batch_size 为 64 ，num_train_steps 为 5000，除说明外，其他超参数保持默认值。

为了方便，设 `hidden_dim=generator_hidden_dim=discriminator_hidden_dim`，smooth 设为 `0.999`。

### 过程图像
![image-20211115235618222](https://i.loli.net/2021/11/15/kjIBfnyJliuq9NM.png)
![](https://i.loli.net/2021/11/15/fCOKgjzIvHDSyQd.png)
![](https://i.loli.net/2021/11/15/5nBhdEwyfQAvMPq.png)



![](https://i.loli.net/2021/11/15/Vk5sNlCWq6zMQn3.png)

![](https://i.loli.net/2021/11/15/vremgjUHRFdZWLz.png)
![](https://i.loli.net/2021/11/15/FBL9UKdHZD5OCXn.png)



### FID 与结果
#### latent_dim=16, hidden_dim=16
FID score: 81.463
![](https://i.loli.net/2021/11/15/ODuVEBXbgNqS7x6.png)

#### latent_dim=100, hidden_dim=16
FID score: 64.098
![](https://i.loli.net/2021/11/15/x1LYkIpGqiNP459.png)

#### latent_dim=16, hidden_dim=100
FID score: 52.499
![](https://i.loli.net/2021/11/15/x1LYkIpGqiNP459.png)

#### latent_dim=100, hidden_dim=100
FID score: 29.649
![](https://i.loli.net/2021/11/15/UlrER64xgskdVWp.png)

注意到，从图表上看，所有的训练都出现了过拟合的现象，且复杂度越高过拟合现象越严重，在结果图像中也有所体现，这与预期一致。
![](https://i.loli.net/2021/11/15/TpLHrdFXhfe4NZl.png)

## latent_dim 和 hidden_dim 对GAN的性能的影响
从实验结果看出，在一定范围内，增加 latent_dim 或 hidden_dim 有助于实验结果准确度的提高；但同时会使得收敛变慢。
更大的 latent_dim 能增加生成器输入的多样性，而 hidden_dim 能增加生成器/判别器网络的复杂性。如果复杂性太高，会导致模型不收敛或者出现过拟合，比如造成模式崩溃现象的出现。
在这个实验中，MINIST 图片间相似度高，增大网络复杂性能获得更多的特征，因此 `latent_dim=100, hidden_dim=100` 时取得了最好的效果。

## 纳什均衡
我们的损失函数为![](https://i.loli.net/2021/11/15/C8JAOzYXuNEbvLy.png)
在理想情况下判别器与真实图像同分布，其倒数为0的点为
$$
D^*(x) = \frac{P_{data}(x)}{P_{data}(x)+P_{g}(x)} = \frac{1}{2}
$$
即为纳什均衡点。
很明显，GAN未收敛到纳什均衡，一方面是 `fake_img` 的真实性最终小于 0.2 ，且 `real_img` 的真实性最终大于 0.8，未达到 0.5 的中间态；另一方面模型始终在震荡，这可能是由于目标函数非凸函数。
![](https://i.loli.net/2021/11/15/TpLHrdFXhfe4NZl.png)

![](https://i.loli.net/2021/11/15/XWRFwpKazZji8k7.png)

## 线性插值
选择结果最好的 `latent_dim=100, hidden_dim=100` 进行测试。
```python
if args.interpolation:
        cnt = 0
        while cnt < 2:
            fixed_noise = torch.randn(1, args.latent_dim, 1, 1, device=device)
            imgs = make_grid(netG(fixed_noise)) * 0.5 + 0.5
            save_image(imgs, "samples.png")
            right = input("yes?")
            if right:
                cnt += 1
                if cnt == 1:
                    t1 = fixed_noise.cpu().numpy()
                else:
                    t2 = fixed_noise.cpu().numpy()
        fixed_noise = torch.tensor([t1*i/9+t2*(9-i)/9 for i in range(10)])
        fixed_noise = fixed_noise.reshape((10, args.latent_dim, 1, 1))
        imgs = make_grid(netG(fixed_noise)) * 0.5 + 0.5
        save_image(imgs, "samples.png")
```
### 0
![](https://i.loli.net/2021/11/15/zo94XAEfadGlqPh.png)
### 1
![](https://i.loli.net/2021/11/15/wqKMm1eEBkoyJiY.png)
### 3
![](https://i.loli.net/2021/11/15/JXpAaf1ijK9Ux4F.png)
### 5
![](https://i.loli.net/2021/11/15/Qj2q8dkU7ID6yvZ.png)
### 9
![](https://i.loli.net/2021/11/15/I2MWUP64sJVkGZF.png)
如果插值端点中不存在的图像出现在线性插值路径中，说明 latent space 有纠缠，特征没有正确分离。从结果来看，插值的图像均符合要求，特征分离较好。

## 模式崩溃
选择结果最好的 `latent_dim=100, hidden_dim=100` 进行测试。
```
fixed_noise = torch.randn(50, args.latent_dim, 1, 1, device=device)
imgs = make_grid(netG(fixed_noise)) * 0.5 + 0.5
save_image(imgs, "samples.png")
```
![](https://i.loli.net/2021/11/15/TGouvfwkqb1dtZ6.png)
统计结果如下
5446088691?68329932?905199890217889194499?011?3717
{'9': 11, '1': 7, '8': 6, '4': 4, '0': 4, '?': 4, '6': 3, '3': 3, '2': 3, '7': 3, '5': 2}
所有数字均出现过，且整体较为平均，基本未受模式崩溃影响。