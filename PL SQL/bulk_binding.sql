DECLARE
    TYPE emp_t IS TABLE OF employees.first_name%TYPE;
    l_tab emp_t := NEW emp_t();
    c NUMBER := 0;
    error_number NUMBER;
BEGIN
    FOR i IN (SELECT first_name FROM employees)
    LOOP
    c := c + 1;
    l_tab.extend();
    l_tab(c) := i.first_name;
    END LOOP;

    -- bulk collect to do the same thing as above
    -- SELECT first_name BULK COLLECT INTO l_tab
    
     /* without bulk binding
    Update will exceed limit for character length in some rows.
    So we have an exception inside the loop
     
    FOR i IN 1..l_tab.COUNT
    LOOP
    BEGIN
    UPDATE ename 
    SET first_name = first_name || ' to be added'
    WHERE first_name = l_tab(i);
    
    EXCEPTION 
    WHEN OTHERS THEN
    NULL;
    END LOOP;
    */
    
    -- with bulk binding we can store exceptions with SAVE EXCEPTIONS, when there is an exception
    -- processing will countinue?
    FORALL i IN 1..l_tab.COUNT SAVE EXCEPTIONS
    UPDATE ename
    SET first_name = first_name || ' to be added!'
    WHERE first_name = l_tab(i);
    
    EXCEPTION WHEN OTHERS THEN
    error_number := sql%bulk_exceptions.count;
    dbms_output.put_line('Total number of errors is: ' || error_number);
    
    FOR j IN 1..error_number
    LOOP
    dbms_output.put_line(sql%bulk_exceptions(j).error_index || sql%bulk_exceptions(j).error_code
    || ' ' || sqlerrm(sql%bulk_exceptions(j).error_code));
    END LOOP;
END;
/


-- Bulk collect and cursors
-- without bulk binding and manual extending of nested table
DECLARE
TYPE emp_tabtype IS TABLE OF employees%rowtype;
emp_table emp_tabtype;
CURSOR emp_c IS SELECT * FROM EMPLOYEES;

c NUMBER := 0;
BEGIN

emp_table := NEW emp_tabtype();

OPEN emp_c;
LOOP
    c := c + 1;
    emp_table.extend();
    FETCH emp_c INTO emp_table(c);
    EXIT WHEN emp_c%NOTFOUND;
    dbms_output.put_line(emp_table(c).first_name);
END LOOP;
    CLOSE emp_c;
END;


-- with bulk binding and automatic extending of a nested table
DECLARE
TYPE emp_t IS TABLE OF employees%ROWTYPE;
emp_table emp_t;
CURSOR emp_c IS SELECT * FROM employees;
BEGIN
OPEN emp_c;
FETCH emp_c BULK COLLECT INTO emp_table;
FOR i IN emp_table.first..emp_table.last
LOOP
    dbms_output.put_line(emp_table(i).first_name);
END LOOP;
END;