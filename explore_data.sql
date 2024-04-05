
/**************************************************
Data Exploration and Answering business questions
***************************************************/
-- 1.	What is the overall customer churn rate?

WITH total_customer AS (
SELECT Count(*) as Total FROM
ecommerce_churn),

churn_customer AS (SELECT Count(*) AS Churned FROM
ecommerce_churn
WHERE Status = 'Churned')

SELECT T.Total, C.Churned, Round((Cast(C.churned as float)/T.total), 4)*100 AS ChurnRate FROM
total_customer T, churn_customer C;

-- The Churn rate is 16.84%

--2.	How does the churn rate vary based on the preferred login device?

WITH total_customer AS (
SELECT PreferredLoginDevice ,Count(*) as Total FROM
ecommerce_churn
GROUP BY PreferredLoginDevice),

churn_customer AS (
SELECT PreferredLoginDevice, Count(*) AS Churned FROM
ecommerce_churn
WHERE Status = 'Churned'
GROUP BY PreferredLoginDevice)

SELECT T.PreferredLoginDevice,T.Total, C.Churned, Round((Cast(C.churned as float)/T.total), 4)*100 AS ChurnRate FROM
total_customer T JOIN churn_customer C ON T.PreferredLoginDevice = C.PreferredLoginDevice;

-- The prefered login devices are computer and phone. Computer accounts for the highest churnrate
-- with 19.83% and then phone with 15.62%. 

--3.	Is there any difference in churn rate between male and female customers?
WITH total_customer AS (
SELECT Gender ,Count(*) as Total FROM
ecommerce_churn
GROUP BY Gender),

churn_customer AS (
SELECT Gender, Count(*) AS Churned FROM
ecommerce_churn
WHERE Status = 'Churned'
GROUP BY Gender)

SELECT T.Gender,T.Total, C.Churned, Round((Cast(C.churned as float)/T.total), 4)*100 AS ChurnRate FROM
total_customer T JOIN churn_customer C ON T.Gender = C.Gender;

-- More men churned in comaprison to wowen 

-- 4.	What is the distribution of customers across different city tiers?
WITH total_customer AS (
SELECT CityTier ,Count(*) as Total FROM
ecommerce_churn
GROUP BY CityTier),

churn_customer AS (
SELECT CityTier, Count(*) AS Churned FROM
ecommerce_churn
WHERE Status = 'Churned'
GROUP BY CityTier)

SELECT T.CityTier,T.Total, C.Churned, Round((Cast(C.churned as float)/T.total), 4)*100 AS ChurnRate FROM
total_customer T JOIN churn_customer C ON T.CityTier = C.CityTier ORDER BY ChurnRate DESC;
 -- Churn Rate City Tier 3 > 2 > 1
-- 5.	What is the typical tenure for churned customers?
ALTER TABLE ecommerce_churn
ADD TenureRange NVARCHAR(50)

UPDATE ecommerce_churn
SET TenureRange =
CASE 
    WHEN tenure <= 6 THEN '6 Months'
    WHEN tenure > 6 AND tenure <= 12 THEN '1 Year'
    WHEN tenure > 12 AND tenure <= 24 THEN '2 Years'
    WHEN tenure > 24 THEN 'more than 2 years'
END

WITH total_customer AS (
SELECT TenureRange ,Count(*) as Total FROM
ecommerce_churn
GROUP BY TenureRange),

range_tenure AS (
SELECT distinct TenureRange FROM ecommerce_churn),

churn_customer AS (
SELECT  r.TenureRange,  COALESCE(COUNT(e.TenureRange), 0) AS Churned FROM
range_tenure r left join ecommerce_churn e on r.TenureRange = e.TenureRange
AND Status = 'Churned'
GROUP BY  r.TenureRange)

SELECT T. TenureRange,T.Total, C.Churned, Round((Cast(C.churned as float)/T.total), 4)*100 AS ChurnRate FROM
total_customer T JOIN churn_customer C ON T.TenureRange = C. TenureRange ORDER BY ChurnRate DESC;

--Most customers churned within a 6 months tenure period

-- 6.	Is there any correlation between the warehouse-to-home distance and customer churn?
ALTER TABLE ecommerce_churn
ADD warehousetohomerange NVARCHAR(50)

