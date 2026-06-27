select *from uber_dirty_advanced;

SELECT * 
FROM uber_dirty_advanced;

-- Total Rows
SELECT COUNT(*) AS Total_Rows
FROM uber_dirty_advanced;

-- Total Columns
SELECT COUNT(*) AS Total_Columns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'uber_dirty_advanced';

-- Column Names & Data Types
SELECT
COLUMN_NAME,
DATA_TYPE,
CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'uber_dirty_advanced';

--Checking the null value in every column 
SELECT
SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS Date_Nulls,
SUM(CASE WHEN Time IS NULL THEN 1 ELSE 0 END) AS Time_Nulls,
SUM(CASE WHEN Booking_ID IS NULL THEN 1 ELSE 0 END) AS BookingID_Nulls,
SUM(CASE WHEN Booking_Status IS NULL THEN 1 ELSE 0 END) AS BookingStatus_Nulls,
SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS CustomerID_Nulls,
SUM(CASE WHEN Vehicle_Type IS NULL THEN 1 ELSE 0 END) AS VehicleType_Nulls,
SUM(CASE WHEN Pickup_Location IS NULL THEN 1 ELSE 0 END) AS PickupLocation_Nulls,
SUM(CASE WHEN Drop_Location IS NULL THEN 1 ELSE 0 END) AS DropLocation_Nulls,
SUM(CASE WHEN Cancelled_Rides_by_Customer IS NULL THEN 1 ELSE 0 END) AS CancelledCustomer_Nulls,
SUM(CASE WHEN Reason_for_cancelling_by_Customer IS NULL THEN 1 ELSE 0 END) AS CancelReason_Nulls,
SUM(CASE WHEN Cancelled_Rides_by_Driver IS NULL THEN 1 ELSE 0 END) AS DriverCancel_Nulls,
SUM(CASE WHEN Driver_Cancellation_Reason IS NULL THEN 1 ELSE 0 END) AS DriverReason_Nulls,
SUM(CASE WHEN Incomplete_Rides IS NULL THEN 1 ELSE 0 END) AS IncompleteRide_Nulls,
SUM(CASE WHEN Incomplete_Rides_Reason IS NULL THEN 1 ELSE 0 END) AS IncompleteReason_Nulls,
SUM(CASE WHEN Booking_Value IS NULL THEN 1 ELSE 0 END) AS BookingValue_Nulls,
SUM(CASE WHEN Ride_Distance IS NULL THEN 1 ELSE 0 END) AS RideDistance_Nulls,
SUM(CASE WHEN Driver_Ratings IS NULL THEN 1 ELSE 0 END) AS DriverRating_Nulls,
SUM(CASE WHEN Customer_Rating IS NULL THEN 1 ELSE 0 END) AS CustomerRating_Nulls,
SUM(CASE WHEN Payment_Method IS NULL THEN 1 ELSE 0 END) AS PaymentMethod_Nulls
FROM uber_dirty_advanced;

-- Check Duplicate Booking IDs
SELECT
Booking_ID,
COUNT(*) AS Duplicate_Count
FROM uber_dirty_advanced
GROUP BY Booking_ID
HAVING COUNT(*) > 1; 

--Total Duplicate Records
SELECT
COUNT(*) - COUNT(DISTINCT Booking_ID)
AS Total_Duplicates
FROM uber_dirty_advanced;

--Unique Vehicle Types
SELECT
Vehicle_Type,
COUNT(*) AS Total
FROM uber_dirty_advanced
GROUP BY Vehicle_Type
ORDER BY Total DESC;

-- Data Sorting 
USE Uber;

SELECT * 
FROM uber_dirty_advanced;

-- Fill Missing Booking_Status with Mode
UPDATE uber_dirty_advanced
SET Booking_Status = 'Completed'
WHERE Booking_Status IS NULL
   OR LTRIM(RTRIM(Booking_Status)) = '';

-- Fill Missing Vehicle_Type with Mode
UPDATE uber_dirty_advanced
SET Vehicle_Type = 'Auto'
WHERE Vehicle_Type IS NULL
   OR LTRIM(RTRIM(Vehicle_Type)) = '';

-- Clean Pickup_Location
UPDATE uber_dirty_advanced
SET Pickup_Location =
    LTRIM(RTRIM(REPLACE(Pickup_Location,'@','')))
WHERE Pickup_Location IS NOT NULL;

-- Clean Drop_Location
UPDATE uber_dirty_advanced
SET Drop_Location =
    LTRIM(RTRIM(REPLACE(Drop_Location,'@','')))
WHERE Drop_Location IS NOT NULL;

-- Remove Multiple Spaces from Pickup_Location
UPDATE uber_dirty_advanced
SET Pickup_Location =
REPLACE(REPLACE(REPLACE(Pickup_Location,'  ',' '),'  ',' '),'  ',' ');

-- Remove Multiple Spaces from Drop_Location
UPDATE uber_dirty_advanced
SET Drop_Location =
REPLACE(REPLACE(REPLACE(Drop_Location,'  ',' '),'  ',' '),'  ',' ');

UPDATE uber_dirty_advanced
SET [Date] = FORMAT(
  TRY_CONVERT(date, REPLACE([Date], '/', '-'), 105),'dd MMMM yyyy')
WHERE TRY_CONVERT(date, REPLACE([Date], '/', '-'), 105) IS NOT NULL;

SELECT *
FROM uber_dirty_advanced;