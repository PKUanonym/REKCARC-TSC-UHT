for i in range(0, 100):
    if i % 1000 == 0:
        print(i)
    fp = open('data/t/t' + repr(i) + '.txt', 'w')
    fp.write('this is t' + repr(i))
    fp.close()
