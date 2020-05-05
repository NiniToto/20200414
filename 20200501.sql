�Ѱ��� ��, �ϳ��� �÷��� �����ϴ� ��������
ex) ��ü ������ �޿� ���, SMITH ������ ���� �μ��� �μ���ȣ

WHERE���� ��밡���� ������
WHERE deptno = 10
==>
�μ���ȣ�� 10 Ȥ�� 30���� ���
WHERE deptno IN (10,30)
WHERE deptno = 10 OR  deptno = 30



MULTI ROW FUNCTION(������ ������)
�������� ��ȸ�ϴ� ���������� ���  = �����ڸ� ���Ұ�
WHERE deptno = (10,30) ==> ���Ұ�
WHERE deptno IN (�������� ���� �����ϰ�, �ϳ��� �÷����� �̷���� ����)

SMITH - 20, ALLEN�� 30�� �μ��� ����

SMITH �Ǵ� ALLEN�� ���ϴ� �μ��� ������ ������ ��ȸ

���� ��������, �ø��� �ϳ��� 
==> ������������ ��밡���� ������ IN(���� �����), (ANY, ALL)(��� �󵵰� ����)
IN : ���������� ��� �� �� ������ ���� ���� �� TRUE
    WHERE �÷�|ǥ���� IN (��������)
    
ANY : �����ڸ� �����ϴ� ���� �ϳ��� ���� �� TRUE
    WHERE �÷�|ǥ���� ������ ANY (��������)
    
ALL : ���������� ��� ���� �����ڸ� ������ �� TRUE
    WHERE �÷�|ǥ���� ������ ALL (��������)
    
SMITH�� ALLEN�� ���� �μ����� �ٹ��ϴ� ��� ������ ��ȸ    

1. ���������� ������� ���� �ܿ� : �ΰ��� ������ ����
1-1] SMITH, ALLEN�� ���� �μ��� �μ���ȣ�� Ȯ���ϴ� ����
SELECT deptno
FROM emp
WHERE ename IN ('SMITH', 'ALLEN'); --20,30

1-2] 1-1]���� ���� �μ���ȣ�� IN������ ���� �ش� �μ��� ���ϴ� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE deptno IN (20,30);

==> ���������� �̿��ϸ� �ϳ��� SQL���� ���� ����
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename IN ('SMITH', 'ALLEN'));
                 
--sub3
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename IN ('SMITH', 'WARD'));
                 
ANY, ALL
SMITH�� WARD �� ����� �޿��� �ƹ� ������ ���� �޿��� �޴� ���� ��ȸ (sal < 1250)
SELECT *
FROM emp
WHERE sal < ANY(SELECT sal
                FROM emp
                WHERE ename IN ('SMITH', 'WARD'));
                
SMITH�� WARD �� ����� �޿��� ��� ������ ���� �޿��� �޴� ���� ��ȸ (sal > 1250)
SELECT *
FROM emp
WHERE sal > ALL(SELECT sal
                FROM emp
                WHERE ename IN ('SMITH', 'WARD'));
                
IN �������� ����
WHERE deptno NOT IN (20, 30);

NOT IN �����ڸ� ����� ��� ���������� ���� NULL�� �ִ��� ���ΰ� �߿��ϴ�.
==���������� �������� ����

�Ʒ� ������ ��ȸ�ϴ� ����� � �ǹ��ΰ�? --> �������� �Ŵ����� �ƴ� ����� ��ȸ
SELECT *
FROM emp
WHERE empno NOT IN (SELECT mgr
                    FROM emp);
--> NULL�� �ֱ� ������ �����۵� ���� �ʴ´�.
--7902, 7698, 7839, 7566, 7788, 7566, 7782
--ford, blake, king, jones, scott, jones, clark
--�ذ� ���1
SELECT *
FROM emp
WHERE empno NOT IN (SELECT mgr
                    FROM emp
                    WHERE mgr IS NOT NULL);
--�ذ� ���2
SELECT *
FROM emp
WHERE empno NOT IN (SELECT NVL(mgr, ?) -->NULLó�� �Լ��� ���� �����Ϳ� ������ ����(������ ������ ���� �ʴ�)���� �־��� �� �ֵ��� ����غ��� �Ѵ�.
                    FROM emp);
                    
���� �÷��� �����ϴ� ���������� ���� ���� ==> ���� �÷��� �����ϴ� ��������
PAIRWISE ���� (������) ==> ���ÿ� ����

SELECT empno, mgr, deptno
FROM emp
WHERE empno IN (7499,7782);

7499, 7782 ����� ������ ���� �μ�, ���� �Ŵ����� ��� ���� ���� ��ȸ
�Ŵ����� 7698�̸鼭 �ҼӺμ��� 30�� ���
�Ŵ����� 7839�̸鼭 �ҼӺμ��� 10�� ���

==>mgr �÷��� deptno �÷��� �������� ����.

SELECT *
FROM emp
WHERE mgr IN (7698, 7839)
  AND deptno IN (10, 30); ==> 4������ ��찡 �߻�, ������ ���������� 2������ ��츸 ��ȸ�ϱ� ���Ѵ�.
  
  
PAIRWISE ���� (���� ������ ����� �ٸ���)
SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                          FROM emp
                          WHERE empno IN (7499,7782));

�������� ���� - ��� ��ġ
SELECT - SCALAR SUB QUERY
FROM - INLINE-VIEW
WHERE - SUB-QUERY

