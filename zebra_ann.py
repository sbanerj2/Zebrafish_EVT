import os, sys
import pandas as pd
import numpy as np
from sklearn import svm
from sklearn.preprocessing import MinMaxScaler, LabelBinarizer
from sklearn.metrics import classification_report
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, f1_score
from sklearn.model_selection import cross_val_score
from sklearn.neural_network import MLPClassifier


def load_data(filename):
	file1 = open(filename,'r') 
	id_lst = []
	feat_lst = []
	cnt = 0
	for line in file1:
		fl = line.strip('\r\n').split(',')
		#print (fl)
		f1 = fl[0]
		f2 = fl[1]
		f3 = fl[2]
		f4 = fl[3]
		f5 = fl[4]
		f6 = fl[5]
		f7 = fl[6]
		f8 = fl[7]
		f9 = fl[8]
		f10 = fl[9]
		f11 = fl[10]
		f12 = fl[11]
		f13 = fl[12]
		f14 = fl[13]
		f15 = fl[14]
		f16 = fl[15]
		f17 = fl[16]
		f18 = fl[17]
		f19 = fl[18]
		f20 = fl[19]
		f21 = fl[20]
		f22 = fl[21]
		label =fl[22]
		id_lst.append(label)
		feat_lst.append([f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11,f12,f13,f14,f15,f16,f17,f18,f19,f20,f21,f22])
		cnt +=1
	file1.close()
	return feat_lst, id_lst
	
def main():
	
	## Download data from the saved csv
	response_file = os.path.abspath('RGC_responses.csv')
	#filename = os.path.abspath(response_file)
	X, Y = load_data(response_file)
	#print(X)
	#print ("Total no. of data :", len(Y), len(X))
	
	## Normalize the data
	scaler = MinMaxScaler()
	x_minmax = scaler.fit_transform(X)
	print ("x_minmax shape: ", x_minmax.shape, len(x_minmax))
	#print ("x_minmax : ",x_minmax)
	#lb = LabelBinarizer()
	#y = lb.fit(Y)
	#print("y: ",y)

	## Train Test split
	test_split = 0.2 # a number between 0.0 and 1.0
	x_train, x_test, y_train, y_test = train_test_split(x_minmax, Y, test_size=float(test_split), random_state=0)
	
	print ("x_train length: ", len(x_train))
	print ("x_test length: ",len(x_test))
	##Define the MLPerceptron
	mlp = MLPClassifier(solver='lbfgs', alpha=1e-5,
						hidden_layer_sizes=(10,10,), random_state=1)
	mlp.fit(x_train,y_train)
	y_pred = mlp.predict(x_test)
	print('y_pred length: \n', len(y_pred))
	#print('y_pred type: \n', y_pred.dtype)
	#print('y_test type: \n', type(y_test[0]))
	print('Accuracy on test data', accuracy_score(y_test, y_pred)) 
	print('Classification report on test data: ') 
	print(classification_report(y_test, y_pred))
	#print('y_test: ', type(y_test[0]), y_test)
	print('y_pred: ', y_pred.dtype, y_pred)
	#print ("y_pred[0]: ", y_pred[0].dtype, y_pred[0])
	print('F1 score on test data', f1_score(y_test, y_pred, labels=['0','1'],pos_label='1'))

main()	
			
