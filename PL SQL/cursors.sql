/* 
Inside PL/SQL blocks we use cursors to declare pointers to active sets of SELECT or DML SQL statements, which we can then manipulate. Cursors also hold certain metadata about a query in it's attributes as it is processed. 

Implicit cursors are created automatically by Oracle when select and other DML statements are executed, it's attributes are accessed by SQL%attribute_name syntax. 

Explicit cursors we declare ourselves and are pertinent only for SELECT statements that return more than one row.

We can fetch values from cursors into %TYPE variables or composite data types such as collections.

When fetching into collections, we can use bulk collect, to fetch all rows at once.
Use an explicit cursor FOR loop when the query will be reused, otherwise an implicit cursor is preferred.

Why use a loop with a FETCH rather than a FOR loop that doesn’t have an explicit FETCH?
Use a FETCH inside a loop when you need to bulk collect or when you need dynamic SQL.
*/

-- Declaring explicit cursor:
DECLARE
    CURSOR c_cny IS 
    SELECT country_name FROM COUNTRIES;
    v_cny_name countries.country_name%TYPE;
BEGIN
dbms_output.put_line('started');
OPEN c_cny;
    LOOP
    -- We are fetching the cursor into the %TYPE variables
    FETCH c_cny INTO v_cny_name;
    EXIT WHEN c_cny%NOTFOUND;
    dbms_output.put_line(v_cny_name);
    END LOOP;
    CLOSE c_cny;
END;

-- Declaring explicit cursors gives us flexibility to exit loops on certain conditions:
DECLARE
  l_total INTEGER := 10000;
  CURSOR employee_id_cur IS
  SELECT employee_id
  FROM plch_employees
  ORDER BY salary ASC; 

  -- We can declare cursor rowtype type.
  l_employee_id   employee_id_cur%ROWTYPE;
BEGIN
  OPEN employee_id_cur;
  LOOP
    FETCH employee_id_cur INTO l_employee_id;
    EXIT WHEN employee_id_cur%NOTFOUND;
    assign_bonus (l_employee_id, l_total);
    EXIT WHEN l_total <= 0;
  END LOOP;
  CLOSE employees_cur;
END;

/*
Cursor FOR loop is the most simple way to use cursors. Open, fetch and close are done automatically when there are no more rows left to fetch or if there is some other reason. You use it when you need all rows from the cursor query.
*/ 

DECLARE 
CURSOR my_cursor IS 
SELECT id, name FROM employees;
BEGIN
-- i index is automatically set to the employees%ROWTYPE type.
  FOR i in my_cursor 
  LOOP
  dbms_output.put_line(i.id || ' ' || i.name);
  END LOOP;
END;

/* 
If cursor query does not return any rows, looping through cursor and checking %NOTFOUND attribute is not useful,
// as the if statement is never evaluated. Below code inside if statement never runs, as there is no country name like 'ole'
*/
DECLARE
    CURSOR c_cny IS 
    SELECT country_name FROM COUNTRIES
    WHERE country_name LIKE 'OLE';
BEGIN
dbms_output.put_line('started');
    FOR i IN c_cny LOOP
    -- This will not get evaluated because loop will never run
    IF c_cny%NOTFOUND THEN
    dbms_output.put_line('You will not see this line.');
    END IF;
    END LOOP;
END;


-- REF cursor 
CREATE OR REPLACE PROCEDURE authors_list(p_membership NUMBER default NULL) AS

    l_cursor   SYS_REFCURSOR;
    l_authors  authors%ROWTYPE;
    l_query    VARCHAR2(100);

BEGIN
    IF p_membership IS NULL THEN    
      l_query := 'SELECT * FROM authors';
      OPEN l_cursor FOR l_query;
    ELSE 
      l_query := 'SELECT * FROM authors WHERE membership_id = :param';
      OPEN l_cursor FOR l_query USING p_membership;
    END IF;

    LOOP
      FETCH l_cursor INTO l_authors;
      EXIT WHEN l_cursor%NOTFOUND;
      dbms_output.put_line(l_authors.author_name);
    END LOOP;
    CLOSE l_cursor;
END;
/