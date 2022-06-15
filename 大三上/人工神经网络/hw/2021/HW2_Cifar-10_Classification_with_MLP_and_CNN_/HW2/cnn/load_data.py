# -*- coding: utf-8 -*-

import numpy as np
import pickle
import os

def load_cifar_4d(data_dir):
    trX = []
    trY = []
    for batch_id in range(1, 6):
        filename = os.path.join(data_dir, 'data_batch_{}'.format(batch_id))
        batch = pickle.load(open(filename, "rb"), encoding='bytes')
        trX.append(batch['data'.encode()])
        trY.append(batch['labels'.encode()])
    trX = np.reshape(np.concatenate(trX, axis=0), (5 * 10000, 3, 32, 32))
    # trX = np.transpose(trX, [0, 2, 3, 1])
    trY = np.reshape(np.concatenate(trY, axis=-1), (5 * 10000, ))

    test_file_name = os.path.join(data_dir, 'test_batch')
    test_batch = pickle.load(open(test_file_name, "rb"), encoding='bytes')
    teX = np.reshape(test_batch['data'.encode()], (10000, 3, 32, 32))
    # teX = np.transpose(teX, [0, 2, 3, 1])
    teY = np.reshape(test_batch['labels'.encode()], (10000, ))

    trX = ((trX - 128.0) / 255.0).astype(np.float32)
    teX = ((teX - 128.0) / 255.0).astype(np.float32)

    return trX, teX, trY, teY
