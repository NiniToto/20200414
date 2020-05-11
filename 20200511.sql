�θ�-�ڽ� ���� ���̺�

    1. ���̺� ���� �� ����
      1] �θ�(dept)
      2] �ڽ�(emp)
      
    2. ������ ���� �� (INSERT) ����
      1] �θ�(dept)
      2] �ڽ�(emp)
      
    3. ������ ���� �� (DELETE) ����
      1] �ڽ�(emp)
      2] �θ�(dept)

���̺� ���� ��(���̺��� �̹� �����Ǿ� �ִ� ���) �������� �߰� ����
DROP TABLE emp_test;

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2)
);

���̺� ���� �� ���������� Ư���� �������� ����

���̺� ������ ���� PRIMARY KEY �߰�
���� : ALTER TABLE ���̺�� ADD CONSTRAINT �������Ǹ� ��������Ÿ�� (������ �÷�[, ...]);
�������� Ÿ�� : UNIQUE, PRIMARY KEY, FOREIGN KEY, CHECK (+ NOT NULL)
ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test PRIMARY KEY (empno);

DESC emp_test;

���̺� ���� �� �������� ����
���� : ALTER TABLE ���̺�� DROP CONSTRAINT �������Ǹ�;
ALTER TABLE emp_test DROP CONSTRAINT pk_emp_test;

���̺� ���� ���� FOREIGN KEY(�ܷ�Ű) �߰� �ǽ�
emp_test.deptno => dept_test.deptno;
�����Ǵ� �ʿ� INDEX�� �� �־�� �Ѵ�.
dept_test���̺��� deptno�� �ε��� ���� �Ǿ��ִ��� Ȯ��
ALTER TABLE ���̺�� ADD CONSTRAINT �������Ǹ� ��������Ÿ�� (�÷�) REFERENCES �������̺�� (�������̺��÷���)

ALTER TABLE emp_test ADD CONSTRAINT fk_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test (deptno);
                            
������ ����
ALTER TABLE emp_test DROP CONSTRAINT fk_emp_test_dept_test;

�������� Ȱ��ȭ/��Ȱ��ȭ
���̺� ������ ���������� �����ϴ� ���� �ƴ϶� ��� ����� ����, �Ѵ� ����
���� : ALTER TABLE ���̺�� ENABLE/DISABLE CONSTRAINT �������Ǹ�;

������ ������ fk_emp_test_dept_test FOREIGN KEY ���������� ��Ȱ��ȭ
ALTER TABLE emp_test DISABLE CONSTRAINT fk_emp_test_dept_test;

dept(�θ�)���̺��� 99�� �μ��� �����ϴ� ��Ȳ
SELECT *
FROM dept_test;

fk_emp_test_dept_test ���������� ��Ȱ��ȭ
SELECT *
FROM emp_test;

emp_test���̺��� 99�� �μ� �̿��� ���� �Է� ������ ��Ȳ
INSERT INTO emp_test VALUES (9999, 'brown', 88);

���� ��Ȳ : emp_test ���̺� dept_test ���̺� �������� �ʴ� 88�� �μ��� ����ϰ� �ִ� ��Ȳ ==> �������� ���Ἲ�� ���� ����
            fk_emp_test_dept_test ���������� ��Ȱ��ȭ�� ����
ALTER TABLE emp_test ENABLE CONSTRAINT fk_emp_test_dept_test; --������ ���Ἲ�� ��ų �� �����Ƿ� Ȱ��ȭ�� �� ����.

emp, dept ���̺��� ���� PRIMARY KEY, FOREIGN KEY ������ �ɷ� ���� ���� ��Ȳ
emp���̺��� empno�� key��
dept���̺��� deptno�� key�� �ϴ� PRIMARY KEY ������ �߰��ϰ�
emp.deptno ==> dept.deptno�� �����ϵ��� FOREIGN KEY�� �߰�

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
ALTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY (deptno);

ALTER TABLE emp ADD CONSTRAINT fk_emp_dept FOREIGN KEY (deptno) REFERENCES dept (deptno);

DESC emp;
DESC dept;

