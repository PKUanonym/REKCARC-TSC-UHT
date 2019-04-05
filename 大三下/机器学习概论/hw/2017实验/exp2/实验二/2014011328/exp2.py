
import random
import math
import numpy
from sklearn import tree, svm, preprocessing
from sklearn.model_selection import train_test_split
from sklearn.naive_bayes import GaussianNB, MultinomialNB, BernoulliNB

def main(task):
	if task == 1 :
		print("Bagging + SVM")
	elif task == 2 :
		print("Bagging + DTree")
	elif task == 3 :
		print("Adaboost + SVM")
	elif task == 4 :
		print("Adaboost + DTree")
	elif task == 5 :
		print("Bagging + Gaussian Naive Bayes")
	elif task == 6 :
		print("Adaboost + Gaussian Naive Bayes")

	dataList = []
	attributesList = []
	X = []
	y = []

	#read data
	#sourceData = open("ContentNewLinkAllSample.csv",'r')
	sourceData = open("ex1.csv",'r') # only transformed link features
	#sourceData = open("ex2.csv",'r') # only content features
	
	#read label (first line of the input file)
	line = sourceData.readline()
	line = line.strip('\n')					
	lineSplit = line.split(',')				
	attributesList.append(lineSplit)			
	
	#read data (rest of the input file)
	line = sourceData.readline()
	while line:
		line = line.strip('.\n')			
		lineSplit = line.split(',')			
		dataList.append( lineSplit ) 	
		line = sourceData.readline()		

	sourceData.close()

	#covert data from string to float (except the class) and seperate to X & y
	for data in dataList :
		#print(data)
		if data[-1] == "spam\r" :
			y.append(0)
		else :
			y.append(1)
		X.append( [float(key) for key in data[:-1]] )

	#print(y)
	#normalize
	X = preprocessing.normalize(X)

	# print(attributesList)
	# print(dataList[0])

	#get training set & test set by resamlping
	X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

	if task == 1 or task == 2 or task == 5: #1Bagging + SVM / #2Bagging + DTree
		bootstrapSize = 100
		result = []
		predict = []
		#start single training
		for i in range(bootstrapSize) :
			X_temp = []
			y_temp = []
			#get trainging set for bagging
			for j in range( len(X_train) ):
				k = random.randint(0, len(X_train) - 1)
				X_temp.append( X_train[k] )
				y_temp.append( y_train[k] )
			#set classifier
			if task == 1:
				clf = svm.LinearSVC(dual=False)
			if task == 2:
				clf = tree.DecisionTreeClassifier()
			if task == 5:
				clf = GaussianNB()
			clf.fit(X_temp , y_temp)
			#predict by single training
			result.append( clf.predict(X_test) )
		#predict by bagging
		for i in range(len(y_test)):
			count = 0
			for j in range(bootstrapSize):
				if result[j][i] ==1 :
					count += 1
			if count > bootstrapSize/2 :
				predict.append(1)
			else :
				predict.append(0)
		#calc the correct ratio
		correctRatio = 0.0
		for i in range( len(y_test) ) :
			if y_test[i] == predict[i] :
				correctRatio += 1
		correctRatio = correctRatio / len(X_test)
		print(correctRatio)

	if task == 3 or task == 4 or task == 6: #3AdaBoost + SVM #4AdaBoost + DTree
		bootstrapSize = 100
		result = []
		predict = []
		weight = [1.0/len(X_train) for x in X_train]
		beta = [0.0 for x in range(bootstrapSize)]

		#start single training
		for i in range(bootstrapSize) :
			#set classifier
			if task == 3:
				clf = svm.LinearSVC(dual=False)
			if task == 4:
				clf = tree.DecisionTreeClassifier()
			if task == 6:
				clf = GaussianNB()
				weight = numpy.array(weight)
			clf.fit(X_train , y_train , sample_weight = weight)
			#predict the training set
			result_temp = clf.predict(X_train)
			#update beta
			errorWeight = sum( [0.0 if result_temp[j]==y_train[j] else weight[j] for j in range( len(X_train) ) ] ) 
			beta[i] = errorWeight / (1 - errorWeight)
			#update weight
			weight = [ weight[j]*beta[i] if result_temp[j]==y_train[j] else weight[j] for j in range( len(X_train) ) ] 
			weightSum = sum(weight)
			weight = [ weight[j]/weightSum for j in range( len(X_train) ) ]
			#predict the test set by single training
			result_temp = clf.predict(X_test)
			result.append([math.log(1/beta[i]) if x == 1 else -math.log(1/beta[i]) for x in result_temp])

		#predict by Adaboost
		for i in range(len(y_test)):
			count = 0.0
			for j in range(bootstrapSize):
				count += result[j][i]
			if count > 0 :
				predict.append(1)
			else :
				predict.append(0)
		#calc the correct ratio
		correctRatio = 0.0
		for i in range( len(y_test) ) :
			if y_test[i] == predict[i] :
				correctRatio += 1
		correctRatio = correctRatio / len(X_test)
		print(correctRatio)

for i in range(1,7):
	main(i)
