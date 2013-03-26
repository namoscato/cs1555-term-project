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
begin
  select my_time into start_date
  from sys_time;

  -- check to see if categories are valid
  i := categories.FIRST;
  loop
    exit when i is null;
    select count(name) into temp from category where parent_category = categories(i);
    if (temp > 0) 
      then raise invalid_cat;
    end if;
    i := categories.NEXT(i);
  end loop;

  insert into product values(1, name, description, seller, start_date, min_price, days, 'underauction', null, null, null) returning auction_id into id;
  return;
exception
  when invalid_cat then raise_application_error(-20001, 'category is invalid');
end;
/

-- test procedure
DECLARE
  arr vcarray;
  id int;
BEGIN
  arr := vcarray('Math', 'Laptops');
  --put_product('test', 'testing', arr, 2, 'user0', 10, id);
  dbms_output.put_line(id);
END;
/

-- counts the number of products sold in the past x months for a specific category c
-- not tested
create or replace function product_count(months number, category varchar2)
return number is
  my_count number;
begin
  select count(p.auction_id) from product p join belongsto b on p.auction_id = b.auction_id
  where b.category = category and p.sell_date >= add_months((select my_time from sys_time), -1 * months);
  return my_count;
end;
/

commit;
purge recyclebin;