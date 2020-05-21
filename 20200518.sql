서브그룹 생성 방식
1. ROLLUP : 뒤에서(오른쪽에서) 하나씩 지워가면서 서브그룹을 생성
2. CUBE : 가능한 모든 조합
3. GROUPING SETS : 개발자가 서브그룹 기준을 직접 기술

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
                
공식용어는 아니지만, 검색 - 도서에 자주 나오는 표현
서브쿼리의 사용된 방법
1. 확인자 : 상호연관 서브쿼리 (EXISTS)
        => 메인 쿼리 실행 -> 서브 쿼리 실행
2. 공급자 : 서브쿼리가 먼저 실행되서 메인쿼리에 값을 공급해주는 역할
        =>
ex) 
SELECT *
FROM emp
WHERE mgr IN (SELECT empno
                 FROM emp); 
13건 : 매니저가 존재하는 직원을 조회

부서별 급여평균이 전체 급여평균보다 큰 부서의 부서번호, 부서별 급여평균 구하기

부서별 평균 급여
SELECT deptno, ROUND(AVG(sal), 2)
FROM emp
GROUP BY deptno;

전체 급여 평균
SELECT ROUND(AVG(sal),2)
FROM emp;

일반적인 서브쿼리 형태
SELECT deptno, ROUND(AVG(sal), 2)
FROM emp
GROUP BY deptno
HAVING ROUND(AVG(sal),2) > (SELECT ROUND(AVG(sal),2)
                            FROM emp);

WITH 절 : SQL에서 반복적으로 나오는 QUERY BLOCK(SUBQUERY)을 별도로 선언하여
          SQL 실행 시 한번만 메모리에 로딩을 하고 반복적으로 사용할 때 메모리 공간의 데이터를
          활용하여 속도 개선을 할 수 있는 KEYWORD
          단, 하나의 SQL에서 반복적인 SQL블럭이 나오는 것은 잘 못 작성한 SQL일 가능성이 높기 때문에 
          다른 형태로 변경할 수 있는지를 검토해보는 것을 추천.

WITH절 사용;
WITH emp_avg_sal AS(
    SELECT ROUND(AVG(sal),2)
    FROM emp
)

SELECT deptno, ROUND(AVG(sal), 2), (SELECT * FROM emp_avg_sal)
FROM emp
GROUP BY deptno
HAVING ROUND(AVG(sal),2) > (SELECT *
                            FROM emp_avg_sal);


계층쿼리
CONNECT BY LEVEL : 행을 반복하고 싶은 수만큼 복제를 해주는 기능
위치 : FROM(WHERE)절 다음에 기술
DUAL테이블과 많이 사용

테이블에 행이 한건, 메모리에서 복제
SELECT LEVEL
FROM dual
CONNECT BY LEVEL <= 5;

위의 쿼리 말고도 이미 배운 KEYWORD를 이용하여 작성 가능
5행이상이 존재하는 테이블을 갖고 행을 제한
만약에 우리가 복제할 데이터가 10000건이면은 10000건에 대한 DISK I/O가 발생
SELECT ROWNUM
FROM emp
WHERE ROWNUM <= 5;

1. 우리에게 주어진 문자열 년월 : 202005
   주어진 년월의 일수를 구하여 일수만큼 행을 생성
   
   SELECT LEVEL
   FROM dual
   CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202005', 'yyyymm')), 'dd');
   
SELECT TO_CHAR(LAST_DAY(TO_DATE('202005', 'yyyymm')), 'dd')
FROM dual;

SELECT TO_DATE('202005', 'yyyymm') + (LEVEL-1) dt, 7개의 컬럼을 추가로 생성
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202005', 'yyyymm')), 'dd');
   
달력의 컬럼은 7개 - 요일 : 특정일자는 하나의 요일에 포함

인라인뷰를 이용해서 단순하게 표현 TO_DATE('202005', 'yyyymm') + (LEVEL-1) ==> dt
SELECT dt
FROM 
(SELECT TO_DATE('202005', 'yyyymm') + (LEVEL-1) dt
 FROM dual
 CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202005', 'yyyymm')), 'dd'));

SELECT dt,
        DECODE(d, 1, dt) 일, DECODE(d, 2, dt) 월, DECODE(d, 3, dt) 화, DECODE(d, 4, dt) 수,
        DECODE(d, 5, dt) 목, DECODE(d, 6, dt) 금, DECODE(d, 7, dt) 토
FROM 
(SELECT TO_DATE('202005', 'yyyymm') + (LEVEL-1) dt, TO_CHAR(TO_DATE('202005', 'yyyymm') + (LEVEL-1), 'D')d
 FROM dual
 CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202005', 'yyyymm')), 'dd'));

SELECT  MIN(DECODE(d, 1, dt)) 일, MIN(DECODE(d, 2, dt)) 월, MIN(DECODE(d, 3, dt)) 화, MIN(DECODE(d, 4, dt)) 수,
        MIN(DECODE(d, 5, dt)) 목, MIN(DECODE(d, 6, dt)) 금, MIN(DECODE(d, 7, dt)) 토
FROM 
(SELECT TO_DATE(:yyyymm, 'yyyymm') + (LEVEL-1) dt, TO_CHAR(TO_DATE(:yyyymm, 'yyyymm') + (LEVEL-1), 'D')d,
        TO_CHAR(TO_DATE(:yyyymm, 'yyyymm') + (LEVEL-1), 'IW') iw
 FROM dual
 CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'yyyymm')), 'dd'))
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);
--min을 쓰는 이유 :  어떤 그룹함수를 써도 상관이 없는데 MIN함수가 알고리즘적으로 가장 효율적이므로...

