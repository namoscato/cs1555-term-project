--CS1555 Term Project
--Nicholas Amoscato -- naa46@pitt.edu
--Ryan Sandhaus -- rjs90@pitt.edu

-- ### 1. Create the tables and insert necessary data

drop table customer cascade constraints ;
drop table administrator cascade constraints ;
drop table product cascade constraints ;
drop table bidlog cascade constraints ;
drop table category cascade constraints ;
drop table belongsto cascade constraints ;

drop table sys_time cascade constraints ;

drop sequence seq1;
drop sequence seq2;

create table customer(
login varchar2(10),
password varchar2(10),
name varchar2(20),
address varchar2(30),
email varchar2(20)
);

create table administrator(
login varchar2(10),
password varchar2(10),
name varchar2(20),
address varchar2(30),
email varchar2(20)
);

create table product(
auction_id int,
name varchar2(20),
description varchar2(30),
seller varchar2(10),
start_date date,
min_price int,
number_of_days int,
status varchar2(20) not null,
buyer varchar2(10),
sell_date date,
amount int,
amount2 int default 0 --extra value added to keep track of 2nd highest bid
);

create table bidlog(
bidsn int,
auction_id int,
bidder varchar2(10),
bid_time date,
amount int
);

create table category(
name varchar2(20),
parent_category varchar2(20)
);

create table belongsto(
auction_id int,
category varchar2(20)
);

create table sys_time(
  my_time date
);

alter table customer add constraint pk_customer primary key(login) ;
alter table administrator add constraint pk_administrator primary key(login) ;
alter table product add constraint pk_product primary key(auction_id) ;
alter table bidlog add constraint pk_bidlog primary key(bidsn) ;
alter table category add constraint pk_category primary key(name) ;
alter table belongsto add constraint pk_belongsto primary key(auction_id, category) ;

alter table product add constraint fk_product1 foreign key(seller) references customer(login) ;
alter table product add constraint fk_product2 foreign key(buyer) references customer(login) ;
alter table bidlog add constraint fk_bidlog1 foreign key(auction_id) references product(auction_id) ;
alter table bidlog add constraint fk_bidlog2 foreign key(bidder) references customer(login) ;
alter table category add constraint fk_category foreign key(parent_category) references category(name) ;
alter table belongsto add constraint fk_belongsto1 foreign key(auction_id) references product(auction_id) ;
alter table belongsto add constraint fk_belongsto2 foreign key(category) references category(name) ;

create sequence seq1 start with 1 increment by 1 nomaxvalue;
create sequence seq2 start with 1 increment by 1 nomaxvalue;

-- auto-increment triggers
CREATE OR REPLACE TRIGGER product_trigger
BEFORE INSERT ON product
FOR EACH ROW
BEGIN
  SELECT seq1.NEXTVAL
  INTO   :new.auction_id
  FROM   dual;
END;
/

CREATE OR REPLACE TRIGGER bidlog_trigger
BEFORE INSERT ON bidlog
FOR EACH ROW
BEGIN
  SELECT seq2.NEXTVAL
  INTO   :new.bidsn
  FROM   dual;
END;
/

insert into administrator values('admin', 'root', 'administrator', '6810 SENSQ', 'admin@1555.com') ;

insert into customer values('user0', 'pwd', 'user0', '6810 SENSQ', 'user0@1555.com');
insert into customer values('user1', 'pwd', 'user1', '6811 SENSQ', 'user1@1555.com');
insert into customer values('user2', 'pwd', 'user2', '6812 SENSQ', 'user2@1555.com');
insert into customer values('user3', 'pwd', 'user3', '6813 SENSQ', 'user3@1555.com');
insert into customer values('user4', 'pwd', 'user4', '6814 SENSQ', 'user4@1555.com');

