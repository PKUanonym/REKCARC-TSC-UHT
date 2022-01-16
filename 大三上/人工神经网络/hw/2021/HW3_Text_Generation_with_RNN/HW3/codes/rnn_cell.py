import torch
from torch import nn
import torch.nn.functional as F

class RNNCell(nn.Module):
    def __init__(self, input_size, hidden_size):
        super().__init__()
        self.input_size = input_size
        self.hidden_size = hidden_size

        self.input_layer = nn.Linear(input_size, hidden_size)
        self.hidden_layer = nn.Linear(hidden_size, hidden_size, bias=False)

    def init(self, batch_size, device):
        #return the initial state
        return torch.zeros(batch_size, self.hidden_size, device=device)

    def forward(self, incoming, state):
        # flag indicates whether the position is valid. 1 for valid, 0 for invalid.
        output = (self.input_layer(incoming) + self.hidden_layer(state)).tanh()
        new_state = output # stored for next step
        return output, new_state

class GRUCell(nn.Module):
    def __init__(self, input_size, hidden_size):
        super().__init__()
        self.input_size = input_size
        self.hidden_size = hidden_size

        # TODO START
        self.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        self.input_layer = nn.ModuleList([nn.Linear(
            input_size, hidden_size).to(self.device) for _ in range(3)])
        self.hidden_layer = nn.ModuleList([nn.Linear(
            hidden_size, hidden_size, bias=False).to(self.device) for _ in range(3)])
        # TODO END

    def init(self, batch_size, device):
        # TODO START
        return nn.init.orthogonal_(torch.empty(batch_size, self.hidden_size, device=device))
        # return torch.zeros(batch_size, self.hidden_size, device=device)
        # TODO END

    def forward(self, incoming, state):
        # TODO START
        # calculate output and new_state
        r = (self.input_layer[0](
            incoming) + self.hidden_layer[0](state)).sigmoid()
        z = (self.input_layer[1](
            incoming) + self.hidden_layer[1](state)).sigmoid()
        n = (self.input_layer[2](
            incoming) + r * self.hidden_layer[2](state)).tanh()
        output = (1-z)*n+z*state
        new_state = output
        return output, new_state
        # TODO END

class LSTMCell(nn.Module):
    def __init__(self, input_size, hidden_size):
        super().__init__()
        self.input_size = input_size
        self.hidden_size = hidden_size

        # TODO START
        # intialize weights and layers
        self.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        self.input_layer = nn.ModuleList([nn.Linear(
            input_size, hidden_size) for _ in range(4)])
        self.hidden_layer = nn.ModuleList([nn.Linear(
            hidden_size, hidden_size, bias=False) for _ in range(4)])
        # TODO END

    def init(self, batch_size, device):
        # TODO START
        # return the initial state (which can be a tuple)
        # nn.init.orthogonal_(torch.empty(batch_size, self.hidden_size, device=device))
        return [torch.zeros(batch_size, self.hidden_size, device=device) for _ in "01"]
        # TODO END

    def forward(self, incoming, state):
        # TODO START
        # calculate output and new_state
        old_h, old_c = state
        i = (self.input_layer[0](
            incoming) + self.hidden_layer[0](old_h)).sigmoid()
        f = (self.input_layer[1](
            incoming) + self.hidden_layer[1](old_h)).sigmoid()
        g = (self.input_layer[2](
            incoming) + self.hidden_layer[2](old_h)).tanh()
        o = (self.input_layer[3](
            incoming) + self.hidden_layer[3](old_h)).sigmoid()
        new_c = torch.mul(f, old_c) + torch.mul(i, g)
        output = torch.mul(o, new_c.tanh())
        new_h = output
        return output, (new_h, new_c)
        # TODO END
