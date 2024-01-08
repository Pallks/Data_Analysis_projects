/* NASHVILLE HOUSING DATA ANALYSIS/*


/* Cleaning data using SQL quiries */


select * from PortfolioProject.nashvillehousing;


-- Populating property address column
-- where property address is  null
-- If ParcelId column is same for different rows then populate the property address col as same 

select * from PortfolioProject.nashvillehousing
order by parcelId ;


-- (1)Using self join to join same table 

select *
from PortfolioProject.nashvillehousing a
join PortfolioProject.nashvillehousing b
on a.parcelid=b.parcelid
and a.uniqueid <> b.uniqueid;


-- (2)After self join we are populating property adress col if uniqueid col is not same for different rows but parcelid col is same

select 
a.parcelid,
a.uniqueid,
b.parcelid,
b.uniqueid,
a.propertyaddress,
b.propertyaddress
from PortfolioProject.nashvillehousing a
join PortfolioProject.nashvillehousing b
on a.parcelid=b.parcelid
and a.uniqueid <> b.uniqueid 
where a.propertyaddress is null;


-- (3)Using ifnull to populate/ISNULL: simply checks if a value is null or not and IFNULL acts like COALESCE 
--    and will return the 2nd value if the first value is null 

select a.parcelid,
a.propertyaddress,
b.parcelid,
b.propertyaddress,
IfNULL(a.propertyaddress,b.propertyaddress) 
from PortfolioProject.nashvillehousing a
join PortfolioProject.nashvillehousing b
on a.parcelid=b.parcelid
and a.uniqueid <> b.uniqueid 
where a.propertyaddress is null;


-- (4)Using update func to populate the null rows in propertyaddress column

update a
set a.propertyaddress = IfNULL(a.propertyaddress,b.propertyaddress) 
from PortfolioProject.nashvillehousing a
join PortfolioProject.nashvillehousing b
on a.parcelid=b.parcelid
and a.uniqueid <> b.uniqueid 
where a.propertyaddress is null;


-- (5)Splitting property adress into indivisual columns of address,city,state 
--    Select propertyaddress from PortfolioProject.nashvillehousing 

select 
SUBSTRING_index(propertyaddress,',',1 ) as address,     
SUBSTRING_index(propertyaddress,',',-1 ) as address 
from PortfolioProject.nashvillehousing ;



-- (6) creating columns to add the new split adress and split city columns


SET SQL_SAFE_UPDATES=0;

Alter table nashvillehousing
add propertysplitaddress varchar(255);
update nashvillehousing
set propertysplitaddress=SUBSTRING_index(propertyaddress,',',1 );


Alter table nashvillehousing
add propertysplitcity varchar(255);
update nashvillehousing
set propertysplitcity=SUBSTRING_index(propertyaddress,',',-1 );


select * from PortfolioProject.nashvillehousing;
 
 
 -- (7) Splitting the owneraddress column using the same substring_index or using 'Parsename'
 
 select * from PortfolioProject.nashvillehousing;

select 
owneraddress  
from PortfolioProject.nashvillehousing;

select 
owneraddress,
SUBSTRING_index(owneraddress,',',1 ) as address1,  
substring_index((SUBSTRING_index(owneraddress,',',2)),',',-1) as address2,
SUBSTRING_index(owneraddress,',',-1 ) as address3
from PortfolioProject.nashvillehousing;


-- (8) Add new columns and update the new values into it 

Alter table nashvillehousing
Add ownersplitaddress varchar(255);
Update nashvillehousing
set ownersplitaddress=SUBSTRING_index(owneraddress,',',1 ) ;

Alter table nashvillehousing
add ownersplitcity varchar(255);
update nashvillehousing
set ownersplitcity=substring_index((SUBSTRING_index(owneraddress,',',2)),',',-1);

Alter table nashvillehousing
Add ownersplitstate varchar(255);
Update nashvillehousing
Set ownersplitstate=SUBSTRING_index(owneraddress,',',-1 ) ;

--  check after the  above upadates
 
select * from PortfolioProject.nashvillehousing

 
-- (9)Changing Y as yes and N as no in Soldasvacant column 
 
-- (a)first checking distinct values of soldasvacant column and counting them
 
 select 
 distinct(soldasvacant),
 count(soldasvacant)
 from PortfolioProject.nashvillehousing
 group by soldasvacant
 order by 2;
 
 -- (b)now replacing the Y, N as yes and no
 
 select soldasvacant,
 case 
 when soldasvacant='Y' then 'Yes' 
 when soldasvacant='N' then  'No'
 else soldasvacant
 end
 from portfolioproject.nashvillehousing;
 
 -- (c) now update the column in the table
 
 update nashvillehousing
 set soldasvacant= 
 case 
 when soldasvacant='Y' then 'Yes' 
 when soldasvacant='N' then  'No'
 else soldasvacant
 end;
 
-- (d)now check and make sure the above is updated 

 select * from PortfolioProject.nashvillehousing;
 

 
 
 
 

 
 
 
 
 
 
 

