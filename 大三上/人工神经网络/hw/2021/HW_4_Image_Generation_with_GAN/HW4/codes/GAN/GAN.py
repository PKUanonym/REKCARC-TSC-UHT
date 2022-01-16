import torch.nn as nn
import torch
import os

def weights_init(m):
    classname = m.__class__.__name__
    if classname.find('Conv') != -1:
        torch.nn.init.normal_(m.weight, 0.0, 0.02)
    elif classname.find('BatchNorm') != -1:
        torch.nn.init.normal_(m.weight, 1.0, 0.02)
        torch.nn.init.zeros_(m.bias)

def get_generator(num_channels, latent_dim, hidden_dim, device):
    model = Generator(num_channels, latent_dim, hidden_dim).to(device)
    model.apply(weights_init)
    return model

def get_discriminator(num_channels, hidden_dim, device):
    model = Discriminator(num_channels, hidden_dim).to(device)
    model.apply(weights_init)
    return model

class Generator(nn.Module):
    def __init__(self, num_channels, latent_dim, hidden_dim):
        super(Generator, self).__init__()
        self.num_channels = num_channels
        self.hidden_dim = hidden_dim
        self.latent_dim = latent_dim

		# TODO START
        self.decoder = nn.Sequential(
            nn.ConvTranspose2d(latent_dim, 4 * hidden_dim,
                               kernel_size=4, stride=1, padding=0),
            nn.BatchNorm2d(4 * hidden_dim),
            nn.ReLU(),
            nn.ConvTranspose2d(4 * hidden_dim, 2 * hidden_dim,
                               kernel_size=4, stride=2, padding=1),
            nn.BatchNorm2d(2 * hidden_dim),
            nn.ReLU(),
            nn.ConvTranspose2d(2 * hidden_dim, hidden_dim,
                               kernel_size=4, stride=2, padding=1),
            nn.BatchNorm2d(hidden_dim),
            nn.ReLU(),
            nn.ConvTranspose2d(hidden_dim, 1, kernel_size=4, stride=2, padding=1),
            nn.Tanh(),
        )
		# TODO END

    def forward(self, z):
        '''
        *   Arguments:
            *   z (torch.FloatTensor): [batch_size, latent_dim, 1, 1]
        '''
        z = z.to(next(self.parameters()).device)
        return self.decoder(z)

    def restore(self, ckpt_dir):
        try:
            if os.path.exists(os.path.join(ckpt_dir, 'generator.bin')):
                path = os.path.join(ckpt_dir, 'generator.bin')
            else:
                path = os.path.join(ckpt_dir, str(max(int(name) for name in os.listdir(ckpt_dir))), 'generator.bin')
        except:
            return None
        self.load_state_dict(torch.load(path))
        return os.path.split(path)[0]

    def save(self, ckpt_dir, global_step):
        os.makedirs(os.path.join(ckpt_dir, str(global_step)), exist_ok=True)
        path = os.path.join(ckpt_dir, str(global_step), 'generator.bin')
        torch.save(self.state_dict(), path)
        return os.path.split(path)[0]

class Discriminator(nn.Module):
    def __init__(self, num_channels, hidden_dim):
        super(Discriminator, self).__init__()
        self.num_channels = num_channels
        self.hidden_dim = hidden_dim
        self.clf = nn.Sequential(
            # input is (num_channels) x 32 x 32
            nn.Conv2d(num_channels, hidden_dim, 4, 2, 1, bias=False),
            nn.LeakyReLU(0.2, inplace=True),
            # state size. (hidden_dim) x 16 x 16
            nn.Conv2d(hidden_dim, hidden_dim * 2, 4, 2, 1, bias=False),
            nn.BatchNorm2d(hidden_dim * 2),
            nn.LeakyReLU(0.2, inplace=True),
            # state size. (hidden_dim*2) x 8 x 8
            nn.Conv2d(hidden_dim * 2, hidden_dim * 4, 4, 2, 1, bias=False),
            nn.BatchNorm2d(hidden_dim * 4),
            nn.LeakyReLU(0.2, inplace=True),
            # state size. (hidden_dim*4) x 4 x 4
            nn.Conv2d(hidden_dim * 4, 1, 4, 1, 0, bias=False),
            nn.Sigmoid()
        )

    def forward(self, x):
        return self.clf(x).view(-1, 1).squeeze(1)

    def restore(self, ckpt_dir):
        try:
            if os.path.exists(os.path.join(ckpt_dir, 'discriminator.bin')):
                path = os.path.join(ckpt_dir, 'discriminator.bin')
            else:
                path = os.path.join(ckpt_dir, str(max(int(name) for name in os.listdir(ckpt_dir))), 'discriminator.bin')
        except:
            return None
        self.load_state_dict(torch.load(path))
        return os.path.split(path)[0]

    def save(self, ckpt_dir, global_step):
        os.makedirs(os.path.join(ckpt_dir, str(global_step)), exist_ok=True)
        path = os.path.join(ckpt_dir, str(global_step), 'discriminator.bin')
        torch.save(self.state_dict(), path)
        return os.path.split(path)[0]
