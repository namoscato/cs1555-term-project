--Queries that use the java interface to fetch data from user


-- ### 1. Customer Interface

-- (a) Browsing products
-- Java: Assuming 'Books' was the category given

select * from product
where status = 'underauction' and auction_id in (
  select auction_id from belongsto where category = 'Books'
);

-- sort by highest bid
select * from product
where status = 'underauction' and auction_id in (
  select auction_id from belongsto where category = 'Books'
) order by amount desc;

-- sort alphabetically by product name
select * from product
where status = 'underauction' and auction_id in (
  select auction_id from belongsto where category = 'Books'
) order by name asc;

-- do we need to provide SQL to list root/sub-categories?


--(b) Searching for product by text
----Java: Assuming 'DELL' and 'INSPIRON' are the two keywords given
------If one keyword:
select auction_id as "Auction ID", name as "Name", description as "Description"    
from product where upper(description )like upper('%dell%') ;
------If two keywords:
select auction_id as "Auction ID", name as "Name", description as "Description"    
from product where upper(description) like upper('%dell%') and upper(description) like upper('%inspiron%') ;

--(e) Let the seller withdraw or sell the product for the 2nd highest price 
--I UPDATED THE PRODUCT TABLE AND ONE OF THE TRIGGERS OR THIS -- I ADDED THE AMOUNT2 ATTRIBUTE
--when an auction ends. The assumes that the seller of the ended product is logged in.
----Java to check each auction_id of closed auctions to see if the logged in seller is the seller of that product.
----Java: Assuming auction_id is 1 
-------If the seller sells:
update product set amount = amount2 where amount2 > 0 and auction_id = 1;
update product set status = "sold" where auction_id = 1;
-------If the seller withdraws:
update product set status = "withdrawn" where auction_id = 1;

--(f) Suggestions
-- If a customer X asks, the system can provide suggestions on which products he/she should look
-- at. The system looks at the bidding history of customer X; then it determines the "bidding
-- friends" of X, that is, those other customers who bid on the same products that X did; then,
-- our system lists a union of the products that the "bidding friend" are currently bidding on. The
-- products should be listed in decreasing "desirability" order: Desirability of a product is defined
-- as the number of distinct "bidding friends" that have bid on this product.

-- this should probably be a function or a view
-- find suggestions for 'user2'
select auction_id from (
  select friends.bidder, bids.auction_id from (
    select distinct bidder
    from bidlog
    where auction_id in (
        select distinct auction_id
        from bidlog
        where bidder = 'user2'
    )
  ) friends join bidlog bids on friends.bidder = bids.bidder join product p on bids.auction_id = p.auction_id
  -- assuming we don't want to include products user has already bid on
  where bids.auction_id not in (
    select distinct auction_id
    from bidlog
    where bidder = 'user2'
  ) and p.status = 'underauction'
) group by auction_id order by count(bidder) desc;

--2. Administrator Interface
--(a) New Customer registration
--	Ask whether or not the new person is a customer or admin and run the following:
--	Assume the following data was entered: 
insert into customer values('TestUser', 'Password', 'Joe Smith', '123 Fake Str', 'joe@smith.com') ;

--(b) Update System Date
--	Ask user to input new system date in dd-mm-yyyy/hh:mi:ssam format:
update sys_time set my_time = to_date('12-dec-2012/09:00:00pm', 'dd-mm-yyyy/hh:mi:ssam');

--4. Additional Function Requirement
--	a. SQL statement to return user info given a login name/password
--		Java: assuming data given was usn: 'TestUser' pwd: 'Password'
select login, password, name, address, email 
from customer where login = 'TestUse' and password = 'Password' ;
--	b. closeAuctions is already made in generate.sql