UPDATE ecommerce_churn
SET warehousetohomerange =
CASE 
    WHEN warehousetohome <= 10 THEN 'Very close distance'
    WHEN warehousetohome > 10 AND warehousetohome <= 20 THEN 'Close distance'
    WHEN warehousetohome > 20 AND warehousetohome <= 30 THEN 'Moderate distance'
    WHEN warehousetohome > 30 THEN 'Far distance'
END

WITH total_customer AS (
SELECT warehousetohomerange ,Count(*) as Total FROM
ecommerce_churn
GROUP BY warehousetohomerange),

churn_customer AS (
SELECT warehousetohomerange, Count(*) AS Churned FROM
ecommerce_churn
WHERE Status = 'Churned'
GROUP BY warehousetohomerange)

SELECT T.warehousetohomerange,T.Total, C.Churned, Round((Cast(C.churned as float)/T.total), 4)*100 AS ChurnRate FROM
total_customer T JOIN churn_customer C ON T.warehousetohomerange = C.warehousetohomerange ORDER BY ChurnRate DESC;
-- The farther the distance, the higher the churn rate

-- 7.	Which is the most preferred payment mode among churned customers?
WITH total_customer AS (
SELECT PreferredPaymentMode ,Count(*) as Total FROM
ecommerce_churn
GROUP BY PreferredPaymentMode),

churn_customer AS (
SELECT PreferredPaymentMode, Count(*) AS Churned FROM
ecommerce_churn
WHERE Status = 'Churned'
GROUP BY PreferredPaymentMode)

SELECT T.PreferredPaymentMode,T.Total, C.Churned, Round((Cast(C.churned as float)/T.total), 4)*100 AS ChurnRate FROM
total_customer T JOIN churn_customer C ON T.PreferredPaymentMode = C.PreferredPaymentMode ORDER BY ChurnRate DESC;

-- The most preferred payment mode among churned customers is Cash on Delivery

-- 8.	How does the average time spent on the app differ for churned and non-churned customers?
SELECT Status, AVG(HourSpendOnApp) as AVG_time FROM
ecommerce_churn GROUP BY Status;
-- No different
-- 9.	Does the number of registered devices impact the likelihood of churn?
WITH total_customer AS (
SELECT NumberOfDeviceRegistered ,Count(*) as Total FROM
ecommerce_churn
GROUP BY NumberOfDeviceRegistered),

churn_customer AS (
SELECT NumberOfDeviceRegistered, Count(*) AS Churned FROM
ecommerce_churn
WHERE Status = 'Churned'
GROUP BY NumberOfDeviceRegistered)

SELECT T.NumberOfDeviceRegistered,T.Total, C.Churned, Round((Cast(C.churned as float)/T.total), 4)*100 AS ChurnRate FROM
total_customer T JOIN churn_customer C ON T.NumberOfDeviceRegistered = C.NumberOfDeviceRegistered ORDER BY ChurnRate DESC;
-- the more device registered, the more customer left
-- 10.	Which order category is most preferred among churned customers?
WITH total_customer AS (
SELECT PreferedOrderCat ,Count(*) as Total FROM
ecommerce_churn
GROUP BY PreferedOrderCat),

churn_customer AS (
SELECT PreferedOrderCat, Count(*) AS Churned FROM
ecommerce_churn
WHERE Status = 'Churned'
GROUP BY PreferedOrderCat)

SELECT T.PreferedOrderCat,T.Total, C.Churned, Round((Cast(C.churned as float)/T.total), 4)*100 AS ChurnRate FROM
total_customer T JOIN churn_customer C ON T.PreferedOrderCat = C.PreferedOrderCat ORDER BY ChurnRate DESC;
-- Mobile phone category has the highest churn rate and grocery has the least churn rate
-- 11.	Is there any relationship between customer satisfaction scores and churn?
WITH total_customer AS (
SELECT SatisfactionScore ,Count(*) as Total FROM
ecommerce_churn
GROUP BY SatisfactionScore),

churn_customer AS (
SELECT SatisfactionScore, Count(*) AS Churned FROM
ecommerce_churn
WHERE Status = 'Churned'
GROUP BY SatisfactionScore)

