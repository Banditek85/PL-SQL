/*
Bulk binding is used to reduce context switches between SQL and PL/SQL
engines inside PL/SQL program and with that improve performance. Every time you have a non-SELECT DML statement inside any kind of loop, you should consider switching to bulk binding. */ 

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
select first_name bulk collect 
into t_names from employees;
-- Printing the nested table:
    for i in t_names.first..t_names.last
    loop
    dbms_output.put_line(t_names(i));
    end loop;
end;

/* PL/SQL collections are held in memory, which on large data sets can represent performance problem. 
For this reason LIMIT clause is provided which is used to fetch and process smaller chunks of data in phases */

DECLARE
-- Declaring a collection type and collection type variable to temporarily store the data
  TYPE t_buffer IS TABLE OF countries.country_name%TYPE;
  v_buffer t_buffer := new t_buffer();
  
-- Declaring the cursor  
  CURSOR c_data IS SELECT country_name
                   FROM countries;
                
BEGIN
  OPEN c_data;
    LOOP
    -- This time we use BULK COLLECT with FETCH INTO clause instead of SELECT
      FETCH c_data BULK COLLECT INTO v_buffer
      LIMIT 5;
      -- When cursor doesn't fetch anything, exit the loop, because it reached the end of the data set.
      EXIT WHEN v_buffer.COUNT = 0;
      
      -- Inner loop to process individual elements in this particular chunk.
        FOR i IN 1..v_buffer.COUNT
          LOOP
            dbms_output.put_line(v_buffer(i)); 
          END LOOP;
    END LOOP;
  CLOSE c_data;
END;
/

-- Without using the LIMIT clause all of the data can be fetched at once and is available in the collection after the fetch completes.
-- It can also be used to fetch only a subset of the data-set, e.g. first 10 rows.

DECLARE
  TYPE t_buffer IS TABLE OF countries.country_name%TYPE;
  v_buffer t_buffer := new t_buffer();
  
  CURSOR c_data IS 
  SELECT country_name FROM countries;

BEGIN
  OPEN c_data;
    FETCH c_data BULK COLLECT INTO v_buffer
    LIMIT 10;
  CLOSE c_data;
END;

-- REF Cursor is an Oracle provided type that can be used to declare cursor variables as pointers to specific SQL work area data sets.
-- Advantage over static CURSOR objects is that they can be passed back to the client or be associated with different queries.
DECLARE
    TYPE books_rec IS RECORD (
    book_category books.book_category%TYPE,
    book_title    books.book_title%TYPE);
    
    l_ref_cur SYS_REFCURSOR;
    l_books_rec books_rec;  
BEGIN
-- we open ref cursor type for this particular query (could be something else)
OPEN l_ref_cur FOR SELECT book_category, book_title 
                   FROM books;
LOOP
-- fetching cursor data set into a record in a loop
    FETCH l_ref_cur INTO l_books_rec;
    EXIT WHEN l_ref_cur%NOTFOUND;
    dbms_output.put_line(l_books_rec.book_title);
END LOOP;
CLOSE l_ref_cur;
END;
/