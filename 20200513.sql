CREATE TABLE dept_test2 AS
SELECT *
FROM dept
WHERE 1 = 1;

SELECT *
FROM dept_test2;

idx1]
CREATE UNIQUE INDEX idx_u_dept_test2_01 ON dept_test2 (deptno);
CREATE INDEX idx_dept_test2_02 ON dept_test2 (dname);
CREATE INDEX idx_dept_test2_03 ON dept_test2 (deptno, dname);

idx3]
1. (empno) 
2. (ename) 
3. (deptno, empno)
4. (deptno sal) 
5. (empno, deptno)
6. (hiredate, deptno)

1. (empno) UI
2. (ename) NUI
3. (deptno) NUI
4. (deptno sal) NUI
5. (hiredate, deptno) NUI

CREATE UNIQUE INDEX idx_u_emp_01 ON emp (empno);
CREATE INDEX idx_emp_02 ON emp (ename);
CREATE INDEX idx_emp_03 ON emp (deptno); --> 04���� �ߺ��ǹǷ� ���� �ȴ�.
CREATE INDEX idx_emp_04 ON emp (deptno sal); --> deptno, sal, mgr
CREATE INDEX idx_emp_05 ON emp (hiredate, deptno); --> group by�� ���ǰ� where���� �����Ƿ� �÷� ������ �������. 
-->�ƿ� deptno sal mgr hiredate 4�� ��� ��ġ�� �͵� ���

-->�ε����� �����ؼ� �ϳ��� ����?�÷�?�� ���ؼ� �����ϴ��� �ε��� ���� ���̴� �͵� ����ؾ��Ѵ�.

EXPLAIN PLAN FOR
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.deptno = :deptno
AND emp.empno LIKE :empno || '%';

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 568005898
 
----------------------------------------------------------------------------------------
| Id  | Operation                    | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |         |     1 |    58 |     4   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                |         |     1 |    58 |     4   (0)| 00:00:01 |
|   2 |   TABLE ACCESS BY INDEX ROWID| DEPT    |     1 |    20 |     1   (0)| 00:00:01 |
|*  3 |    INDEX UNIQUE SCAN         | PK_DEPT |     1 |       |     0   (0)| 00:00:01 |
|*  4 |   TABLE ACCESS FULL          | EMP     |     1 |    38 |     3   (0)| 00:00:01 |
----------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - access("DEPT"."DEPTNO"=TO_NUMBER(:DEPTNO))
   4 - filter("EMP"."DEPTNO"=TO_NUMBER(:DEPTNO) AND TO_CHAR("EMP"."EMPNO") LIKE 
              :EMPNO||'%')



Plan hash value: 50904946
 
-------------------------------------------------------------------------------------------
| Id  | Operation                    | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
-------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |            |     1 |    58 |     2   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                |            |     1 |    58 |     2   (0)| 00:00:01 |
|   2 |   TABLE ACCESS BY INDEX ROWID| DEPT       |     1 |    20 |     1   (0)| 00:00:01 |
|*  3 |    INDEX UNIQUE SCAN         | PK_DEPT    |     1 |       |     0   (0)| 00:00:01 |
|*  4 |   TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    38 |     1   (0)| 00:00:01 |
|*  5 |    INDEX RANGE SCAN          | IDX_EMP_03 |     5 |       |     0   (0)| 00:00:01 |
-------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - access("DEPT"."DEPTNO"=TO_NUMBER(:DEPTNO))
   4 - filter(TO_CHAR("EMP"."EMPNO") LIKE :EMPNO||'%')
   5 - access("EMP"."DEPTNO"=TO_NUMBER(:DEPTNO))


�����ð��� ��� ����
==> ������ ���� ���¸� �̾߱��Ѵ�. ������� �̾߱Ⱑ �ƴϴ�.
inner join : ���ο� �����ϴ� �����͸� ��ȸ�ϴ� ���� ���
outer join : ���ο� �����ص� ������ �Ǵ� ���̺��� �÷� ������ ��ȸ�ϴ� ���� ���
cross join : ������ ����(īƼ�� ������Ʈ), ���� ������ ������� �ʾƼ� ���� ������ ��� ����� ���� ���εǴ� ���
self join : ���� ���̺��� �����ϴ� ����

�����ڰ� DBMS�� SQL�� ���� ��û�ϸ� DBMS�� SQL�� �м��ؼ� ��� �� ���̺��� ���������� �����Ѵ�.
�̶� ����ϴ� 3���� �������� ���� ����� �ִ�. (������� �̾߱��̴�.)
1. Nested Loop JOIN
2. Sort Merge JOIN
3. Hash JOIN

1. Nested Loop JOIN
 . ���� ������ ����
 . ���� �Ϲ����� ���� ���
 . �ҷ��� �����͸� ������ �� ���
 . ���� ���伺�� ����ȴ�. ==> ���ε� ����� �ǽð����� �����ֱ� ������...

2. Sort Merge JOIN
 . ���� �÷��� �ε����� ���� ���
 . �뷮�� �����͸� �����ϴ� ��쿡 ���
 . ���εǴ� ���̺��� ���� ���εǴ� �÷����� �����Ѵ�. ==> ���� ���ǿ� �ش��ϴ� �����͸� ã��� �����ϴ�.
 . ������ ������ ������ �����ϹǷ� ���伺�� ������.
 . ���� �������� �ʴ´�. ==> Hash JOIN���� ��ü
 . ��, ���� ������ = �� �ƴϾ ��� �����ϴ�.
 
3. Hash JOIN
 . ���� �÷��� �ε����� ���� ���
 . ���� ���̺��� �Ǽ��� ������ ���� ������ ���� ��� ==> Hash �� ���̺��� ���� ����°� �߿��ϱ� ������... ==> ���̺��� ���� ����� ������ ���ϴ°� �����ϱ� �����̴�.
 . ���� ������ = �� ��츸 ��� �����ϴ�.
 . HASH �Լ� : �Է°��� ����,Ÿ�԰� ������� Hash �Լ� ������ ġȯ���ִ� �Լ� (Hash �Լ� ������ ���̴� ����, ������ �Ұ����� Ư¡�� �ִ�.)
 . Hash �Լ� ���� ���� �����ͳ��� �����Ѵ�. ==> ���� �۾��� �ʿ� ����.
 . Nested Loop join�� ������ single I/O�� ���� �δ㵵 ����. ==> cpu�ڿ� �̿�

INDEX�� Ȱ������ ���ϴ� ���
1. �÷��� ���� (�º��� �������� ����� �ϸƻ���)
- �ε����� ������ �� �÷��� WHERE������ �����ϸ� �ٸ� ���� �ȴ�.
2. ������ ����
- != �� ���� ���´� �����͸� ã�Ⱑ �����.
3. NULL ��
- IS (NOT)NULL... INDEX���� NULL�� �����Ͱ� ���Ե��� �ʱ⶧����... ==> NOT NULL ������ �߿伺 ==> �����Ͱ� ������ ���ٰ� �ǴܵǸ� NOT NULL ���������� �ɾ��ִ°� ����Ŭ���� �����ϴ�.
4. LIKE ����� ���� ���ϵ� ī�� 
- '%T'�� ���� ���


SELECT *
FROM emp;
idx4]

CREATE UNIQUE INDEX idx_u_emp_01 ON emp (empno);
CREATE INDEX idx_dept_01 ON dept (deptno, loc);
CREATE INDEX idx_emp_02 ON emp (deptno, sal);


3. (emp) deptno, empno (dept) deptno
4. (emp) deptno, sal
5. (emp) deptno (dept) deptno, loc
