-- Bulk binding is used to reduce the amount of code and more importantly to reduce context switches between SQL and PL/SQL
-- engines. Every time you have a non-SELECT DML statement inside any kind of loop, you should consider switching to bulk binding. 

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

/* Shorter way of doing same thing as above is with bulk collect (here used with implicit cursor), which implicitly extends collection
and inserts the value:
*/
select first_name bulk collect into t_names from employees;

-- Printing the nested table:
    for i in t_names.first..t_names.last
    loop
    dbms_output.put_line(t_names(i));
    end loop;
end;

/* PL/SQL collections are held in memory, which on large data sets can represent performance problem. For this reason LIMIT clause
is provided which is used to fetch and process smaller chunks of data in phases */

DECLARE
-- Declaring a collection type and collection type variable to temporarily store the data
  TYPE t_buffer IS TABLE OF countries.country_name%TYPE;
  v_buffer t_buffer := new t_buffer();
  
-- Declaring the cursor  
  CURSOR c_data IS 
                SELECT country_name FROM countries;
                
BEGIN
  OPEN c_data;
    LOOP
      FETCH c_data BULK COLLECT INTO v_buffer
      LIMIT 5;
      -- When cursor did not fetch anything, exit the loop
      EXIT WHEN v_buffer.COUNT = 0;
      
      -- Process the data here
        FOR i IN 1..v_buffer.COUNT
          LOOP
            dbms_output.put_line(v_buffer(i)); 
          END LOOP;
    END LOOP;
  CLOSE c_data;
END;
/

-- Without using the LIMIT clause all of the data can be fetched at once and is available in the collection after the fetch
-- completes

DECLARE
  TYPE t_buffer IS TABLE OF countries.country_name%TYPE;
  v_buffer t_buffer := new t_buffer();
  
  CURSOR c_data IS 
                SELECT country_name FROM countries;

BEGIN
  OPEN c_data;
    FETCH c_data BULK COLLECT INTO v_buffer;
  CLOSE c_data;
END;


-- Or fetch just first 10 rows in the table
/*
BEGIN
   OPEN c_data;
     FETCH c_data BULK COLLECT INTO v_buffer
     LIMIT 10;
   CLOSE c_data;
 END;
*/ 










