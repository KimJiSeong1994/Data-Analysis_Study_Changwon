#  ================================================= [ setting ] ==================================================
import pandas as pd
import numpy as np
import os
import xgboost as xgb

os.chdir('C:/Users/knuser/PycharmProjects/BOOK/Kaggle_우승작으로_배우는머신러닝_탐구생활/Santander Product Recommendation Competition/Data')

np.random.seed(2018) # set.seed function in R
train = pd.read_csv('train_ver2.csv')
test = pd.read_csv('test_ver2.csv')

#  ======================================== [ tidying data to modeling ] ========================================

prods = train.colums[24:].tolist() # 제품에 관한 변수들 별도 저장
train[prods] = train[prods].fillna(0.0).astype(np.int8) # NA값을 0으로 대처

no_product = train[prods].sum(axis = 1) == 0 # 상품을 하다고 구매하지 않은 고객은 제외
train = train[~no_product]

for col in train.columns[24: ] :
    test[col] = 0 # 테스트 데이터에 없는 제품 변수는 0으로 대처
    df = pd.concat([train, test], axis = 0) # train, test set 합침

features = []
categorical_cols = ['ind_empleado', 'pais_residencia', 'pais_residencia', 'sexo',
                    'tiprel_1mes', 'indext', 'conyuemp', 'canal_entrada',
                    'indfall', 'tipodom', 'nomprov', 'segmento']
for col in categorical_cols :
    df[col], _ = df[col].factorize(na_sentinel =- 99) # 결측값을 99로 대처
features += categorical_cols

## [ remove odd obs & NA] ------------------------------------------------------
df['age'].replace(' NA', -99, inplace = True)
df['age'] = df['age'].astype(np.int8)

df['antiguedad'].replace('      NA', -99, inplace = True)
df['antiguedad'] = df['antiguedad'].astype(np.int8)

df['renta'].replace('      NA', -99, inplace = True)
df['renta'].fillna(-99, inplace = True)
df['renta'] = df['renta'].astype(np.int8)

features += ['age', 'antiguedad', 'renta', 'ind_nuevo', 'indrel', 'indrel_1mes', 'ind_actividad_cliente'] # 사용변수 추가

## [ date value를 통해 year, month  파생변수 형성] -----------------------------
df['fecha_alta_month'] = df['fecha_alta'].map(lambda x : 0.0 if x.__class__ is float else float(x.split('-')[1])).astype(np.int8)
df['ult_fec_cli_1t_year'] = df['ult_fec_cli_1t_year'].map(lambda x : 0.0 if x.__class__ is float else float(x.split('-')[0])).astype(np.int16)
features += ['fecha_alta_month', 'ult_fec_cli_1t_year']

## [날짜를 숫자로 변환] --------------------------------------------------------
df.fillna(-99, inplace = True)
def date_to_int(str_date) :
    Y, M, D = [int(a) for a in str_date.strip().split("-")]
    int_date = (int(Y) - 2015) * 12 + int(M)
    return int_date

df['int_date'] = df['fecha_dato'].map(date_to_int).astype(np.int8)

## [lag-1 변수 생성 ] --------------------------------------------------------
df_lag = df.copy()
df_lag.colnums = [col + '_prev' if col not in ['ncodpers', 'int_date'] else col for col in df.columns]
df_lag['int_date'] += 1

df_train = df.merge(df_lag, on = ['ncodpers', 'int_date'], how = 'left')
for prod in prods :
    prev = prod + '_prev'
    df_train[prev].fillna(0, inplace = True) # 지난 달의 제품 정보가 존재하지 않을 경우 0으로 대처

features += [feature + '_prev' for feature in features]
features += [prod + '_prev' for prod in prods]

#  ============================================ [ 모델 평가 ] ==================================================
## [ 교차분석 ] -------------------------------
use_dates = ['2016-01-28', '2016-02-28', '2016-03-28', '2016-04-28', '2016-05-28'] # train set에 사용할 변수
train = df_train[df_train['fecha_dato'].isin(use_dates)]
test = df_train['fecha_dato' == '2016-06-28']

X = []
Y = []
for i, prod in enumerate(prods) : # train set에서 신규 구매 건수만 추출
    prev = prod + '_prev'
    prX = train[(train[prod]) == 1 & (train[prev] == 0)]
    prY = np.zeros(prX.shape[0], dtype = np.int8) + i
    X.append(prX)
    Y.append(prY)
XY = pd.concat(X)
Y = np.hstack(Y)
XY['y'] = Y

vld_date = '2016-05-28'
XY_train = XY[XY['fecha_dato'] != vld_date]
XY_vld = XY[XY['fecha_dato'] == vld_date]

