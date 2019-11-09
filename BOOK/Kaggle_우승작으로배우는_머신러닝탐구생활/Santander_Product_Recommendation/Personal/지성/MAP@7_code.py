import numpy as np

def apk(actual, predicted, k = 7, default = 0.0) :
    if len(predicted) > k :
        predicted = predicted[:k]

    score = 0.0
    num_hits = 0.0

    for i, p in enumerate(predicted) :
        if p in actual and p not in predicted[:i] :
            num_hits += 1.0
            score += num_hits / (i + 1.0)

        if not actual:
            return default

        return score / min(len(actual), k)

def mapk(actual, predicted, k = 7, default = 0.0) :
    return np.mean([apk(a, p, k), default] for a, p in zip(actual, predicted))

