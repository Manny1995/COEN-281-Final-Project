#Builds a simple decision tree

import csv
with open('../../Datasets/opioids.csv', 'rb') as opioidFile:
    reader = csv.reader(opioidFile, delimiter=" ", quo techar = '|')
    for row in reader:
        print ', ' . join(row)
