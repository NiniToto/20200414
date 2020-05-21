����׷� ���� ���
1. ROLLUP : �ڿ���(�����ʿ���) �ϳ��� �������鼭 ����׷��� ����
2. CUBE : ������ ��� ����
3. GROUPING SETS : �����ڰ� ����׷� ������ ���� ���

sub_a2]
DROP TABLE dept_test;

SELECT *
FROM dept;

CREATE TABLE dept_test AS
SELECT *
FROM dept;

INSERT INTO dept_test VALUES(99, 'it1', 'daejeon');
INSERT INTO dept_test VALUES(98, 'it2', 'daejeon');

SELECT *
FROM dept_test;

DELETE dept_test
WHERE deptno NOT IN (SELECT deptno
                     FROM emp);

DELETE dept_test
WHERE NOT EXISTS (SELECT 'X'
                  FROM emp
                  WHERE emp.deptno = dept_test.deptno);

sub_a3]
SELECT *
FROM emp_test;

UPDATE emp_test a SET sal = sal+200
WHERE a.sal <  (SELECT AVG(sal)
                FROM emp b
                WHERE a.deptno = b.deptno
                GROUP BY deptno);
             
SELECT *
FROM emp a
WHERE a.sal < (SELECT AVG(sal)
                FROM emp b
                WHERE a.deptno = b.deptno
                GROUP BY deptno);
                
���Ŀ��� �ƴ�����, �˻� - ������ ���� ������ ǥ��
���������� ���� ���
1. Ȯ���� : ��ȣ���� �������� (EXISTS)
        => ���� ���� ���� -> ���� ���� ����
2. ������ : ���������� ���� ����Ǽ� ���������� ���� �������ִ� ����
        =>
ex) 
SELECT *
FROM emp
WHERE mgr IN (SELECT empno
                 FROM emp); 
13�� : �Ŵ����� �����ϴ� ������ ��ȸ

�μ��� �޿������ ��ü �޿���պ��� ū �μ��� �μ���ȣ, �μ��� �޿���� ���ϱ�

�μ��� ��� �޿�
SELECT deptno, ROUND(AVG(sal), 2)
FROM emp
GROUP BY deptno;

��ü �޿� ���
SELECT ROUND(AVG(sal),2)
FROM emp;

�Ϲ����� �������� ����
SELECT deptno, ROUND(AVG(sal), 2)
FROM emp
GROUP BY deptno
HAVING ROUND(AVG(sal),2) > (SELECT ROUND(AVG(sal),2)
                            FROM emp);

WITH �� : SQL���� �ݺ������� ������ QUERY BLOCK(SUBQUERY)�� ������ �����Ͽ�
          SQL ���� �� �ѹ��� �޸𸮿� �ε��� �ϰ� �ݺ������� ����� �� �޸� ������ �����͸�
          Ȱ���Ͽ� �ӵ� ������ �� �� �ִ� KEYWORD
          ��, �ϳ��� SQL���� �ݺ����� SQL���� ������ ���� �� �� �ۼ��� SQL�� ���ɼ��� ���� ������ 
          �ٸ� ���·� ������ �� �ִ����� �����غ��� ���� ��õ.

WITH�� ���;
WITH emp_avg_sal AS(
    SELECT ROUND(AVG(sal),2)
    FROM emp
)

SELECT deptno, ROUND(AVG(sal), 2), (SELECT * FROM emp_avg_sal)
FROM emp
GROUP BY deptno
HAVING ROUND(AVG(sal),2) > (SELECT *
                            FROM emp_avg_sal);


��������
CONNECT BY LEVEL : ���� �ݺ��ϰ� ���� ����ŭ ������ ���ִ� ���
��ġ : FROM(WHERE)�� ������ ���
DUAL���̺�� ���� ���

���̺� ���� �Ѱ�, �޸𸮿��� ����
SELECT LEVEL
FROM dual
CONNECT BY LEVEL <= 5;

