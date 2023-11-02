--Cleaning Data in Nash House 
select * from Nashhouse

--Standardize the Format 
--convert() func to convert to  sepecific datatype --convert(datatype,column)
select convert(date,saledate) as SaleDate from Nashhouse

--Doing through Adding new column
alter table Nashhouse
add SaleDateConverted date

update Nashhouse
set SaleDateConverted = convert(date,saledate)

select saledate, SaleDateConverted from Nashhouse

--Populate porperty address data
--i.e adding data of property address "B" to property address "A" where the property address is null of A is null
select a.ParcelId,a.PropertyAddress,b.ParcelId,b.PropertyAddress,
isnull(a.PropertyAddress,b.PropertyAddress)
from Nashhouse as a
join Nashhouse as b
on a.PropertyAddress = b.PropertyAddress and a.uniqueId <> b.uniqueId
where a.PropertyAddress is Null

update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from Nashhouse as a
join Nashhouse as b
on a.PropertyAddress = b.PropertyAddress and a.uniqueId <> b.uniqueId
where a.PropertyAddress is Null 

--change Y and N to Yes and No in sold and vacant field
select SoldAsVacant
case
when SoldAsVacant = 'Y' THEN 'YES',
when SoldAsVacant = 'N' THEN 'No',
end as Sold_As_Vacant
from Nashhouse

--Checking Duplicates
select ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference, count(UniqueID) as Duplicates
from Nashhouse
group by ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference
having count(UniqueID) > 1

--Remove Duplicates
with my_cte as (
	select *,
	row_number() over(partition by ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference order by UniqueId) as Row_No
	from Nashhouse
)
select * from my_cte
where Row_No > 1
order by PropertyAddress

--delete from Nashhouse
--where UniqueID in 
--(
--select UniqueID from Nashhouse
--group by PropertyAddress
--having count(UniqueID) > 1
--)

--Removing the Unwanted Columns
alter table Nashhouse
drop column OwnerAddress, TaxDistrict


