import tensorflow as tf
import numpy as np

from model import batch_normalization_layer, dropout_layer

def check(name, y1, y2, error_information=""):
    shape1 = y1.shape
    shape2 = y2.shape

    if len(shape1) != len(shape2):
        print("%s: ERROR shape[1]" % name)
        return
    else:
        for i in range(len(shape1)):
            if shape1[i] != shape2[i]:
                print("%s: ERROR shape[2]" % name)
                
    y1 = np.reshape(y1, [-1])
    y2 = np.reshape(y2, [-1])

    def equal(a, b):
        if abs(a - b) < 1e-4 or (a - b)/(max(abs(a), abs(b))+1e-3) < 1e-3:
            return True
        else:
            return False

    for i in range(len(y1)):
        if equal(y1[i], y2[i]):
            continue
        else:
            print("%s: ERROR value[3] . %s" % (name, error_information))
            return
    print("%s: PASS!" % name)

def checkdrop(name, y1, y2, y3, input):
    shape1 = y1.shape
    shape2 = y2.shape

    if len(shape1) != len(shape2):
        print("%s: ERROR shape[1]" % name)
        return
    else:
        for i in range(len(shape1)):
            if shape1[i] != shape2[i]:
                print("%s: ERROR shape[2]" % name)
                
    drop1 = float(np.sum(np.abs(y2) < 1e-5)) / y2.size
    drop2 = float(np.sum(np.abs(y3) < 1e-5)) / y3.size
    keep1 = float(np.sum(np.abs(input/0.8-y2)<1e-5)) / y2.size
    keep2 = float(np.sum(np.abs(input/0.2-y3)<1e-5)) / y2.size
    
    res = 0
    if drop1 > 0.17 and drop1 < 0.23 and keep1>0.77 and keep1<0.83:
        res += 1
    if drop2 > 0.77 and drop2 < 0.83 and keep2>0.17 and keep2<0.23:
        res += 1
        
    if res == 0:
        print("%s: ERROR value[3]" % name)
    elif res == 1:
        print("%s: need recheck. Rerun this program, maybe you will see different result." % name)
    else:
        print("%s: PASS!" % name)
    
with tf.Session() as sess:
    x = tf.placeholder(tf.float32, [None, 28, 28, 1])
    with tf.variable_scope('y1'):
        BN_true_ans_ = tf.layers.batch_normalization(x, 3, training=True)
        BN_false_ans_ = tf.layers.batch_normalization(x, 3, training=False)
        drop_true_ans_ = tf.layers.dropout(x, 0.2, training=True)
        drop_false_ans_ = tf.layers.dropout(x, 0.2, training=False)
    
    with tf.variable_scope('y2'):
        BN_true_ = batch_normalization_layer(x, is_train=True)
    with tf.variable_scope('y3'):
        BN_false_ = batch_normalization_layer(x, is_train=False)
    with tf.variable_scope('y4'):
        drop_true1_ = dropout_layer(x, 0.2, is_train=True)
    with tf.variable_scope('y5'):
        drop_true2_ = dropout_layer(x, 0.8, is_train=True)
    with tf.variable_scope('y6'):
        drop_false_ = dropout_layer(x, 0.2, is_train=False)

    sess.run(tf.global_variables_initializer())
    inputs = np.random.uniform(low=-0.1, high=1.1, size=(128, 28, 28, 1))
    BN_true_ans, BN_false_ans, drop_true_ans, drop_false_ans, \
    BN_true, BN_false, drop_true1, drop_true2, drop_false = sess.run([\
        BN_true_ans_, BN_false_ans_, drop_true_ans_, drop_false_ans_, \
        BN_true_, BN_false_, drop_true1_, drop_true2_, drop_false_], {x: inputs})

    check("BN_true", BN_true_ans, BN_true, error_information="This error maybe caused by different initialization, please check manually.")
    check("BN_false", BN_false_ans, BN_false, error_information="This error maybe caused by different initialization, please check manually.")
    checkdrop("drop_true", drop_true_ans, drop_true1, drop_true2, inputs)
    check("drop_false", drop_false_ans, drop_false)