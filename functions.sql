
create or replace type vcarray as varray(50) of varchar2(20);
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
  new_id int;
  start_date date;
  invalid_cat exception;
begin
  select my_time into start_date
  from sys_time;

  -- check to see if categories are valid
  i := categories.FIRST;
  loop
    exit when i is null;
    if ((select count(name) from category where parent_category = categories(i)) = 0) 
      then raise invalid_cat;
    end if;
    i := categories.NEXT(i);
  end loop;

  insert into product values(1, name, description, seller, start_date, min_price, days, 'underauction', null, null, null) returning auction_id into new_id;
  return;
exception
  when invalid_cat then raise_application_error(-20001, 'category is invalid');
end;
/

commit;

-- execute put_product('test', 'testing', vcarray('Laptops', 'Math'), 2, 'user0', 10);