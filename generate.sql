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
amount2 int default 0
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

create or replace type vcarray as varray(20) of varchar2(20);
/

create or replace procedure put_product (
  name in varchar2,
  description in varchar2,
  categories in vcarray,
  days in int,
  seller in varchar2,
  min_price in int,
  id out int
) is
  i number;
  temp number;
  start_date date;
  invalid_cat exception;
  cat_no_exist exception;
begin
  select my_time into start_date
  from sys_time;

  -- do we need to surround this with a transaction?
  i := categories.FIRST;
  loop
    exit when i is null;
    -- check to see if category exists
    select count(name) into temp from category where name = categories(i);
    if (temp != 1)
      then raise cat_no_exist;
    else
      -- check to see if category is valid
      select count(name) into temp from category where parent_category = categories(i);
      if (temp > 0) 
        then raise invalid_cat;
      end if;
    end if;
    i := categories.NEXT(i);
  end loop;

  insert into product values(1, name, description, seller, start_date, min_price, days, 'underauction', null, null, null, null) returning auction_id into id;

  -- add categories to product
  i := categories.FIRST;
  loop
    exit when i is null;
    insert into belongsto values(id, categories(i));
    i := categories.NEXT(i);
  end loop;

  return;
exception
  when invalid_cat then raise_application_error(-20001, 'category is invalid');
  when cat_no_exist then raise_application_error(-20002, 'category does not exist');
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

-- *** check the validity of the new bid
-- *** record in the database the new bid


-- (e) Selling products

---- (1) sell the product
select count(bidsn) as bids from bidlog where auction_id = 1;
-- if bids > 1:
  update product
  set status = 'sold', buyer = (
    select bidder
    from bidlog
    where auction_id = 1 and rownum <= 1
    order by bid_time desc
  ), sell_date = (select my_time from sys_time), amount = (select amount2 from product where auction_id = 1)
  where auction_id = 1;

---- (2) withdraw the auction
update product
set status = 'withdrawn'
where auction_id = 1;


--(f) Suggestions

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


-- *** (c) Product statistics


-- (d) Statistics

-- counts the number of products sold in the past x months for a specific category c
create or replace function product_count(months number, cat varchar2)
return number is
  my_count number;
begin
  select count(p.auction_id) into my_count
  from product p join belongsto b on p.auction_id = b.auction_id
  where b.category = cat and p.sell_date >= add_months((select my_time from sys_time), -1 * months);
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
  from (
    select distinct p.auction_id, p.amount
    from bidlog b join product p on b.auction_id = p.auction_id
    where p.status = 'sold' and b.bidder = user and b.bid_time >= add_months((select my_time from sys_time), -1 * months)
  );
  return my_count;
end;
/
-- select buying_amount('user2', 4) from dual;


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
