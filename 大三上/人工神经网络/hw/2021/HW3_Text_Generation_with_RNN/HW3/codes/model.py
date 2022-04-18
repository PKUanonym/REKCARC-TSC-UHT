import numpy as np
import torch
from torch import nn
import torch.nn.functional as F

from rnn_cell import RNNCell, GRUCell, LSTMCell


class RNN(nn.Module):
    def __init__(self,
                 num_embed_units,  # pretrained wordvec size
                 num_units,        # RNN units size
                 num_vocabs,       # vocabulary size
                 wordvec,          # pretrained wordvec matrix
                 dataloader,
                 model='rnn'):      # dataloader

        super().__init__()

        # load pretrained wordvec
        self.wordvec = wordvec
        # the dataloader
        self.dataloader = dataloader

        # TODO START
        Cell = LSTMCell if model == 'lstm' else GRUCell if model == 'gru' else RNNCell
        self.cell = Cell(num_embed_units, num_units)
        self.embedding = nn.Embedding.from_pretrained(self.wordvec,num_embed_units)
        # TODO END

        # intialize other layers
        self.linear = nn.Linear(num_units, num_vocabs)

    def forward(self, batched_data, device):
        # Padded Sentences
        # shape: (batch_size, length)
        sent = torch.tensor(
            batched_data["sent"], dtype=torch.long, device=device)
        # An example:
        #   [
        #   [2, 4, 5, 6, 3, 0],   # first sentence: <go> how are you <eos> <pad>
        #   [2, 7, 3, 0, 0, 0],   # second sentence:  <go> hello <eos> <pad> <pad> <pad>
        #   [2, 7, 8, 1, 1, 3]    # third sentence: <go> hello i <unk> <unk> <eos>
        #   ]
        # You can use self.dataloader.convert_ids_to_sentence(sent[0]) to translate the first sentence to string in this batch.

        # Sentence Lengths
        length = torch.tensor(
            batched_data["sent_length"], dtype=torch.long, device=device)  # shape: (batch)
        # An example (corresponding to the above 3 sentences):
        #   [5, 3, 6]

        batch_size, seqlen = sent.shape

        # TODO START
        # implement embedding layer
        embedding = self.embedding(sent)
        # TODO END

        now_state = self.cell.init(batch_size, device)

        loss = 0
        logits_per_step = []
        for i in range(seqlen - 1):
            hidden = embedding[:, i]
            # shape: (batch_size, num_units)
            hidden, now_state = self.cell(hidden, now_state)
            logits = self.linear(hidden)  # shape: (batch_size, num_vocabs)
            logits_per_step.append(logits)

        # TODO START
        # calculate loss
        log_softmax = nn.LogSoftmax(dim=1)
        loss = 0
        for i in range(batch_size):
            for j in range(1, min(int(length[i]), seqlen)):
                loss += -log_softmax(logits_per_step[j-1])[i][sent[i][j]]
        loss /= length.sum()
        # TODO END

        return loss, torch.stack(logits_per_step, dim=1)

    def inference(self, batch_size, device, decode_strategy, temperature, max_probability):
        # First Tokens is <go>
        now_token = torch.tensor(
            [self.dataloader.go_id] * batch_size, dtype=torch.long, device=device)
        flag = torch.tensor([1] * batch_size, dtype=torch.float, device=device)

        now_state = self.cell.init(batch_size, device)

        generated_tokens = []
        for _ in range(50):  # max sentecne length

            # TODO START
            # translate now_token to embedding
            embedding = self.embedding(now_token)
            # TODO END

            hidden = embedding
            hidden, now_state = self.cell(hidden, now_state)
            logits = self.linear(hidden)  # shape: (batch_size, num_vocabs)

            if decode_strategy == "random":
                # shape: (batch_size, num_vocabs)
                prob = (logits / temperature).softmax(dim=-1)
                now_token = torch.multinomial(
                    prob, 1)[:, 0]  # shape: (batch_size)
            elif decode_strategy == "top-p":
                # TODO START
                # implement top-p samplings
                # Reference: https://gist.github.com/thomwolf/1a5a29f6962089e871b94cbd09daf317
                sorted_logits, sorted_indices = torch.sort(logits, descending=True)
                cum_prob = sorted_logits.softmax(dim=-1).cumsum(dim=-1)
                sorted_indices_to_remove = cum_prob > max_probability
                sorted_indices_to_remove[:, 1:] = sorted_indices_to_remove[:, :-1].clone()
                sorted_indices_to_remove[:, 0] = 0
                indices_to_remove = sorted_indices_to_remove.scatter(dim=-1, index=sorted_indices, src=sorted_indices_to_remove)
                logits[indices_to_remove] = float('-inf')
                prob = (logits / temperature).softmax(dim=-1)
                now_token = torch.multinomial(prob, 1)[:, 0]
                # TODO END
            else:
                raise NotImplementedError("unknown decode strategy")

            generated_tokens.append(now_token)
            flag = flag * (now_token != self.dataloader.eos_id)

            if flag.sum().tolist() == 0:  # all sequences has generated the <eos> token
                break

        return torch.stack(generated_tokens, dim=1).detach().cpu().numpy()
