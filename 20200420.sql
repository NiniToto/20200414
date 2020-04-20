/*
���̺��� ����,��ȸ ������ ����.
==> ORDER BY �÷��� ���Ĺ��, ...
*/

����*
ORDER BY �÷����� ��ȣ
==> SELECT�� 3��° �÷��� �������� ����
����) SELECT �÷��� ������ �ٲ�ų�, �÷��� �߰��� �Ǹ� ���� �ǵ���� �������� ���� ���ɼ��� ����

SELECT *
FROM emp
ORDER BY 3;

��Ī���� ������ �����ϴ�
�÷����ٰ� ������ ���� ���ο� �÷��� ����� ���
SAL*DEPTNO SAL_DEPT

SELECT empno, ename, sal, deptno, sal*deptno sal_dept
FROM emp
ORDER BY sal_dept;

--orderby1
SELECT *
FROM dept
ORDER BY dname;

SELECT *
FROM dept
ORDER BY loc DESC;

--orderby2
SELECT *
FROM emp
WHERE comm IS NOT NULL AND comm != 0 
ORDER BY comm DESC, empno ASC;
--null���� ������ �׻� null�̹Ƿ� WHERE comm != 0���θ� �����ص� �˸´� ���� ���´�.

--orderby3
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;

--orderby4
SELECT *
FROM emp
WHERE (deptno = 10 OR deptno = 30) AND sal > 1500 
ORDER BY ename DESC;

SELECT *
FROM emp
WHERE deptno IN ( 10, 30 ) AND sal > 1500 
ORDER BY ename DESC;

/*
����¡ ó���� �ϴ� ����
1. �����Ͱ� �ʹ� ���Ƽ�
    . �� ȭ�鿡 ������ ��뼺�� ��������.
    . ���ɸ鿡�� ��������.

����Ŭ���� ����¡ ó�� ��� ==> ROWNUM
*/

ROWNUM : SELECT ������� 1������ ���ʴ�� ��ȣ�� �ο����ִ� Ư�� KEYWORD

SELECT ROWNUM, empno, ename
FROM emp;

SELCET ���� *ǥ���ϰ� �޹ٸ� ���� �ٸ� ǥ��(ex ROWNUM)�� ����� ���
*�տ� � ���̺� ���Ѱ��� ���̺� ��Ī, ��Ī�� ����ؾ� �Ѵ�.

SELECT ROWNUM, e.*
FROM emp e;

����¡ ó���� ���� �ʿ��� ���� : 
1. ������ ������(10)
2. ������ ���� ����

1page : 1 ~ 10
2page : 11 ~ 20 (11 ~ 14)

-- 1������ ����¡ ����
SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 10;

-- 2������ ����¡ ����
SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 11 AND 20;

ROWNUM�� Ư¡
1. ORACLE���� ����
    . �ٸ� DBMS�� ��� ����¡ ó���� ���� ������ Ű���尡 ���� (ex. LIMIT)
2. 1������ ���������� �д� ��츸 ����
    ROWNUM BETWEEN 1 AND 10 ==> 1 ~ 10
    ROWNUM BETWEEN 11 AND 20 ==> 1 ~ 10�� SKIP �ϰ� 11~ 20�� �������� �õ� --> X
    
    WHERE ������ ROWNUM�� ����� ��� ���� ����
    ROWNUM = 1;
    ROWNUM BETWEEN 1 AND N;
    ROWNUM <, <= N; ( 1~ N )

SELECT ROWNUM, empno, ename
FROM emp
ORDER BY empno;

SELECT ROWNUM, empno, ename
FROM emp
ORDER BY ename;

ROWNUM�� ORDER BY ������ ����ȴ�.
SELECT -> ROWNUM -> ORDER BY

ROWNUM�� ��������� ���� ������ �� ���·� ROWNUM�� �ο��Ϸ��� IN-LINE VIEW �� ����ؾ��Ѵ�.
**IN-LINE : ���� ����� �ߴ�;

SELECT *
FROM
    (SELECT ROWNUM rn, a.*
    FROM
        (SELECT empno, ename
        FROM emp
        ORDER BY ename) a) a
WHERE rn BETWEEN 11 AND 20;

WHERE rn BETWEEN 1 AND 10; 1 PAGE;
WHERE rn BETWEEN 11 AND 20; 2 PAGE;
.
.
WHERE rn BETWEEN pageSize * (n-1) + 1 AND pageSize * n; n PAGE;

--sql������ ������ �����ϱ� ���� : �� ���
SELECT *
FROM
    (SELECT ROWNUM rn, a.*
    FROM
        (SELECT empno, ename
        FROM emp
        ORDER BY ename) a) a
WHERE rn BETWEEN :pageSize *(:page - 1 ) + 1 AND :page * :pageSize;

SELECT ROWNUM, a.*
FROM
    (SELECT empno, ename
    FROM emp
    ORDER BY ename) a;

IN-LINE VIEW�� �񱳸� ���� VIEW�� ���� ����(�����н�, ���߿� ���´�)
VIEW - ����

DML - Data Manipulation Language : SELECT, INSERT, UPDATE, DELETE
DDL - Data Definition Language : CREATE, DROP, MODIFY, RENAME

CREATE OR REPLACE VIEW emp_ord_by_ename AS
    SELECT empno, ename
    FROM emp
    ORDER BY ename;
    
IN-LINE VIEW�� �ۼ��� ����
SELECT *
FROM (SELECT empno, ename
        FROM emp
        ORDER BY ename);
        
VIEW�� �ۼ��� ����
SELECT *
FROM emp_ord_by_ename;

emp ���̺� �����͸� �߰��ϸ�
IN-LINE VIEW, VIEW�� ����� ������ ����� ��� ������ ������?

--view ���̺��� Ʋ�� ����, view�� sql�̱⋚���� ��ü�� ����.

���� �ۼ� �� ������ ã�ư���
JAVA : �����
SQL : ����� ���� ����.

����¡ ó�� == ����, ROWNUM
����, ROWNUM�� �ϳ��� �������� ������ ��� ROWNUM���� ������ �Ͽ� ���ڰ� ���̴� ���� �߻�
==>IN-LINE VIEW�� �ذ�
1. ���Ŀ� ���� IN-LINE VIEW
2. ROWNUM�� ���� IN-LINE VIEW

SELECT *
FROM
    (SELECT ROWNUM rn, a.*
    FROM
        (SELECT empno, ename
        FROM emp
        ORDER BY ename) a)
WHERE rn BETWEEN 11 AND 20;

--row3
SELECT *
FROM
    (SELECT ROWNUM rn, a.*
    FROM
        (SELECT empno, ename
        FROM emp
        ORDER BY ename)a)
WHERE rn BETWEEN 11 AND 14;

SELECT *
FROM
    (SELECT ROWNUM rn, a.*
    FROM
        (SELECT *
        FROM PROD
        ORDER BY PROD_LGU DESC, PROD_COST)a)
WHERE rn BETWEEN 1 + (:page - 1) * :pageSize AND :pageSize * :page;






