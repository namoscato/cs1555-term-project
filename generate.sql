
drop table customer cascade constraints ;
drop table administrator cascade constraints ;
drop table product cascade constraints ;
drop table bidlog cascade constraints ;
drop table category cascade constraints ;
drop table belongsto cascade constraints ;

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
status varchar2(10) not null,
buyer varchar2(10),
sell_date date,
amount int
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
category varchar2(10)
);

create table time(
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

insert into administrator values('admin', 'root', 'administrator', '6810 SENSQ', 'admin@1555.com') ;

insert into customer values('user0', 'pwd', 'user0', '6810 SENSQ', 'user0@1555.com');
insert into customer values('user1', 'pwd', 'user1', '6811 SENSQ', 'user1@1555.com');
insert into customer values('user2', 'pwd', 'user2', '6812 SENSQ', 'user2@1555.com');
insert into customer values('user3', 'pwd', 'user3', '6813 SENSQ', 'user3@1555.com');
insert into customer values('user4', 'pwd', 'user4', '6814 SENSQ', 'user4@1555.com');

insert into product values(0, 'Database', 'SQL ER-design', 'user0', to_date('04-dec-2012/12:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 50, 2, 'sold', 'user2', to_date('06-dec-2012/12:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 53);
insert into product values(1, '17 inch monitor', '17 inch monitor', 'user0', to_date('06-dec-2012/12:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 100, 2, 'sold', 'user4', to_date('08-dec-2012/12:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 110);
insert into product values(2, 'DELL INSPIRON 1100', 'DELL INSPIRON notebook', 'user0', to_date('07-dec-2012/12:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 500, 7, 'underauction', null, null, null);
insert into product values(3, 'Return of the King', 'fantasy', 'user1', to_date('07-dec-2012/12:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 40, 2, 'sold', 'user2', to_date('09-dec-2012/12:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 40);
insert into product values(4, 'The Sorcerer Stone', 'Harry Porter series', 'user1', to_date('08-dec-2012/12:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 40, 2, 'sold', 'user3', to_date('10-dec-2012/12:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 40);
insert into product values(5, 'DELL INSPIRON 1100', 'DELL INSPIRON notebook', 'user1', to_date('09-dec-2012/12:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 200, 1, 'withdrawn', null, null, null);
insert into product values(6, 'Advanced Database', 'SQL Transaction index', 'user1', to_date('10-dec-2012/12:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 50, 2, 'underauction', null, null, null);

insert into bidlog values(0, 0, 'user2', to_date('04-dec-2012/08:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 50);
insert into bidlog values(1, 0, 'user3', to_date('04-dec-2012/09:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 53);
insert into bidlog values(2, 0, 'user2', to_date('05-dec-2012/08:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 60);
insert into bidlog values(3, 1, 'user4', to_date('06-dec-2012/08:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 100);
insert into bidlog values(4, 1, 'user2', to_date('07-dec-2012/08:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 110);
insert into bidlog values(5, 1, 'user4', to_date('07-dec-2012/09:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 120);
insert into bidlog values(6, 3, 'user2', to_date('07-dec-2012/08:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 40);
insert into bidlog values(7, 4, 'user3', to_date('09-dec-2012/08:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 40);
insert into bidlog values(8, 6, 'user2', to_date('07-dec-2012/08:00:00am', 'dd-mm-yyyy/hh:mi:ssam'), 55);

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

insert into category values(0, 'Computer Science');
insert into category values(0, 'Computer books');
insert into category values(1, 'Monitors');
insert into category values(2, 'Laptops');
insert into category values(3, 'Fiction books');
insert into category values(4, 'Fiction books');
insert into category values(5, 'Laptops');
insert into category values(6, 'Computer Science');
insert into category values(6, 'Computer books');

commit ;
purge recyclebin ;



