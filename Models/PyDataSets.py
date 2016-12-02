import csv
import pandas as pd
import numpy as np
from sklearn import preprocessing

def test():
	a = "Testing"
	return a


#returns a data frame of the prescriber opioids
def loadOpioids():
	
	opioidCSV = pd.DataFrame.from_csv('../Datasets/clean/prescriber-info-cleaned.csv', header=0)
	opioidArray = opioidCSV.values
	# le = preprocessing.LabelEncoder()
	# le.fit(opioidArray)  
	# le.classes_
	# OneHotEncoder(categorical_features=[1, 2], dtpe="np.float64", handle_unknown='error', n_values='auto', sparse=True)

	# print opioidArray

	opioidTarget = opioidCSV['Opioid.Prescriber'].values
	print opioidTarget

	opioidVars = opioidCSV[opioidCSV.columns.difference(['Opioid.Prescriber'])].values
	print opioidVars

	opioidDict = {}
	opioidDict['vars'] = opioidVars
	opioidDict['target'] = opioidTarget

	return opioidDict