�������� Ȯ��
1. ������ �������ִ� �޴�(���̺� ���� => �������� tab)
2. USER_CONSTRAINTS
   (SELECT *
    FROM USER_CONSTRAINTS);
2.1 USER_CONS_COLUMNS
    (SELECT *
    FROM USER_CONS_COLUMNS);

�÷�Ȯ��
1.��
2.SELECT *
3.DESC
4.DATA DICTIONARY, ����Ŭ���� ���������� �����ϴ� view
  (SELECT *
  FROM USER_TAB_COLUMNS
  WHERE TABLE_NAME = 'EMP');

SELECT 'SELECT * FROM ' || TABLE_NAME || ';'
FROM USER_TABLES;

���̺�, �÷� �ּ� : USER_TAB_COMMENTS, USER_COL_COMMENTS;
SELECT *
FROM user_tab_comments;

���̺��� ������ ���� ��� : 
���̺� ��� => ī���ڸ� + �Ϸù�ȣ

���̺��� �ּ� �����ϱ�
���� : COMMENT ON TABLE ���̺�� IS '�ּ�';
COMMENT ON TABLE emp IS '����';

�÷��ּ� Ȯ��
SELECT *
FROM user_col_comments
WHERE TABLE_NAME = 'EMP';

�÷� �ּ� ����
COMMENT ON COLUMN ���̺��.�÷��� IS '�ּ�';

COMMENT ON COLUMN emp.empno IS '���';
COMMENT ON COLUMN emp.ename IS '�̸�';
COMMENT ON COLUMN emp.hiredate IS '�Ի�����';

comment1]
SELECT *
FROM user_tab_comments;

SELECT *
FROM user_col_comments;

SELECT t.table_name, t.table_type, t.comments tab_comment, c.column_name, c.comments col_comment
FROM user_tab_comments t, user_col_comments c
WHERE t.table_name = c.table_name 
  AND (t.table_name = 'CUSTOMER' OR t.table_name = 'PRODUCT' OR t.table_name = 'CYCLE' OR t.table_name = 'DAILY');

SELECT t.table_name, t.table_type, t.comments tab_comment, c.column_name, c.comments col_comment
FROM user_tab_comments t, user_col_comments c
WHERE t.table_name = c.table_name 
  AND t.table_name IN('CUSTOMER', 'PRODUCT', 'CYCLE', 'DAILY'); -- IN�����ڸ� �������!


VIEW : ����
������ ������ ���� =  SQL      (�������� ������ ������ �ƴϴ�.)
���� : CREATE [OR REPLACE] VIEW ���̸� [�÷���Ī1, �÷���Ī2 ,...] AS
        SELECT ����;
