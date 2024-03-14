SELECT * 
FROM dbo.Housing

ALTER TABLE Housing 
ALTER COLUMN SaleDate Date;

 -----------------------------------------------------

 --Populate Property Address data 
 SELECT * 
 FROM dbo.Housing 
 WHERE PropertyAddress is not null 
 ORDER BY ParcelID DESC

SELECT a.ParcelID,a.PropertyAddress, b.ParcelID, b.PropertyAddress,ISNULL (a.PropertyAddress,b.PropertyAddress)
FROM dbo.Housing a
JOIN dbo.Housing b
   on a.ParcelID = b.ParcelID
   AND a.[UniqueID] <>b.[UniqueID]
WHERE a.PropertyAddress is null;

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From dbo.Housing a
JOIN dbo.Housing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


------------------------------------------------------------------------------
-- Breaking out Address into Individual Columns (Address, City, State)
SELECT PropertyAddress
FROM dbo.Housing
WHERE PropertyAddress is null

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Street
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as City

From dbo.Housing

ALTER TABLE Housing
Add PropertyStreetAddress Nvarchar(255);

Update Housing
SET PropertyStreetAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE Housing
Add PropertyCityAddress Nvarchar(255);

Update Housing
SET PropertyCityAddress = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


SELECT *
FROM Housing

ALTER TABLE Housing
DROP COLUMN PropertyAddress


SELECT CONCAT(PropertyStreetAddress, ',', PropertyCityAddress) as PropertyAdress
FROM Housing

ALTER TABLE Housing 
ADD PropertyAddress NVARCHAR(255);

UPDATE Housing
SET PropertyAddress = CONCAT(PropertyStreetAddress, ',', PropertyCityAddress)


SELECT OwnerAddress
FROM Housing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3) as Street,
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2) as City,
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1) as State
From Housing



ALTER TABLE Housing
Add OwnerStreetAddress Nvarchar(255);

Update Housing
SET OwnerStreetAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE Housing
Add OwnerCityAddress Nvarchar(255);

Update Housing
SET OwnerCityAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE Housing
Add OwnerStateAddress Nvarchar(255);

Update Housing
SET OwnerStateAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

SELECT *
FROM Housing


--------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant) as Count
From Housing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No' 
	   ELSE SoldAsVacant
	   END as count
From Housing


Update Housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	               When SoldAsVacant = 'N' THEN 'No'
	               ELSE SoldAsVacant
	               END

SELECT * 
FROM Housing