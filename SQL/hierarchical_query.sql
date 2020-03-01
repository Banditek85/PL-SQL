/*
Hierarchical queries include CONNECT BY and PRIOR keywords.
One of the expressions of the CONNECT BY expression has to include PRIOR keyword - if expression resolves to true
prior row is defined as parent of current row
START WITH keyword defines where the hierarchy result set should should start
*/

/* LEVEL pseudocolumn is generated automatically, is useful for formatting the result set */

SELECT employee_id
      ,LPAD('-', LEVEL*2) || (first_name || ' ' || last_name) name 
      ,manager_id
      ,prior (first_name || ' ' || last_name) manager_name
      ,LEVEL
FROM employees
START WITH manager_id IS NULL
CONNECT BY manager_id = prior employee_id;

-- We can order result set with ORDER SIBLINGS BY which will ignore parent rows when ordering - in most
-- cases this is what we want