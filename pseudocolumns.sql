/* 
Pseudo-columns are Oracle assigned values (pseudo-fields) used in the same context as database columns, but are not insertable
or stored in the database. 
Examples: ROWNUM, SYSDATE, SYSTIMESTAMP, ROWID, CURRVAL, NEXTVAL etc.
*/

SELECT SYSDATE, SYSTIMESTAMP FROM dual;

/*
ROWNUM pseudo-column returns a number indicating the order in which a row was selected from a table so it can be used to limit
the result set of our query.
*/ 

-- This selects only first three rows of type 'Cruiser':
SELECT ship_id, ship_name, port_num from ships
WHERE ship_type = 'Cruiser' AND ROWNUM <= 3;

/*
ROWNUM is incremented only when the previous row has it's own value assigned. That's why this will not return any rows, because
ROWNUM is not greater than 1 for the first row and condition is always false.
*/
SELECT * FROM employees
WHERE ROWNUM > 1;

/*
ROWNUM pseudo-column has it's value assigned BEFORE any ordering and grouping of the result set is done, so we need to do these
operations (if they are needed) in a separated subquery. This will select first top 5 paid employees.
*/
SELECT * FROM 
  (SELECT * FROM employees 
   ORDER BY salary DESC)
WHERE ROWNUM <= 5;