
------------------------STAGE-----------------------------

--Orders 
 CREATE TABLE stg.Orders(
    order_id	VARCHAR(50),
    customer_id	VARCHAR(50),
    order_status VARCHAR(50),
    order_purchase_timestamp VARCHAR(50),
    order_approved_at VARCHAR(50),
    order_delivered_timestamp VARCHAR(50),
    order_estimated_delivery_date VARCHAR(50)
);
-- Create index for order_id in Orders table for faster query performance (Faster LOOKUP)
-- ın querying, search, join analyse, filter,sort on order_idö performance will be improved.
CREATE NONCLUSTERED INDEX idx_Orders_order_id
ON stg.Orders (order_id);

--OrderDetail 
CREATE TABLE Stg.OrderDetail(
    order_id VARCHAR(50),
    order_item_id VARCHAR(50),
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    price DECIMAL(18,2),
    shipping_charges DECIMAL(18,2)
);

--Customers 
CREATE TABLE stg.Customer(
    customer_id	VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(50),
    customer_state VARCHAR(50)
);

-- Payments 
CREATE TABLE stg.Payments(
    order_id VARCHAR(50),
    payment_sequential VARCHAR(50),
    payment_type VARCHAR(50),
    payment_installments VARCHAR(50),
    payment_value DECIMAL(18,2)
);

--products 
CREATE TABLE stg.Product(
    product_id VARCHAR(50),
    product_category_name VARCHAR(50),
    product_weight_g VARCHAR(50),
    product_length_cm VARCHAR(50),
    product_height_cm VARCHAR(50),
    product_width_cm VARCHAR(50)
);

--TRUNCATE TABLE stg.Product
--TRUNCATE TABLE stg.Payments
--TRUNCATE TABLE stg.Customer
--TRUNCATE TABLE stg.Orders

-------------------------Dimensions-----------------------

--DimCustomer
CREATE TABLE dbo.DimCustomer(    
	Customerkey	INT IDENTITY(1,1),
    CustomerID	VARCHAR(50),
	CustomerCity VARCHAR(50),
	CustomerZipCode VARCHAR(10),
	CustomerState VARCHAR(50)
);

--Product
CREATE TABLE dbo.DimProduct(    
	Productkey INT IDENTITY (1,1),
	product_id	VARCHAR(50),
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT,
	CreateDate DATETIME DEFAULT GETUTCDATE(),
	CreateBy varchar(50) DEFAULT ORIGINAL_LOGIN(),
	ModifiedDate DATETIME DEFAULT GETUTCDATE(),
	ModifiedDateBy varchar(50) DEFAULT ORIGINAL_LOGIN()
);

--DimProductcategory
CREATE TABLE dbo.DimProductcategory(    
	Productcategorykey INT IDENTITY (1,1),
    product_category_name VARCHAR(50),
	CreateDate DATETIME DEFAULT GETUTCDATE(),
	CreateBy varchar(50) DEFAULT ORIGINAL_LOGIN(),
	ModifiedDate DATETIME DEFAULT GETUTCDATE(),
	ModifiedDateBy varchar(50) DEFAULT ORIGINAL_LOGIN()
);

--DimPaymentType
CREATE TABLE dbo.DimPaymentType(    
	PaymentTypekey INT IDENTITY (1,1),
    payment_type VARCHAR(50),
	CreateDate DATETIME DEFAULT GETUTCDATE(),
	CreateBy varchar(50) DEFAULT ORIGINAL_LOGIN(),
	ModifiedDate DATETIME DEFAULT GETUTCDATE(),
	ModifiedDateBy varchar(50) DEFAULT ORIGINAL_LOGIN()
);

--DimOrder
CREATE TABLE dbo.DimOrder(    
	Orderkey INT IDENTITY (1,1),
	order_id VARCHAR(50),
    order_status VARCHAR(50),
	CreateDate DATETIME DEFAULT GETUTCDATE(),
	CreateBy varchar(50) DEFAULT ORIGINAL_LOGIN(),
	ModifiedDate DATETIME DEFAULT GETUTCDATE(),
	ModifiedDateBy varchar(50) DEFAULT ORIGINAL_LOGIN()
);



-- ======DimDate
CREATE TABLE dbo.DimDate (
    DateKey INT PRIMARY KEY,
    date DATE,
    year INT,
    month INT,
    day INT,
    quarter INT,
    week INT,
    day_of_week INT,
    is_weekend INT
);


--One time execution to populate Dimdate

DECLARE @startDate DATE = '2015-01-01';
DECLARE @endDate DATE = GETDATE();    -- @endDate=GETDATE() -> curr date 
DECLARE @currentDate DATE = @startDate; -- #set to startdate store curr date being processes

WHILE @currentDate <= @endDate
BEGIN
    INSERT INTO dimDate (DateKey, date, year, month, day, quarter, week, day_of_week, is_weekend)
    VALUES (
        CONVERT(INT, FORMAT(@currentDate, 'yyyyMMdd')), --datekey converted to integer
        @currentDate,   -- actualdate 
        YEAR(@currentDate),
        MONTH(@currentDate),
        DAY(@currentDate),
        DATEPART(QUARTER, @currentDate),
        DATEPART(WEEK, @currentDate),
        DATEPART(WEEKDAY, @currentDate), -- dayofweek (1=sunday, 7=saturday)
        CASE WHEN DATEPART(WEEKDAY, @currentDate) IN (1, 7) THEN 1 ELSE 0 END -- 1=weekend, 0=weekday
    );
    
    SET @currentDate = DATEADD(DAY, 1, @currentDate); --incrementing (add 1 day to curr date)
END

--SELECT * FROM dbo.dimDate


--Fact Table--
CREATE TABLE [dbo].[FactOrder](
    [FactOrderKey] [int] IDENTITY(1,1) NOT NULL,
    [Customerkey] [int] NOT NULL,
    [Orderkey] [int] NOT NULL,
    [ProductKey] [int] NOT NULL,
    [ProductCategorykey] [int] NOT NULL,
    [PaymentTypeKey] [int] NOT NULL,
    [PurchaseDateKey] [int] NOT NULL,
    [DeliveredDateKey] [int] NOT NULL,
    [InvoicePayment] [decimal](18, 2) NULL,
    [Price] [decimal](18, 2) NULL,
    [Logistics] [decimal](18, 2) NULL,
    [CreatedDate] DATETIME NOT NULL DEFAULT GETUTCDATE(),
	[CreatedBy] [nvarchar](4000) NOT NULL DEFAULT ORIGINAL_LOGIN(),
    [ModifiedDate] DATETIME NOT NULL DEFAULT GETUTCDATE(),
	[ModifieddateBy] [nvarchar](4000) NOT NULL DEFAULT ORIGINAL_LOGIN(), 
	CONSTRAINT [PK_FactOrder] PRIMARY KEY CLUSTERED (FactOrderKey ASC) -- clustered optimal here since the data is physically stored in that order. and faster.
);

	CREATE NONCLUSTERED INDEX idx_FactOrderKey
ON dbo.FactOrder (FactOrderKey ASC)
WITH (
    PAD_INDEX = OFF,                -- Don't leave space for growth; fill index pages fully.
    STATISTICS_NORECOMPUTE = OFF,   -- Allow automatic recomputation of statistics.
    IGNORE_DUP_KEY = OFF,           -- Do not ignore duplicate keys; raise errors on duplicates.
    ALLOW_ROW_LOCKS = ON,           -- Allow row-level locking for better concurrency.
    ALLOW_PAGE_LOCKS = ON,           -- Allow page-level locking for better performance on large operations.
	FILLFACTOR = 90,
	SORT_IN_TEMPDB = ON
) ON [PRIMARY]; 

