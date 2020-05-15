�����ȹ : SQL�� ���������� � ������ ���ļ� �������� ������ �ۼ�
    -����ϴµ� ��� ���� ����� �ʿ�(�ð�)
    
2���� ���̺��� �����ϴ� SQL
2���� ���̺� ���� �ε����� 5���� �ִٸ�,
������ �����ȹ ���� �?? ���̺��� �þ ���� ���ϱ޼������� �þ��. 
������ ª�� �ð��ȿ� �س��� �Ѵ�.(������ ���� �ؾ��ϹǷ�)

���� ������ SQL�� ����� ��� ������ �ۼ��� �����ȹ�� ������ ���
���Ӱ� ������ �ʰ� ��Ȱ���� �Ѵ�.(���ҽ� ����)
-������ SQL : �ؽ�Ʈ�� �����ؾ� �Ѵ�. ==> SQL ������ ��ҹ���, ������� ��ġ�ϴ� SQL
SELECT * FROM emp;
Select * FROM emp;
�� �� ������ ���� �ٸ� SQL�� �ν��Ѵ�.

Ư�������� ������ ��ȸ�ϰ� ������ : ����� �̿��ؼ�
Select /* 202004_b */ *
FROM emp
WHERE empno = :empno;

SYNONYM : ��ü�� ��Ī�� �����ؼ� ��Ī�� ���� ���� ��ü�� ���
���� : CREATE SYNONYM �ó�Ը� FOR ��������Ʈ;

SQL CATEGORY
DML
DDL
DCL
TCL

DCL (Data Control Language)


Data Dictionary : �ý��� ������ �� �� �ִ� VIEW, ����Ŭ�� ��ü������ ����
category (���ξ�)
USER : �ش� ����ڰ� �����ϰ� �ִ� ��ü ���
ALL : �ش� ����� ���� + ��ȯ�� �ο����� ��ü ���
DBA : ��� ��ü ���
V$ : ����, �ý��� ����

SELECT 'SELECT * FROM' || table_name ||';'
FROM user_tables;

SELECT *
FROM ALL_TABLES;

SELECT *
FROM DBA_TABLES; --> sys�������� ����

SELECT *
FROM dictionary;




--SQL����
Multiple insert : �������� �����͸� ���ÿ� �Է��ϴ� insert�� Ȯ�屸��

1. unconditional insert : ������ ���� ���� ���̺� �Է��ϴ� ���
���� : 
    INSERT ALL
        INTO ���̺��
        [,INTO ���̺��, ...]
    VALUES (...) | SELECT QUERY;

SELECT *
FROM emp_test;

emp_test ���̺��� �̿��Ͽ� emp_test2���̺� ����
CREATE TABLE emp_test2 AS
SELECT *
FROM emp_test
WHERE 1 != 1;

SELECT *
FROM emp_test;
SELECT *
FROM emp_test2;

emp_test, emp_test2 ���̺� ���ÿ� �Է� -->�� ���̺��� ���°� �����ϴ�.
INSERT ALL
    INTO emp_test
    INTO emp_test2
SELECT 9998, 'brown', 88 FROM dual UNION ALL
SELECT 9997, 'cony', 88 FROM dual;

2. conditional insert : ���ǿ� ���� �Է��� ���̺��� ����

INSERT ALL 
    WHEN ���� ...THEN
        INTO �Է����̺�1 VALUES
    WHEN ���� ...THEN
        INTO �Է����̺�2 VALUES
    ELSE
        INTO �Է����̺�3 VALUES
        
SELECT ����� ���� ���� empno = 9998�̸� emp_test���� �����͸� �Է�
                      �׿ܿ��� emp_test2�� �����͸� �Է�
INSERT ALL
    WHEN empno = 9998 THEN
        INTO emp_test VALUES (empno, ename, deptno)
    ELSE
        INTO emp_test2 (empno, deptno) VALUES (empno, deptno)
SELECT 9998 empno, 'brown' ename, 88 deptno FROM dual UNION ALL
SELECT 9997, 'cony', 88 FROM dual;

ROLLBACK;

SELECT *
FROM emp_test;
SELECT *
FROM emp_test2;

conditional insert (all) ==> first : ������ �����ϴ� ù ��° WHEN ���� ����
INSERT FIRST
    WHEN empno <= 9998 THEN
        INTO emp_test VALUES (empno, ename, deptno)
    WHEN empno <= 9997 THEN
        INTO emp_test2 VALUES (empno, ename, deptno)
