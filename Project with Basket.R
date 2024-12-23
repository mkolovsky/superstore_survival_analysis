getwd()
setwd("/Users/business/Desktop/LMU/CRM/CRM data")
data.df = read.csv('superstore_dataset2011-2015(1).csv')
typeof(data.df)
summary(data.df)
str(data.df)
colnames(data.df)
library(dplyr)
library(lubridate)
library(survival)
library(survminer)
library(dplyr)
library(ggplot2)


#1. What months are the most orders made?
data.df$Order.Date <- dmy(data.df$Order.Date)
data.df$Ship.Date <- dmy(data.df$Ship.Date)
data.df %>% 
  mutate(Month = month(Order.Date, label = TRUE)) %>% 
  count(Month, sort = TRUE)

# Month    n
#1    Nov 6342
#2    Dec 6302
#3    Sep 5975
#4    Jun 5331
#5    Aug 5078
#6    Oct 4490
#7    May 3747
#8    Jul 3166
#9    Apr 3057
#10   Mar 3035
#11   Jan 2599
#12   Feb 2168

#2. What cities have the highest count of discounts used
# Count discounts by city
discount_by_city <- data.df %>%
  filter(Discount > 0) %>%
  group_by(City) %>%
  summarise(Discount_Count = n()) %>%
  arrange(desc(Discount_Count))

# Display top 10 cities
head(discount_by_city, 10)

#1 Philadelphia             537
#2 Santo Domingo            443
#3 Manila                   432
#4 Houston                  377
#5 Tegucigalpa              362
#6 Jakarta                  337
#7 Lagos                    333
#8 Chicago                  314
#9 Istanbul                 314
#10 Bangkok                  287

#3. Who are the top 10% of most profitable customers (customer.name) and what do they buy (product category, sub.category, product.name)?
library(dplyr)

# Calculate total profit per customer
customer_profits <- data.df %>%
  group_by(Customer.Name) %>%
  summarize(Total_Profit = sum(Profit)) %>%
  arrange(desc(Total_Profit))

# Identify the top 10% of customers
top_10_percent <- customer_profits %>%
  slice_max(order_by = Total_Profit, prop = 0.1)

# Display top 10% customers
print(head(top_10_percent, 10))

# Get purchase details for top customers
top_customer_purchases <- data.df %>%
  filter(Customer.Name %in% top_10_percent$Customer.Name) %>%
  group_by(Customer.Name, Category, Sub.Category, Product.Name) %>%
  summarize(Total_Sales = sum(Sales),
            Total_Quantity = sum(Quantity),
            Total_Profit = sum(Profit)) %>%
  arrange(desc(Total_Profit))

# Display top purchases
print(head(top_customer_purchases, 20))

#4. Which country has the highest order volume by subcategory
# Load necessary libraries
library(dplyr)

# Calculate order volume by country and subcategory
order_volume_by_country_subcategory <- data.df %>%
  group_by(Country, Sub.Category) %>%
  summarize(Order_Volume = n()) %>%
  ungroup() %>%
  arrange(desc(Order_Volume))

# Find the country with the highest order volume by subcategory
highest_order_volume_country <- order_volume_by_country_subcategory %>%
  slice(1)

# View the result
highest_order_volume_country
#United States; Binders; 1523

#5. What’s the average time to ship an order (shipdate-orderdate)
# Load necessary libraries
library(dplyr)

# Ensure the dates are in Date format
data.df <- data.df %>%
  mutate(Order.Date = as.Date(Order.Date, format = "%m/%d/%Y"),
         Ship.Date = as.Date(Ship.Date, format = "%m/%d/%Y"))

# Calculate the shipping time in days
data.df <- data.df %>%
  mutate(Shipping_Time = as.numeric(difftime(Ship.Date, Order.Date, units = "days")))

# Calculate the average shipping time
average_shipping_time <- data.df %>%
  summarize(Average_Shipping_Time = mean(Shipping_Time, na.rm = TRUE))

# View the result
average_shipping_time
#3.96 or 4 days

#6. What cities have the most customers shopping with us
# Load necessary libraries
library(dplyr)

# Calculate the number of unique customers by city
customers_by_city <- data.df %>%
  group_by(City) %>%
  summarize(Unique_Customers = n_distinct(Customer.ID)) %>%
  arrange(desc(Unique_Customers))

# View the top cities with the most customers
customers_by_city

#7. Rank highest to lowest category and sub.category and product name by number of order.ids
library(dplyr)

combined_ranking <- data.df %>%
  group_by(Category, Sub.Category, Product.Name) %>%
  summarize(Order_Count = n_distinct(Order.ID)) %>%
  ungroup() %>%
  arrange(desc(Order_Count)) %>%
  mutate(Overall_Rank = row_number())

# Display the top 20 rows of the combined ranking
print(head(combined_ranking, 20))

#8. How many customers are returning and who are they?
library(dplyr)

