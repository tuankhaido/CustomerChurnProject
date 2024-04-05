create database ChurnRate;
/********************
Data Cleaning
*********************/

-- 1. Find the total number of customers
SELECT DISTINCT COUNT(CustomerID) as TotalNumberOfCustomers
FROM ecommerce_churn 
-- Answer = There are 5,630 customers in this dataset

-- 2. Check for duplicate rows
SELECT CustomerID, COUNT (CustomerID) as Count
FROM ecommerce_churn
GROUP BY CustomerID
Having COUNT (CustomerID) > 1
-- Answer = There are no duplicate rows

-- 3. Check for null values count for columns with null values
SELECT 'Tenure' as ColumnName, COUNT(*) AS NullCount 
FROM ecommerce_churn
WHERE Tenure IS NULL 
UNION
SELECT 'WarehouseToHome' as ColumnName, COUNT(*) AS NullCount 
FROM ecommerce_churn
WHERE warehousetohome IS NULL 
UNION
SELECT 'HourSpendonApp' as ColumnName, COUNT(*) AS NullCount 
FROM ecommerce_churn
WHERE hourspendonapp IS NULL
UNION
SELECT 'OrderAmountHikeFromLastYear' as ColumnName, COUNT(*) AS NullCount 
FROM ecommerce_churn
WHERE orderamounthikefromlastyear IS NULL 
UNION
SELECT 'CouponUsed' as ColumnName, COUNT(*) AS NullCount 
FROM ecommerce_churn
WHERE couponused IS NULL 
UNION
SELECT 'OrderCount' as ColumnName, COUNT(*) AS NullCount 
FROM ecommerce_churn
WHERE ordercount IS NULL 
UNION
SELECT 'DaySinceLastOrder' as ColumnName, COUNT(*) AS NullCount 
FROM ecommerce_churn
WHERE daysincelastorder IS NULL 

-- 3.1 Handle null values
-- We will fill null values with their mean. 
UPDATE ecommerce_churn
SET Hourspendonapp = (SELECT AVG(Hourspendonapp) FROM ecommerce_churn)
WHERE Hourspendonapp IS NULL 

UPDATE ecommerce_churn
SET tenure = (SELECT AVG(tenure) FROM ecommerce_churn)
WHERE tenure IS NULL 

UPDATE ecommerce_churn
SET orderamounthikefromlastyear = (SELECT AVG(orderamounthikefromlastyear) FROM ecommerce_churn)
WHERE orderamounthikefromlastyear IS NULL 

UPDATE ecommerce_churn
SET WarehouseToHome = (SELECT  AVG(WarehouseToHome) FROM ecommerce_churn)
WHERE WarehouseToHome IS NULL 

UPDATE ecommerce_churn
SET couponused = (SELECT AVG(couponused) FROM ecommerce_churn)
WHERE couponused IS NULL 

UPDATE ecommerce_churn
SET ordercount = (SELECT AVG(ordercount) FROM ecommerce_churn)
WHERE ordercount IS NULL 

UPDATE ecommerce_churn
SET daysincelastorder = (SELECT AVG(daysincelastorder) FROM ecommerce_churn)
WHERE daysincelastorder IS NULL 


--4. Create a new column based off the values of churn column.
-- called customerstatus that shows 'Stayed' and 'Churned' instead of 0 and 1 (USE EXCEL BEFORE IMPORT)

-- 5. Create a new column based off the values of complain column.
-- called complainrecieved that shows 'Yes' and 'No' instead of 0 and 1  (USE EXCEL BEFORE IMPORT)


-- 6. Check values in each column for correctness and accuracy

-- 6.1 a) Check distinct values for preferredlogindevice column
select distinct preferredlogindevice 
from ecommerce_churn
-- the result shows phone and mobile phone which indicates the same thing, so I will replace mobile phone with phone

-- 6.1 b) Replace mobile phone with phone
UPDATE ecommerce_churn
SET preferredlogindevice = 'phone'
WHERE preferredlogindevice = 'mobile phone'

-- 6.2 a) Check distinct values for preferedordercat column
select distinct preferedordercat 
from ecommerce_churn
-- the result shows mobile phone and mobile, so I replace mobile with mobile phone

-- 6.2 b) Replace mobile with mobile phone
UPDATE ecommerce_churn
SET preferedordercat = 'Mobile Phone'
WHERE Preferedordercat = 'Mobile'

-- 6.3 a) Check distinct values for preferredpaymentmode column
select distinct PreferredPaymentMode 
from ecommerce_churn
-- the result shows Cash on Delivery and COD which mean the same thing, so I replace COD with Cash on Delivery

-- 6.3 b) Replace mobile with mobile phone
UPDATE ecommerce_churn
SET PreferredPaymentMode  = 'Cash on Delivery'
WHERE PreferredPaymentMode  = 'COD'

-- 6.4 a) check distinct value in warehousetohome column
SELECT DISTINCT warehousetohome
FROM ecommerce_churn

SELECT AVG(WarehouseToHome) FROM ecommerce_churn
-- I can see two values 126 and 127 that are outliers, it could be a data entry error, so I will correct it to 26 & 27 respectively

-- 6.4 b) Replace value 127 with 27
UPDATE ecommerce_churn
SET warehousetohome = '27'
WHERE warehousetohome = '127'

-- 6.4 C) Replace value 126 with 26
UPDATE ecommerce_churn
SET warehousetohome = '26'
WHERE warehousetohome = '126'