���� ���� ���� �̹� ��� KEYWORD�� �̿��Ͽ� �ۼ� ����
5���̻��� �����ϴ� ���̺��� ���� ���� ����
���࿡ �츮�� ������ �����Ͱ� 10000���̸��� 10000�ǿ� ���� DISK I/O�� �߻�
SELECT ROWNUM
FROM emp
WHERE ROWNUM <= 5;

1. �츮���� �־��� ���ڿ� ��� : 202005
   �־��� ����� �ϼ��� ���Ͽ� �ϼ���ŭ ���� ����
   
   SELECT LEVEL
   FROM dual
   CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202005', 'yyyymm')), 'dd');
   
SELECT TO_CHAR(LAST_DAY(TO_DATE('202005', 'yyyymm')), 'dd')
FROM dual;

SELECT TO_DATE('202005', 'yyyymm') + (LEVEL-1) dt, 7���� �÷��� �߰��� ����
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202005', 'yyyymm')), 'dd');
   
�޷��� �÷��� 7�� - ���� : Ư�����ڴ� �ϳ��� ���Ͽ� ����

�ζ��κ並 �̿��ؼ� �ܼ��ϰ� ǥ�� TO_DATE('202005', 'yyyymm') + (LEVEL-1) ==> dt
SELECT dt
FROM 
(SELECT TO_DATE('202005', 'yyyymm') + (LEVEL-1) dt
 FROM dual
 CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202005', 'yyyymm')), 'dd'));

SELECT dt,
        DECODE(d, 1, dt) ��, DECODE(d, 2, dt) ��, DECODE(d, 3, dt) ȭ, DECODE(d, 4, dt) ��,
        DECODE(d, 5, dt) ��, DECODE(d, 6, dt) ��, DECODE(d, 7, dt) ��
FROM 
(SELECT TO_DATE('202005', 'yyyymm') + (LEVEL-1) dt, TO_CHAR(TO_DATE('202005', 'yyyymm') + (LEVEL-1), 'D')d
 FROM dual
 CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202005', 'yyyymm')), 'dd'));

SELECT  MIN(DECODE(d, 1, dt)) ��, MIN(DECODE(d, 2, dt)) ��, MIN(DECODE(d, 3, dt)) ȭ, MIN(DECODE(d, 4, dt)) ��,
        MIN(DECODE(d, 5, dt)) ��, MIN(DECODE(d, 6, dt)) ��, MIN(DECODE(d, 7, dt)) ��
FROM 
(SELECT TO_DATE(:yyyymm, 'yyyymm') + (LEVEL-1) dt, TO_CHAR(TO_DATE(:yyyymm, 'yyyymm') + (LEVEL-1), 'D')d,
        TO_CHAR(TO_DATE(:yyyymm, 'yyyymm') + (LEVEL-1), 'IW') iw
 FROM dual
 CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'yyyymm')), 'dd'))
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);
--min�� ���� ���� :  � �׷��Լ��� �ᵵ ����� ���µ� MIN�Լ��� �˰��������� ���� ȿ�����̹Ƿ�...

SELECT 
        DECODE(d, 1, dt) ��, DECODE(d, 2, dt) ��, DECODE(d, 3, dt) ȭ, DECODE(d, 4, dt) ��,
        DECODE(d, 5, dt) ��, DECODE(d, 6, dt) ��, DECODE(d, 7, dt) ��
FROM 
(SELECT TO_DATE('202005', 'yyyymm') + (LEVEL-1) dt, TO_CHAR(TO_DATE('202005', 'yyyymm') + (LEVEL-1), 'D')d
 FROM dual
 CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202005', 'yyyymm')), 'dd'));

calendar1]
SELECT NVL(SUM(DECODE(m, 1, sales)),0) jan, NVL(SUM(DECODE(m, 2, sales)),0) feb, NVL(SUM(DECODE(m, 3, sales)),0) mar,
       NVL(SUM(DECODE(m, 4, sales)),0) apr, NVL(SUM(DECODE(m, 5, sales)),0) may, NVL(SUM(DECODE(m, 6, sales)),0) jun
