SELECT *
FROM PortfolioProject..NashvilleHousing;

SELECT SaleDate
FROM PortfolioProject..NashvilleHousing;


SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'NashvilleHousing';

--------------------------------------------------------------------------------------------------------------------------


-- Right Now Sale date is a Datetime Format but that time is not required

SELECT SaleDate, Convert(date, SaleDate) AS Date
FROM PortfolioProject..NashvilleHousing;

-- Updating the table 

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate);

SELECT *
FROM NashvilleHousing;

SELECT *
FROM NashvilleHousing
WHERE PropertyAddress is null;


--------------------------------------------------------------------------------------------------------------------------


-- Breaking out Address into Individual Columns (Address, City, State)

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing AS a
JOIN NashvilleHousing AS b
   ON a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null;


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing AS a
JOIN NashvilleHousing AS b
   ON a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null;


SELECT *
FROM NashvilleHousing
WHERE PropertyAddress is null;
-- Now there are no Property Address which are null.


SELECT MAX(LEN(PropertyAddress))
FROM NashvilleHousing;

SELECT MAX(LEN(SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) ))
FROM NashvilleHousing;

-- Maximum Length of Property Address is 42 characters and that of address is 31 Characters so Maximum Length of City can be (42-31) 11 Characters.

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS City
FROM NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD Address VARCHAR(100);

ALTER TABLE NashvilleHousing
ADD City VARCHAR(50);


UPDATE NashvilleHousing
SET Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) ,
    City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) ;


SELECT *
FROM NashvilleHousing;

SELECT * 
FROM NashvilleHousing
WHERE SalePrice is null; --No missing Values for Sale Price.


SELECT ownerAddress
FROM NashvilleHousing;

SELECT PARSENAME(REPLACE(ownerAddress, ',', '.'),3),
       PARSENAME(REPLACE(ownerAddress, ',', '.'),2),
	   PARSENAME(REPLACE(ownerAddress, ',', '.'),1)
FROM NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD ownerSplitAddress VARCHAR(100);

UPDATE NashvilleHousing
SET ownerSplitAddress = PARSENAME(REPLACE(ownerAddress, ',', '.'),3);

ALTER TABLE NashvilleHousing
ADD ownerSplitCity VARCHAR(100);

UPDATE NashvilleHousing
SET ownerSplitCity = PARSENAME(REPLACE(ownerAddress, ',', '.'),2);

ALTER TABLE NashvilleHousing
ADD ownerSplitState VARCHAR(100);

UPDATE NashvilleHousing
SET ownerSplitState = PARSENAME(REPLACE(ownerAddress, ',', '.'),1);

SELECT * FROM NashvilleHousing;


--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT SoldAsVacant , COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant;


SELECT soldAsvacant,
CASE WHEN soldAsVacant = 'yes' THEN 'Y' 
     WHEN soldAsVacant = 'No' THEN  'N' 
	 ELSE soldAsVacant
	END
FROM NashvilleHousing;

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN soldAsVacant = 'yes' THEN 'Y' 
     WHEN soldAsVacant = 'No' THEN  'N' 
	 ELSE soldAsVacant
	END

SELECT SoldAsVacant , COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant;

-------------------------------------------------------------------------------------------------------------

-- Deleting Duplicate Rows

SELECT ParcelID, PropertyAddress, OwnerAddress, COUNT(*)
FROM NashvilleHousing
GROUP BY  ParcelID, PropertyAddress, OwnerAddress
HAVING COUNT(*) > 1;

SELECT * 
FROM NashvilleHousing
WHERE PropertyAddress = '3113  MILLIKEN DR, JOELTON' AND OwnerAddress = '3113  MILLIKEN DR, JOELTON, TN';
-- There are indeed two properties with same address and parcelId

-- Removing the Duplicate Rows



WITH CTE AS (
SELECT *, 
ROW_NUMBER() OVER (
PARTITION BY ParcelId, propertyAddress, OwnerAddress
ORDER BY ParcelId
) row_num
FROM NashvilleHousing
)
DELETE FROM CTE
WHERE row_num > 1;


SELECT ParcelID, PropertyAddress, OwnerAddress, COUNT(*)
FROM NashvilleHousing
GROUP BY  ParcelID, PropertyAddress, OwnerAddress
HAVING COUNT(*) > 1; -- There are no duplicate rows now.


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


Select *
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate











