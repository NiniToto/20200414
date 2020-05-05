OUTER JOIN
���̺� ���� ������ �����ص�, �������� ���� ���̺��� �÷��� ��ȸ�� �ǵ��� �ϴ� ���� ���
<==> INNER JOIN(�츮�� ���ݱ��� ��� ���)

LEFT OUTER JOIN     : ������ �Ǵ� ���̺��� JOIN Ű���� ���ʿ� ��ġ
RIGHT OUTER JOIN    : ������ �Ǵ� ���̺��� JOIN Ű���� �����ʿ� ��ġ
FULL OUTER JOIN     : LEFT OUTER JOIN + RIGHT OUTER JOIN ~ (�ߺ��Ǵ� �����Ͱ� �ѰǸ� ������ ó��)

emp���̺��� �÷� �� mgr �÷��� ���� �ش� ������ ������ ������ ã�ư� �� �ִ�.
������ KING ������ ��� ����ڰ� ���� ������ �Ϲ����� INNER JOIN ó�� �� ���ο� �����Ͽ� KING�� ������ 13���� �����͸� ��ȸ�� �ȴ�.

INNER JOIN ���� ==> ������ �����ؾ����� �����Ͱ� ��ȸ�ȴ�.
==> KING�� ����� ����(mgr)�� NULL�̱� ������ ���ο� �����ϰ� KING�� ������ ������ �ʴ´�. (13�Ǹ� ��ȸ)

����� ���, ����� �̸�, ���� ���, ���� �̸�
SELECT m.empno mgr_id, m.ename mgr_name, e.empno emp_id, e.ename emp_name
FROM emp e, emp m
WHERE e.mgr = m.empno;

SELECT m.empno mgr_id, m.ename mgr_name, e.empno emp_id, e.ename emp_name
FROM emp e JOIN emp m ON (e.mgr = m.empno);

���� ������ OUTER �������� ����
(KING ������ ���ο� �����ص� ���� ������ ���ؼ��� ��������, ������ ����� ������ ���� ������ ������ �ʴ´�.);

SELECT m.empno, m.ename, e.empno, e.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno);

SELECT m.empno, m.ename, e.empno, e.ename
FROM emp m RIGHT OUTER JOIN emp e ON (e.mgr = m.empno);
--�� ������ �����ϴ�. ������ �Ǵ� ���̺��� ���ʿ� �ִ��� �����ʿ� �ִ��� �����ϰ� ������ �Ǵ� ���̺��� ������ LEFT, RIGHT ���ָ� �ȴ�.

SELECT NVL(m.empno,0), NVL(m.ename,0), e.empno, e.ename -- NULL ó�� ����...
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno);

ORACLE-SQL : OUTER
oracle join
1. FROM ���� ������ ���̺� ���(�޸��� ����)
2. WHERE ���� ���� ������ ���
3. ���� �÷�(�����)�� ������ �����Ͽ� �����Ͱ� ���� ���� �÷��� (+)�� �ٿ� �ش�.
    ==> ������ ���̺� �ݴ��� �� ���̺��� �÷�
    
SELECT m.empno, m.ename, e.empno, e.ename
FROM emp e, emp m 
WHERE e.mgr = m.empno(+);

OUTER ������ ���� ��� ��ġ�� ���� ��� ��ȭ

������ ����� �̸�, ���̵� �����ؼ� ��ȸ
��, ������ �ҼӺμ��� 10���� ���ϴ� �����鸸 �����ؼ�;
������ ON���� ������� ��
SELECT m.empno, m.ename, e.empno, e.ename, e.deptno
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno AND e.deptno = 10);

������ WHERE���� ������� ��
SELECT m.empno, m.ename, e.empno, e.ename, e.deptno
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)
WHERE e.deptno = 10;

SELECT m.empno, m.ename, e.empno, e.ename, e.deptno
FROM emp e JOIN emp m ON (e.mgr = m.empno)
WHERE e.deptno = 10;

OUTER ������ �ϰ� ���� ���̶�� ������ ON���� ����ϴ°� �´�. 

SELECT m.empno, m.ename, e.empno, e.ename, e.deptno
FROM emp e, emp m 
WHERE e.mgr = m.empno(+) AND e.deptno = 10;

--�ǽ� outerjoin1
SELECT *
FROM buyprod
WHERE buy_date = TO_DATE('2005/01/25', 'YYYY/MM/DD');

--ORACLE
SELECT buy_date, buy_prod, prod.prod_id, prod_name, buy_qty
FROM prod, buyprod
WHERE prod.prod_id = buyprod.buy_prod(+) AND buy_date(+) = TO_DATE('2005/01/25', 'YYYY/MM/DD');

--ANSI-SQL
SELECT buy_date, buy_prod, prod.prod_id, prod_name, buy_qty
FROM prod LEFT OUTER JOIN buyprod ON( prod.prod_id = buyprod.buy_prod AND buy_date = TO_DATE('2005/01/25', 'YYYY/MM/DD') );

