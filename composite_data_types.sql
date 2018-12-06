-- PL/SQL COMPOSITE DATA TYPES
-- Data types which hold multiple values

-- ** RECORDS
-- **Internal components of records can be of different data-types and are called fields. We acces each field by it's name.
DECLARE
-- We declare a record data type and it's fields data types.
TYPE myType IS RECORD (
v_first competitors.compet_name%TYPE,
v_second competitors.compet_description%type
);
v_myType myType;
BEGIN
-- We access fields in a record through a dot notation 
v_myType.v_first := 'some name';
v_myType.v_second := 'some description';
dbms_output.put_line(v_myType.v_first || ' ' || v_myType.v_second);
END;

-- %ROWTYPE DATA TYPE IS BASED ON A CERTAIN ROW OF A CERTAIN TABLE
DECLARE
-- Declaring a variable with a %rowtype data type.
v_compet competitors%ROWTYPE;
BEGIN
v_compet.compet_name := 'Mitja';
dbms_output.put_line(v_compet.compet_name);
END;

-- ** COLLECTIONS

-- VARRAYS (Fixed pre-defined size, index starts with 1). EXTEND function can be used on it. For initialization constructor function can be used. 
DECLARE
    TYPE my_varray IS VARRAY(5) OF VARCHAR(100);
    v_arr my_varray;
    len integer;
BEGIN
    v_arr := my_varray('one', 'two', 'three', 'four', 'five'); 
    len := v_arr.count;
    FOR i in 1..len loop
    dbms_output.put_line(v_arr(i));
    end loop;
END;

-- NESTED TABLES
--Analogous to List data type in other languages. Variable size, index starts with 1. EXTEND function is required to add additional indexes. For initialization constructor function can be used.
DECLARE
TYPE t_nt IS TABLE OF NUMBER;
    my_nt t_nt := t_nt(4, 2, 4, 5, 7);
BEGIN
    dbms_output.put_line(my_nt(4));
END;

-- ASSOCIATIVE ARRAYS (Also called INDEX BY tables)
-- Key/value structure analogous to dictionary or map data-types; primary key is of integer OR string data type and value of scalar or record data type. Does not use a constructor function for initialization!

DECLARE 
    TYPE t_ibt IS TABLE OF VARCHAR2(100) 
    INDEX BY VARCHAR2(10);
    myibt t_ibt;
BEGIN
    myibt('first') := 'one';
    dbms_output.put_line(myibt('first'));
END;