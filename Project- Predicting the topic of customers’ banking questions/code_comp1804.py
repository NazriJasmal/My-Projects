# -*- coding: utf-8 -*-
"""code_comp1804

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1iZoT8U404zMQVGykji_HCsnSXkaEwC2H

# **COMP1804-Applied Machine Learning Coursework**
### Option 2 Dataset: Predicting the topic of customers’ banking queries.
We are consulting a bank on how to make their online customer service more effective.
The Bank wants to trial an automated first level of filtering for questions asked by customers in an online chat. Specifically, they want to know whether it is possible to identify the topic a question relates to, for some specific topics of interest. The Dataset is also provided with sample questions and their associated topics .

We need to use machine learning to predict the question topic, whether a question is in the following categories: “card queries or issues”, “needs troubleshooting”, “top up queries or issues” or “other”.

##Importing Essential Libraries and Read the Dataset

#### Import Essential Libraries
"""

!pip install gdown

"""####Download the Dataset from google drive
The dataset provided by the bank in the ".csv" format is uploaded to the google drive.

Use the python package gdown to download the csv file from the google drive
"""

import spacy
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from IPython.display import HTML
import seaborn as sns
import gdown

gdown.download_folder('https://drive.google.com/drive/folders/13l1CyKYt_rAryX4089KofeWg4Iv5wHoq', quiet=True)

# Create an NLP pipeline
nlp = spacy.load('en_core_web_sm')

"""#### Beautified display of data frame
This function is used to  display the data frame neatly to get a better understanding of the data within it.
"""

def display_clean(value):
  display(HTML(pd.DataFrame(value).to_html()))

"""####Load the Dataset from the CSV file
Load the data from csv file to a dataframe using the pandas.
"""

data = pd.read_csv('/content/COMP1804-BankDataset/OPTION2_joined_coursework_dataset_banking_final.csv')

"""##Analysing the Dataset and EDA

EDA stands for Exploratory Data Analysis. It is a process of examining and analyzing data sets to summarize their main characteristics, identify patterns, and detect anomalies or outliers. EDA is typically conducted prior to any formal statistical testing or modeling and is aimed at gaining insights into the data and developing an understanding of its structure and relationships between variables. 

Before proceeding, Analyse the data and undersand the basic outline of the data.

#### Dimension of the Data
"""

data.shape

"""The provided dataset contains 14195 entries and 3 columns.

#### Columns in the dataset
"""

data.columns

"""The columns in the dataset are:
* text
* label
* query_index

####Data types of each columns
"""

data.dtypes

"""#### Explore the dataset"""

print(data.head())

"""From the dataset we can understand about the columns:
* text - questions asked by the customers
* labels - category to which the questions belong to
* query_index - a unique identifier.

We can use df.sample() for the random display of rows in the dataset. We can pass an integer as argument to indicate how many rows need to be displayed randomly.
"""

print(data.sample(5))

"""The attribute df.loc[index] can be used to get the data in this particular index."""

print(data.loc[423])

"""We can notice that certain labels in the data set are represented as NaN, indicating missing data. In Python, missing or empty fields are replaced with "NaN"

Let's see how many empty datas are there in the given dataset.

####Checking the issues

First we will check whether empty or null data is present in the dataset.
"""

data.isna().sum()

"""The column label have empty fields, which is approximately 3-4% of the entire dataset. We will handle this in the data preprocessing stage.

Now we will check whether duplicate values are present in the dataset.
"""

data.duplicated().sum()

"""There are some duplicated entries in the dataset.

Now we will check how many customers' queries in the dataset are repeated.
"""

data.text.duplicated().sum()

display_clean(data.loc[data.text.duplicated()].head())

"""From this we can understand that the entry in the dataset with '#' symbol refers to a missing data point

"""

print(data.describe())

"""Use describe() function to get the statistics of the dataset.
From the statistics of data we can understand that `text` field contains `#` values about 68 times. We can also assume that `#` is not a question that belong to this field. So, it is important to train the model. We will handle this in data preprocessing section
"""

