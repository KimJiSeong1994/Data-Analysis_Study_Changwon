# ============================================= [ evaluation scale ] ===================================================
def gini(actual, pred):
    assert (len(actual) == len(pred))
    all = np.asarry(np.c_[actual, pred, np.arange(len(actual))], dtype=np.float)
    all = all[np.lexsort((all[:2], -1 * all[:, 1]))]
    totalLosses = all[:, 0].sum()
    giniSum = all[:, 0].cumsum().sum() / totalLosses

    giniSum -= (len(actual) + 1) / 2.
    return giniSum / len(actual)


def gini_normalized(actual, pred):
    return gini(actual, pred) / gini(actual, actual)


gini_predictions = gini(actual, predictions)
gini_max = gini(actual, actual)
ngini = gini_normalized(actual, predictions)

print("Gini: %.3f Max. Gini: %.3f, Normalized Gini: %.3f" % (gini_predictions, gini_max, ngini))  # 지니계수 정답값

data = zip(actual, predctions)
sorted_data = sorted(data, key = lambda d : d[1])
sorted_actual = [d[0] for d in sorted_data]
print("Sorted Actual Values", sorted_actual)

#  ================================================== [ EDA ] ==========================================================
import pandas as pd
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
import seaborn as sns
%matplotlib inline

train = pd.read_csv("C:/Users\knuser/Desktop\Personal_PJ/[ Project ] Kaggle/Porto Seguro’s Safe Driver Prediction\data/train.csv")
test = pd.read_csv("C:/Users\knuser/Desktop\Personal_PJ/[ Project ] Kaggle/Porto Seguro’s Safe Driver Prediction\data/test.csv")

train.info()

binary = ["ps_ind_06_bin", "ps_ind_07_bin", "ps_ind_08_bin", "ps_ind_09_bin", "ps_ind_10_bin",
          "ps_ind_11_bin", "ps_ind_12_bin", "ps_ind_13_bin", "ps_ind_16_bin", "ps_ind_17_bin",
          "ps_ind_18_bin",
          "ps_calc_15_bin", "ps_calc_16_bin", "ps_calc_17_bin", "ps_calc_18_bin", "ps_calc_19_bin",
          "ps_calc_20_bin"]

category = ["ps_ind_02_cat", "ps_ind_04_cat", "ps_ind_05_cat",
            "ps_car_01_cat", "ps_car_02_cat", "ps_car_03_cat",
            "ps_car_04_cat", "ps_car_05_cat", "ps_car_06_cat",
            "ps_car_07_cat", "ps_car_08_cat", "ps_car_09_cat",
            "ps_car_10_cat", "ps_car_11_cat"]

integer = ["ps_ind_01", "ps_ind_03", "ps_ind_14", "ps_ind_15", "ps_calc_04",
           "ps_calc_05", "ps_calc_06", "ps_calc_07", "ps_calc_08", "ps_calc_09",
           "ps_calc_10", "ps_calc_11", "ps_calc_12", "ps_calc_13", "ps_calc_14",
           "ps_car_11"]

floats = ["ps_reg_01", "ps_reg_02", "ps_reg_03", "ps_calc_01", "ps_calc_02",
          "ps_calc_03", "ps_car_12", "ps_car_13", "ps_car_14", "ps_car_15"]

test["target"] = np.nan
df = pd.concat([train, test], axis = 0)


def bar_plot(col, data, hue=None):
    f, ax = plt.subplots(figsize=(10, 5))
    sns.countplot(x=col, hue=hue, data=data, alpha=0.5)
    plt.show()


def dist_plot(col, data):
    f, ax = plt.subplots(figsize=(10, 5))
    sns.distplot(data[col].dropna(), kde=False, bins=10)
    plt.show()


for col in binary + category + integer:
    bar_plot(col, df)

for col in floats:
    dist_plot(col, df)

corr = df.corr()
cmap = sns.color_palette("Blues")
f, ax = plt.subplots(figsize = (10, 7))
sns.heatmap(corr, cmap = cmap)


