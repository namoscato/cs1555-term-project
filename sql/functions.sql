create or replace type vcarray as varray(20) of varchar2(20);
/

-- procedure inserts a product into the database
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
DECLARE
  arr vcarray;
  id int;
BEGIN
  arr := vcarray('Math', 'Laptopss');
  --put_product('test', 'testing', arr, 2, 'user0', 10, id);
  dbms_output.put_line(id);
END;
/


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

commit;
purge recyclebin;