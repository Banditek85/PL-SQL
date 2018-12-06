-- Object oriented concepts in PL/SQL

-- Creating object types as user defined data types, similar to classes in other programming languages.

-- You create objects on data-base level to be able to instantiate instances of them in pl/sql blocks, subprograms or packages. Declaration part is public part
CREATE OR REPLACE TYPE Animal IS OBJECT 
(
  name varchar2(100),
  legs number(1),
  MEMBER FUNCTION speak RETURN VARCHAR2
);
/
CREATE OR REPLACE TYPE BODY Animal IS
  MEMBER FUNCTION speak RETURN VARCHAR2 IS
  -- declare variables here
    BEGIN
      RETURN name || '  says woof.';
    END;
END;