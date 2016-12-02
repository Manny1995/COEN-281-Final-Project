from sklearn.naive_bayes import GaussianNB
import numpy as np
import PyDataSets as data

gbModel = GaussianNB()


opioids = data.loadOpioids()
# print opioids.values

gnb = GaussianNB()
# print opioids.columns
#print np.ravel(opioids['Opioid.Prescriber'].values)
#print np.ravel(opioids[['BRIMONIDINE.TARTRATE', 'FELODIPINE.ER']])
#print opioids[['Opioid.Prescriber']]

# y = np.ravel(opioids[['Opioid.Prescriber']])

target = opioids['target']
values = opioids['vars']

print target.shape
print values.shape

y_pred = gnb.fit(values, target).predict(target)