FROM
    (SELECT dt, sales, TO_CHAR(dt, 'mm') m
     FROM sales);
--3���� null�����°� nvl���� �ٸ� ������� �� �� ������ �����غ���..

calendar1 - Teacher]
������ : �ϴ��� ����
ȭ�鿡 ��Ÿ���� �ϴ� ���� : ������
SELECT MIN(DECODE(mm, '201901', sales)) m1, MIN(DECODE(mm, '201902', sales)) m2, MIN(DECODE(mm, '201903', sales)) m3, --nvl
       MIN(DECODE(mm, '201904', sales)) m4, MIN(DECODE(mm, '201905', sales)) m5, MIN(DECODE(mm, '201906', sales)) m6
FROM
 (SELECT TO_CHAR(dt, 'YYYYMM') mm, SUM(sales) sales
 FROM sales
 GROUP BY TO_CHAR(dt, 'YYYYMM'));

claendar2]
SELECT LEVEL
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202005','yyyymm')), 'dd')
                + TO_CHAR(TO_DATE('202005', 'yyyymm')-1, 'dd') - TO_CHAR(NEXT_DAY(TO_DATE('202005','yyyymm') - 7, 1), 'dd')
                + TO_CHAR(NEXT_DAY(TO_DATE('202005', 'yyyymm'), 7), 'dd');


SELECT TO_CHAR(TO_DATE('202005', 'yyyymm')-1, 'dd') - TO_CHAR(NEXT_DAY(TO_DATE('202005','yyyymm') - 7, 1), 'dd')
FROM dual;

SELECT TO_CHAR(NEXT_DAY(TO_DATE('202005', 'yyyymm'), 7), 'dd')
FROM dual;



SELECT  MIN(DECODE(d, 1, dt)) ��, MIN(DECODE(d, 2, dt)) ��, MIN(DECODE(d, 3, dt)) ȭ, MIN(DECODE(d, 4, dt)) ��,
        MIN(DECODE(d, 5, dt)) ��, MIN(DECODE(d, 6, dt)) ��, MIN(DECODE(d, 7, dt)) ��
FROM 
(SELECT TO_DATE(:yyyymm, 'yyyymm') + (LEVEL-1) dt, 
        TO_CHAR(TO_DATE(:yyyymm, 'yyyymm') + (LEVEL-1), 'D')d,
        TO_CHAR(TO_DATE(:yyyymm, 'yyyymm') + (LEVEL-1), 'IW') iw
 FROM dual
 CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'yyyymm')), 'dd')
                + TO_CHAR(TO_DATE(:yyyymm, 'yyyymm')-1, 'dd') - TO_CHAR(NEXT_DAY(TO_DATE(:yyyymm,'yyyymm') - 7, 1), 'dd')
                + TO_CHAR(NEXT_DAY(TO_DATE(:yyyymm, 'yyyymm'), 7), 'dd'))
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);

------------

SELECT  MIN(DECODE(d, 1, dt)) ��, MIN(DECODE(d, 2, dt)) ��, MIN(DECODE(d, 3, dt)) ȭ, MIN(DECODE(d, 4, dt)) ��,
        MIN(DECODE(d, 5, dt)) ��, MIN(DECODE(d, 6, dt)) ��, MIN(DECODE(d, 7, dt)) ��
FROM 
(SELECT TO_DATE(:yyyymm, 'yyyymm') -(TO_CHAR(TO_DATE(:yyyymm, 'yyyymm')-1, 'dd') - TO_CHAR(NEXT_DAY(TO_DATE(:yyyymm,'yyyymm') - 7, 1), 'dd')+1) + (LEVEL-1) dt, 
        TO_CHAR(TO_DATE(:yyyymm, 'yyyymm') -((TO_CHAR(TO_DATE(:yyyymm, 'yyyymm')-1, 'dd') - TO_CHAR(NEXT_DAY(TO_DATE(:yyyymm,'yyyymm') - 7, 1), 'dd')+1))+ (LEVEL-1), 'D')d,
        TO_CHAR(TO_DATE(:yyyymm, 'yyyymm') -((TO_CHAR(TO_DATE(:yyyymm, 'yyyymm')-1, 'dd') - TO_CHAR(NEXT_DAY(TO_DATE(:yyyymm,'yyyymm') - 7, 1), 'dd')+1))+ (LEVEL-1), 'IW') iw
 FROM dual
 CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'yyyymm')), 'dd')
                + TO_CHAR(TO_DATE(:yyyymm, 'yyyymm')-1, 'dd') - TO_CHAR(NEXT_DAY(TO_DATE(:yyyymm,'yyyymm') - 7, 1), 'dd')+1
                + TO_CHAR(NEXT_DAY(LAST_DAY(TO_DATE(:yyyymm, 'yyyymm')), 7), 'dd'))
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);


