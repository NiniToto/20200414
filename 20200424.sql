1. NULLó�� �ϴ� ���

DESC emp;

 -- INSERT INTO emp (empno, ename) VALUES(null, 'brown'); ���߿� ��� INSERT Ű����

SELECT NVL(empno,0), ename, NVL(sal,0), NVL(comm, 0) --NVL�Լ��� ���� ����߱⶧���� ���� ������ �ƴϴ�.
--empno�� ��쿡�� null���� ������ �ʴ� �÷��̱⶧���� NVL�� ���ؼ� null���� �������� �ʿ䰡 ����.
FROM emp;

2. CONDITION
CASE, DECODE

3. �����ȹ
    �����ȹ�̶�?
    �����ȹ�� �д� ������?
    
/*
emp ���̺� ��ϵ� �����鿡�� ���ʽ��� �߰������� ������ ����
�ش� ������ job�� SALESMAN�� ��� SAL 5% �λ�� �ݾ��� ���ʽ��� ����
�ش� ������ job�� MANAGER�̸鼭 deptno�� 10���̸� SAL 30% �λ�, �׷��� ������ 10%�λ�� �ݾ��� ���ʽ��� ����
�ش� ������ job�� PRESIDENT�� ��� SAL 20% �λ�� �ݾ��� ���ʽ��� ����
�� �� �������� SAL��ŭ�� ����
*/


SELECT empno, ename, job, deptno, 
        DECODE(job, 
                    'SALESMAN',sal*1.05,
                    'MANAGER',DECODE(deptno, 10, sal*1.3, sal*1.1), 
                    'PRESIDENT', sal*1.2, sal*1) bonus, 
        sal   
FROM emp
ORDER BY job DESC, deptno;

============================================================================================================;

���� A = {10, 15, 18, 23, 24, 25, 29, 30, 35, 37}
PRIME NUMBER �Ҽ� : {23, 29, 37} : COUNT-3, MAX-37, MIN-23, AVG-29.7, SUM-89
��Ҽ� : {10, 15, 18, 24, 25, 30, 35};

MULTI ROW FUNCTION (�׷� �Լ�)

GROUP FUNCTION
�������� �����͸� �̿��Ͽ� ���� �׷쳢�� ���� �����ϴ� �Լ�
�������� �Է¹޾� �ϳ��� ������ ����� ���δ�.
EX : �μ��� �޿� ���
    emp ���̺��� 14���� ������ �ְ�, 14���� ������ 3���� �μ�(10, 20, 30)�� ���� �ִ�.
    �μ��� �޿� ����� 3���� ������ ����� ��ȯ�ȴ�.
    
SELECT �׷��� ���� �÷�, �׷��Լ�
FROM ���̺�
GROUP BY �׷��� ���� �÷�
[ORDER BY ];

GROUP BY ����� ���� ���� : SELECT ������ ����� �� �ִ� �÷��� ���ѵ� 
                          -GROUP BY ���� ������� ���� �÷��� SELECT ������ ���� ���� ����.
                          -GROUP �Լ�(MAX, MIN, COUNT, SUM, AVG)�� �����ٸ� �� �� ����.

�μ����� ���� ���� �޿� ��

SELECT deptno, 
        MAX(sal),
        MIN(sal),
        ROUND(AVG(sal), 2),
        SUM(sal),
        COUNT(sal), --�μ��� �޿� �Ǽ�(sal �÷��� ���� null�� �ƴ� row�� ��)
        COUNT(*),    --�μ��� ���� ��(null�� ������ ������� �ش� �÷��� ���� ���� ����)
        COUNT(mgr)
FROM emp
GROUP BY deptno;