# Identify returning customers
returning_customers <- data.df %>%
  group_by(Customer.ID, Customer.Name) %>%
  summarize(Order_Count = n_distinct(Order.ID)) %>%
  filter(Order_Count > 1) %>%
  arrange(desc(Order_Count))

# Count the number of returning customers
num_returning_customers <- nrow(returning_customers)

# Display the results
print(paste("Number of returning customers:", num_returning_customers))
print(head(returning_customers, 10))

#9. Whats the average profit per subcategory
library(dplyr)

# Calculate average profit per subcategory
avg_profit_subcategory <- data.df %>%
  group_by(Category, Sub.Category) %>%
  summarize(
    Total_Profit = sum(Profit),
    Total_Orders = n(),
    Avg_Profit = mean(Profit),
    Avg_Profit_Per_Order = Total_Profit / Total_Orders
  ) %>%
  arrange(desc(Avg_Profit_Per_Order))

# Display the results
print(avg_profit_subcategory)

#10. Average quantity per order by state
# Load necessary library
library(dplyr)

# Load the dataset
data.df <- read.csv("superstore_dataset2011-2015-1.csv")

# Define a vector of U.S. state names
us_states <- c("Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", 
               "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", 
               "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", 
               "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", 
               "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", 
               "New Hampshire", "New Jersey", "New Mexico", "New York", 
               "North Carolina", "North Dakota", "Ohio", "Oklahoma", 
               "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", 
               "South Dakota", "Tennessee", "Texas", "Utah", 
               "Vermont", "Virginia", "Washington", "West Virginia",
               "Wisconsin", "Wyoming")

# Calculate average quantity per order by U.S. state
avg_quantity_by_us_state <- data.df %>%
  filter(State %in% us_states) %>%  # Filter for U.S. states only
  group_by(State, Order.ID) %>%
  summarize(Total_Quantity = sum(Quantity), .groups = 'drop') %>%
  group_by(State) %>%
  summarize(
    Avg_Quantity_Per_Order = mean(Total_Quantity), 
    Orders = n(),
    .groups = 'drop'
  ) %>%
  arrange(desc(Avg_Quantity_Per_Order))

# Display the results
print(avg_quantity_by_us_state)


#survival analysis
library(dplyr)
library(lubridate)
library(survival)
library(survminer)
library(ggplot2)

# Load the dataset
data.df <- read.csv("superstore_dataset2011-2015-1.csv")

# Display variable names
variable.names(data.df)

# Calculate total profit, discount, and sales per customer
total_profit <- data.df %>%
  group_by(Customer.Name) %>%
  summarise(total_profit = sum(Profit),
            total_discount = sum(Discount),
            total_sales = sum(Sales))

# Join total profit data with original dataset
data.df <- total_profit %>% left_join(data.df)

# Convert Order.Date to proper date format
a <- as.Date(data.df$Order.Date, format = "%m/%d/%Y")
b <- as.Date(data.df$Order.Date, format = "%d-%m-%Y")
a[is.na(a)] <- b[!is.na(b)]
data.df$Order.Date <- a

summary(data.df$Order.Date)

# Create RFM dataframe
rfm.df <- data.df

# Define frequency
frequency <- rfm.df %>% count(Customer.Name)
rfm.df <- frequency %>% left_join(rfm.df)

# Define recency
recency <- rfm.df %>%
  group_by(Customer.Name) %>%
  summarise(last_date = max(Order.Date))
rfm.df <- recency %>% left_join(rfm.df)

# Add RFM variables
rfm.df <- rfm.df %>% 
  mutate(frequency = n,
         recency = last_date,
         monetary = total_profit,
         Findex = cut(frequency, breaks = c(28, 58, 67, 77, 109), labels = c("1", "2", "3", "4")))

# Calculate recency in days
date1 <- as.Date("2015-01-01", tz = "UTC")
rfm.df$Rdays <- as.numeric(difftime(date1, rfm.df$recency, units = "days"))

# Create RFM indices
rfm.df <- rfm.df %>%
  mutate(Rindex = cut(Rdays, breaks = c(0, 7, 17, 36, 430), labels = c("1", "2", "3", "4")),
         Mindex = cut(total_profit, breaks = c(-6153, 1040, 1834, 2673, 8674), labels = c("1", "2", "3", "4")),
         CLV = 20 * as.numeric(Findex) / 5 + 40 * as.numeric(Rindex) / 5 + 40 * as.numeric(Mindex) / 5)

# Survival Analysis
cust.date <- rfm.df %>% 
  group_by(Customer.ID) %>% 
  summarise(last.date = max(Order.Date),
            early.date = min(Order.Date))

cust.date$time <- as.numeric(cust.date$last.date - cust.date$early.date)
cust.date$day.diff <- as.numeric(difftime(Sys.Date(), cust.date$last.date, units = "days"))
cust.date$state <- ifelse(cust.date$day.diff >= 3700, 1, 0)

# Plot histogram of last order dates
ggplot(cust.date, aes(x = last.date)) + geom_histogram()
summary(cust.date$last.date)

