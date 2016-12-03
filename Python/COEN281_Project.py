
# coding: utf-8

# In[34]:

import os
import io
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn import neighbors, metrics, grid_search, cross_validation, preprocessing
from collections import Counter
import statsmodels.formula.api as smf
import seaborn as sns
import statsmodels.api as sm

from statsmodels.graphics.mosaicplot import mosaic

pd.set_option('display.max_rows', 10)
pd.set_option('display.notebook_repr_html', True)
pd.set_option('display.max_columns', 17)

get_ipython().magic(u'matplotlib inline')
plt.style.use('ggplot')


# In[77]:

df_overdoses = pd.read_csv(os.path.join('overdoses-cleaned.csv')) 
df_opioids = pd.read_csv(os.path.join('opioids.csv'))
df_prescriber= pd.read_csv(os.path.join('prescriber-info-cleaned.csv'))
df_prescriber_old= pd.read_csv(os.path.join('prescriber-info.csv'))
df= pd.read_csv(os.path.join('aggregatedInfo-clean.csv'))



# In[78]:

df


# In[13]:

df_overdoses 


# In[14]:

df_opioids


# In[15]:

df_prescriber 


# In[180]:

print"Describtion of Death Overdoses \n", df_overdoses.Deaths.describe()

df_maxOD= df_overdoses[df_overdoses.Deaths==df_overdoses.Deaths.max()]
df_minOD= df_overdoses[df_overdoses.Deaths==df_overdoses.Deaths.min()]

print "State with the highest", df_maxOD.iat[0, 1], "with the population of", df_maxOD.iat[0, 2], "and Death rate of", df_maxOD.iat[0, 3]
print "State with the lowest", df_minOD.iat[0, 1], "with the population of", df_minOD.iat[0, 2], "and Death rate of", df_minOD.iat[0, 3]


# In[142]:

normpop= preprocessing.normalize(df_overdoses.Population, norm='l2')

normpop
#overdoses/populartion *100000

#df_overdoses["PopNorm"]= pd.Series(normpop, index=df_overdoses.index) 


# In[143]:

def OD_pop(row):
    return (row.Deaths/row.Population)*100000

df_overdoses['Norm']=OD_pop(df_overdoses)
df_overdoses.head()


# In[179]:

df_maxOD_norm= df_overdoses[df_overdoses.Norm==df_overdoses.Norm.max()]
df_minOD_norm= df_overdoses[df_overdoses.Norm==df_overdoses.Norm.min()]

print "State with the highest rate of death overdoses per capita ", df_maxOD_norm.iat[0, 1],"with the popluation of", df_maxOD_norm.iat[0, 2],"and Death rate of", df_maxOD_norm.iat[0, 3]
print "State with the lowest rate of death overdoses per capita", df_minOD_norm.iat[0, 1],"with the popluation of", df_minOD_norm.iat[0, 2],"and Death rate of", df_minOD_norm.iat[0, 3]



# In[151]:

print"Describtion of Gender of Prescribers \n", df_prescriber_old.Gender.describe()
print"New Describtion of Gender of Prescribers \n", df.Gender.describe()


# In[152]:

print"Describtion of State of Prescribers \n", df_prescriber_old.State.describe()
print"New Describtion of State of Prescribers \n", df.State.describe()


# In[153]:

print"Describtion of Specialty of Prescribers \n", df_prescriber_old.Specialty.describe()
print"New Describtion of Specialty of Prescribers \n", df.Specialty.describe()


# In[28]:

print"Describtion of Credentials of Prescribers \n", df_prescriber_old.Credentials.describe()


# In[23]:

df_overdoses.Deaths.plot(kind = 'box', figsize = (8, 8), vert = False)


# In[22]:

df_overdoses.Norm.plot(kind = 'box', figsize = (8, 8), vert = False)


# In[187]:

sns.lmplot('Deaths', 'Population', df)


# In[189]:

df.NumState.plot(kind = 'hist', figsize = (8, 8))


# In[ ]:

model = smf.ols(formula = 'SalePrice ~ IsAStudio', data = df_prescriber).fit()

model.summary()


# In[ ]:




# In[155]:

sns.stripplot(x="State", y="OpioidP", data=df, jitter=True);


# In[35]:

plt.rcParams['font.size'] = 16.0
mosaic(df_prescriber_old, ['Gender', 'Opioid.Prescriber']);


# In[126]:

plt.rcParams['font.size'] = 16.0
mosaic(df, ['Specialty', 'OpioidP']);


# In[134]:

plt.rcParams['font.size'] = 16.0
plt.rcParams['figure.figsize'] = 10, 5
m= mosaic(df, ['Specialty', 'OpioidP','Gender']);


# In[190]:

f, ax = plt.subplots(figsize=(20, 20),)
sns.countplot(x="State",hue='Gender', data=df);
plt.rcParams.update({'font.size': 10})


# In[56]:

f, ax = plt.subplots(figsize=(4, 4),)
sns.countplot(y="Gender", data=df_prescriber_old, color="c");
plt.rcParams.update({'font.size': 10})


# In[191]:

f, ax = plt.subplots(figsize=(10, 10),)
sns.countplot(x="NumSpeciality",hue='Gender', data=df);
plt.rcParams.update({'font.size': 10})


# In[192]:

f, ax = plt.subplots(figsize=(10, 10),)
sns.countplot(x="OpioidP",hue='Gender', data=df);
plt.rcParams.update({'font.size': 10})


# In[193]:

f, ax = plt.subplots(figsize=(10, 10),)
sns.countplot(x="OpioidP",hue='Specialty', data=df);
plt.rcParams.update({'font.size': 10})


# In[60]:

g = sns.FacetGrid(df_prescriber_old, col="Gender")
g.map(plt.hist, "Opioid.Prescriber");


# In[62]:

g = sns.FacetGrid(df_prescriber_old, col="Gender")
g.map(plt.hist, "Opioid.Prescriber");


# In[64]:

sns.countplot(y="State", hue="Gender", data=df_prescriber_old, palette="Greens_d");


# In[79]:

sns.lmplot('NumGender', 'OpioidP', df)


# In[177]:

g = sns.FacetGrid(df, col="OpioidP", size=5, aspect=1)
g.map(sns.barplot, "Specialty", "Deaths");



# In[87]:

model_gender = smf.ols(formula = 'OpioidP ~ NumGender', data = df).fit()
model_gender.summary()


# In[88]:

model_state = smf.ols(formula = 'OpioidP ~ NumState', data = df).fit()
model_state.summary()


# In[89]:

model_spe = smf.ols(formula = 'OpioidP ~ NumSpeciality ', data = df).fit()
model_spe.summary()


# In[90]:

model_state_gender = smf.ols(formula = 'OpioidP ~ NumSpeciality + NumGender', data = df).fit()
model_state_gender.summary()


# In[196]:

model_state_gender = smf.ols(formula = 'OpioidP ~ NumSpeciality + NumState', data = df).fit()
model_state_gender.summary()


# In[86]:

g = sns.FacetGrid(df, col="OpioidP", hue="NumGender")
g.map(plt.scatter, "NumSpeciality", "Deaths", alpha=0.7)
g.add_legend();


# In[96]:

figure = sm.qqplot(model_gender.resid, line = 's')


# In[97]:

figure1 = sm.qqplot(model_state.resid, line = 's')


# In[98]:

figure2 = sm.qqplot(model_spe.resid, line = 's')


# In[99]:

figure3 = sm.qqplot(model_state_gender.resid, line = 's')


# In[103]:

sns.lmplot('NumState', 'OpioidP', df)


# In[104]:

sns.lmplot('NumSpeciality', 'OpioidP', df)


# In[108]:

sns.boxplot(x="Specialty", y="", hue="Gender", data=df);


# In[ ]:



