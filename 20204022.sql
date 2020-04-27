 --fn3
 SELECT '201912' PARAM,
        (LAST_DAY(TO_DATE('201912', 'yyyymm')) -
        LAST_DAY(ADD_MONTHS(TO_DATE('201912', 'yyyymm'), -1) + 1)) DT
 FROM dual;
 
  SELECT '201912' PARAM,
        TO_CHAR(LAST_DAY(TO_DATE('201912', 'yyyymm')), 'dd') dt 
 FROM dual;
 
 SELECT '201912' PARAM,
        TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'yyyymm')), 'dd') dt 
 FROM dual;
 
 EXPLAIN PLAN FOR
 SELECT *
 FROM emp
 WHERE empno = '7369';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

/*
EXPLAIN PLAN FOR;
TABLE(DBMS_XPLAN.DISPLAY);

���� ��ȹ�� ���� ���� (id)
* �鿩���� �Ǿ������� �ڽ� ���۷��̼�
1.�� -> �Ʒ�
  *��, �ڽ� ���۷��̼��� ������ �ڽĺ��� �д´�.

--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 | ���̺��� ��ü ���� �о���
--------------------------------------------------------------------------
 ���� ���� : 1 => 0
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7369) ����ȯ�� �˾Ƽ� ����

*/

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

/*
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter(TO_CHAR("EMPNO")='7369') -- ��� �࿡ ���� TO_CHAR �Լ��� ����Ǿ���. �߸��� �����
*/

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7300 + '69';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

/*
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7369) -- �ڵ������� 7369�� �˻�
*/

SELECT ename, sal, TO_CHAR(sal, 'L009,999.00')
FROM emp;


NULL�� ���õ� �Լ�
NVL
NVL2
NULLIF
COALESCE;

�� null ó���� �ؾ��ұ�?
NULL�� ���� �������� NULL�̴�.

���� �� emp ���̺� �����ϴ� sal, comm �ΰ��� �÷� ���� ���� ���� �˰� �;
������ ���� SQL�� �ۼ�.

SELECT empno, ename, sal, comm, sal + comm sal_plus_comm
FROM emp;

SELECT empno, ename, sal, comm, NVL(sal + comm, sal) sal_plus_comm
FROM emp;

SELECT empno, ename, sal, comm, sal + NVL(comm, 0) sal_plus_comm
FROM emp;


NVL(expr1, expr2)
expr1�� null�̸� expr2���� �����ϰ� expr1�� null�� �ƴϸ� expr1�� ����

REG_DT �÷��� NULL�� ��� ���� ��¥�� ���� ���� ������ ���ڷ� ǥ��
SELECT userid, usernm, reg_dt
FROM users;

SELECT userid, usernm, NVL(reg_dt, LAST_DAY(SYSDATE))
FROM users;
