SELECT T.SatisfactionScore,T.Total, C.Churned, Round((Cast(C.churned as float)/T.total), 4)*100 AS ChurnRate FROM
total_customer T JOIN churn_customer C ON T.SatisfactionScore = C.SatisfactionScore ORDER BY ChurnRate DESC;
--  Customer satisfaction score of 5 has the highest churn rate, satisfaction score of 1 has the least churn rate

-- 12.	Does the marital status of customers influence churn behavior?
WITH total_customer AS (
SELECT MaritalStatus ,Count(*) as Total FROM
ecommerce_churn
GROUP BY MaritalStatus),

churn_customer AS (
SELECT MaritalStatus, Count(*) AS Churned FROM
ecommerce_churn
WHERE Status = 'Churned'
GROUP BY MaritalStatus)

SELECT T.MaritalStatus,T.Total, C.Churned, Round((Cast(C.churned as float)/T.total), 4)*100 AS ChurnRate FROM
total_customer T JOIN churn_customer C ON T.MaritalStatus = C.MaritalStatus ORDER BY ChurnRate DESC;
-- Single customers have the highest churn rate while married customers have the least churn rate
-- 13.	How many addresses do churned customers have on average?
SELECT AVG(NumberOfAddress) as AVG_ADDRESS FROM
ecommerce_churn WHERE Status = 'Churned';
-- On average, churned customers have 4 addresses
-- 14.	Do customer complaints influence churned behavior?

WITH total_customer AS (
SELECT RecievedComplain ,Count(*) as Total FROM
ecommerce_churn
GROUP BY RecievedComplain),

churn_customer AS (
SELECT RecievedComplain, Count(*) AS Churned FROM
ecommerce_churn
WHERE Status = 'Churned'
GROUP BY RecievedComplain)

SELECT T.RecievedComplain,T.Total, C.Churned, Round((Cast(C.churned as float)/T.total), 4)*100 AS ChurnRate FROM
total_customer T JOIN churn_customer C ON T.RecievedComplain = C.RecievedComplain ORDER BY ChurnRate DESC;
-- Customers with complains had the highest churn rate

-- 15.	How does the use of coupons differ between churned and non-churned customers?

SELECT Status, sum(CouponUsed) AS COUNT_COUPON FROM ecommerce_churn GROUP BY Status;
-- Churned customers used less coupons in comparison to non churned customers

-- 16.	What is the average number of days since the last order for churned customers?

SELECT AVG(daysincelastorder) AS AverageNumofDaysSinceLastOrder
FROM ecommerce_churn
WHERE Status = 'Churned';
-- The average number of days since last order for churned customer is 3
-- 17.	Is there any correlation between cashback amount and churn rate?
ALTER TABLE ecommerce_churn
ADD cashbackamountrange NVARCHAR(50)

UPDATE ecommerce_churn
SET cashbackamountrange =
CASE 
    WHEN cashbackamount <= 100 THEN 'Low Cashback Amount'
    WHEN cashbackamount > 100 AND cashbackamount <= 200 THEN 'Moderate Cashback Amount'
    WHEN cashbackamount > 200 AND cashbackamount <= 300 THEN 'High Cashback Amount'
    WHEN cashbackamount > 300 THEN 'Very High Cashback Amount'
END

WITH total_customer AS (
SELECT cashbackamountrange ,Count(*) as Total FROM
ecommerce_churn
GROUP BY cashbackamountrange),

churn_customer AS (
SELECT  cashbackamountrange, Count(*) AS Churned FROM
ecommerce_churn
WHERE Status = 'Churned'
GROUP BY  cashbackamountrange)

SELECT T. cashbackamountrange,T.Total, C.Churned, Round((Cast(C.churned as float)/T.total), 4)*100 AS ChurnRate FROM
total_customer T JOIN churn_customer C ON T. cashbackamountrange = C. cashbackamountrange ORDER BY ChurnRate DESC;

-- Customers with a Moderate Cashback Amount (Between 100 and 200) have the highest churn rate
SELECT AVG(CashbackAmount) AS AverageCashback
FROM ecommerce_churn WHERE Status = 'Churned';