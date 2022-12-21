--Taking a look at the data 
SELECT *
FROM NashvilleHousing


--Standardize date format 
SELECT SaleDate, CONVERT(Date, SaleDate) AS ConvertedDate
FROM NashvilleHousing

--Adding a new Column to the table
ALTER TABLE NashvilleHousing
ADD SaleDateConvertedD Date

--Inserting values into new column
UPDATE NashvilleHousing
SET SaleDateConverted =  CONVERT(Date, SaleDate)

SELECT SaleDate, SaleDateConverted
FROM NashvilleHousing

--Populate Property Address Data 
SELECT PropertyAddress
FROM NashvilleHousing

SELECT *
FROM NashvilleHousing
--WHERE PropertyAddress IS NULL 
ORDER BY ParcelID

SELECT a.ParcelID,a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL

UPDATE a
SET a.PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL



--Breaking out property address into individual columns(Address, City)
SELECT PropertyAddress
FROM NashvilleHousing

SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS City
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255)

UPDATE NashvilleHousing 
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255)
 
UPDATE NashvilleHousing 
SET PropertySplitCity  = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,
 LEN(PropertyAddress))



--Breaking out owner address into individual columns(Address, City, State)
SELECT OwnerAddress
FROM NashvilleHousing

SELECT PARSENAME(OwnerAddress,1)
FROM NashvilleHousing

SELECT PARSENAME(REPLACE(OwnerAddress,',','.'), 3),
PARSENAME(REPLACE(OwnerAddress,',','.'), 2),
PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255)

UPDATE NashvilleHousing 
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255)
 
UPDATE NashvilleHousing 
SET OwnerSplitCity  = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255)
 
UPDATE NashvilleHousing 
SET OwnerSplitState  = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)

SELECT *
FROM NashvilleHousing

--Change Y and N to Yes and No in 'SoldAsVacant' field
SELECT Distinct(SoldAsVacant)
FROM NashvilleHousing

SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant, CASE 
WHEN SoldAsVacant = 'N' THEN 'No'
WHEN SoldAsVacant = 'Y' THEN 'Yes'
ELSE SoldAsVacant
END
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE 
WHEN SoldAsVacant = 'N' THEN 'No'
WHEN SoldAsVacant = 'Y' THEN 'Yes'
ELSE SoldAsVacant
END
FROM NashvilleHousing

--Remove Duplicates
SELECT * 
FROM NashvilleHousing


WITH CTE AS 
(SELECT * , ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress,SalePrice,SaleDate, LegalReference ORDER BY UniqueID
) AS row_num
FROM NashvilleHousing)
--SELECT *
--FROM CTE
--WHERE row_num > 1
DELETE FROM CTE
WHERE row_num >1 


--Delete unused columns 
ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, PropertyAddress, TaxDistrict

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate