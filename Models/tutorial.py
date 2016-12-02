#https://en.wikipedia.org/wiki/Iris_flower_data_set

from sklearn import datasets

iris = datasets.load_iris()
from sklearn.naive_bayes import GaussianNB

#print(iris)
gnb = GaussianNB()

print iris.data

print iris.target

#y_pred = gnb.fit(iris.data, iris.target).predict(iris.data)
#print("Number of mislabeled points out of a total %d points : %d" % (iris.data.shape[0],(iris.target != y_pred).sum()))

#Number of mislabeled points out of a total 150 points : 6
