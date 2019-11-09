import matplotlib
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import os
os.chdir("/Users/kimjiseong/PycharmProjects/BOOK/Kaggle_우승작으로_배우는머신러닝_탐구생활/Santander Product Recommendation Competition/data")
train = pd.read_csv("train_ver2.csv")


# ------------------------- Visu.EDA -----------------------
skip_cols = ["ncodpers", "renta"]
for col in train.columns :
    if col in skip_cols :
        continue

        # 영역 구분 및 변수명 출력
        print("-" * 50)
        print("col : ", col)

        # figsize 설정
        f, ax = plt.subplots(figsize = (20, 15))
        sns.countplot(x = col, data = train, alpha = 0.5)
        plt.show()

# ----------------------- time EDA ---------------------------

