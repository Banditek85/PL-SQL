DECLARE
    v_parent_cursor  sys_refcursor;
    v_child_cursor   sys_refcursor;
    v_dname          varchar2(199);
    v_sal            number;
    v_comm           number;
BEGIN
    OPEN v_parent_cursor FOR SELECT dname, 
                                    CURSOR(SELECT sal, comm 
                                           FROM emp e
                                           WHERE e.deptno = d.deptno)
    FROM dept d;
    
    LOOP
    FETCH v_parent_cursor INTO v_dname, v_child_cursor;
    EXIT WHEN v_parent_cursor%NOTFOUND;
    
    dbms_output.put_line('Processing department: ' || v_dname);
    
        LOOP
            FETCH v_child_cursor INTO v_sal, v_comm;
            EXIT WHEN v_child_cursor%NOTFOUND;
            
            dbms_output.put_line('Salary: ' || v_sal || ',  Commission: ' || v_comm);
        END LOOP;
    END LOOP;
END;

/**************************************************************************************/
DECLARE
    CURSOR parent_cur IS 
    SELECT CURSOR(SELECT 1 FROM dual) AS foo FROM dual;
    
    v_child_cursor   sys_refcursor;
    v_num number;
BEGIN
    OPEN parent_cur;
    LOOP
        FETCH parent_cur INTO v_child_cursor;
        EXIT WHEN parent_cur%NOTFOUND;
        
        LOOP
            FETCH v_child_cursor INTO v_num;
            EXIT WHEN v_child_cursor%NOTFOUND;
            dbms_output.put_line(v_num);
        END LOOP;
    END LOOP;
    CLOSE parent_cur;
END;