/* 
Cursor is a pointer to the private sql context area from where meta-data about a current SELECT or DML statement (INSERT, UPDATE, DELETE or MERGE) can be accessed. We use cursor attributes to access values, which always hold the last executed select or dml statement. For implicit cursors which are controlled by Oracle these attributes are: SQL%FOUND, SQL%NOTFOUND, SQL%ROWCOUNT, SQL%ISOPEN. For explicit cursor 'SQL' is replaced by declared cursor name and is used for retrieving multiple rows.
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
  l_total       INTEGER := 10000;
  CURSOR employee_id_cur
  IS
  SELECT employee_id
  FROM plch_employees
  ORDER BY salary ASC; 
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
CURSOR my_cursor is SELECT id, name FROM employees;
BEGIN
-- i index is automatically set to the employees%ROWTYPE type.
  for i in my_cursor 
  LOOP
  dbms_output.put_line(i.id || ' ' || i.name);
  END LOOP;
END;


/* 
If cursor query does not return any rows, %NOTFOUND attribute is not useful, as the if statement is never evaluated. Below code inside if statement never runs, as there is no country name like 'ole'
*/
DECLARE
    CURSOR c_cny IS 
    SELECT country_name FROM COUNTRIES
    WHERE country_name LIKE 'OLE';
BEGIN
dbms_output.put_line('started');
    FOR i IN c_cny LOOP
    IF c_cny%NOTFOUND THEN
    dbms_output.put_line('You will not see this line.');
    END IF;
    END LOOP;
END;


-- You can also declare pl/sql record type based on a cursor.
DECLARE
CURSOR record_cursor IS
SELECT employee_id, first_name FROM employees
WHERE department_id = 30;

-- Instead of [table_name]%ROWTYPE we are declaring variable based on cursor rowtype:
v_emp_rec record_cursor%ROWTYPE;
BEGIN
  OPEN record_cursor;
  LOOP
    FETCH record_cursor INTO v_emp_rec;
    EXIT WHEN record_cursor%NOTFOUND;
    dbms_output.put_line(v_emp_rec.employee_id || ' ' || v_emp_rec.first_name);
  END LOOP
END;
