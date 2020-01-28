## ================================================== [ setting ] ==================================================
import numpy as np
import pandas as pd
from sklearn.metrics import roc_auc_score
from sklearn.linear_model import LogisticRegression
from collections import defaultdict

usecols = ['ncodpers', 'ind_ahor_fin_ult1', 'ind_aval_fin_ult1', 'ind_cco_fin_ult1',
       'ind_cder_fin_ult1', 'ind_cno_fin_ult1', 'ind_ctju_fin_ult1',
       'ind_ctma_fin_ult1', 'ind_ctop_fin_ult1', 'ind_ctpp_fin_ult1',
       'ind_deco_fin_ult1', 'ind_deme_fin_ult1', 'ind_dela_fin_ult1',
       'ind_ecue_fin_ult1', 'ind_fond_fin_ult1', 'ind_hip_fin_ult1',
       'ind_plan_fin_ult1', 'ind_pres_fin_ult1', 'ind_reca_fin_ult1',
       'ind_tjcr_fin_ult1', 'ind_valo_fin_ult1', 'ind_viv_fin_ult1',
       'ind_nomina_ult1', 'ind_nom_pens_ult1', 'ind_recibo_ult1'] # 상품품목으로 data parsing

train = pd.read_csv("C:/Users/knuser/PycharmProjects/Data-Analysis_Study_Changwon/BOOK/Kaggle_우승작으로배우는_머신러닝탐구생활/Santander_Product_Recommendation/Data/train_ver2.csv", usecols = usecols)
sample = pd.read_csv("C:/Users/knuser/PycharmProjects/Data-Analysis_Study_Changwon/BOOK/Kaggle_우승작으로배우는_머신러닝탐구생활/Santander_Product_Recommendation/Data/sample_submission.csv")


train = train.drop_duplicates(["ncodpers"], keep = "last")
train.fillna(0, inplace = True) # str_replace_na() function in R

models = {}
model_preds = {}
id_preds = defaultdict(list)
ids = train["ncodpers"].values

for c in train.columns :
       if c != "ncodpers" :
              print(c)
              y_train = train[c]
              x_train = train.drop([c, "ncodpers"], 1)

              clf = LogisticRegression() # 이항 분류
              clf.fit(x_train, y_train)
              p_train = clf.predict_proba(x_train)[:, 1]

              models[c] = clf
              model_preds[c] = p_train
              for id, p in zip(ids, p_train):
                     id_preds[id].append(p)
                     print(roc_auc_score(y_train, p_train))

already_active = {}
for row in train.values:
       row = list(row)
       id = row.pop(0)
       active = [c[0] for c in zip(train.columns[1: ]) if c[1] > 0]
       already_active[id] = active

train_preds = {}
for id, p in id_preds.items():
       preds = [i[0] for i in sorted([i for i in zip(train.columns[1:], p) if i[0] not in already_active[id]], key=lambda i: i[1], reverse=True)[:7]]
       train_preds[id] = preds

test_preds = []
for row in sample.values:
       id = row[0]
       p = train_preds[id]
       test_preds.append(" ".join(p))

sample['added_products'] = test_preds
sample.to_csv("collab_sub.csv", index= False)