data_text = data.text
sorted_duplicates = data[data_text.isin(data_text[data_text.duplicated()])].sort_values("text")

display_clean(sorted_duplicates.head())

"""#### Check Data Imbalance
We will plot a bar graph to check any imbalance in the dataset.
"""

display_clean(data['label'].value_counts())
data['label'].value_counts().plot.bar()
plt.show()

"""From that Bar graph, we can see that the `top_up_queries_or_issues` is significantly lesser than the `other`. Overall, the dataset is not heavily imbalanced.

Also we can see that the categories which are same but are recognised as distinct, like "other" and "Other". This is due to the inconsistency in their naming conventions.

##Data preprocessing
It can be difficult to ensure the quality of large datasets due to various issues such as missing data, inconsistency, and irrelevant features. Nonetheless, manually detecting all of these problems can be impractical and time-consuming.

#### Irrelevant or Duplicate Data in the dataset

As observed during the EDA process, the dataset contains some missing values represented by the '#' symbol, which can be safely removed. 

However, it is possible that there may be other missing data points in the dataset, and it is important to determine how many of these are present.

We can use `df.isna()` to detect any value is missing in the dataset.
"""

data.drop(data.loc[data.text=="#"].index, inplace=True)

"""Now, we will remove the possible duplicate values that may be present in the dataset."""

data.drop_duplicates(inplace=True)
print(data.duplicated().sum())

"""Now check the statistical properties using describe() function to ensure that the data is ready to use in the subsequent modelling steps."""

data.describe()

"""We can see that there is still some duplicates in the dataset. If we see the above statistics, the question `What do you need my identity details for?` is occuring twice in the dataset."""

display_clean(data.loc[data.text == 'What do you need my identity details for?'])

"""We can see that same question assigned to an empty label also. Lets now try to find any duplicates is occuring in the `text` field."""

data.text.duplicated().sum()

data.label.isna().sum()

display_clean(data.loc[data.text == 'Are there any fees for top ups?'])

"""Lets now remove the empty field in the `label` field as we could see that empty field is occuring in the duplicate data. In order to maintain completeness, we will remove only the empty values in the label field."""

data.drop(data.loc[data.label.isna()].index, inplace=True)

display_clean(data.loc[data.text == 'Are there any fees for top ups?'])

data.text.duplicated().sum()

"""Use the function value_counts() to get the number of categories in the dataset."""

display_clean(data['label'].value_counts())

"""It is evident that certain categories in the dataset are same but are being recognized as distinct categories due to inconsistencies in their naming conventions. For example, "other" and "Other"  refer to the same category."""

data.loc[data.label=='Card_queries_or_issues','label'] = 'card_queries_or_issues'
data.loc[data.label=='Top_up_queries_or_issues','label'] = 'top_up_queries_or_issues'
data.loc[data.label=='Needs_troubleshooting','label'] = 'needs_troubleshooting'
data.loc[data.label=='Other','label'] = 'other'

label = data['label'].value_counts().index

"""#### Text Cleaning"""

nlp.Defaults.stop_words -= {"top", "up"}
# nlp.Defaults.stop_words -= {"top", "up", "down", "due"}

def cleanText(text):
  doc = nlp(text)
  lemmaData = []
  for i,token in enumerate(doc):
    if (token.is_stop) or (token.is_punct):
      pass;
    else:
      lemmaData.append(token.lemma_);
  return ' '.join(lemmaData);

data['cleaned'] = data['text'].apply(lambda x: cleanText(x))

data.head()

data.describe()

"""#### Label Encoding"""

from sklearn.feature_extraction.text import CountVectorizer

vectorizer = CountVectorizer()
X_data = vectorizer.fit_transform(data['cleaned'].values).toarray()
Y_target = data['label']

from sklearn.preprocessing import LabelEncoder

# create an object of the LabelEncoder class
lblEncoder_Y = LabelEncoder()

# apply LblEncoder object to our target variables
Y_target = lblEncoder_Y.fit_transform(Y_target)

Y_target

"""#### Dimensionality Reduction using PCA"""

import pandas as pd
import numpy as np
from sklearn.decomposition import PCA
from matplotlib import cm

