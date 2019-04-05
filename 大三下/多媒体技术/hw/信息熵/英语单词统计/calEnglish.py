import math
import sys
reload(sys)

def log(num):
	return math.log(num)/math.log(2)

def judge(c):
    if c >= 'a' and c <= 'z':
        return True
    else:
        return False

def count():
    fopen = open("HarryPotter.txt" , "r")
    allWords = 0 # count of all words
    uniqueWords = 0 # count of different words
    words = {} # all different words
    for line in fopen:
        line = line.lower()
        for i in range(0 , len(line)):
            if judge(line[i]):
                temp = line[i]
                allWords += 1
                if words.has_key(temp): # not different word
                    words[temp] += 1
                elif not words.has_key(temp): #different word
                    uniqueWords += 1
                    words[temp] = 1
            else:
                continue
    print allWords
    print uniqueWords
    fopen.close()

    answer = 0
    words = sorted(words.items() , key = lambda d:d[1] , reverse = True) # sort by count
    fout = open("countEnglish.txt" , "w")
    for i in range(0 , 25):
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