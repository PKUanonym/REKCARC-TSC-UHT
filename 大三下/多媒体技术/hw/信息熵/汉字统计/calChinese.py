import math
import sys
reload(sys)
sys.setdefaultencoding('utf-8')
I = []
def log(num):
	return math.log(num) / math.log(2)

def judge(c):
    try:
        if c >= u'\u4e00' and c<=u'\u9fa5':
            return True
        else:
            return False
    except:
        return True

def count():
    fopen = open("santi.txt" , "r")
    allWords = 0 # count of all words
    uniqueWords = 0 # count of different words
    words = {} # all different words
    for line in fopen:
		try:
			line = line.decode("gbk") # change to utf-8
			line = line.encode("utf-8")
		except:
			continue
		for i in range(0 , (len(line) - 3) / 3):
			temp = line[i : i + 3]
			allWords += 1
			if not judge(temp):
				continue
			if words.has_key(temp): # not different word
				words[temp] += 1
			elif not words.has_key(temp): #different word
				uniqueWords += 1
				words[temp] = 1
    print allWords
    print uniqueWords
    fopen.close()
    answer = 0
    words = sorted(words.items() , key = lambda d:d[1] , reverse = True) # sort by count
    fout = open("countChinese.txt" , "w")
    for i in range(0 , 50):
        temp2 = words[i][0] + " " + str(words[i][1]) + " "
        temp2 += str(words[i][1] * 1.0 / allWords) + " "
        temp2 += str(log(words[i][1] * 1.0 / allWords)) + "\n"
        answer += words[i][1] * 1.0 / allWords * log(words[i][1] * 1.0 / allWords)
        fout.write(temp2)
    print "the answer is: "
    print -1 * answer
    fout.close()

if __name__ == '__main__':
    count()


