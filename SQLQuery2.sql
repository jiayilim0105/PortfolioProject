--Cleaning data in SQL queries
SELECT
*FROM dbo.NashvilleHousing

--Standardize date format
SELECT SalesDateConverted, CONVERT(date, SaleDate)
FROM dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate=CONVERT(date, SaleDate)

ALTER TABLE NashvilleHousing
Add SalesDateConverted Date;

UPDATE NashvilleHousing
SET SalesDateConverted=CONVERT(date, SaleDate)

--Populate Property address data
SELECT *
FROM dbo.NashvilleHousing
--WHERE propertyaddress is null
order by ParcelID

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b
ON a.ParcelID=b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b
ON a.ParcelID=b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress is null

--Breaking out Address into individual columns(address, city, state)
SELECT PropertyAddress
FROM dbo.NashvilleHousing
--WHERE propertyaddress is null
--order by ParcelID

SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
FROM dbo.NashvilleHousing

UPDATE NashvilleHousing
SET PropertySplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);


UPDATE NashvilleHousing
SET PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

SELECT *
FROM dbo.NashvilleHousing


SELECT OwnerAddress
FROM dbo.NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2)


ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState=PARSENAME(REPLACE(OwnerAddress,',','.'),1)

SELECT *
FROM dbo.NashvilleHousing



--Change Y and N to Yes and No in "Sold as vacant" field
SELECT DISTINCT(SoldAsVacant), Count(SoldAsVacant)
FROM dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant='Y' THEN 'YES'
	 WHEN SoldAsVacant='N' THEN 'NO'
	 ELSE SoldAsVacant
	 END
FROM dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant=CASE WHEN SoldAsVacant='Y' THEN 'YES'
	 WHEN SoldAsVacant='N' THEN 'NO'
	 ELSE SoldAsVacant
	 END

SELECT DISTINCT(SoldAsVacant), Count(SoldAsVacant)
FROM dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

--Remove Duplicates
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY
				ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY uniqueID)row_num
FROM dbo.NashvilleHousing
)
SELECT*
FROM RowNumCTE
where row_num>1 
--ORDER BY PropertyAddress

SELECT *
FROM dbo.NashvilleHousing



--Delete Unused Column
SELECT *
FROM dbo.NashvilleHousing

ALTER TABLE dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict,PropertyAddress

ALTER TABLE dbo.NashvilleHousing
DROP COLUMN SaleDate