# perform PCA with two components
pca = PCA(n_components=2)
transformed_data = pca.fit_transform(X_data)

# get all possible classes
classes_ = np.unique(Y_target)
adop = lblEncoder_Y.inverse_transform(classes_)
# assign different colors to different classes
colors = cm.get_cmap("tab10")(np.linspace(0,1,len(classes_)))

# plot the transformed data for each class with a different color
plt.figure(figsize=(10, 10))
for target_class,color in zip(classes_, colors):
    # let's only plot the transformed data points for a given label
    plt.scatter(transformed_data[Y_target==target_class,0],
                transformed_data[Y_target==target_class,1],
                label=classes_,
                color=color)
plt.legend(adop)

"""#### OverSampling

To address the data imbalance issue, we will apply the oversampling method by utilizing the SMOTE library.

"""

from imblearn.over_sampling import SMOTE
from numpy import where

# transform the dataset
oversample = SMOTE()
X, Y = oversample.fit_resample(X_data, Y_target)

"""Let us now plot the sample data"""

sampledData = pd.DataFrame()
sampledData["label"] = lblEncoder_Y.inverse_transform(Y)
sampledData['label'].value_counts().plot.bar()
plt.show()
print(sampledData['label'].value_counts())

"""#### Splitting the Data"""

from sklearn.model_selection import train_test_split

# train_dataset, test_dataset = train_test_split(data, stratify=data['label'], test_size= 0.2)
X_train_dataset, X_temp_dataset, Y_train_dataset, Y_temp_dataset = train_test_split(X, Y, stratify=Y, test_size= 0.8)
X_valid_dataset, X_test_dataset, Y_valid_dataset, Y_test_dataset = train_test_split(X_temp_dataset, Y_temp_dataset, test_size= 0.5)

"""##Machine Learning Modeling

#### Majority Class Modeling
"""

from sklearn.dummy import DummyClassifier
from sklearn.metrics import accuracy_score, confusion_matrix, classification_report, ConfusionMatrixDisplay

dummy = DummyClassifier(strategy='most_frequent')
dummy.fit(X_train_dataset, Y_train_dataset)
y_pred = dummy.predict(X_test_dataset)
print(classification_report(Y_test_dataset, y_pred))

"""#### Traditional Modelling using MultinomialNB"""

from sklearn.naive_bayes import MultinomialNB
from sklearn.model_selection import GridSearchCV

model = MultinomialNB() # using naive bayes classification algorithm 
param_grid = {'alpha': [0.1, 5.0, 30.0]}
grid = GridSearchCV(model, param_grid, cv=5)
grid.fit(X_train_dataset,Y_train_dataset)

## predicting the values
y_pred = grid.predict(X_test_dataset)

#score of the model
grid.score(X_valid_dataset,Y_valid_dataset)

print(y_pred)

from sklearn.metrics import accuracy_score, confusion_matrix, classification_report, ConfusionMatrixDisplay

print(classification_report(Y_test_dataset, y_pred))

cm = confusion_matrix(Y_test_dataset,y_pred)

confusion_matrix = ConfusionMatrixDisplay(confusion_matrix=cm)
confusion_matrix.plot()

ax = sns.heatmap(cm, annot=True, cmap='Blues', fmt='g')
plt.xlabel('Predicted Label')
plt.ylabel('Actual Label')
ax.set_xticklabels(label, rotation=45, horizontalalignment='right')
ax.set_yticklabels(label, rotation=0, horizontalalignment='right')
plt.show()

"""#### Traditional Modeling using SGDClassifier"""

from sklearn.linear_model import SGDClassifier

sgd_classifier = SGDClassifier()
param_grid = {
  'penalty': ['l2', 'elasticnet'],
  'alpha': [0.0001, 0.001, 0.01],
  'max_iter': [1000, 5000, 10000],
  'class_weight': ['balanced']
}
grid = GridSearchCV(sgd_classifier, param_grid, cv=5)
grid.fit(X_train_dataset,Y_train_dataset)

print("Best: %f using %s" % (grid.best_score_, grid.best_params_))

## predicting the values
y_pred = grid.predict(X_test_dataset)

#score of the model
grid.score(X_valid_dataset,Y_valid_dataset)

print(classification_report(Y_test_dataset, y_pred))

from sklearn.metrics import accuracy_score, confusion_matrix, classification_report, ConfusionMatrixDisplay
cm = confusion_matrix(Y_test_dataset,y_pred)

confusion_matrix = ConfusionMatrixDisplay(confusion_matrix=cm)
confusion_matrix.plot()

ax = sns.heatmap(cm, annot=True, cmap='Blues', fmt='g')
plt.xlabel('Predicted Label')
plt.ylabel('Actual Label')
ax.set_xticklabels(label, rotation=45, horizontalalignment='right')
ax.set_yticklabels(label, rotation=0, horizontalalignment='right')
plt.show()

"""#### Traditional Modelling using Logistic Regression"""

from sklearn.linear_model import LogisticRegression
from sklearn.metrics import f1_score, make_scorer

model = LogisticRegression(max_iter=1000)
# logisRe.fit(X_train_dataset,Y_train_dataset)

scorer = make_scorer(f1_score, average='weighted')
param_grid = {'penalty': ['l2'], 'C': [0.01, 0.1, 1, 10]}
grid = GridSearchCV(model, param_grid, scoring=scorer, cv=5)
grid.fit(X_train_dataset,Y_train_dataset)

# Print the best hyperparameters and corresponding accuracy score
print("Best: %f using %s" % (grid.best_score_, grid.best_params_))

## predicting the values
y_pred = grid.predict(X_test_dataset)

#score of the model
grid.score(X_valid_dataset,Y_valid_dataset)

print(classification_report(Y_test_dataset, y_pred))

from sklearn.metrics import accuracy_score, confusion_matrix, classification_report, ConfusionMatrixDisplay
cm = confusion_matrix(Y_test_dataset,y_pred)

confusion_matrix = ConfusionMatrixDisplay(confusion_matrix=cm)
confusion_matrix.plot()

ax = sns.heatmap(cm, annot=True, cmap='Blues', fmt='g')
plt.xlabel('Predicted Label')
plt.ylabel('Actual Label')
ax.set_xticklabels(label, rotation=45, horizontalalignment='right')
ax.set_yticklabels(label, rotation=0, horizontalalignment='right')
plt.show()

"""#### Building Artificial Neural Network using Keras"""

from keras.models import Sequential
from keras.layers import Dense, Dropout
from keras.wrappers.scikit_learn import KerasClassifier
import tensorflow as tf

# Define the model architecture
def create_model(dropout_rate=0.0):
    model = Sequential()
    model.add(Dense(104, activation='relu'))
    model.add(Dropout(dropout_rate))
    model.add(Dense(len(data['label'].value_counts()), activation='softmax'))
    model.compile(loss=tf.keras.losses.SparseCategoricalCrossentropy(), optimizer=tf.keras.optimizers.Adam(learning_rate=0.001), metrics=['accuracy'])
    return model

model = KerasClassifier(build_fn=create_model)

param_grid = {
    'batch_size': [10, 50, 120],
    'epochs': [20, 60],
    'dropout_rate': [0.2]
}

# Create the GridSearchCV object
grid = GridSearchCV(estimator=model, param_grid=param_grid, cv=5)

# Fit the GridSearchCV object to the training data
grid_result = grid.fit(X_train_dataset,Y_train_dataset)

# Print the best hyperparameters and corresponding accuracy score
print("Best: %f using %s" % (grid_result.best_score_, grid_result.best_params_))

test_probabilities = grid_result.predict(X_test_dataset)

print(classification_report(Y_test_dataset, y_pred))

from sklearn.metrics import accuracy_score, confusion_matrix, classification_report, ConfusionMatrixDisplay

cm = confusion_matrix(Y_test_dataset,y_pred)
confusion_matrix = ConfusionMatrixDisplay(confusion_matrix=cm)
confusion_matrix.plot()

labels = lblEncoder_Y.inverse_transform(classes_)
labels