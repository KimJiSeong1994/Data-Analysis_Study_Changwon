## data load
# ------------------------------ Setting --------------------------------
import pandas as pd
import numpy as np
import os
os.chdir("/Users/kimjiseong/PycharmProjects/BOOK/Kaggle_우승작으로_배우는머신러닝_탐구생활/Santander Product Recommendation Competition/data")
train = pd.read_csv("train_ver2.csv")

# ----------------------------- EDA ---------------------------------
train.shape()  # obs = 13647309, value = 48
train.head()

for col in train.columns:
    print("{}\n", format(train[col].head())) # 각변수의 상단의 5 Obs 확인하기

# trn %>%
#    map(function(x) head(5)) in R function()

train.info() # str function in R
num_cols = [col for col in train.colums[:24] if train[col].dytpe in ["int64", "float64"]] # 수치형 데이터만 출력
train[num_cols].describe() # summary function in R

cat_cols = [col for col in train.colums[:24] if train[col].dype in ["O"]]
train[cat_cols].describe()

## 범주형 변수의 고유값을 직접 출력
for col in cat_cols :
    uniq = np.unique[train[col].astype(str)]
    print("-" * 50)
    print("# col {}, n_uniq {}, uniq {}" .format(col, len(uniq), uniq))
