-- EXECUTE IMMEDIATE statement is used in dynamic SQL context and can execute dynamic SQL statement or PL/SQL block. It is used to:
-- * issue stand-alone sql statements that cannot be represented directly in PL/SQL block
-- * to built up a dynamic query where table names, where clauses etc. are not known at compile time
-- * issue DCL and TCL statements like GRANT, REVOKE, COMMIT, ROLLBACK, SAVEPOINT etc. inside PL/SQL block.

DECLARE
v_code VARCHAR2(100) := '
BEGIN
dbms_output.put_line(''OLEOLEOLE'');
END;';

BEGIN

EXECUTE IMMEDIATE v_code;

END;