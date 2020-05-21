SELECT dt
FROM gis_dt;

dt �÷����� �����Ͱ� 5/8 ~ 6/7�� �ش��ϴ� ������ Ÿ�� �ڷᰡ ����Ǿ� �ִµ�
5/1 ~ 5/31�� �ش��ϴ� ��¥(�����)�� �ߺ����� ��ȸ�ϰ� �ʹ�.
���ϴ� ��� : 5/8 ~ 5/31 �ִ� 24���� ���� ��ȸ�ϰ� ���� ��Ȳ

0.293��
SELECT TO_CHAR(dt, 'YYYYMMDD'), COUNT (*)
FROM gis_dt
WHERE dt BETWEEN TO_DATE('20200508', 'YYYYMMDD') AND TO_DATE('20200531 23:59:59', 'YYYYMMDD HH24:MI:SS')
GROUP BY TO_CHAR(dt, 'YYYYMMDD')
ORDER BY TO_CHAR(dt, 'YYYYMMDD');

1.EXISTS ==>

�츮�� ���ϴ� ���� �ִ� ���� ��� : 31

SELECT TO_CHAR(d, 'YYYYMMDD')
FROM
    (SELECT TO_DATE('20200501', 'YYYYMMDD') + (LEVEL - 1) d
    FROM dual
    CONNECT BY LEVEL <= 31) a
WHERE EXISTS (SELECT 'X'
                FROM gis_dt
                WHERE dt BETWEEN TO_DATE(TO_CHAR(d, 'YYYYMMDD') || '00:00:00', 'YYYYMMDDHH24:MI:SS') 
                             AND TO_DATE(TO_CHAR(d, 'YYYYMMDD') || '23:59:59', 'YYYYMMDDHH24:MI:SS'));

============================================================================================

PL/SQL ==> PL/SQL�� �����ϴ� ���� ����Ŭ ��ü
        . �ڵ� ��ü�� ����Ŭ�� ����
        . ������ �ٲ� �Ϲ� ���α׷��� ���� ������ �ʿ䰡 ����
        
SQL ==> SQL ������ �Ϲ� ���� ����(java)
        .���� sql�� ���õ� ������ �ٲ�� java������ ������ ���ɼ��� ũ��.

PL/SQL : Procedual Language / Structured Query Language
SQL : ������, ������ ���� ����

������ �ϴٺ��� � ���ǿ� ���� ��ȸ�ؾ� �� ���̺� ��ü�� �ٲ�ų�, 
������ ��ŵ�ϴ� ���� �������� �κ��� �ʿ��� ���� �ִ�

DBMS�󿡼� ������ ������ SQL�� �ۼ��ϸ� �����ϴ�(���������� �����)
�Ϲ����� ���α׷��� ���� ����ϴ� ��������(if, case), �ݺ���(for, while), ���� ���� Ȱ���� �� �ִ� PL/SQL�� ����

���� ������
java =
pl/sql :=

java���� sysout ==> console�� ���
PL/SQL���� ����
SET SERVEROUTPUT ON; �α׸� �ܼ�â�� ��°����ϰԲ� �ϴ� ����

PL/SQL BLOCK�� �⺻����
DECLARE : ����� (���� ���� ����, ��������)
BEGIN : ����� (������ �����Ǵ� �κ�)
EXCEPTION : ���ܺ� (���ܰ� �߻� ���� �� CATCH�Ͽ� �ٸ� ������ �����ϴ� �κ�)(= try-catch)

PL/SQL �͸�(�̸��� ����, ��ȸ��) ���;

DECLARE
    /*JAVA : TYPE ������
    PL/SQL : ������ TYPE*/
    
    v_deptno NUMBER(2);
    v_dname VARCHAR2(14);
    