# Plot histogram of days since last order
hist(cust.date$day.diff)

# Calculate date 3700 days ago
today <- Sys.Date()
date_3700_days_ago <- today - 3700
print(date_3700_days_ago)

# Kaplan-Meier survival analysis
cust.date$survival <- Surv(cust.date$time / 30, cust.date$state)
fit <- survfit(survival ~ 1, data = cust.date)
ggsurvplot(fit)

# Join customer data with RFM data
new.cust.date <- cust.date %>% left_join(rfm.df, by = "Customer.ID")

# Survival analysis by Market
fit_market <- survfit(survival ~ Market, new.cust.date)
ggsurvplot(fit_market)

# Cox proportional hazards model
cox_model <- coxph(survival ~ Market + Sales + Segment + CLV, new.cust.date)
summary(cox_model)

str(data.df)

#LOGIT REGRESSION

# Load necessary libraries
library(dplyr)
library(ROCR)

# Step 1: Convert `Profit` into a binary variable (1 = Profitable, 0 = Not Profitable)
data.df <- data.df %>%
  mutate(is_profitable = ifelse(Profit > 0, 1, 0))

# Step 2: Check the structure and summary of `Profit`
str(data.df$Profit)
summary(data.df$Profit)

# Step 3: Calculate average profit per subcategory
avg_profit_subcat <- data.df %>%
  group_by(Sub.Category) %>%
  summarise(avg_profit = mean(Profit, na.rm = TRUE), .groups = 'drop') # Added .groups argument

# Print average profit by subcategory
print(avg_profit_subcat)

# Step 4: Join the average profit back to the main dataframe for modeling
data.df <- data.df %>%
  left_join(avg_profit_subcat, by = "Sub.Category")

# Check if avg_profit is present in data.df
if (!"avg_profit" %in% names(data.df)) {
  stop("avg_profit not found in the dataframe after join.")
}

# Step 5: Ensure `total_sales` and `total_discount` exist; if not, calculate them
if (!"total_sales" %in% names(data.df)) {
  data.df <- data.df %>%
    mutate(total_sales = Sales) # Adjust based on your dataset
}

if (!"total_discount" %in% names(data.df)) {
  data.df <- data.df %>%
    mutate(total_discount = Discount) # Adjust based on your dataset
}

# Step 6: Logistic regression model
logit_model <- glm(is_profitable ~ avg_profit + total_sales + total_discount, 
                   data = data.df, 
                   family = binomial)

# Step 7: Generate predicted probabilities for ROC analysis
data.df <- data.df %>%
  mutate(predicted_probabilities = predict(logit_model, newdata = data.df, type = "response"))

# Step 8: Prepare data for ROC
# Ensure `predicted_probabilities` and `is_profitable` are correctly populated
if (!"predicted_probabilities" %in% names(data.df)) {
  stop("The predicted probabilities were not computed correctly.")
}

pred <- prediction(data.df$predicted_probabilities, data.df$is_profitable)
perf <- performance(pred, "tpr", "fpr")

# Step 9: Plot the ROC curve
plot(perf, colorize = TRUE, lwd = 2, main = "ROC Curve")
abline(a = 0, b = 1, lty = 2, col = "gray")  # Reference line

# Step 10: AUC Calculation
auc <- performance(pred, "auc")
auc_value <- auc@y.values[[1]]
print(paste("AUC:", round(auc_value, 2)))

# Step 11: Model summary
summary(logit_model)

#Basket Analysis
# Load necessary libraries
library(arules)
library(arulesViz)

# Select necessary columns for basket analysis
data_mini <- data.df[, c("Order.ID", "Sub.Category")]
head(data_mini)

# Save the data to a CSV file
write.csv(data_mini, "transdata.csv", row.names = FALSE)

# Read transactions from the CSV file
transdata <- read.transactions(
  file = "transdata.csv",
  format = "single",
  sep = ",",
  cols = c("Order.ID", "Sub.Category"),
  rm.duplicates = TRUE,
  header = TRUE
)

# Convert to transactions and inspect
data_transactions <- as(transdata, "transactions")
summary(data_transactions)

# Plot item frequency (top 20)
itemFrequencyPlot(data_transactions, topN = 20, type = "absolute")

# Generate association rules
data.rules <- apriori(
  data_transactions,
  parameter = list(support = 0.0005, confidence = 0.4, target = "rules")
)

# Summary of rules
summary(data.rules)

# Convert rules to a dataframe
df_basket <- as(data.rules, "data.frame")

# Inspect top 10 rules by lift
top_lift <- head(sort(data.rules, by = "lift"), 10)
inspect(top_lift)

# Inspect top 10 rules by confidence
top_conf <- head(sort(data.rules, by = "confidence"), 10)
inspect(top_conf)

# Plot the top rules by lift
group.hi <- head(sort(data.rules, by = "lift"), 10)
plot(group.hi, method = "graph", control = list(type = "items"))

# Inspect the top rules
inspect(group.hi)