�׷� �Լ��� ���� �μ���ȣ �� ���� ���� �޿��� ���� �� ������,
���� ���� �޿��� �޴� ����� �̸��� �� ���� ����.
 ==> ���� WINDOW FUNCTION(�м��Լ�)�� ���� �ذ� ����
 
 emp ���̺��� �׷� ������ �μ���ȣ�� �ƴ� ��ü �������� �����ϴ� ���
 
 SELECT MAX(sal),
        MIN(sal),
        ROUND(AVG(sal), 2),
        SUM(sal),
        COUNT(sal), --��ü ������ �޿� �Ǽ�
        COUNT(*),    --��ü ���� ��
        COUNT(mgr)  -- mgr �÷��� null�� �ƴ� �Ǽ�
FROM emp;

--�׷����� ��� �����ָ� �ȴ�.

/*
GROUP BY���� ���� �÷��� SELECT���� ���� ������ ������,
GROUP BY���� �ִ� �÷��� SELECT������ �������� ���� ��ȸ�� ���� �ʴ� ���̶� ������. 
*/

�׷�ȭ�� ���þ��� ������ ���ڿ�, ����� �� �� �ִ�.
SELECT deptno, 'TEST', 1,
        MAX(sal),
        MIN(sal),
        ROUND(AVG(sal), 2),
        SUM(sal),
        COUNT(sal), --��ü ������ �޿� �Ǽ�
        COUNT(*),    --��ü ���� ��
        COUNT(mgr)  -- mgr �÷��� null�� �ƴ� �Ǽ�
FROM emp
GROUP BY deptno;

�׷� �Լ� ����� NULL ���� ���ܰ� �ȴ�.
SELECT deptno, SUM(comm)
FROM emp
GROUP BY deptno;
--30�� �μ����� null ���� ���� ���� ������ SUM(comm)�� ���� ���������� ���� �� Ȯ���� �� �ִ�.

10, 20�� �μ��� SUM(comm)�÷��� null�� �ƴ϶� 0�� �������� NULLó��
SELECT deptno, NVL(SUM(comm), 0)
FROM emp
GROUP BY deptno;
--Ư���� ������ �ƴϸ� �׷��Լ� ������� NULLó���� �ϴ� ���� ���ɻ� ���� : 
    --NVL(SUM(comm),0) ,SUM(NVL(comm,0)) �� ��������� ���� �����غ���.

single row �Լ��� where���� ����� �� ������,
multi row �Լ�(group �Լ�)�� where���� ����� �� ����
GROUP BY �� ���� HAVING ���� ������ ����ؾ� �Ѵ�.

�μ��� �޿� ���� 5000�� �Ѵ� �μ��� ��ȸ
SELECT detpno, SUM(sal)
FROM emp
WHERE SUM(sal) > 5000
GROUP BY deptno; -- Ʋ�� ����

SELECT COUNT(*)
FROM emp
GROUP BY deptno
HAVING SUM(sal) > 9000;

SELECT deptno, SUM(sal)
FROM emp
GROUP BY deptno
HAVING SUM(sal) > 9000;

--grp1
SELECT MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, SUM(sal) sum_sal, 
       COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp;

--grp2
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, SUM(sal) sum_sal, 
       COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp
GROUP BY deptno;

--grp3
SELECT CASE
        WHEN deptno = 10 THEN 'ACCOUNTING'
        WHEN deptno = 20 THEN 'RESEARCH'
        WHEN deptno = 30 THEN 'SALES'
        END dname, 
        MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, SUM(sal) sum_sal, 
        COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp
GROUP BY deptno
ORDER BY max_sal DESC;

SELECT *
FROM dept;

--grp4
SELECT TO_CHAR(hiredate, 'yyyymm') hire_yyyymm, COUNT(TO_CHAR(hiredate, 'yyyymm'))cnt, COUNT(*)
FROM emp
GROUP BY TO_CHAR(hiredate, 'yyyymm')
ORDER BY TO_CHAR(hiredate, 'yyyymm');

--grp5
SELECT TO_CHAR(hiredate, 'yyyy') hire_yyyymm, COUNT(*)cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'yyyy')
ORDER BY TO_CHAR(hiredate, 'yyyy');

--grp6
SELECT COUNT(*) cnt
FROM dept;

--grp7
SELECT COUNT(COUNT(deptno)) cnt
FROM emp
GROUP BY deptno;






