�������� ���� - ��ȯ�ϴ� ��, �÷��� ��(�ܿ� �ʿ�� ����.)
���� ��
    ���� �÷�(SCALAR SUB QUERY)
    ���� �÷�
���� ��
    ���� �÷�(���� ���� ����)
    ���� �÷�

SCALAR SUB QUERY
���� ��, ���� �÷��� �����ϴ� ���������� ��� ����
���� ������ �ϳ��� �÷�ó�� �ν�;
SELECT 'X', (SELECT SYSDATE FROM dual)
FROM dual;

SCALAR SUB QUERY�� �ϳ��� ��, �ϳ��� �÷��� ��ȯ�ؾ� �Ѵ�.
SELECT 'X', (SELECT empno, ename FROM emp WHERE ename = 'SMITH')
FROM dual;
--���� �ϳ����� �÷��� 2������ ������ �߻��Ѵ�.

������ �ϳ��� �÷��� �����ϴ� ��Į�� ��������
SELECT 'X', (SELECT empno FROM emp)
FROM dual;                    
--�÷��� �ϳ����� ���� �������� ������ �߻��Ѵ�.

emp���̺� ����� ��� �ش� ������ �Ҽ� �μ� �̸��� �� ���� ����. ==> JOIN
Ư�� �μ��� �μ� �̸��� ��ȸ�ϴ� ����
SELECT dname
FROM dept
WHERE deptno = 10;

--JOIN ����
SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;
--�� ������ ��Į�� ���������� ����
SELECT empno, ename, emp.deptno, (SELECT dname FROM dept WHERE deptno = emp.deptno) --'deptno = 10'�̶�� �ۼ��ϸ� ��� ������ dname�� ACCOUNTING���� ���´�. �ذ��ϱ� ���� emp.deptno�Է� 
FROM emp;

�������� ���� - ���������� �÷��� ������������ ����ϴ��� ���ο� ���� ����
��ȣ���� ��������(corelated sub query)
    . ���������� ����Ǿ�� ���������� ������ �����ϴ�.
    . 
���ȣ ���� ��������(non corelated sub query)
    . ���������� �ܵ������� ���� �����ϴ�.
    . ���������� ���̺��� ���� ��ȸ�� ����, ���������� ���̺��� ���� ��ȸ�� ���� �ִ�. ==> ����Ŭ�� �Ǵ� ���� �� ���ɻ� ������ �������� �����Ѵ�.
    
--����
��� ������ �޿� ��� ���� ���� �޿��� �޴� ���� ���� ��ȸ�ϴ� ������ �ۼ��ϼ���.(sub query �̿�)
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal) FROM emp);
�����غ� ����, ���� ������ ��ȣ ���� ���������ΰ�? ���ȣ ���� ���������ΰ�? ==> ���ȣ ���� ��������

������ ���� �μ��� �޿� ��պ��� ���� �޿��� �޴� ����
��ü ������ �޿� ��� ==> ������ ���� �μ��� �޿� ���

Ư�� �μ��� �޿� ����� ���ϴ� SQL
SELECT AVG(sal)
FROM emp
WHERE deptno = 10;
    
SELECT *
FROM emp a
WHERE sal > (SELECT AVG(sal) FROM emp WHERE deptno = a.deptno); ==> ��ȣ ���� ��������

SELECT *
FROM emp a
WHERE sal > (SELECT AVG(sal) FROM emp WHERE deptno = a.deptno);

SELECT *
FROM dept;
    
INSERT INTO dept VALUES(99, 'ddit', 'daejeon');

emp���̺� ��ϵ� �������� 10, 20, 30�� �μ����� �Ҽ��� �Ǿ�����
���� �Ҽӵ��� ���� �μ� : 40, 99
--sub4
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno FROM emp);

������ �Ѹ��̶� �����ϴ� �μ�
SELECT *
FROM dept
WHERE deptno IN (SELECT deptno FROM emp);

--sub5
SELECT pid, pnm
FROM product
WHERE pid NOT IN (SELECT pid FROM cycle WHERE cid = 1);

--sub6
SELECT *
FROM cycle
WHERE cid = 1 AND pid IN(SELECT pid FROM cycle WHERE cid = 2);

--sub7
SELECT a.cid, c.cnm, a.pid, a.pnm, a.day, a.cnt
FROM a, customer c
WHERE a.cid = 1 AND a.pid IN (SELECT product.pid
                              FROM cycle, product 
                              WHERE cycle.pid = product.pid AND cycle.cid = 2) a; --���������� �ִ� �����͸� ������������ ������ �ȵȴ�.
                              
��Į�� ���������� �̿��� ���
SELECT cnm FROM customer WHERE cid = 1;
SELECT pnm FROM product WHERE pid = 100;

SELECT cid, (SELECT cnm FROM customer WHERE cid = cycle.cid) cnm, pid, (SELECT pnm FROM product WHERE pid = cycle.pid) pnm, day, cnt
FROM cycle
WHERE cid = 1 AND pid IN(SELECT pid FROM cycle WHERE cid = 2);

������ �̿��� ��� -- �Ϲ������� �� ���� ���� �ۼ� ���(����Ƚ���� �� ���� Ȯ���� ����)
SELECT cycle.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM cycle, customer, product
WHERE cycle.cid = customer.cid AND cycle.pid = product.pid AND cycle.cid = 1 AND cycle.pid IN (SELECT pid FROM cycle WHERE cid =2);