insert into product values(1, 'Database', 'SQL ER-design', 'user0', to_date('04-dec-2012/12:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 50, 2, 'sold', 'user2', to_date('06-dec-2012/12:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 53, 0);
insert into product values(2, '17 inch monitor', '17 inch monitor', 'user0', to_date('06-dec-2012/12:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 100, 2, 'sold', 'user4', to_date('08-dec-2012/12:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 110, 0);
insert into product values(3, 'DELL INSPIRON 1100', 'DELL INSPIRON notebook', 'user0', to_date('07-dec-2012/12:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 500, 7, 'underauction', null, null, null, 0);
insert into product values(4, 'Return of the King', 'fantasy', 'user1', to_date('07-dec-2012/12:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 40, 2, 'sold', 'user2', to_date('09-dec-2012/12:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 40, 0);
insert into product values(5, 'The Sorcerer Stone', 'Harry Porter series', 'user1', to_date('08-dec-2012/12:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 40, 2, 'sold', 'user3', to_date('10-dec-2012/12:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 40, 0);
insert into product values(6, 'DELL INSPIRON 1100', 'DELL INSPIRON notebook', 'user1', to_date('09-dec-2012/12:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 200, 1, 'withdrawn', null, null, null, 0);
insert into product values(7, 'Advanced Database', 'SQL Transaction index', 'user1', to_date('10-dec-2012/12:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 50, 2, 'underauction', null, null, null, 0);
insert into product values(8, 'Another Database', 'SQL ER-design', 'user1', to_date('04-nov-2012/12:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 50, 2, 'sold', 'user2', to_date('06-nov-2012/12:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 53, 0);
insert into product values(9, 'The Sorcerer Stone 2', 'Harry Porter series', 'user1', to_date('08-dec-2012/12:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 40, 2, 'underauction', null, null, null, 0);

insert into bidlog values(1, 1, 'user2', to_date('04-dec-2012/08:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 50);
insert into bidlog values(2, 1, 'user3', to_date('04-dec-2012/09:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 53);
insert into bidlog values(3, 1, 'user2', to_date('05-dec-2012/08:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 60);
insert into bidlog values(4, 2, 'user4', to_date('06-dec-2012/08:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 100);
insert into bidlog values(5, 2, 'user2', to_date('07-dec-2012/08:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 110);
insert into bidlog values(6, 2, 'user4', to_date('07-dec-2012/09:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 120);
insert into bidlog values(7, 4, 'user2', to_date('07-dec-2012/08:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 40);
insert into bidlog values(8, 5, 'user3', to_date('09-dec-2012/08:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 40);
insert into bidlog values(9, 7, 'user2', to_date('07-dec-2012/08:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 55);
insert into bidlog values(10, 1, 'user2', to_date('07-dec-2012/08:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 100);
insert into bidlog values(11, 9, 'user3', to_date('09-dec-2012/08:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 40);

insert into category values('Books', null);
insert into category values('Textbooks', 'Books');
insert into category values('Fiction books', 'Books');
insert into category values('Magazines', 'Books');
insert into category values('Computer Science', 'Textbooks');
insert into category values('Math', 'Textbooks');
insert into category values('Philosophy', 'Textbooks');
insert into category values('Computer Related', null);
insert into category values('Desktop PCs', 'Computer Related');
insert into category values('Laptops', 'Computer Related');
insert into category values('Monitors', 'Computer Related');
insert into category values('Computer books', 'Computer Related');

insert into belongsto values(1, 'Computer Science');
insert into belongsto values(1, 'Computer books');
insert into belongsto values(2, 'Monitors');
insert into belongsto values(3, 'Laptops');
insert into belongsto values(4, 'Fiction books');
insert into belongsto values(5, 'Fiction books');
insert into belongsto values(6, 'Laptops');
insert into belongsto values(7, 'Computer Science');
insert into belongsto values(7, 'Computer books');
insert into belongsto values(8, 'Computer books');

insert into sys_time values(to_date('01-dec-2011/09:00:00am', 'dd-mm-yyyy/hh:mi:ssam'));

commit;


-- ### 2. Customer Interface

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

-- we probabaly need to write SQL to list root/sub categories at some point


-- (b) Searching for product by text
----Java: Assuming 'DELL' and 'INSPIRON' are the two keywords given
------If one keyword:
select auction_id as "Auction ID", name as "Name", description as "Description"    
from product where upper(description )like upper('%dell%') ;
------If two keywords:
select auction_id as "Auction ID", name as "Name", description as "Description"    
from product where upper(description) like upper('%dell%') and upper(description) like upper('%inspiron%') ;


-- (c) Putting products for auction

create or replace type vcarray as table of varchar2(20);
/

-- check if category is valid:
-- select count(name) from category where name = ? or parent_category = ?
-- if count(name) == 1, it is a leaf
-- if count(name) == 0, category doesn't exist
-- if count(name) > 1, category exists, but it is not a leaf

create or replace procedure put_product (
  name in varchar2,
  description in varchar2,
  categories in vcarray,
  days in int,
  seller in varchar2,
  min_price in int,
  id out int
) is
  start_date date;
begin
  select my_time into start_date
  from sys_time;

  insert into product values(1, name, description, seller, start_date, min_price, days, 'underauction', null, null, null, null) returning auction_id into id;

  -- add categories to product
  -- assume categories are valid (checked in Java)
  for i in 1..categories.count loop
    insert into belongsto values(id, categories(i));
  end loop;

  return;
end;
/

-- test procedure
-- DECLARE
--  arr vcarray;
--  id int;
-- BEGIN
--  arr := vcarray('Math', 'Laptopss');
--  put_product('test', 'testing', arr, 2, 'user0', 10, id);
-- dbms_output.put_line(id);
-- END;
-- /


-- (d) Bidding on products

-- advance system time by 5 seconds after a new bid is inserted
CREATE OR REPLACE TRIGGER tri_bidTimeUpdate
BEFORE INSERT ON product
FOR EACH ROW
BEGIN
  update sys_time
  set my_time = my_time + 5/86400 ;
END;
/

-- update the amount attribute for a product after a bid is placed on it
-- also updating amount2 to reflect the second highest price
CREATE OR REPLACE TRIGGER tri_updateHighBid
AFTER INSERT ON bidlog
FOR EACH ROW
BEGIN
  update product
  set amount = :new.amount where auction_id = :new.auction_id ;
  update product
  set amount2 = :old.amount where auction_id = :new.auction_id ;
END;
/

-- check the validity of the new bid (surrounded by transaction?)
-- might be able to return a boolean to use w/ java

create or replace function validate_bid(id int, bid int)
return int is
  invalid exception;
  amount int;
  status varchar2(20);
begin
  -- do we still need this? should this be set only once for all transactions?
  set transaction isolation level serializable name 'bid' ;
  select amount into amount
  from product
  where auction_id = id;

  if bid <= amount then
    raise invalid;
  end if;

  select status into status
  from product
  where auction_id = id;

  -- sanity check
  if status <> 'underauction' then
    raise invalid;
  end if;
  commit ;
  return 1;
exception
  when invalid then
    return 2; --set to 2 so in java there can be a specific error for if the bid is
	--invalid due to it being too low, or on an incorrect product
  when others then
    return 0;
end;
/
-- select validate_bid(7,55) from dual;

-- if validate_bid():
-- record in the database the new bid where <amount> is an amount
insert into bidlog values(1, 1, 'username', (select my_time from sys_time), <amount>);

/*
This procudure is going to be used in the Java implementation. Currently we have our
concurrency-checking transaction surround the creation of the function as well as the
insert, which is unnecessary. This will be changed with the following procudure:

create or replace procedure make_bid()
begin
set transaction isolation level serializable name 'bid' ;
if select validate_bid(<id>, <amount>) from amount != 0
then
insert into bidlog values(1, 1, 'username', (select my_time from sys_time), <amount>);
end if ;
commit ;
end ;
/
*/



-- (e) Selling products

---- (1) sell the product
select count(bidsn) as bids from bidlog where auction_id = 1;
-- if bids > 1:
update product
set status = 'sold', buyer = (
  select * from (
    select bidder
    from bidlog
    where auction_id = 1
    order by bid_time desc
  ) where rownum <= 1
), sell_date = (select my_time from sys_time), amount = (select amount2 from product where auction_id = 1)
where auction_id = 1;
-- if bids == 1, then don't update amount attr

---- (2) withdraw the auction
update product
set status = 'withdrawn'
where auction_id = 1;


--(f) Suggestions
-- find suggestions for 'user0'

select product.auction_id, product.name, product.description, product.amount from (
  select friends.bidder, bids.auction_id from (
    -- find user's friends
    select distinct bidder
    from bidlog b1
    where not exists (
      -- select auction_ids that bidder didn't bid on
      -- this should be empty; otherwise, bidder is not a friend
      select distinct auction_id
      from bidlog b2
      where bidder = 'user0' and not exists (
        select distinct bidder, auction_id
        from bidlog b3
        where b1.bidder = b3.bidder and b2.auction_id = b3.auction_id
      )
    ) and bidder <> 'user0' and (
      -- take care of special case in which user has not bid on anything
      select count(auction_id)
      from bidlog
      where bidder = 'user0'
    ) > 0
  ) friends join bidlog bids on friends.bidder = bids.bidder join product p on bids.auction_id = p.auction_id
  -- assuming we don't want to include products user has already bid on
  where bids.auction_id not in (
    select distinct auction_id
    from bidlog
    where bidder = 'user0'
  ) and p.status = 'underauction'
) t1 join product on t1.auction_id = product.auction_id
group by product.auction_id, product.name, product.description, product.amount
order by count(bidder) desc;


-- ### 3. Administrator Interface

-- (a) New Customer registration
-- Ask whether or not the new person is a customer or admin and run the following:
-- Assume the following data was entered:
select count(login) as valid from customer where login = 'TestUser';
-- if valid == 0:
insert into customer values('TestUser', 'Password', 'Joe Smith', '123 Fake Str', 'joe@smith.com') ;


-- (b) Update System Date
--  Ask user to input new system date in dd-mm-yyyy/hh:mi:ssam format:
update sys_time set my_time = to_date('12-dec-2012/09:00:00pm', 'dd-mm-yyyy/hh:mi:ssam');


-- (c) Product statistics

---- (1) for all  products
select name, status, amount as highest_bid, login from (
  select p.name, p.status, p.amount, b.bidder as login
  from product p join bidlog b on p.auction_id = b.auction_id and p.amount = b.amount
  where p.status = 'underauction'
  union
  select name, status, amount, buyer as login
  from product
  where status = 'sold'
);

---- (2) if seller name is provided
-- assume seller = user0
select name, status, amount as highest_bid, login, seller from (
  select p.name, p.status, p.amount, b.bidder as login, p.seller
  from product p join bidlog b on p.auction_id = b.auction_id and p.amount = b.amount
  where p.status = 'underauction'
  union
  select name, status, amount, buyer as login, seller
  from product
  where status = 'sold'
) where seller = 'user0';


-- (d) Statistics

-- counts the number of products sold in the past x months for a specific category c
create or replace function product_count(months number, cat varchar2)
return number is
  my_count number;
begin
  select count(p.auction_id) into my_count
  from product p join belongsto b on p.auction_id = b.auction_id
  where b.category = cat and p.status = 'sold' and p.sell_date >= add_months((select my_time from sys_time), -1 * months);
  return my_count;
end;
/
-- select product_count(5, 'Computer bookss') from dual;

-- counts the number of bids a user u has placed in the past x months
create or replace function bid_count(user varchar2, months number)
return number is
  my_count number;
begin
  select count(bidsn) into my_count
  from bidlog
  where bidder = user and bid_time >= add_months((select my_time from sys_time), -1 * months);
  return my_count;
end;
/
-- select bid_count('user2', 4) from dual;

-- calculates the total dollar amount a specific user u has spent in the past x months,
create or replace function buying_amount(user varchar2, months number)
return number is
  my_count number;
begin
  select sum(amount) into my_count
  from product
  where status = 'sold' and buyer = user and sell_date >= add_months((select my_time from sys_time), -1 * months)
  group by buyer;
  return my_count;
end;
/
-- select buying_amount('user4', 4) from dual;

-- i. the top k highest volume categories (highest count of products sold), here we only
--    care categories that do not contain any other subcategories (i.e, leaf nodes in the category hierarchy).
-- assume months = 12
select c1.name, product_count(12, c1.name) as count
from category c1
where not exists (
  select name
  from category c2
  where c2.parent_category = c1.name
) and product_count(12, c1.name) > 0
order by product_count(12, c1.name) desc;

-- ii. the top k highest volume categories (highest count of products sold), we only care categories
--     that do not belong to any other category (root nodes in the category hierarchy).
-- for each root category, do this:
-- assume root category and child categories is list: 'Computer Science' and 'Computer books'
-- assume months = 12
select count(auction_id) from (
  select distinct p.auction_id
  from product p join belongsto b on p.auction_id = b.auction_id
  where p.status = 'sold' and p.sell_date >= add_months((select my_time from sys_time), -1 * 13) and b.category in ('Computer Science', 'Math', 'Philosophy', 'Fiction books', 'Magazines')
);
-- then, add these results to a SortedMap in Java and only list the top k results

-- iii. the top k most active bidders (highest count of bids placed)
-- assume month = 12 and k = 5
select * from (
  select login, bid_count(login, 12) as amount
  from customer
  where bid_count(login, 12) > 0
  order by amount desc
) where rownum <= 5;

-- iv. the top k most active buyers (highest total dollar amount spent)
-- assume month = 12 and k = 5
select * from (
  select login, buying_amount(login, 12) as amount
  from customer
  where buying_amount(login, 12) is not null
  order by amount desc
) where rownum <= 5;

-- ### 4. Additional Functional Requirements

-- (a) get user info
select * from customer where login = 'username' and password = 'password';

-- (b) Create closeAuctions trigger
-- check if an auction has expired and change its status to 'close'
CREATE OR REPLACE TRIGGER closeAuctions
AFTER UPDATE ON sys_time
BEGIN
  update product
  set status = 'close'
  where status = 'underauction' and (start_date + number_of_days) < (select my_time from sys_time);
END;
/

commit;
purge recyclebin;
