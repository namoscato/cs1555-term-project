
create or replace type vcarray as varray(50) of varchar2(20);
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
  new_id int;
  start_date date;
begin
  select my_time into start_date
  from sys_time;
  insert into product values(1, name, description, seller, start_date, min_price, days, 'underauction', null, null, null) returning auction_id into new_id;
  return;
end;
/

-- execute put_product('test', null, vcarray('Laptops', 'Math'), 2, 'user0', 10);