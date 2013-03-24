--Queries that use the java interface to fetch data from user


--1. Customer Interface
--(a) Browsing products
----Java: String X = user input for category
select auction_id as "Auction ID", name as "Name", description as "Description"    
from product where status = 'underauction' and auction_id is in
	(select auction_id from belongs to where category = *X*) ;
----Prompt user if they want to sort by highest bid (a), alphabetically by product name(b), or exit:
--------a:
select auction_id as "Auction ID", name as "Name", 
description as "Description", amount as "Highest Bid"  
from product where status = 'underauction' and auction_id is in
	(select auction_id from belongs to where category = *X*) 
order by amount desc ;
--------b:
select auction_id as "Auction ID", name as "Name", description as "Description"    
from product where status = 'underauction' and auction_id is in
	(select auction_id from belongs to where category = *X*) 
order by name desc ;