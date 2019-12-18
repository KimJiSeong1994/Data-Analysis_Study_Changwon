# ======================================== [ setting ]  ========================================
import pandas as pd
import numpy as np
import os
os.chdir('C:\\Users\\knuser\\PycharmProjects\\BOOK\\Kaggle_우승작으로_배우는머신러닝_탐구생활\\Santander Product Recommendation Competition\\Data')
train = pd.read_csv("train_ver2.csv")

# ======================================== [ EDA ]  ========================================

train.shape # (13647309, 48)
train.info() # info = str function in R

num_cols = [col for col in train.columns[:24] if train[col].dtype in ['int64', 'float64']] # 수치형 변수 값 확인하기
train[num_cols].describe() # describe = summary function in R

cat_cols = [col for col in train.columns[:24] if train[col].dtype in ['O']] # 범주형 변수 값 확인하기
train[cat_cols].describe()

import matplotlib
import matplotlib.pyplot as plt
import seaborn as sns
# %matplotlib inline # jupyter notebook에서 plot를 출력하기 위해

# [ 범주형 데이터 plotting ] ----------------------------------------------------------------
skip_cols = ['ncodpers', 'renta']
for col in train.columns:
    if col in skip_cols:
        continue

    print("-" * 50)
    print("col : ", col)

    f, ax = plt.subplots(figsize=(20, 15))
    sns.countplot(x=col, data=train, alpha=0.5)
    plt.show()

# [ time-data plotting ] ----------------------------------------------------------------
months = np.unique(train['fecha_dato']).tolist()
label_cols = train.columns[24:].tolist()

label_over_time = []
for i in range(len(label_cols)):
    label_sum = train.groupby(['fecha_dato'])[label_cols[i]].agg('sum')
    label_over_time.append(label_sum.tolist())
label_sum_over_time = []

for i in range(len(label_cols)):
    label_sum_over_time.append(np.asarray(label_over_time[i:]).sum(axis=0)) # asarray : input data를 배열행태로 변환
color_list = ['#F5B7B1', '#D2B4DE', '#AED6F1', '#A2D9CE', '#ABEBC6', '#F9E79F', '#F5CBA7', '#CCD1D1']
f, ax = plt.subplots(figsize=(30, 15))
for i in range(len(label_cols)):
    sns.barplot(x=months,
                y=label_sum_over_time[i],
                color=color_list[i % 8],
                alpha=0.7)
plt.legend([plt.Rectangle((0, 0), 1, 1, fc=color_list[i % 8], edgecolor='none') for i in range(len(label_cols))],
           label_cols, loc=1, ncol=2, prop={'size': 16})


label_sum_percdent = (label_sum_over_time / (1.*np.asarray(label_sum_over_time).max(axis = 0))) * 100
f, ax = plt.subplots(figsize = (30, 15))
for i in range(len(label_cols)) :
    sns.barplot(x = months,
               y = label_sum_percdent[i],
               color = color_list[i%8],
               alpha = 0.7) # 월별 상대값 (비율)로 시각화
plt.legend([plt.Rectangle((0,0), 1, 1,fc = color_list[i%8], edgecolor = 'none')
            for i in range(len(label_cols))], label_cols, loc = 1, ncol = 2, prop={'size':16})

# [ 신규 구매 데이터 생성 ] ----------------------------------------------------------------
prods = train.columns[24:].tolist()
def date_to_int(str_date):
    Y, M, D = [int(a) for a in str_date.strip().split("-")]
    int_date = (int(Y) - 2015) * 12 + int(M)
    return int_date

train['int_date'] = train['fecha_dato'].map(date_to_int).astype(np.int8)
train_lag = train.copy()
train_lag.columns = [col + '_prev' if col not in ['ncodpers', 'int_date'] else col for col in train.columns]
df_train = train.merge(train_lag, on=['ncodpers', 'int_date'], how='left')  # 데이터 합치기

del train, train_lag  # del = rm function in R
for prod in prods:
    prev = prod + '_prev'
    df_train[prev].fillna(0, inplace=True)  # fillna = str_replace_na function in R

for prod in prods:
    padd = prod + '_add'
    prev = prod + '_prev'
    df_train[padd] = ((df_train[prod] == 1) & (df_train[prev] == 0)).astype(np.int8) # 날짜를 숫자 데이터로 변환

add_cols = [prod + '_add' for prod in prods]
labels = df_train[add_cols].copy()
labels.columns = prods
labels.to_csv('labels.csv', index = False) # 신규 구매 변수만을 추출하여 저장

lebels = pd.read_csv('labels.csv').astype(int)
fecha_dato = pd.read_csv('train_ver2.csv', usecols = ['fecha_dato'])

labels['date'] = fecha_dato.fecha_dato
months = np.unique(fecha_dato.fecha_dato).tolist()
label_cols = labels.columns.tolist()[:24]

label_over_time = []
for i in range(len(label_cols)) :
    label_over_time.append(labels.groupby(['date'])[label_cols[i]].agg('sum').tolist())

label_sum_over_time = []
for i in range(len(label_cols)) :
    label_sum_over_time.append(np.asarray(label_over_time[i:]).sum(axis = 0))

color_list = ['#F5B7B1', '#D2B4DE', '#AED6F1', '#A2D9CE', '#ABEBC6', '#F9E79F', 'F5CBA7', '#CCD1D1']
f, ax = plt.subplot(figsize = (30, 15))
for i in range(len(label_cols)):
    sns.barplot(x = months, y = label_sum_over_time[i], color = color_list[i%8], alpha = 0.7)
plt.legend([plt.Rectangle((0, 0), 1, 1,
                          fc = color_list[i%8],
                          edgecolor = 'none')
            for i in range(len(label_cols))],
           loc = 1,
           ncol = 2,
           prop = {'size' : 16}) #누적막대 그래프 plotting

label_sum_percent = (label_sum_over_time / (1.*np.asarray(label_sum_over_time).max(axis = 0))) * 100
f, ax = plt.subplot(figsize = (30, 15))
for i in range(len(label_cols)):
    sns.barplot(x = months, y = label_sum_percent[i], color = color_list[i%8], alpha = 0.7)
plt.legend([plt.Rectangle((0, 0), 1, 1,
                          fc = color_list[i%8],
                          edgecolor = 'none')
            for i in range(len(label_cols))],
           loc = 1,
           ncol = 2,
           prop = {'size' : 16}) #월별 상대값 그래프 plotting



