# Boston Housing: Regression and Classification Models

An end-to-end machine learning study on the Boston Housing dataset, built as the fourth assignment for an Artificial Intelligence course. The project spans exploratory data analysis, custom from-scratch regression implementations, and a systematic comparison of five classifiers (with hyperparameter tuning) for a 3-tier house-price classification task.

**Institution:** University of Tehran, School of Electrical and Computer Engineering
**Course:** Artificial Intelligence
**Author:** Babak Hosseini Mohtasham
**Assignment specification:** [`HW-4-Project.pdf`](./HW-4-Project.pdf)

---

## Overview

Working from the classic Boston Housing dataset (506 samples, 13 features, target `MEDV` = median home value), the project is organized into two complementary parts: (1) predicting `MEDV` directly as a **regression** problem using both closed-form and gradient-descent linear/polynomial regression implemented from scratch, and (2) discretizing `MEDV` into three price tiers (Economical / Normal / Luxury, via quantile split) and framing it as a **classification** problem, solved and compared across five distinct model families using `scikit-learn` and `XGBoost`.

**Objectives:**

1. Perform exploratory data analysis (correlation structure, distribution analysis, missing-value patterns) and apply feature-appropriate missing-value imputation (KNN imputation, group-mean imputation, mode imputation, and targeted deletion) rather than a single blanket strategy.
2. Implement simple and polynomial linear regression from scratch via both the closed-form (normal equation) solution and gradient descent, and compare their fit quality across feature choices and polynomial degrees.
3. Build a unified `MyClassifier` evaluation interface, then train and hyperparameter-tune five classifiers — Decision Tree, KNN, Random Forest, XGBoost, and SVM (linear and RBF kernels) — on the 3-tier price classification task.
4. Compare models via accuracy, precision/recall/F1 (micro, macro, and weighted averages), confusion matrices, ROC/AUC (multi-class, one-vs-rest), and feature importance.

## Methodology

| Component | Description |
|---|---|
| **Dataset** | Boston Housing (`DataSet.xlsx`), 506 samples, 13 features (`CRIM`, `RM`, `LSTAT`, `PTRATIO`, `NOX`, `TAX`, etc.), target `MEDV` |
| **Preprocessing** | Per-column missing-value strategy (KNN imputation for `DIS`, group-mean imputation for `B` conditioned on `RAD`, mode imputation for `CHAS`, row deletion only for missing targets); removal of `RAD` after identifying near-collinearity with `CRIM`/`TAX`; duplicate removal; `StandardScaler`/`Normalizer` feature scaling; train/validation/test split (80/10/10) |
| **Regression models (from scratch)** | Simple linear regression via the closed-form normal-equation solution; polynomial regression (degrees 1–5) via both the closed-form solution and batch gradient descent on the RSS/MSE loss |
| **Classification target** | `MEDV` discretized into 3 tiers (`Economical`, `Normal`, `Luxury`) via the 20th/80th percentile split |
| **Classifiers compared** | Decision Tree, K-Nearest Neighbors, Random Forest, XGBoost, and Support Vector Machine (linear and RBF kernels) — each wrapped in a shared `MyClassifier` interface with `GridSearchCV`/`RandomizedSearchCV`-based hyperparameter tuning |
| **Evaluation** | Accuracy, precision/recall/F1 (micro/macro/weighted), confusion matrices, one-vs-rest multi-class ROC/AUC, and Random Forest / XGBoost feature-importance plots |

## Repository Structure

| Path | Description |
|---|---|
| [`CA04_Spring403.ipynb`](./CA04_Spring403.ipynb) | Full implementation across all phases: EDA, preprocessing, from-scratch regression, and classifier training/tuning/evaluation, with written answers to the assignment's conceptual questions |
| [`DataSet.xlsx`](./DataSet.xlsx) | The Boston Housing dataset used for both the regression and classification tasks |
| [`HW-4-Project.pdf`](./HW-4-Project.pdf) | Original assignment specification |

## Key Results

**XGBoost achieved the best classification performance after hyperparameter tuning**, reaching **89.1% test accuracy** (weighted F1 = 0.894) on the 3-tier price classification task — matching the best result among all five model families tested, with Random Forest close behind at 87.0%–84.8% depending on split. Full test-set results across all tuned models:

| Model | Test Accuracy | Weighted F1 |
|---|---|---|
| **XGBoost (tuned)** | **0.891** | **0.894** |
| Random Forest (tuned) | 0.848–0.870 | 0.857–0.869 |
| Decision Tree (tuned) | 0.783–0.804 | 0.783–0.794 |
| SVM — linear (tuned) | 0.826–0.848 | 0.835–0.847 |
| SVM — RBF (tuned) | 0.783–0.826 | 0.786–0.832 |
| KNN (tuned) | 0.804–0.848 | 0.800–0.850 |

**`RM` (average number of rooms) is the strongest single predictor of price**, showing the highest correlation with `MEDV` in the exploratory correlation analysis and the best fit quality of any individual feature under both closed-form and gradient-descent regression (R² = 0.841–0.898 depending on polynomial degree, versus R² = 0.033–0.364 for `CHAS`, `PTRATIO`, and `LSTAT` individually). In the Random Forest feature-importance ranking for the classification task, `RM` and `LSTAT` (percentage of lower-status population) emerged as the two most important features overall.

**Polynomial regression improved substantially over simple linear regression on `RM` alone**, with R² rising from 0.841 (degree 1) to 0.898 (degree 5) under the closed-form solution, while a naive PCA-based single-component feature performed markedly worse (R² = −0.732) than using `RM` directly — reinforcing that a well-chosen individual feature outperformed an unsupervised linear combination of all features for this target.

*(Full discussion of bias-variance tradeoffs, ensemble learning theory (bagging vs. boosting), distance metrics for KNN, ROC/AUC for multi-class problems, and threshold-tuning experiments are in the notebook.)*

## Reproducing the Results

1. Install dependencies: `pip install pandas numpy matplotlib seaborn scikit-learn xgboost scipy openpyxl`.
2. Open [`CA04_Spring403.ipynb`](./CA04_Spring403.ipynb) and run all cells — `DataSet.xlsx` is loaded via a relative path, so keep it alongside the notebook.
3. The notebook is organized into phases (EDA/preprocessing → from-scratch regression → classifiers → ensemble methods/XGBoost → SVM → ROC/threshold analysis); each classifier phase re-splits and re-scales the data as appropriate for that model before running `GridSearchCV`/`RandomizedSearchCV` and reporting validation and test performance via the shared `MyClassifier.fit_predict_report(...)` interface.

## Notes on Scope

- The 3-tier classification labels (`Economical`, `Normal`, `Luxury`) are derived from the 20th and 80th percentiles of `MEDV`, producing an imbalanced class split that is reflected in the gap between macro- and weighted-averaged metrics reported for each model.
- Reported accuracy ranges above reflect that most models were evaluated at two points in the pipeline (validation split and final held-out test split, both before and after a re-run with tuned hyperparameters); the 89.1% XGBoost figure is the final tuned test-set result.
- Hyperparameters for every model were selected via `RandomizedSearchCV` followed by a narrower `GridSearchCV` around the randomized search's best region, rather than a single exhaustive grid search.
