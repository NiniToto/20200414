ROLLUP : ����׷� ���� - ����� �÷��� �����ʿ������� ���������� GROUP BY�� ����

�Ʒ� ������ ����׷�
1. GROUP BY job, deptno
2. GROUP BY job,
3. GROUP BY ==> ��ü

ROLLUP��� �� �����Ǵ� ����׷��� ���� : ROLLUP�� ����� �÷� �� + 1;

GROUP_AD2
SELECT CASE
    WHEN GROUPING(job) = 1 THEN '�Ѱ�' 
    WHEN GROUPING(job) = 0 THEN job
    END job, deptno, SUM(sal)
FROM emp
GROUP BY ROLLUP (job, deptno);

GROUP_AD2_1]
SELECT CASE
        WHEN GROUPING(job) = 1 THEN '��' 
        WHEN GROUPING(job) = 0 THEN job
    END job,
    CASE
        WHEN GROUPING(deptno) = 1 AND GROUPING(job) = 0 THEN '�Ұ�'
        WHEN GROUPING(deptno) = 1 AND GROUPING(job) = 1 THEN '��'
        ELSE TO_CHAR(deptno)
    END deptno, SUM(sal) --CASE�� �� �� WHEN������ ��ȯ�ϴ� THEN�� ���ϰ����� Ÿ���� ��� �����ؾ� �Ѵ�.
FROM emp
GROUP BY ROLLUP (job, deptno);
--decode�ε� �غ���.

GROUP_AD3]
SELECT deptno, job, SUM(sal) sal
FROM emp
GROUP BY ROLLUP (deptno, job);

GROUP_AD4]
SELECT dept.dname, job, sal
FROM
    (SELECT deptno, job, SUM(sal) sal
    FROM emp
    GROUP BY ROLLUP (deptno, job)) a, dept
WHERE a.deptno = dept.deptno(+);

GROUP_AD5]
SELECT NVL(dept.dname, '����'), job, sal
FROM
    (SELECT deptno, job, SUM(sal) sal
    FROM emp
    GROUP BY ROLLUP (deptno, job)) a, dept
WHERE a.deptno = dept.deptno(+);


2.GROUPING SETS
ROLLUP�� ���� : ���ɾ��� ����׷쵵 �����ؾ� �Ѵ�.
               ROLLUP���� ����� �÷��� �����ʿ��� ���������� ������
               ���� �߰������� �ִ� ����׷��� ���ʿ��� ��� ����

GROUPING SETS : �����ڰ� ���� ������ ����׷��� ���
              . ROLLUP ���� �ٸ��� ���⼺�� ����.
              
���� : GROUP BY GROUPING SETS (col1,col2,...)

GROUP BY col1
UNION ALL
GROUP BY col2

SELECT job, deptno, SUM(sal)
FROM emp
GROUP BY GROUPING SETS(job, deptno);

�׷������
1. job, deptno
2. mgr

SELECT job, deptno, mgr, SUM(sal)
FROM emp
GROUP BY GROUPING SETS ((job, deptno), mgr);

3. CUBE
���� : GROUP BY CUBE (col1, ...)
����� �÷��� ������ ��� ���� (������ ��Ų��.)

GROUP BY CUBE (job, deptno);
1.job   deptno
2.      deptno
3.job
4.

SELECT job, deptno, SUM(sal)
FROM emp
GROUP BY CUBE (job, deptno);

SELECT job, deptno, mgr, SUM(sal)
FROM emp
GROUP BY job, ROLLUP(deptno), CUBE(mgr);

**�߻� ������ ������ ���
1.job   deptno  mgr     
2.job   deptno          
3.job           mgr     
4.job                   

SELECT job, deptno, mgr, SUM(sal+NVL(comm,0))sal
FROM emp
GROUP BY job, ROLLUP(job,deptno), CUBE(mgr);

1. job  (job deptno)  mgr ==> job deptno mgr
2. job  (job deptno)      ==> job deptno
3. job  (job       )  mgr ==> job mgr
4. job  (job       )      ==> job       
5. job  (          )  mgr ==> job mgr
6. job  (          )      ==> job

�� 4����

��ȣ���� �������� ������Ʈ
1. emp���̺��� �̿��Ͽ� emp_test ���̺� ����
    ==> ������ ������ emp_test���̺� ���� ���� ����
    DROP TABLE emp_test;
2. emp_test ���̺� dname�÷� �߰�(dept ���̺� ����)
CREATE TABLE emp_test AS
SELECT *
FROM emp;

ALTER TABLE emp_test ADD (dname VARCHAR2(14));

SELECT *
FROM emp_test;

DESC emp_test;
3. subquery�� �̿��Ͽ� emp_test ���̺� �߰��� dname�÷��� ������Ʈ ���ִ� �����ۼ�
emp_test�� dname �÷��� ���� dept ���̺��� dname �÷����� update
emp_test���̺��� deptno���� Ȯ���ؼ� dept���̺��� deptno���̶� ��ġ�ϴ� dname �÷����� �����ͼ� update
SELECT *
FROM emp_test;

SELECT *
FROM dept;

UPDATE emp_test SET dname = (SELECT dname
                               FROM dept
                              WHERE emp_test.deptno = dept.deptno );
emp_test���̺��� dname�÷��� dept ���̺� �̿��ؼ� dname�� ��ȸ�Ͽ� ������Ʈ
UPDATE ����� �Ǵ� �� : 14 ==> WHERE ���� ���� ������� �ʾұ� �����̴�.
��� ������ ������� dname�÷��� dept ���̺��� ��ȸ�Ͽ� ������Ʈ;

SELECT *
FROM dept_test;

DROP TABLE dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept;

ALTER TABLE dept_test ADD (empcnt NUMBER);

sub_a1]
UPDATE dept_test SET empcnt = (SELECT COUNT (*)
                                 FROM emp
                                WHERE emp.deptno = dept_test.deptno
                                GROUP BY deptno);

UPDATE dept_test SET empcnt = (SELECT COUNT (*)
                                 FROM emp
                                WHERE emp.deptno = dept_test.deptno);

SELECT ��� ��ü�� ������� �׷� �Լ��� ������ ���
���Ǵ� ���� ������ 0���� ����
SELECT COUNT(*)
FROM emp
WHERE 1 = 2;

GROUP BY ���� ����� ��� ����� �Ǵ� ���� ���� ��� ��ȸ�Ǵ� ���� ����.
SELECT COUNT(*)
FROM emp
WHERE 1 = 2
GROUP BY deptno;
