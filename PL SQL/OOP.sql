-- Object oriented concepts in PL/SQL

-- Creating object types as user defined data types, similar to classes in other programming languages.

-- You create objects on data-base level to be able to create instances of them in pl/sql blocks, subprograms or packages. Declaration part is public part
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

-- ********************************************* --

CREATE OR REPLACE TYPE Rectangle IS OBJECT 
(
  length NUMBER,
  height NUMBER,
  MEMBER PROCEDURE display,
  -- Order functions are called when comparison operators are called automatically between two instances of this type. Order functions receive another instance as a parameter and the order is defined by internal logic of the function. Map functions are the same, except that order is defined by internal type attribute and they don't except parameters. Type can only contain one order OR map function, but not both.
  ORDER MEMBER FUNCTION compare(r Rectangle) RETURN NUMBER
);
/

CREATE OR REPLACE TYPE BODY Rectangle IS 
  MEMBER PROCEDURE display IS
  BEGIN
  dbms_output.put_line(TO_CHAR(self.length + self.height));
  END display;
  ORDER MEMBER FUNCTION compare(r Rectangle) RETURN NUMBER IS
  BEGIN
    IF self.length * self.height > r.length * r.height THEN
      RETURN 1;
    ELSE 
      RETURN -1;
    END IF;
  END compare;
END;

-- Example program
DECLARE
  box1 Rectangle := Rectangle(1, 1);
  box2 Rectangle := Rectangle(3,3);
  compare_result number;
BEGIN
  -- Calling member procedures and functions, parenthesis are optional.
  box1.display();
  box2.display();
  
  -- Calling order function
  compare_result := box1.compare(box2);
  dbms_output.put_line(compare_result);

  IF box1 > box2 THEN 
    dbms_output.put_line('First bigger');
  ELSE 
    dbms_output.put_line('Second bigger');
  END IF;
END;