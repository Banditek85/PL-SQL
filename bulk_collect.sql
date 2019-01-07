declare
    type string_table is table of varchar2(50);
    t_names string_table := new string_table();
    c number := 0;
begin
/* Manually populating the t_names nested table with implicit cursor

  for i in (select first_name from employees)
  loop
    c := c + 1;
    t_names.extend();
    t_names(c) := i.first_name;
  end loop;
*/

/* Shorter way of doing same thing as above is with bulk collect, which implicitly extends collection
and inserts the value:
*/
select  first_name bulk collect into t_names from employees;

-- Printing the nested table:
    for i in t_names.first..t_names.last
    loop
    dbms_output.put_line(t_names(i));
    end loop;
end;