SELECT LEVEL
 FROM dual
 CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'yyyymm')), 'dd')
                + TO_CHAR(TO_DATE(:yyyymm, 'yyyymm')-1, 'dd') - TO_CHAR(NEXT_DAY(TO_DATE(:yyyymm,'yyyymm') - 7, 1), 'dd')+1
                + TO_CHAR(NEXT_DAY(LAST_DAY(TO_DATE(:yyyymm, 'yyyymm')), 7), 'dd')
                
SELECT LEVEL
 FROM dual
 CONNECT BY LEVEL <= TO_CHAR(TO_DATE(:yyyymm, 'yyyymm')-1, 'dd') - TO_CHAR(NEXT_DAY(TO_DATE(:yyyymm,'yyyymm') - 7, 1), 'dd')+1
                        --04/30 - 4/28 + 1

claendar2 - Teacher];

SELECT  MIN(DECODE(d, 1, dt)) ��, MIN(DECODE(d, 2, dt)) ��, MIN(DECODE(d, 3, dt)) ȭ, MIN(DECODE(d, 4, dt)) ��,
        MIN(DECODE(d, 5, dt)) ��, MIN(DECODE(d, 6, dt)) ��, MIN(DECODE(d, 7, dt)) ��
FROM 
(SELECT TO_DATE(:yyyymm, 'yyyymm') + (LEVEL-1) dt, 
        TO_CHAR(TO_DATE(:yyyymm, 'yyyymm') + (LEVEL-1), 'D')d,
        TO_CHAR(TO_DATE(:yyyymm, 'yyyymm') + (LEVEL-1), 'IW') iw
 FROM dual
 CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'yyyymm')), 'dd'))
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);

202005 ==> �ش���� 1���� ���ϴ� ���� �Ͽ����� �����ΰ�?
SELECT TO_DATE('202005', 'YYYYMM'), TO_CHAR(TO_DATE('202005', 'YYYYMM'), 'd'),
       TO_DATE('202005', 'YYYYMM') - TO_CHAR(TO_DATE('202005', 'YYYYMM'), 'd') + 1 s
FROM dual;

202005 ==> �ش���� ������ ���ڰ� ���ϴ� ���� ������� �����ΰ�?
SELECT LAST_DAY(TO_DATE('202005', 'YYYYMM')), TO_CHAR(LAST_DAY(TO_DATE('202005', 'YYYYMM')), 'd'),
       LAST_DAY(TO_DATE('202005', 'YYYYMM')) + (7 - TO_CHAR(LAST_DAY(TO_DATE('202005', 'YYYYMM')), 'd')) e
FROM dual;

 SELECT DECODE(d, 1, iw+1, iw),
           MIN(DECODE(d, 1, dt)) sun, MIN(DECODE(d, 2, dt)) mon, 
           MIN(DECODE(d, 3, dt)) tue, MIN(DECODE(d, 4, dt)) wed, 
           MIN(DECODE(d, 5, dt)) thu, MIN(DECODE(d, 6, dt)) fri,
           MIN(DECODE(d, 7, dt)) sat