BEGIN
    /*dept ���̺��� 10�� �μ��� �ش��ϴ� �μ���ȣ, �μ����� DECLARE���� ������ �ΰ��� ������ ���*/
    
    SELECT deptno, dname INTO v_deptno, v_dname
    FROM dept
    WHERE deptno = 10;
    
    /*JAVA�� SYSOUT*/
    DBMS_OUTPUT.PUT_LINE(v_deptno ||'     '|| v_dname);
END;
/

������ Ÿ�� ����
v_deptno, v_dname �ΰ��� ���� ���� ==> dept ���̺��� �÷� ���� �������� ����
                                 ==> dept ���̺��� �÷� ������ Ÿ�԰� �����ϰ� �����ϰ� ���� ��Ȳ
                                 
������ Ÿ���� ���� �������� �ʰ� ���̺��� �÷� Ÿ���� �����ϵ��� ������ �� �ִ�.
���̺��.�÷���%TYPE;
==> ���̺� ������ �ٲ� pl/sql ��Ͽ� ����� ������ Ÿ���� �������� �ʾƵ� �ڵ����� ����ȴ�.
 
DECLARE
    v_deptno DEPT.DEPTNO%TYPE;
    v_dname DEPT.DNAME%TYPE;
BEGIN
    SELECT deptno, dname INTO v_deptno, v_dname
    FROM dept
    WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE(v_deptno ||'     '|| v_dname);
END;
/
 
�Լ��� ����ϴ� ��� : ȸ�縸�� Ư���� ������ �ʿ��� ���, ...

PROCEDURE : �̸��� �ִ� PL/SQL ���, ���ϰ��� ����.
            ������ ���� ó�� �� �����͸� �ٸ� ���̺� �Է��ϴ� ���� ����Ͻ� ������ ó���� �� ���
            ����Ŭ ��ü ==> ����Ŭ ������ ������ �ȴ�.
            ������ �ִ� ������� ���ν��� �̸��� ���� ������ ����
            
CREATE OR REPLACE PROCEDURE printdept (p_deptno IN dept.deptno%TYPE) IS
--�����
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    
BEGIN
    SELECT deptno, dname INTO v_deptno, v_dname
    FROM dept
    WHERE deptno = p_deptno;
    
    DBMS_OUTPUT.PUT_LINE(v_deptno ||'         '|| v_dname);
END;
/

���ν��� ���� ��� : EXEC ���ν��� �̸�;

EXEC printdept;

���ڰ� �ִ� printdept ����
EXEC printdept(10);
EXEC printdept(20);
EXEC printdept(30);

PL/SQL ������ SELECT ������ ���� ���� �� �����Ͱ� �Ѱǵ� �ȳ��� ��� NO_DATA_FOUND ���ܸ� ������.
EXEC printdept(50);

pro_1]
CREATE OR REPLACE PROCEDURE printemp (p_empno IN emp.empno%TYPE) IS
    v_ename  emp.ename%TYPE;
    v_dname  dept.dname%TYPE;
BEGIN 
    SELECT ename, dname INTO v_ename, v_dname
    FROM emp, dept
    WHERE emp.deptno = dept.deptno AND empno = p_empno;
    
    DBMS_OUTPUT.PUT_LINE(v_ename ||'         '|| v_dname);
END;
/

EXEC printemp(7369);--simth
EXEC printemp(7499);--allen
EXEC printemp(7839);--king

pro_2]
CREATE OR REPLACE PROCEDURE registdept_test (p_deptno IN dept.deptno%TYPE, p_dname IN dept.dname%TYPE, p_loc IN dept.loc%TYPE) IS
    
BEGIN
    INSERT INTO dept_test (deptno, dname, loc) VALUES (p_deptno, p_dname, p_loc);
END;
/

EXEC registdept_test(99,'ddit','daejeon');

SELECT *
FROM dept_test;

pro_3]
CREATE OR REPLACE PROCEDURE UPDATEdept_test (p_deptno IN dept.deptno%TYPE, p_dname IN dept.dname%TYPE, p_loc IN dept.loc%TYPE) IS
    
BEGIN
    UPDATE dept_test SET deptno = p_deptno, dname = p_dname,  loc = p_loc;