SELECT 
        DECODE(d, 1, dt) 일, DECODE(d, 2, dt) 월, DECODE(d, 3, dt) 화, DECODE(d, 4, dt) 수,
        DECODE(d, 5, dt) 목, DECODE(d, 6, dt) 금, DECODE(d, 7, dt) 토
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
--3월에 null나오는거 nvl말고 다른 방법으로 할 수 없는지 생각해보기..

calendar1 - Teacher]
데이터 : 일단위 실적
화면에 나타내야 하는 단위 : 월단위
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



SELECT  MIN(DECODE(d, 1, dt)) 일, MIN(DECODE(d, 2, dt)) 월, MIN(DECODE(d, 3, dt)) 화, MIN(DECODE(d, 4, dt)) 수,
        MIN(DECODE(d, 5, dt)) 목, MIN(DECODE(d, 6, dt)) 금, MIN(DECODE(d, 7, dt)) 토
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

SELECT  MIN(DECODE(d, 1, dt)) 일, MIN(DECODE(d, 2, dt)) 월, MIN(DECODE(d, 3, dt)) 화, MIN(DECODE(d, 4, dt)) 수,
        MIN(DECODE(d, 5, dt)) 목, MIN(DECODE(d, 6, dt)) 금, MIN(DECODE(d, 7, dt)) 토
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

SELECT  MIN(DECODE(d, 1, dt)) 일, MIN(DECODE(d, 2, dt)) 월, MIN(DECODE(d, 3, dt)) 화, MIN(DECODE(d, 4, dt)) 수,
        MIN(DECODE(d, 5, dt)) 목, MIN(DECODE(d, 6, dt)) 금, MIN(DECODE(d, 7, dt)) 토
FROM 
(SELECT TO_DATE(:yyyymm, 'yyyymm') + (LEVEL-1) dt, 
        TO_CHAR(TO_DATE(:yyyymm, 'yyyymm') + (LEVEL-1), 'D')d,
        TO_CHAR(TO_DATE(:yyyymm, 'yyyymm') + (LEVEL-1), 'IW') iw
 FROM dual
 CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'yyyymm')), 'dd'))
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);

202005 ==> 해당월의 1일이 속하는 주의 일요일은 몇일인가?
SELECT TO_DATE('202005', 'YYYYMM'), TO_CHAR(TO_DATE('202005', 'YYYYMM'), 'd'),
       TO_DATE('202005', 'YYYYMM') - TO_CHAR(TO_DATE('202005', 'YYYYMM'), 'd') + 1 s
FROM dual;

202005 ==> 해당월의 마지막 일자가 속하는 주의 토요일은 몇일인가?
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
SELECT  MIN(DECODE(d, 1, dt)) 일, MIN(DECODE(d, 2, dt)) 월, MIN(DECODE(d, 3, dt)) 화, MIN(DECODE(d, 4, dt)) 수,
        MIN(DECODE(d, 5, dt)) 목, MIN(DECODE(d, 6, dt)) 금, MIN(DECODE(d, 7, dt)) 토
FROM 
(SELECT TO_DATE(:yyyymm, 'yyyymm') + (LEVEL-1) dt, TO_CHAR(TO_DATE(:yyyymm, 'yyyymm') + (LEVEL-1), 'D')d,
        TO_CHAR(TO_DATE(:yyyymm, 'yyyymm') + (LEVEL), 'IW') iw
 FROM dual
 CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'yyyymm')), 'dd'))
GROUP BY iw
ORDER BY 토;              


SELECT  MIN(DECODE(d, 1, dt)) 일, MIN(DECODE(d, 2, dt)) 월, MIN(DECODE(d, 3, dt)) 화, MIN(DECODE(d, 4, dt)) 수,
        MIN(DECODE(d, 5, dt)) 목, MIN(DECODE(d, 6, dt)) 금, MIN(DECODE(d, 7, dt)) 토
FROM 
(SELECT TO_DATE(:yyyymm, 'yyyymm') + (LEVEL-1) dt, 
        TO_CHAR(TO_DATE(:yyyymm, 'yyyymm') + (LEVEL-1), 'D')d,
        CEIL(LEVEL/7)week
 FROM dual
 CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'yyyymm')), 'dd'))
GROUP BY week
ORDER BY week;    
===================================================================================================================
 
 