--outerjoin2
SELECT TO_DATE('2005/01/25', 'YYYY/MM/DD') buy_date, buy_prod, prod.prod_id, prod_name, buy_qty --��¥���� ���� ������ ���̴�.
FROM prod, buyprod
WHERE prod.prod_id = buyprod.buy_prod(+) AND buy_date(+) = TO_DATE('2005/01/25', 'YYYY/MM/DD');

--outerjoin3
SELECT TO_DATE('2005/01/25', 'YYYY/MM/DD') buy_date, buy_prod, prod.prod_id, prod_name, NVL(buy_qty, 0) buy_qty
FROM prod, buyprod
WHERE prod.prod_id = buyprod.buy_prod(+) AND buy_date(+) = TO_DATE('2005/01/25', 'YYYY/MM/DD');

--outerjoin4
SELECT NVL(cycle.pid, product.pid) pid, pnm, NVL(cid, 1) cid, NVL(day, 0) day, NVL(cnt,0) cnt
FROM cycle, product
WHERE cycle.pid(+) = product.pid AND cid(+) = 1;

SELECT NVL(cycle.pid, product.pid) pid, pnm, NVL(cid, 1) cid, NVL(day, 0) day, NVL(cnt,0) cnt
FROM cycle RIGHT OUTER JOIN product ON (cycle.pid = product.pid AND cid = 1);

--outerjoin5
SELECT c.pid, c.pnm, 1 cid, NVL(A.day, 0) day, NVL(A.cnt, 0) cnt
FROM product c,
    (SELECT a.cid, a.pid, a.day, a.cnt, b.cnm
     FROM cycle a, customer b
     WHERE a.cid(+) = b.cid AND a.cid =1) A
WHERE c.pid = A.pid(+);
     
SELECT A.* 
FROM 
    (SELECT *
    FROM cycle, product
    WHERE cycle.pid = product.pid) A;
    
    
SELECT pid, pnm, a.cid, cnm, day, cnt
FROM customer RIGHT OUTER JOIN
    (SELECT NVL(cycle.pid, product.pid) pid, pnm, NVL(cid, 1) cid, NVL(day, 0) day, NVL(cnt,0) cnt
     FROM cycle RIGHT OUTER JOIN product ON (cycle.pid = product.pid AND cid = 1)) a ON (customer.cid = a.cid)
ORDER BY pid DESC, day DESC;
     
CROSS JOIN
���� ������ ������� ���� ���
��� ������ ���� �������� ����� ��ȸ�ȴ�.

SELECT *
FROM product, cycle, customer
WHERE product.pid = cycle.pid; 

--ANSI-SQL
SELECT *
FROM emp CROSS JOIN dept; --emp 14��, dept 4�� = 56���� ������ �� �ִ�.

--ORACLE : ���� ���̺� ����ϰ� WHERE ���� ������ ������� �ʴ´�.
SELECT *
FROM emp, dept; 

--crossjoin1
SELECT *
FROM customer, product;

SELECT *
FROM customer CROSS JOIN product;

��������
WHERE : ������ �����ϴ� �ظ� ��ȸ�ǵ��� ����

SELECT *
FROM emp
WHERE 1 = 1

���� <==> ����
���������� �ٸ� ���� �ȿ��� �ۼ��� ����
�������� ������ ��ġ
1. SELECT
    SCALAR SUB QUERY
    . �������� : ��Į�� ���������� ��ȸ�Ǵ� ���� 1���̰�, �÷��� �Ѱ��� �÷��̾�� �Ѵ�. ex) DUAL���̺�
    
2. FROM
    INLINE-VIEW
    . SELECT ������ ��ȣ�� ���� ��
    
3. WHERE
    SUB QUERY
    . WHERE ���� ���Ǵ� ����
    
SMITH�� ���� �μ��� �������� ���� ������?

1. SMITH�� ���� �μ��� �������?
2. 1������ �˾Ƴ� �μ���ȣ�� ���ϴ� ������ ��ȸ

==> �������� 2���� ������ ���� ����
    �ι�° ������ ù��° ������ ����� ���� ���� �ٸ��� �����;� �Ѵ�.
    (SMITH(20) => WARD(30) => �ι�° ���� �ۼ� �� 10������ 30������ ������ ����
     => �������� ���鿡�� ���ո�)

ù��° ����;
SELECT deptno
FROM emp
WHERE ename = 'SMITH';

�ι�° ����;
SELECT *
FROM emp
WHERE deptno = 20;

���������� ���� ���� ����
SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                  FROM emp
                 WHERE ename = :ename);
                 
--sub1
SELECT COUNT(*)
FROM emp
WHERE sal > (SELECT AVG(sal)
               FROM emp);

SELECT AVG(sal)
FROM emp;

--sub2
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
               FROM emp);
               
































