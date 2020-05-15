EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7369;

SELECT *
FROM TABLE(dbms_xplan.display);

ROWID : ���̺� ���� ����� �����ּ�
        (java - �ν��Ͻ� ����)
        (c - ������)
SELECT ROWID, emp.*
FROM emp;

����ڿ� ���� ROWID ���
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE ROWID = 'AAAE5xAAFAAAAETAAF'; --����ڰ� ROWID�� �˰� �ִ� ���� ���� ����.

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 1116584662
 
-----------------------------------------------------------------------------------
| Id  | Operation                  | Name | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------------
|   0 | SELECT STATEMENT           |      |     1 |    38 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY USER ROWID| EMP  |     1 |    38 |     1   (0)| 00:00:01 |
-----------------------------------------------------------------------------------

INDEX �ǽ�]
1. emp���̺� ���� ������ pk_emp PRIMARY KEY ���������� ����
ALTER TABLE emp DROP CONSTRAINT pk_emp;

�ε��� ���� empno���� �̿��Ͽ� ������ ��ȸ
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

2.  emp���̺� empno�÷����� PRIMARY KEY ���������� ����
    (empno�÷����� ������ INDEX�� ����)
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

3. 2�� SQL�� ���� (SELECT �÷��� ����)
EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

4. empno�÷��� non-unique �ε����� �����Ǿ� �ִ� ���
ALTER TABLE emp DROP CONSTRAINT pk_emp;

CREATE INDEX idx_emp_01 ON emp (empno); --nonunique �ε����� ������ ���̴�.

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

5. emp ���̺��� job ���� ��ġ�ϴ� �����͸� ã�� ���� ��
idx_emp_01 : empno

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);

idx_emp_01�� ��� ������ empno�÷� �������� �Ǿ� �ֱ� ������ job �÷��� �����ϴ� SQL������ ȿ�������� ����� ���� ���� ������
TABLE ��ü �����ϴ� �����ȹ�� ��������.

idx_emp_02 (job) ������ �� �� �����ȹ�� ��
CREATE INDEX idx_emp_02 ON emp (job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);

6. emp ���̺��� job = 'MANAGER' �̸鼭 ename �� C�� �����ϴ� ����� ��ȸ
�ε��� ��Ȳ : idx_emp_01 (empno), 
            idx_emp_02 (job)

EXPLAIN PLAN FOR            
SELECT *
FROM emp
WHERE job = 'MANAGER' AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

7. emp ���̺��� job = 'MANAGER' �̸鼭 ename �� C�� �����ϴ� ����� ��ȸ
���ο� �ε��� �߰� : idx_emp_03 (job, ename)
CREATE INDEX idx_emp_03 ON emp (job, ename);
�ε��� ��Ȳ : idx_emp_01 (empno), 
            idx_emp_02 (job),
            idx_emp_03 (job, ename)

EXPLAIN PLAN FOR            
SELECT /*+ INDEX( emp IDX_EMP_03) */* --��Ʈ �ּ� : idx_emp_03�� ���ؼ� �����϶�� �ּ�, +�� ���ؼ� Ȱ��ȭ?�� ��...
FROM emp
WHERE job = 'MANAGER' AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

8. emp ���̺��� job = 'MANAGER' �̸鼭 ename �� C�� ������ ����� ��ȸ
�ε��� ��Ȳ : idx_emp_01 (empno), 
            idx_emp_02 (job),
            idx_emp_03 (job, ename)

EXPLAIN PLAN FOR            
SELECT *
FROM emp
WHERE job = 'MANAGER' AND ename LIKE '%C';

SELECT *
FROM TABLE(dbms_xplan.display);

9. ���� �÷� �ε����� �÷� ������ �߿伺
�ε��� ���� �÷� : (job, ename) VS (ename, job)
*** �����ؾ� �ϴ� sql�� ���� �ε��� �÷� ������ �����ؾ� �Ѵ�.
���� sql : job = manager, ename�� C�� �����ϴ� ��� ������ ��ȸ
�ε��� �߰� : idx_emp_04 (ename, job)
CREATE INDEX idx_emp_04 ON emp (ename, job);
���� �ε��� ���� : idx_emp_03;
DROP INDEX idx_emp_03;

�ε��� ��Ȳ : idx_emp_01 (empno), 
            idx_emp_02 (job),
            idx_emp_04 (ename, job)

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

���ο����� �ε���
emp ���̺� empno �÷��� PRIMARY KEY�� �������� ����
pk_emp : empno ==> idx_emp_01 ���� (pk_emp�ε����� �ߺ�)
DROP INDEX idx_emp_01;
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);

�ε��� ��Ȳ : pk_emp (empno), 
            idx_emp_02 (job),
            idx_emp_04 (ename, job)

EXPLAIN PLAN FOR
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
    AND emp.empno = 7788;
--emp���̺� empno������ �����Ƿ� emp���̺��� ���� �д°� ����    

SELECT *
FROM TABLE(dbms_xplan.display);