END;
/

EXEC UPDATEdept_test(99,'ddit_m','daejeon');

SELECT *
FROM dept_test;


���պ���
��ȸ����� �÷��� �ϳ��� ������ ��� �۾� ���ŷӴ�
==> ���� ������ ����Ͽ� �������� �ؼ�

0. %TYPE : �÷�
1. %ROWTYPE : Ư�� ���̺��� ���� ��� �÷��� ������ �� �ִ� ���� ���� Ÿ��
    (���� : %TYPE - Ư�� ���̺��� �÷� Ÿ���� ����)
2. PL/SQL RECORD : ���� ������ �� �ִ� Ÿ��, �÷��� �����ڰ� ���� ���
                    ���̺��� ��� �÷��� ����ϴ°� �ƴ϶� �÷��� �Ϻθ� ����ϰ� ���� ��
3. PL/SQL TABLE TYPE : �������� ��, �÷��� ������ �� �ִ� Ÿ��

%ROWTYPE
�͸������ dept ���̺��� 10�� �μ������� ��ȸ�Ͽ� %ROWTYPE���� ������ ������
������� �����ϰ� DBMS_OUTPUT.PUT_LINE�� �̿��Ͽ� ���


DECLARE
        v_dept_row dept%ROWTYPE;
BEGIN
        SELECT * INTO v_dept_row
        FROM dept
        WHERE deptno = 10;
        
        DBMS_OUTPUT.PUT_LINE(v_dept_row.deptno || '/' || v_dept_row.dname || '/' || v_dept_row.loc);
END;
/

%RECORD : ���� ������ �� �ִ� ����Ÿ��, �÷� ������ �����ڰ� ���� ������ �� �ִ�.
dept���̺��� deptno, dname �ΰ� �÷��� ������� �����ϰ� ���� ��

DECLARE
    /*deptno, dname �÷� �ΰ��� ���� ������ �� �ִ� TYPE�� ����*/
    TYPE dept_rec IS RECORD(
        deptno dept.deptno%TYPE,
        dname dept.dname%TYPE);
        
        /*���Ӱ� ���� Ÿ������ ������ ���� (class����� �ν��Ͻ� ����)*/
        v_dept_rec dept_rec;
BEGIN
    SELECT deptno, dname INTO v_dept_rec
    FROM dept
    WHERE deptno = 10;

    DBMS_OUTPUT.PUT_LINE(v_dept_rec.deptno || '     ' || v_dept_rec.dname);
END;
/

�������� ������ �� ��
SELECT ����� �������̱� ������ �ϳ��� �� ������ ���� �� �ִ� ROWTYPE ��������
���� ���� ���� ���� ���� �߻�
==> ���� ���� ������ �� �ִ� TABLE TYPE ���

DECLARE
        v_dept_row dept%ROWTYPE;
BEGIN
        SELECT * INTO v_dept_row
        FROM dept
        
        DBMS_OUTPUT.PUT_LINE(v_dept_row.deptno || '/' || v_dept_row.dname || '/' || v_dept_row.loc);
END;
/

TABLE TYPE : �������� ������ �� �ִ� Ÿ��
����
TYPE Ÿ�Ը� IS TABLE OF �� Ÿ�� INDEX BY �ε����� ���� Ÿ��;
dept ���̺��� �� ������ ������ �� �ִ� ���̺� TYPE
    java : ArrayList<Dept> dept_tab = new ArrayList<Dept>();
    
    java������ �ε����� ����(BINARY_INTEGER), 
    PL/SQL������ �ε����� ����(BINARY_INTEGER), ���ڿ�(VARCHAR(2))
    
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    
DECLARE
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    v_dept dept_tab;
BEGIN
    SELECT * BULK COLLECT INTO v_dept --���� ���� �Ѳ����� ������ �� ����ϴ� Ű���� :  BULK COLLECT INTO
    FROM dept;
END;
/






