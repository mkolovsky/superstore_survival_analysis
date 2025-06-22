# 📊 Superstore Business Intelligence & Predictive Analytics

This project performs a comprehensive analysis using the **Superstore dataset (2011–2015)**. It includes:

* Business Intelligence Reporting
* Exploratory Data Analysis (EDA)
* Customer Analytics
* Survival Analysis (Churn Prediction)
* Logistic Regression Modeling
* Market Basket (Association Rules) Analysis

---

## ⚙️ 1. Setting Up & Data Loading

* Loads the **Superstore CSV file** and sets the working directory
* Inspects structure, summary statistics, and column names

---

## 🧼 2. Data Cleaning & Preprocessing

* Converts **Order Date** and **Ship Date** to date format using `lubridate`
* Loads key libraries:

  * `dplyr`, `ggplot2` (data manipulation and plotting)
  * `survival`, `survminer` (for churn modeling)
  * `arules`, `arulesViz` (for basket analysis)

---

## 📊 3. Exploratory Data Analysis (EDA)

* **Orders by Month**: Identify peak sales periods
* **Discount Usage by City**: Highlights discount-heavy markets
* **Top 10% Profitable Customers**: Analyze purchasing patterns and products
* **Order Volume by Country/Subcategory**: Spot geographic product preferences
* **Average Shipping Time**: Days between order and delivery
* **Customer Density**: Cities with the most unique buyers
* **Category/Subcategory Rankings**: Most to least ordered
* **Repeat Buyers**: Count orders from returning customers
* **Average Profit per Subcategory**
* **Average Quantity per Order by State**

---

## ⏳ 4. Survival Analysis (Customer Churn)

* Uses **Kaplan-Meier estimator** to model retention
* Defines **churn** as time since last purchase
* Calculates **RFM metrics** (Recency, Frequency, Monetary)
* Builds a **Cox Proportional Hazards model** to identify churn predictors

---

## 📈 5. Logistic Regression: Profitability Prediction

* Creates a **binary target variable**:

  * Profitable (1) vs. Not Profitable (0)
* Predictors include:

  * Average subcategory profit
  * Total sales
  * Total discounts
* Evaluates model performance with **ROC Curve** and **AUC**

---

## 🛒 6. Market Basket Analysis

* Transforms transaction data (`Order.ID`, `Sub.Category`) to basket format
* Applies the **Apriori algorithm** to find frequent itemsets
* Generates **association rules** (support, confidence, lift)
* Visualizes top rules with `arulesViz`

---

## 💡 Key Insights

* **Sales Trends**: Monthly peaks, customer demand patterns
* **Profit Drivers**: Top cities, customers, categories
* **Churn Behavior**: Predictable dropout windows (using survival curves)
* **Repeat Buyers**: High-value customer identification
* **Cross-Sell Potential**: Product bundling opportunities through rule mining

---

## 🚀 Suggested Improvements

1. **Data Validation**: Handle missing values and ensure clean inputs
2. **Feature Engineering**: Add CLV, seasonality, time-between-purchase metrics
3. **Model Evaluation**: Use cross-validation, expand predictor space
4. **Advanced ML**: Explore **XGBoost**, **Random Forests**, or **Neural Networks**
5. **Basket Optimization**: Tune **Apriori parameters** for more actionable rules