(VIEW�� �����ϱ� ���ؼ��� CREATE VIEW ������ ���� �־�� �Ѵ�.(DBA����)
-SYSTEM ������ ���ؼ� GRANT CREATE VIEW TO ����(����������� �ο���)

emp���̺��� sal, comm�÷��� ������ 6���� �÷��� ��ȸ�� ������ v_emp view�� ����
SELECT *
FROM emp;

CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

SELECT *
FROM v_emp;

v_emp VIEW�� ��ȸ�� �� �ֵ��� ���� �ο�
1. ���� �ο� �� hr�������� v_emp VIEW ��ȸ
SELECT *
FROM WONWOO.v_emp; --���� �̸��� �ƴ϶� ����� �̸����� �ؾ��Ѵ�.

2.hr�������� ���� �ο�
GRANT SELECT ON v_emp TO HR;

3.hr�������� v_emp �ٽ� ��ȸ
SELECT *
FROM WONWOO.v_emp;

VIEW ��� �뵵
  . ������ ����(���ʿ��� �÷� ������ ����)
  . ���� ����ϴ� ������ ������ ����
    . INLINE-VIEW�� ����ص� ������ ����� ���� �� ������ MAIN������ ������� ������ �ִ�.
    
�ǽ�
v_emp_dept �並 ����
emp, dept ���̺��� deptno�÷����� �����ϰ�
emp.empno, ename, dept.deptno, dname 4���� �÷����� ����

CREATE OR REPLACE VIEW v_emp_dept AS
SELECT emp.empno, ename, dept.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT *
FROM v_emp_dept;

VIEW ����
���� : DROP VIEW ���̸�;

VIEW�� ���� DML ó��
SIMPLE VIEW�� ���� ����
SIMPLE VIEW : ���ε��� �ʰ�, �Լ�, GROUP BY, ROWNUM�� ������� ���� ������ ������ VIEW
COMPLEX VIEW : �� ��

v_emp : SIMPLE VIEW

SELECT *
FROM v_emp;

v_emp�� ���� 7369 SMITH ����� �̸��� brown���� ����
UPDATE v_emp SET ename = 'brown'
WHERE empno = 7369;

v_emp���� sal �÷��� �����Ƿ� ������ �� ����.
UPDATE v_emp SET sal = 1000
WHERE empno = 7369;

ROLLBACK;

SELECT *
FROM emp;


SEQUENCE
������ �������� �������ִ� ����Ŭ ��ü
���� �ĺ��� ���� ������ �� �ַ� ���

�ĺ��� ==> �ش� ���� �����ϰ� ������ �� �ִ� ��
���� <==> ���� �ĺ���

�Ϲ������� � ���̺�(����Ƽ)�� �ĺ��ڸ� ���ϴ� �����
[����], [����], [������]

�Խ����� �Խñ� : �Խñ� �ۼ��ڰ�, ����, � ����, �ۼ� �ߴ���
�Խñ��� �ĺ��� : �ۼ���id, �ۼ�����, ������
    ==> ���� �ĺ��ڰ� �ʹ� �����ϱ� ������ ������ ���̼��� ����
        ���� �ĺ��ڸ� ��ü�� �� �ִ� (�ߺ����� �ʴ�) ���� �ĺ��ڸ� �̿�


������ �ϴٺ��� ������ ���� �����ؾ��� ���� �ִ�.
ex : ���, �й�, �Խñ� ��ȣ, ...
     ���, �й� : ü��
     �Խñ� ��ȣ : ü�谡 ������ ��ġ�� �ʴ� ����
     
ü�谡 �ִ� ���� �ڵ�ȭ���� ���ٴ� ����� ���� Ÿ�� ��찡 ����
ü�谡 ���� ���� �ڵ�ȭ�� ���� ==> SEQUENCE ��ü�� Ȱ���Ͽ� �ս��� ���� ����
                                ==> �ߺ����� �ʴ� ���� ���� ��ȯ
                                
�ߺ����� �ʴ� ���� �����ϴ� ���
1. KEY TABLE�� ����
    ==> SELECT FOR UPDATE ���ü��� ������ �� �ִ�.
    ==> ���� �� ���� ���� ����̴�.
    ==> ������ ���� �̻ڰ� �����ϴ°� �����ϴ�.(SEQUENCE ������ �Ұ����ϴ�)

2. JAVA�� UUID Ŭ������ Ȱ��, ������ ���̺귯�� Ȱ��(����) ==> ������, ����, ī���...���� ������ ����Ѵ�.

3. ORCLE DB - SEQUENCE

SEQUENCE ����
���� : CREATE SEQUENCE ��������;

seq_emp ������ ����
CREATE SEQUENCE seq_emp;

���� : ��ü���� �������ִ� �Լ��� ���ؼ� ���� �޾ƿ´�.
NEXTVAL : �������� ���� ���ο� ���� �޾ƿ´�.
CURRVAL : ������ ��ü�� NEXTVAL�� ���� ���� ���� �ٽ��ѹ� Ȯ���� �� ���
            (Ʈ����ǿ��� NEXTVAL �����ϰ� ���� ����� ����);
            
SELECT seq_emp.NEXTVAL            
FROM dual;

NEXTVAL�� �����ϸ� ���������� �����ϹǷ� CURRVAL�� ���ؼ� ���� ������ �о�� ���� �״�� ��� �����ϴ�.
SELECT seq_emp.CURRVAL            
FROM dual;

SELECT *
FROM emp_test;

SEQUENCE �� ���� �ߺ����� �ʴ� empno �� �����Ͽ� INSERT�ϱ�
INSERT INTO emp_test VALUES (seq_emp.NEXTVAL, 'sally', 88);




