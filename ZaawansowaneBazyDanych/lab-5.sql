-- =============================================
-- Weronika
-- Gurba
-- 233082
-- =============================================
-- =============================================
-- Zadanie 1
-- =============================================

-- https://github.com/weronikag77/BazyDanych.git

-- =============================================
-- Zadanie 2
-- =============================================

alter table [233082].Customer

add 
	SysStartTime DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL DEFAULT GETDATE(),
	SysEndTime DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL DEFAULT '9999-12-31 23:59:59.9999999',
	PERIOD FOR System_Time (SysStartTime, SysEndTime)
go

alter table [233082].Customer
SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [233082].CustomerHistory))
go

-- =============================================
-- Zadanie 3
-- =============================================

ALTER TABLE [233082].Customer
SET (SYSTEM_VERSIONING = OFF)
go

UPDATE [233082].Customer
SET Suffix = 'None'
WHERE Suffix is null
GO

UPDATE [233082].Customer
SET Title = 'None'
WHERE Title is null
GO

UPDATE [233082].Customer
SET SalesPerson = 'None'
WHERE CustomerID = 30125
GO

INSERT INTO [233082].Customer (FirstName, LastName, PasswordHash, PasswordSalt)
VALUES ('Zachary', 'Williams', 'qwer', 'tyui'),
	('Chris', 'Weaver', 'opas', 'dfgh'),
	('Naomi', 'White', 'jklz', 'xcvb'),
	('Chloe', 'Watson', 'dfre', 'hgty'),
	('Carol', 'Whitney', 'vcds', 'jjkh')
go

-- =============================================
-- Zadanie 4
-- =============================================

ALTER TABLE [233082].Customer
SET (SYSTEM_VERSIONING = ON)
go

SELECT * FROM [233082].Customer
FOR SYSTEM_TIME ALL
WHERE CustomerID = 30125
go

-- =============================================
-- Zadanie 5
-- =============================================

SELECT * FROM [233082].Customer
FOR SYSTEM_TIME as of '2026-04-12 13:41:00.9912749'
go

-- =============================================
-- Zadanie 6
-- =============================================

CREATE XML SCHEMA COLLECTION SalesLT.ProductAttributeSchema AS N'
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xs:element name="Attributes">
        <xs:complexType>
            <xs:sequence>
                <xs:element name="Weight" type="xs:decimal"/>
                <xs:element name="Color" type="xs:string"/>
                <xs:element name="Material" type="xs:string"/>
                <xs:element name="Size" type="xs:string"/>
                <xs:element name="Price" type="xs:decimal"/>
            </xs:sequence>
        </xs:complexType>
    </xs:element>
</xs:schema>';
go

CREATE TABLE [SalesLT].[ProductAttribute] (
    ProductID INT PRIMARY KEY,
    Attributes XML(SalesLT.ProductAttributeSchema) NOT NULL,
    
    CONSTRAINT FK_ProductAttribute_Product FOREIGN KEY (ProductID)
    REFERENCES [SalesLT].[Product] (ProductID)
);
go

-- =============================================
-- Zadanie 7
-- =============================================

INSERT INTO [SalesLT].[ProductAttribute] (ProductID, Attributes)
VALUES (680,
'<Attributes>
    <Weight>2.5</Weight>
    <Color>Red</Color>
    <Material>Aluminum</Material>
    <Size>L</Size>
    <Price>24.5</Price>
</Attributes>'),

(727, 
'<Attributes>
    <Weight>1.2</Weight>
    <Color>Silver</Color>
    <Material>Carbon</Material>
    <Size>M</Size>
    <Price>56.5</Price>
</Attributes>'),

(745, 
'<Attributes>
    <Weight>0.5</Weight>
    <Color>Black</Color>
    <Material>Plastic</Material>
    <Size>S</Size>
    <Price>59.0</Price>
</Attributes>'),

(777, 
'<Attributes>
    <Weight>3.0</Weight>
    <Color>Blue</Color>
    <Material>Steel</Material>
    <Size>XL</Size>
    <Price>128.5</Price>
</Attributes>'),

(810, 
'<Attributes>
    <Weight>1.8</Weight>
    <Color>White</Color>
    <Material>Composite</Material>
    <Size>M</Size>
    <Price>45.9</Price>
</Attributes>');
go

-- =============================================
-- Zadanie 8
-- =============================================

UPDATE [SalesLT].[ProductAttribute]
set Attributes.modify('replace value of(/Attributes/Color)[1] with "W-color"')
go

UPDATE [SalesLT].[ProductAttribute]
set Attributes.modify('replace value of(/Attributes/Material)[1] with "W-material"')
go

UPDATE [SalesLT].[ProductAttribute]
set Attributes.modify('replace value of(/Attributes/Size)[1] with "W-size"')
go

-- =============================================
-- Zadanie 9
-- =============================================

declare @var_json nvarchar(max) = N'{"Name:"Weronika", "Age":20}'
SET @var_json = JSON_MODIFY(@var_json, '$.Age', 21);
go