def bar_plot_ci(col, data):
    f, ax = plt.subplots(figsize=(10, 5))
    sns.barplot(x=col, y="target", data=data)
    plt.show()


for col in binary + category + integer:
    bar_plot_ci(col, df)

## + [ diff. trainDataSet, testDataSet ] ======
df["is_test"] = df["target"].isnull()

for col in binary + category + integer :
    bar_plot(col, df, "is_test")

#  ================================================ [ modeling ] =======================================================
import pandas as pd

train_label = train["target"]
train_df = train["id"]
test_id = test["id"]

del train["target"], train["id"], test["id"]
train["missing"] = (train == -1).sum(axis = 1).astype(float) # NA개수를 파생변수로 생성
test["missing"] = (test == -1).sum(axis = 1).astype(float)

bin_features = [c for c in train.columns if "bin" in c] # d이진변수 합
train["bin_sum"] = train[bin_features].sum(axis = 1)
test["bin_sum"] = test[bin_features].sum(axis = 1)

features = ["ps_ind_06_bin", "ps_ind_07_bin", "ps_ind_08_bin", "ps_ind_09_bin", "ps_ind_12_bin",
            "ps_ind_16_bin", "ps_ind_17_bin", "ps_ind_18_bin", "ps_ind_04_cat", "ps_ind_05_cat",
            "ps_car_01_cat", "ps_car_02_cat", "ps_car_03_cat", "ps_car_04_cat", "ps_car_06_cat",
            "ps_car_07_cat", "ps_car_08_cat", "ps_car_09_cat", "ps_car_11_cat", "ps_ind_01",
            "ps_ind_03", "ps_ind_15", "ps_car_11"] # Target Encoding

## + [ LightGBM ] ================================
from sklearn.model_selection import StratifiedKFold
import lightgbm as lgbm

num_boost_round = 10000
params = {"objective": "binary",
          "bossting_type": "gbdt",
          "learning_rate": 0.1,
          "num_leaves": 15,
          "max_bin": 256,
          "feature_fraction": 0.6,
          "verbosity": 0,
          "drop_rate": 0.1,
          "is_unbalance": False,
          "max_drop ": 50,
          "min_child_samples": 10,
          "min_split_gain": 0,
          "subsample": 0.9,
          "seed": 2018}

NFOLDS = 5
kfold = StratifiedKFold(n_splits=NFOLDS, shuffle=True, random_state=218)
kf = kfold.split(train, train_label)

cv_train = np.zeros(len(train_label))
cv_pred = np.zeros(len(test_id))
best_trees = []
fold_scores = []

for i, (train_fold, validate) in enumerate(kf):
    X_train, X_validate, label_train, label_validate = train.iloc[train_fold, :], train.iloc[validate, :], train_label[
        train_fold], train_label[validate]

    for feature in features:
        map_dic = pd.DataFrame([X_train[feature], label_train]).T.groupby(feature).agg("mean")
        map_dic = map_dic.to_dict()["target"]

        X_train[feature + "_target_enc"] = X_train[feature].apply(lambda x: map_dic.get(x, 0))
        X_validate[feature + "_target_enc"] = X_validate[feature].apply(lambda x: map_dic.get(x, 0))
        test[feature + "_target_enc"] = test[feature].apply(lambda x: map_dic.get(x, 0))

    dtrain = lgbm.Dataset(X_train, label_train)
    dvalid = lgbm.Dataset(X_validate, label_validate, reference=dtrain)

    bst = lgbm.train(params,
                     dtrain,
                     num_boost_round,
                     valid_set=dvalid,
                     feval=evalerror,
                     verbose_eval=100,
                     early_stopping_round=100)
    best_trees.append(bst.best_iteration)

    cv_pred += bst.predict(test, num_iteration=bst.best_iteration)
    cv_train[validate] += bst.predict(X_validate)

    score = gini(label_validate, cv_train[validate])
    print(score)
    fold_scores.append(score)

cv_pred /= NFOLDS