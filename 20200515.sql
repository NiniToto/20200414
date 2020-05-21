ROLLUP : 서브그룹 생성 - 기술된 컬럼을 오른쪽에서부터 지워나가면 GROUP BY를 실행

아래 쿼리의 서브그룹
1. GROUP BY job, deptno
2. GROUP BY job,
3. GROUP BY ==> 전체

ROLLUP사용 시 생성되는 서브그룹의 수는 : ROLLUP에 기술한 컬럼 수 + 1;

GROUP_AD2
SELECT CASE
    WHEN GROUPING(job) = 1 THEN '총계' 
    WHEN GROUPING(job) = 0 THEN job
    END job, deptno, SUM(sal)
FROM emp
GROUP BY ROLLUP (job, deptno);

GROUP_AD2_1]
SELECT CASE
        WHEN GROUPING(job) = 1 THEN '총' 
        WHEN GROUPING(job) = 0 THEN job
    END job,
    CASE
        WHEN GROUPING(deptno) = 1 AND GROUPING(job) = 0 THEN '소계'
        WHEN GROUPING(deptno) = 1 AND GROUPING(job) = 1 THEN '계'
        ELSE TO_CHAR(deptno)
    END deptno, SUM(sal) --CASE를 쓸 때 WHEN절에서 반환하는 THEN의 리턴값들의 타입이 모두 동일해야 한다.
FROM emp
GROUP BY ROLLUP (job, deptno);
--decode로도 해보자.

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
SELECT NVL(dept.dname, '총합'), job, sal
FROM
    (SELECT deptno, job, SUM(sal) sal
    FROM emp
    GROUP BY ROLLUP (deptno, job)) a, dept
WHERE a.deptno = dept.deptno(+);


2.GROUPING SETS
ROLLUP의 단점 : 관심없는 서브그룹도 생성해야 한다.
               ROLLUP절에 기술한 컬럼을 오른쪽에서 지워나가기 때문에
               만약 중간과정에 있는 서브그룹이 불필요할 경우 낭비

GROUPING SETS : 개발자가 직접 생성할 서브그룹을 명시
              . ROLLUP 과는 다르게 방향성이 없다.
              
사용법 : GROUP BY GROUPING SETS (col1,col2,...)

GROUP BY col1
UNION ALL
GROUP BY col2

SELECT job, deptno, SUM(sal)
FROM emp
GROUP BY GROUPING SETS(job, deptno);

그룹기준을
1. job, deptno
2. mgr

SELECT job, deptno, mgr, SUM(sal)
FROM emp
GROUP BY GROUPING SETS ((job, deptno), mgr);

3. CUBE
사용법 : GROUP BY CUBE (col1, ...)
기술된 컬럼의 가능한 모든 조합 (순서는 지킨다.)

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

**발생 가능한 조합을 계산
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

총 4가지

상호연관 서브쿼리 업데이트
1. emp테이블을 이용하여 emp_test 테이블 생성
    ==> 기존에 생성된 emp_test테이블 삭제 먼저 진행
    DROP TABLE emp_test;
2. emp_test 테이블에 dname컬럼 추가(dept 테이블 참고)
CREATE TABLE emp_test AS
SELECT *
FROM emp;

ALTER TABLE emp_test ADD (dname VARCHAR2(14));

SELECT *
FROM emp_test;

DESC emp_test;
3. subquery를 이용하여 emp_test 테이블에 추가된 dname컬럼을 업데이트 해주는 쿼리작성
emp_test의 dname 컬럼의 값을 dept 테이블의 dname 컬럼으로 update
emp_test테이블의 deptno값을 확인해서 dept테이블의 deptno값이랑 일치하는 dname 컬럼값을 가져와서 update
SELECT *
FROM emp_test;

SELECT *
FROM dept;

UPDATE emp_test SET dname = (SELECT dname
                               FROM dept
                              WHERE emp_test.deptno = dept.deptno );
emp_test테이블의 dname컬럼을 dept 테이블 이용해서 dname값 조회하여 업데이트
UPDATE 대상이 되는 행 : 14 ==> WHERE 절을 따로 기술하지 않았기 때문이다.
모든 직원을 대상으로 dname컬럼을 dept 테이블에서 조회하여 업데이트;

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

SELECT 결과 전체를 대상으로 그룹 함수를 적용한 경우
대상되는 행이 없더라도 0값이 리턴
SELECT COUNT(*)
FROM emp
WHERE 1 = 2;

GROUP BY 절을 기술할 경우 대상이 되는 행이 없을 경우 조회되는 행이 없다.
SELECT COUNT(*)
FROM emp
WHERE 1 = 2
GROUP BY deptno;