FROM
(SELECT (TO_DATE('202005', 'YYYYMM') - TO_CHAR(TO_DATE('202005', 'YYYYMM'), 'D') + 1) + (LEVEL-1) dt, 
        TO_CHAR((TO_DATE('202005', 'YYYYMM') - TO_CHAR(TO_DATE('202005', 'YYYYMM'), 'D') + 1) + (LEVEL-1), 'D') d,
        TO_CHAR((TO_DATE('202005', 'YYYYMM') - TO_CHAR(TO_DATE('202005', 'YYYYMM'), 'D') + 1) + (LEVEL-1), 'iw') iw
 FROM dual
 CONNECT BY LEVEL <= 
        ((LAST_DAY(TO_DATE('202005', 'YYYYMM')) +( 7- TO_CHAR(LAST_DAY(TO_DATE('202005', 'YYYYMM')), 'D')))
        - (TO_DATE('202005', 'YYYYMM') - TO_CHAR(TO_DATE('202005', 'YYYYMM'), 'D') + 1 ) + 1) )
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);

SELECT DECODE(d, 1, iw+1, iw),
           MIN(DECODE(d, 1, dt)) sun, MIN(DECODE(d, 2, dt)) mon, 
           MIN(DECODE(d, 3, dt)) tue, MIN(DECODE(d, 4, dt)) wed, 
           MIN(DECODE(d, 5, dt)) thu, MIN(DECODE(d, 6, dt)) fri,
           MIN(DECODE(d, 7, dt)) sat
FROM
(SELECT (TO_DATE(:date, 'YYYYMM') - TO_CHAR(TO_DATE(:date, 'YYYYMM'), 'D') + 1) + (LEVEL-1) dt, 
        TO_CHAR((TO_DATE(:date, 'YYYYMM') - TO_CHAR(TO_DATE(:date, 'YYYYMM'), 'D') + 1) + (LEVEL-1), 'D') d,
        TO_CHAR((TO_DATE(:date, 'YYYYMM') - TO_CHAR(TO_DATE(:date, 'YYYYMM'), 'D') + 1) + (LEVEL-1), 'iw') iw
 FROM dual
 CONNECT BY LEVEL <= 
        ((LAST_DAY(TO_DATE(:date, 'YYYYMM')) +( 7- TO_CHAR(LAST_DAY(TO_DATE(:date, 'YYYYMM')), 'D')))
        - (TO_DATE(:date, 'YYYYMM') - TO_CHAR(TO_DATE(:date, 'YYYYMM'), 'D') + 1 ) + 1) )
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);
                        
===================================================================================================================
SELECT  MIN(DECODE(d, 1, dt)) ��, MIN(DECODE(d, 2, dt)) ��, MIN(DECODE(d, 3, dt)) ȭ, MIN(DECODE(d, 4, dt)) ��,
        MIN(DECODE(d, 5, dt)) ��, MIN(DECODE(d, 6, dt)) ��, MIN(DECODE(d, 7, dt)) ��
FROM 
(SELECT TO_DATE(:yyyymm, 'yyyymm') + (LEVEL-1) dt, TO_CHAR(TO_DATE(:yyyymm, 'yyyymm') + (LEVEL-1), 'D')d,
        TO_CHAR(TO_DATE(:yyyymm, 'yyyymm') + (LEVEL), 'IW') iw
 FROM dual
 CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'yyyymm')), 'dd'))
GROUP BY iw
ORDER BY ��;              


SELECT  MIN(DECODE(d, 1, dt)) ��, MIN(DECODE(d, 2, dt)) ��, MIN(DECODE(d, 3, dt)) ȭ, MIN(DECODE(d, 4, dt)) ��,
        MIN(DECODE(d, 5, dt)) ��, MIN(DECODE(d, 6, dt)) ��, MIN(DECODE(d, 7, dt)) ��
FROM 
(SELECT TO_DATE(:yyyymm, 'yyyymm') + (LEVEL-1) dt, 
        TO_CHAR(TO_DATE(:yyyymm, 'yyyymm') + (LEVEL-1), 'D')d,
        CEIL(LEVEL/7)week
 FROM dual
 CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'yyyymm')), 'dd'))
GROUP BY week
ORDER BY week;    
===================================================================================================================
 
 