## [ XGBoost modeling ] -------------------------------
param =  {
    'booster' : 'gbtree',
    'max_depth' : '8',
    'nthread' : 4,
    'num_class' : len(prods),
    'objdective' : 'mlogloss',
    'eta' : 0.1,
    'min_child_weight' : 10,
    'colsample_bytree' : 0.8,
    'colsample_bylevel' : 0.9,
    'seed' : 2018
}

X_train = XY_train.as_matrix(columns = features)
Y_train = XY_train.as_matrix(columns = ['y'])
dtrain = xgb.DMatrix(X_train, label = Y_train, feature_names = features)

X_vld = XY_vld.as_matrix(columns = features)
Y_vld = XY_vld.as_matrix(columns = ['y'])
dvld = xgb.DMatrix(X_vld, label = Y_vld, feature_names = features)

watch_list = [(dtrain, 'train'), (dvld, 'eval')]
model = xgb.train(param,
                  dtrain,
                  num_boost_round = 1000,
                  evals = watch_list,
                  early_stopping_rounds = 20)

import pickle
pickle.dump(model, open('model/xgb.baseline.pkl', 'wb'))
best_ntree_limit = model.best_ntree_limit  # 학습한 모델을 저장

#  ============================================ [ MAP@7 평가 척도 계산 ] ===============================================
vld = train[train['fecha_dato'] == vld_date]
ncodpers_vld = vld.as_matrix(columns = ['ncodpers'])

for prod in prods : # 고객 식별 번호를 추출
    prev = prod + '_prev'
    padd = prod + '_add'
    vld[padd] = vld[prod] - vld[prev]
add_vld = vld.as_matrix(columns = [prod + '_add' for prod in prods])
add_vld_list = [list() for i in range(len(ncodpers_vld))]

count_vld = 0
for ncodper in range(len(ncodpers_vld)) :
    for prod in range(len(prods)) :
        if add_vld[ncodper, prod] > 0 :
            add_vld_list[ncodper].append(prod)
            count_vld += 1

from .MAP7 import mapk
print(mapk(add_vld_list, add_vld_list, 7, 0.0)) # 검증데이터에서 얻을수 있는 최대 MAP@7 값 계산 (0.042663)

X_vld = vld.as_matrix(columns = features)
Y_vld = vld.as_matrix(columns = ['y'])
dvld = xgb.DMatrix(X_vld, label = Y_vld, feature_names = features)
preds_vld = model.predict(dvld, ntree_limit = best_ntree_limit)
preds_vld = preds_vld - vld.as_matrix(columns =  [prod + '_prev' for prod in prods]) # 저번 달에 보유한 제품은 신규 구매가 불가 (확률값에서 1을 빼줌)

result_vld = []
for ncodper, pred in zip(ncodpers_vld, preds_vld) :
    y_prods = [(y, p, ip) for y, p, ip in zip(pred, prods, range(len(prods)))]
    y_prods = sorted(y_prods, key = lambda a : a[0], reverse = True)[:7] # 예츠 상위 7개 추출
    result_vld.append([ip for y, p, ip in y_prods])

print(mapk(add_vld_list, result_vld, 7, 0.0)) # (0.036466)
(0.036466 / 0.042663) # 약 85% acc.

#  ============================================ [ 재출파일 만들기 ] ===============================================
## [ XGBoost 모델을 전체 훈련 데이토로 재학습 ] -----------------
X_all = XY.as_matrinx(columns = features)
Y_all = XY.as_matrinx(columns = ['y'])
dall = xgb.DMatrix(X_all, label = Y_all, feature_names = features)
watch_list = [(dall, 'train')]

best_ntree_limit = int(best_ntree_limit * (len(XY_train) + len(XY_vld)) / len(XY_train))
model = xgb.train(param,
                  dall,
                  num_boost_round = best_ntree_limit,
                  evals = watch_list) # 모델 재학습

print('Freature importance: ')
for kv in sorted([(k, v) for k, v in model.get_fscore().items()],
                 key = lambda kv : kv[1], reverse = True) :
    print(kv) # 변수 중요도 확인

X_test = test.as_matrix(columns = features)
dtest = xgb.DMatrix(X_test, feature_names = features)
preds_test = model.predict(dtest, ntree_limit = best_ntree_limit)
ncodpers_test = test.as_matrix(columns = ['ncodpers'])
preds_test = preds_test - test.as_matrix(columns = [prod + '_prev' for prod in prods])

submit_file = open('model/xgb.baseline.2015-06-28', 'w')
submit_file.write('ncodpers,added_products\n')
for ncodper, pred in zip(ncodpers_test, preds_test) :
    y_prods = sorted(y_prods, key = lambda a : a[0], reverse = True)[:7]
    y_prods = [p for y, p, ip in y_prods]
    submit_file.write('{},{}\n'.format(int(ncodper), ' '.join(y_prods)))
