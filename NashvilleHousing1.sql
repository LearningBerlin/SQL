  SELECT * 
  FROM PortfolioProject.dbo.NashvilleHousing 

  --Standardize Date Format 
  SELECT SaleDate, CONVERT(Date,SaleDate)Fiverr
  FROM PortfolioProject.dbo.NashvilleHousing 


  ALTER TABLE PortfolioProject.dbo.NashvilleHousing 
Add SaleDateConverted Date;

Update PortfolioProject.dbo.NashvilleHousing 
SET SaleDateConverted = CONVERT(Date,SaleDate);

-- Property Address is null
-- adding property address where it is empty with the same address
 select * 
 from PortfolioProject.dbo.NashvilleHousing 
 where PropertyAddress is null 
  --  there are duplicates but they have unique ParcelID get them togther and see 
  Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
  From PortfolioProject.dbo.NashvilleHousing a
  Join PortfolioProject.dbo.NashvilleHousing b
       on a.ParcelID = b.ParcelID
	   AND a.[UniqueID ] <> b.[UniqueID ]
  Where a.PropertyAddress is null 

  Update a 
  SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
  FROM PortfolioProject.dbo.NashvilleHousing a
  JOIN PortfolioProject.dbo.NashvilleHousing b
       on a.ParcelID = b.ParcelID
	   AND a.[UniqueID ] <> b.[UniqueID ]
  WHERE a.PropertyAddress is null 

  -- RUN THE CODE 
    Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
  From PortfolioProject.dbo.NashvilleHousing a
  Join PortfolioProject.dbo.NashvilleHousing b
       on a.ParcelID = b.ParcelID
	   AND a.[UniqueID ] <> b.[UniqueID ]
  Where a.PropertyAddress is null 

  --Breaking out Address into Individual Columns (Address, City, State) 

  -- the property Address
  SELECT PropertyAddress
  FROM PortfolioProject.dbo.NashvilleHousing
  

  -- getting rid of comma we use charindex
  -- using charindex breaks the address into several columns 
Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

-- The address 
Update PortfolioProject.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);
 --The city 
Update PortfolioProject.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))
 
 --SECOND WAY TO BREAK DOWN ADDRESS IN THREE DIFFERENT COLUMNS 
Select *
From PortfolioProject.dbo.NashvilleHousing

SELECT OwnerAddress 
From PortfolioProject.dbo.NashvilleHousing 


Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1) 
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255); 

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3) 

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplittCity Nvarchar(255); 

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
SET OwnerSplittCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255); 

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


Select * 
From PortfolioProject.dbo.NashvilleHousing

-- change Y and N to Yes and No in "Sold as Vacant" field 

SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant 
Order by 2 


Select SoldAsVacant 
,CASE When SoldAsVacant = 'Y' THEN 'Yes'
      When SoldAsVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
	  END
FROM PortfolioProject.dbo.NashvilleHousing

UPDATE PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
      When SoldAsVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
	  END


SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant 
Order by 2 


---- REMOVE DUPLICATES ---------
WITH RowNumCTE AS(
SELECT *, 
       ROW_NUMBER() OVER(
	   PARTITION BY ParcelID,
	               PropertyAddress,
				   SalePrice,
				   SaleDate,
				   LegalReference
				   ORDER BY
				      UniqueID
					  )row_num
FROM PortfolioProject.dbo.NashvilleHousing 
)
Select *
From RowNumCTE
WHERE row_num >1
ORDER BY PropertyAddress



-- delect unused columns 

Select *
from PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate


