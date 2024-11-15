
--==================== PK Constraints =======================================
--Customer
IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints
    WHERE [parent_object_id] = OBJECT_ID('DimCustomer')
    AND [type] = 'PK'
)
BEGIN
	ALTER TABLE [dbo].[DimCustomer]
	ADD CONSTRAINT pk_DimCustomer PRIMARY KEY ([Customerkey]);
END;

--DimOrder

IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints
    WHERE [parent_object_id] = OBJECT_ID('DimOrder')
    AND [type] = 'PK'
)
BEGIN

	ALTER TABLE [dbo].[DimOrder]
	ADD CONSTRAINT pk_DimOrder PRIMARY KEY ([Orderkey]);
END;


--DimPaymentType

IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints
    WHERE [parent_object_id] = OBJECT_ID('DimPaymentType')
    AND [type] = 'PK'
)
BEGIN
	ALTER TABLE [dbo].[DimPaymentType]
	ADD CONSTRAINT pk_DimPaymentType PRIMARY KEY ([PaymentTypekey]);
END;

--DimProduct
IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints
    WHERE [parent_object_id] = OBJECT_ID('DimProduct')
    AND [type] = 'PK'
)
BEGIN
	ALTER TABLE [dbo].[DimProduct]
	ADD CONSTRAINT pk_DimProduct PRIMARY KEY ([Productkey]);

END;

--DimProductcategory
IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints
    WHERE [parent_object_id] = OBJECT_ID('DimProductcategory')
    AND [type] = 'PK'
)
BEGIN
	ALTER TABLE [dbo].[DimProductcategory]
	ADD CONSTRAINT pk_DimProductcategory PRIMARY KEY ([Productcategorykey]);

END;


--DimDate
IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints
    WHERE [parent_object_id] = OBJECT_ID('DimDate')
    AND [type] = 'PK'
)
BEGIN
	ALTER TABLE [dbo].[DimDate]
	ADD CONSTRAINT pk_DimDate PRIMARY KEY ([DateKey]);

END;

--DimDate
IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints
    WHERE [parent_object_id] = OBJECT_ID('DimDate')
    AND [type] = 'PK'
)
BEGIN
	ALTER TABLE [dbo].[DimLocation]
	ADD CONSTRAINT pk_DimDate PRIMARY KEY ([DateKey]);

END;

---========================= FK Constraint ================================

ALTER TABLE [dbo].[FactOrder]
ADD CONSTRAINT fk_DimOrder
FOREIGN KEY ([Orderkey]) REFERENCES [dbo].[DimOrder]([Orderkey]);


ALTER TABLE [dbo].[FactOrder]
ADD CONSTRAINT fk_DimCustomer
FOREIGN KEY ([Customerkey]) REFERENCES [dbo].[DimCustomer]([Customerkey]);


ALTER TABLE [dbo].[FactOrder]
ADD CONSTRAINT fk_DimProduct
FOREIGN KEY ([ProductKey]) REFERENCES [dbo].[DimProduct]([ProductKey]);


ALTER TABLE [dbo].[FactOrder]
ADD CONSTRAINT fk_DimProductcategory
FOREIGN KEY ([ProductCategorykey]) REFERENCES [dbo].[DimProductcategory]([ProductCategorykey]);


ALTER TABLE [dbo].[FactOrder]
ADD CONSTRAINT fk_DimPaymentType
FOREIGN KEY ([PaymentTypeKey]) REFERENCES [dbo].[DimPaymentType] ([PaymentTypeKey]);


ALTER TABLE [dbo].[FactOrder]
ADD CONSTRAINT fk_DimDate_PurchaseDateKey
FOREIGN KEY ([PurchaseDateKey]) REFERENCES [dbo].[DimDate]([DateKey]);



ALTER TABLE [dbo].[FactOrder]
ADD CONSTRAINT fk_DimDate_DeliveredDateKey
FOREIGN KEY ([DeliveredDateKey]) REFERENCES [dbo].[DimDate]([DateKey]);
