1. NULL처리 하는 방법

DESC emp;

 -- INSERT INTO emp (empno, ename) VALUES(null, 'brown'); 나중에 배울 INSERT 키워드

SELECT NVL(empno,0), ename, NVL(sal,0), NVL(comm, 0) --NVL함수를 많이 사용했기때문에 좋은 쿼리는 아니다.
--empno의 경우에는 null값이 허용되지 않는 컬럼이기때문에 NVL을 통해서 null값을 필터해줄 필요가 없다.
FROM emp;

2. CONDITION
CASE, DECODE

3. 실행계획
    실행계획이란?
    실행계획을 읽는 순서는?
    
/*
emp 테이블에 등록된 직원들에게 보너스를 추가적으로 지급할 예정
해당 직원의 job이 SALESMAN일 경우 SAL 5% 인상된 금액을 보너스로 지급
해당 직원의 job이 MANAGER이면서 deptno가 10번이면 SAL 30% 인상, 그렇지 않으면 10%인상된 금액을 보너스로 지금
해당 직원의 job이 PRESIDENT일 경우 SAL 20% 인상된 금액을 보너스로 지급
그 외 직원들은 SAL만큼만 지급
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

집합 A = {10, 15, 18, 23, 24, 25, 29, 30, 35, 37}
PRIME NUMBER 소수 : {23, 29, 37} : COUNT-3, MAX-37, MIN-23, AVG-29.7, SUM-89
비소수 : {10, 15, 18, 24, 25, 30, 35};

MULTI ROW FUNCTION (그룹 함수)

GROUP FUNCTION
여러행의 데이터를 이용하여 같은 그룹끼리 묶어 연산하는 함수
여러행을 입력받아 하나의 행으로 결과가 묶인다.
EX : 부서별 급여 평균
    emp 테이블에는 14명의 직원이 있고, 14명의 직원은 3개의 부서(10, 20, 30)에 속해 있다.
    부서별 급여 평균은 3개의 행으로 결과가 반환된다.
    
SELECT 그룹핑 기준 컬럼, 그룹함수
FROM 테이블
GROUP BY 그룹핑 기준 컬럼
[ORDER BY ];

GROUP BY 적용시 주의 사항 : SELECT 구문에 기술할 수 있는 컬럼이 제한됨 
                          -GROUP BY 절에 기술하지 않은 컬럼은 SELECT 구문에 나올 수가 없다.
                          -GROUP 함수(MAX, MIN, COUNT, SUM, AVG)로 묶었다면 쓸 수 있음.

부서별로 가장 높은 급여 값

SELECT deptno, 
        MAX(sal),
        MIN(sal),
        ROUND(AVG(sal), 2),
        SUM(sal),
        COUNT(sal), --부서별 급여 건수(sal 컬럼의 값이 null이 아닌 row의 수)
        COUNT(*),    --부서별 행의 수(null의 유무에 상관없이 해당 컬럼의 행의 수를 리턴)
        COUNT(mgr)
FROM emp
GROUP BY deptno;

그룹 함수를 통해 부서번호 별 가장 높은 급여를 구할 수 있지만,
가장 높은 급여를 받는 사람의 이름을 알 수는 없다.
 ==> 추후 WINDOW FUNCTION(분석함수)을 통해 해결 가능
 
 emp 테이블의 그룹 기준을 부서번호가 아닌 전체 직원으로 설정하는 방법
 
 SELECT MAX(sal),
        MIN(sal),
        ROUND(AVG(sal), 2),
        SUM(sal),
        COUNT(sal), --전체 직원의 급여 건수
        COUNT(*),    --전체 행의 수
        COUNT(mgr)  -- mgr 컬럼이 null이 아닌 건수
FROM emp;

--그룹핑을 모두 지워주면 된다.

/*
GROUP BY절에 없는 컬럼이 SELECT절에 오면 문제가 되지만,
GROUP BY절에 있는 컬럼을 SELECT절에서 빼버리는 것은 조회만 하지 않는 것이라 괜찮다. 
*/

그룹화와 관련없는 임의의 문자열, 상수는 올 수 있다.
SELECT deptno, 'TEST', 1,
        MAX(sal),
        MIN(sal),
        ROUND(AVG(sal), 2),
        SUM(sal),
        COUNT(sal), --전체 직원의 급여 건수
        COUNT(*),    --전체 행의 수
        COUNT(mgr)  -- mgr 컬럼이 null이 아닌 건수
FROM emp
GROUP BY deptno;

그룹 함수 연산시 NULL 값은 제외가 된다.
SELECT deptno, SUM(comm)
FROM emp
GROUP BY deptno;
--30번 부서에는 null 값을 갖는 행이 있지만 SUM(comm)의 값이 정상적으로 계산된 걸 확인할 수 있다.

10, 20번 부서의 SUM(comm)컬럼이 null이 아니라 0이 나오도록 NULL처리
SELECT deptno, NVL(SUM(comm), 0)
FROM emp
GROUP BY deptno;
--특별한 사유가 아니면 그룹함수 계산결과에 NULL처리를 하는 것이 성능상 유리 : 
    --NVL(SUM(comm),0) ,SUM(NVL(comm,0)) 두 실행과정에 대해 생각해보기.

single row 함수는 where절에 기술할 수 있지만,
multi row 함수(group 함수)는 where절에 기술할 수 없고
GROUP BY 절 이후 HAVING 절에 별도로 기술해야 한다.

부서별 급여 합이 5000이 넘는 부서만 조회
SELECT detpno, SUM(sal)
FROM emp
WHERE SUM(sal) > 5000
GROUP BY deptno; -- 틀린 쿼리

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






























