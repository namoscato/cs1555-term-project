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


--(b) Searching for product by text
----Java stuff to check if they entered one or two keywords (X, Y)
------If one keyword:
select auction_id as "Auction ID", name as "Name", description as "Description"    
from product where description like "%X%" ;
------If two keywords:
select auction_id as "Auction ID", name as "Name", description as "Description"    
from product where description like "%X%Y%" or "%Y%X" ;

--(e) Let the seller withdraw or sell the product for the 2nd highest price 
--I UPDATED THE PRODUCT TABLE AND ONE OF THE TRIGGERS OR THIS -- I ADDED THE AMOUNT2 ATTRIBUTE
--when an auction ends. The assumes that the seller of the ended product is logged in.
----Java to check each auction_id of closed auctions to see if the logged in seller is the seller of that product.
----Java to ask whether they want to sell or withdraw the product given the amount2 value.
-------If the seller sells:
update product set amount = amount2 where amount2 > 0 and auction_id = X;
update product set status = "sold" where auction_id = X;
-------If the seller withdraws:
update product set status = "withdrawn" where auction_id = X ;

--(f) Suggestions
-- If a customer X asks, the system can provide suggestions on which products he/she should look
-- at. The system looks at the bidding history of customer X; then it determines the "bidding
-- friends" of X, that is, those other customers who bid on the same products that X did; then,
-- our system lists a union of the products that the "bidding friend" are currently bidding on. The
-- products should be listed in decreasing "desirability" order: Desirability of a product is defined
-- as the number of distinct "bidding friends" that have bid on this product.

-- this should probably be a function or a view
select auction_id from (
  select friends.bidder, bids.auction_id from (
    select distinct bidder
    from bidlog
    where auction_id in (
        select distinct auction_id
        from bidlog
        where bidder = 'user2'
    )
  ) friends join bidlog bids on friends.bidder = bids.bidder
  -- assuming we don't want to include products user has already bid on
  where bids.auction_id not in (
    select distinct auction_id
    from bidlog
    where bidder = 'user2'
  )
) group by auction_id order by count(bidder) desc;

--2. Administrator Interface
--(a) New Customer registration
--	Ask whether or not the new person is a customer or admin and run the following:
insert into customer/administrator values(X, Y, Z, I, J) ;

--(b) Update System Date
--	Ask user to input new system date in dd-mm-yyyy/hh:mi:ssam format:
update sys_time set my_time = X ;

