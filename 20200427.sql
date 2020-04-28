SELECT COUNT(*) cnt
FROM
    (SELECT deptno
     FROM emp
     GROUP BY deptno); --INLINE-VIEW�� ���ؼ� �ش� ����� ���̺�� �����.
     
DBMS : DataBase Management System
==> db
RDBMS : Relational DataBase Management System
==> ������ �����ͺ��̽� ���� �ý���

JOIN ������ ����
ANSI - ǥ��
�������� ����(ORACLE)

NATURAL JOIN : -- Ȱ�뵵�� ��������
    . �����Ϸ��� �� ���̺��� ����� �÷��� �̸��� ���� ���
    . emp, dept ���̺��� deptno��� �����(������ �̸�, Ÿ��) ����� �÷��� �����ϴ� ���
    . �ٸ� ANSI-SQL ������ ���ؼ� ��ü�� �����ϰ�, ���� ���̺���� �÷����� �������� ������ ����� �Ұ����ϱ� ������
      ���󵵴� �ټ� ����.
    
JOIN�� ��� �ٸ� ���̺��� �÷��� ����� �� �ֱ� ������
SELECT�� �� �ִ� �÷��� ������ ��������. ==> ���� Ȯ��         (cf. ���� Ȯ�� ==> ���� ����

�����Ϸ��� �ϴ� �÷��� ������ ������� ����
SELECT *
FROM emp NATURAL JOIN dept;
--�� ���̺��� �̸��� ������ �÷�(deptno)���� �����Ѵ�.

ORACLE�� ��� ���� ������ ANSI ����ó�� ����ȭ���� ����
����Ŭ ���� ����
    1. ������ ���̺� ����� FROM ���� ����ϸ� �����ڴ� �ݷ�(,)
    2. ����� ������ WHERE���� ����ϸ� �ȴ�. (ex :  WHERE emp.deptno = dept.deptno)
    
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

deptno�� 10���� �����鸸 ��ȸ
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno AND emp.deptno = 10; --���ÿ� �����ؾ��ϴ� �����̹Ƿ� AND�� �;��ϰ� Ȯ���ڸ� ���� emp.deptnoó�� ��������� ǥ������� �Ѵ�.

ANSI-SQL : JOIN with USING -- ���� ������� �ʴ´�.
    . join �Ϸ��� ���̺� �̸��� ���� �÷��� 2�� �̻��� ��
    . �����ڰ� �ϳ��� �÷����θ� �����ϰ� ���� �� ���� �÷����� ���
    
SELECT *
FROM emp JOIN dept USING (deptno);

ANSI-SQL : JOIN with ON -- ���� ����Ѵ�.
    . �����Ϸ��� �� ���̺� �÷����� �ٸ� ��
    . ON���� ����� ������ ���
    
SELECT *
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

--ORACLE�������� �ٽ� �ۼ��غ��� ==> ANSI-SQL���� ����� 3���� ������ ��� �ϳ��� ǥ�� ����.
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;


JOIN�� ������ ����
1. SELF JOIN : �����Ϸ��� ���̺��� ���� ���� ��
    ex)
    EMP ���̺��� �� ���� ������ ������ ��Ÿ���� ������ ���� �� mgr �÷��� �ش� ������ ������ ����� ǥ��
    �ش� ������ �������� �̸��� �˰���� ��

ANSI-SQL�� SQL ���� :
    . �����Ϸ��� �ϴ� ���̺� EMP(����), EMP(������ ������)
    . ����� �÷� : ����.mgr = ������.empno
    . ���� �÷� �̸��� �ٸ���(MGR, EMPNO)
    . NATURAL JOIN, JOIN with USING�� ����� �Ұ����� ����
    . JOIN with ON�� ���
    
SELECT *
FROM emp e JOIN emp m ON (e.mgr = m.empno); --���̺� alias�� �����ν� ���� ���̺� ������ ������ ��Ȯ�ϰ� �� �� �ִ�.

NONEQUI JOIN : ����� ������ = �� �ƴ� ��

�� ���� WHERE���� ����� ������ : =, !=, <>, <=, <, >, >=, AND, OR, NOT, LIKE(%,_), IN,BETWEEN AND

SELECT *
FROM emp;

SELECT *
FROM salgrade;

SELECT emp.empno, emp.ename, emp.sal, salgrade.grade
FROM emp JOIN salgrade ON (emp.sal BETWEEN salgrade.losal AND salgrade.hisal);

--ORACLE ���� �������� ����
SELECT emp.empno, emp.ename, emp.sal, salgrade.grade
FROM emp, salgrade
WHERE emp.sal BETWEEN salgrade.losal AND salgrade.hisal;

--join0
SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
ORDER BY deptno;

SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
ORDER BY deptno;

--join0_1
SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno AND dept.deptno IN (10,30);

SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno AND dept.deptno IN (10,30));

SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno AND dept.deptno IN (10,30))
WHERE empno BETWEEN 7500 AND 7700;

SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
WHERE dept.deptno IN (10,30); --ON�� �ȿ� �����ҷ��� �ϴ� ����� �־��ִ� ���� �����ϱ⿡ �� ����.


--join0_2
SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
WHERE sal >2500
ORDER BY deptno;

SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno AND sal > 2500
ORDER BY deptno;

--join0_3
SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno AND sal > 2500 AND empno > 7600
ORDER BY deptno;

SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
WHERE sal >2500 AND empno > 7600
ORDER BY deptno;

--join0_4
SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno AND sal > 2500 AND empno > 7600 AND dname = 'RESEARCH'
ORDER BY deptno;

SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
WHERE sal >2500 AND empno > 7600 AND emp.deptno = 20
ORDER BY deptno;

-- =�� ���� ���ڰ����� ������ ���� �������� �����غ���.

--join1
SELECT lprod.lprod_gu,lprod.lprod_nm, prod.prod_id, prod.prod_name -- �ϳ��� ���̺��� �����ϴ� �÷��� ���̺�.�÷� ������ ������� �ʾƵ� �ȴ�.
FROM prod, lprod  --lprod�� ���� ���̺��̹Ƿ� ���� ������ִ°� �������鿡�� ����.
WHERE prod.prod_lgu = lprod_gu;
--�⺻������ oracle���� 50���� �ุ�� ���� ������ִ� ����¡ó���� �Ǿ��ִ�.
SELECT lprod.lprod_gu,lprod.lprod_nm, prod.prod_id, prod.prod_name
FROM prod JOIN lprod ON(prod.prod_lgu = lprod_gu);