SELECT 9998 empno, 'brown' ename, 88 deptno FROM dual UNION ALL
SELECT 9997, 'cony', 88 FROM dual;

MERGE : �ϳ��� ������ ���� �ٸ� ���̺�� �����͸� �ű� �Է�, �Ǵ� ������Ʈ�ϴ� ����
���� :
MERGE INTO �������(emp_test)
USING (�ٸ� ���̺� | VIEW | subquery)
ON (�������� USING ���� ���� ���� ���)
WHEN NOT MATCHED THEN
    INSERT (col, ...) VALUES (value1, ...)
WHEN MATCHED THEN
    UPDATE SET col1=val1, col2=val2, ...

1. �ٸ� �����ͷ� ���� Ư�� ���̺�� �����͸� �����ϴ� ���

2. KEY�� ���� ��� INSERT
   KEY�� ���� �� UPDATE

1. emp���̺��� �����͸� emp_test ���̺�� ����
emp���̺� �����ϰ� emp_test���̺��� �������� �ʴ� ������ �ű��Է�
emp���̺� �����ϰ� emp_test���̺��� �����ϴ� ������ �̸� ����

INSERT INTO emp_test VALUES (7369, 'cony', 88);
SELECT *
FROM emp_test;

9998	brown	88
9997	cony	88
7369	cony	88
9999	brown	88

emp���̺��� 14�� �����͸� emp_test���̺� ������ empno�� �����ϴ��� �˻��ؼ�
������ empno�� ������ insert-empno, ename, ������ empno�� ������ update-ename;

MERGE INTO emp_test
USING emp
ON (emp_test.empno = emp.empno)
WHEN NOT MATCHED THEN
    INSERT (empno, ename) VALUES (emp.empno, emp.ename)
WHEN MATCHED THEN
    UPDATE SET ename = emp.ename; --empno�� ���������̱⋚���� update�� ����� �� �� ����.


9999�� ������� �ű��Է��ϰų�, ������Ʈ�� �ϰ� ���� ��  
(����ڰ� 9999��, james ����� ����ϰų�, ������Ʈ�ϰ� ���� ��)
���� ���� ���̺� ==> �ٸ� ���̺�� ����

�̹��� �ϴ� �ó����� : �����͸� ==> Ư�� ���̺�� ���� (9999, james)

MERGE������ ������� ������
1. ������ ���� ������ ���� SELECT ����
2. �����Ͱ� ������ UPDATE, ������ INSERT

MERGE INTO emp_test
USING dual --���� ���̺��� ���� ��� dual�� ���
   ON (emp_test.empno = 9999)
WHEN NOT MATCHED THEN
    INSERT (empno, ename) VALUES (9999, 'james')
WHEN MATCHED THEN
    UPDATE SET ename = 'james';
    
SELECT *
FROM emp_test;

MERGE INTO emp_test
USING (SELECT 9999 eno, 'james' enm
       FROM dual) a
   ON (emp_test.empno = a.eno)
WHEN NOT MATCHED THEN
    INSERT (empno, ename) VALUES (9999, 'james')
WHEN MATCHED THEN
    UPDATE SET ename = 'james';
    
group_ad1]
SELECT deptno, SUM(sal)
FROM emp
GROUP BY deptno

UNION ALL

SELECT null, SUM(sal)
FROM emp;

REPORT GROUP FUNCTION
������ emp���̺��� �̿��Ͽ� �μ���ȣ�� ������ �޿� �հ� ��ü ������ �޿� ���� ��ȸ�ϱ� ���ؼ�
GROUP BY�� ����ϴ� �ΰ��� SQL�� ������ �ϳ��� ��ġ��(UNION ALL) �۾��� �����ߴ�.

Ȯ��� GROUP BY 3����
1. GROUP BY ROLLUP
���� : GROUP BY ROLLUP (�÷�1, ...)
���� : ����׷��� ������ִ� �뵵
����׷� ���� ��� : ROLLUP ���� ����� �÷��� �����ʿ������� �ϳ��� �����ϸ鼭 ����׷��� ����
������ ����׷��� UNION�� ����� ��ȯ

SELECT job, deptno, SUM(sal) sal
FROM emp
GROUP BY ROLLUP (job, deptno)

����׷� :  1. GROUP BY job, deptno
              UNION
           2. GROUP BY job
              UNION
           3. ��ü�� GROUP BY
           
1������ �Ѿ�]            
SELECT deptno, SUM(sal)
FROM emp
GROUP BY ROLLUP (deptno);

����׷��� ���� : ROLLUP ���� ����� �÷� ���� + 1;
