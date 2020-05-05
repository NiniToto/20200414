한개의 행, 하나의 컬럼을 리턴하는 서브쿼리
ex) 전체 직원의 급여 평균, SMITH 직원이 속한 부서의 부서번호

WHERE에서 사용가능한 연산자
WHERE deptno = 10
==>
부서번호가 10 혹은 30번인 경우
WHERE deptno IN (10,30)
WHERE deptno = 10 OR  deptno = 30



MULTI ROW FUNCTION(다중행 연산자)
다중행을 조회하는 서브쿼리의 경우  = 연산자를 사용불가
WHERE deptno = (10,30) ==> 사용불가
WHERE deptno IN (여러개의 행을 리턴하고, 하나의 컬럼으로 이루어진 쿼리)

SMITH - 20, ALLEN은 30번 부서에 속함

SMITH 또는 ALLEN이 속하는 부서의 조직원 정보를 조회

행이 여러개고, 컬름은 하나다 
==> 서브쿼리에서 사용가능한 연산자 IN(많이 사용함), (ANY, ALL)(사용 빈도가 낮음)
IN : 서브쿼리의 결과 값 중 동일한 값이 있을 때 TRUE
    WHERE 컬럼|표현식 IN (서브쿼리)
    
ANY : 연산자를 만족하는 값이 하나라도 있을 때 TRUE
    WHERE 컬럼|표현식 연산자 ANY (서브쿼리)
    
ALL : 서브쿼리의 모든 값이 연산자를 만족할 때 TRUE
    WHERE 컬럼|표현식 연산자 ALL (서브쿼리)
    
SMITH와 ALLEN이 속한 부서에서 근무하는 모든 직원을 조회    

1. 서브쿼리를 사용하지 않을 겨우 : 두개의 쿼리를 실행
1-1] SMITH, ALLEN이 속한 부서의 부서번호를 확인하는 쿼리
SELECT deptno
FROM emp
WHERE ename IN ('SMITH', 'ALLEN'); --20,30

1-2] 1-1]에서 얻은 부서번호로 IN연산을 통해 해당 부서에 속하는 직원 정보 조회
SELECT *
FROM emp
WHERE deptno IN (20,30);

==> 서브쿼리를 이용하면 하나의 SQL에서 실행 가능
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
SMITH나 WARD 두 사원의 급여중 아무 값보다 작은 급여를 받는 직원 조회 (sal < 1250)
SELECT *
FROM emp
WHERE sal < ANY(SELECT sal
                FROM emp
                WHERE ename IN ('SMITH', 'WARD'));
                
SMITH나 WARD 두 사원의 급여중 모든 값보다 많은 급여를 받는 직원 조회 (sal > 1250)
SELECT *
FROM emp
WHERE sal > ALL(SELECT sal
                FROM emp
                WHERE ename IN ('SMITH', 'WARD'));
                
IN 연산자의 부정
WHERE deptno NOT IN (20, 30);

NOT IN 연산자를 사용할 경우 서브쿼리의 값에 NULL이 있는지 여부가 중요하다.
==정상적으로 동작하지 않음

아래 쿼리가 조회하는 결과는 어떤 의미인가? --> 누군가의 매니저가 아닌 사람을 조회
SELECT *
FROM emp
WHERE empno NOT IN (SELECT mgr
                    FROM emp);
--> NULL이 있기 때문에 정상작동 하지 않는다.
--7902, 7698, 7839, 7566, 7788, 7566, 7782
--ford, blake, king, jones, scott, jones, clark
--해결 방법1
SELECT *
FROM emp
WHERE empno NOT IN (SELECT mgr
                    FROM emp
                    WHERE mgr IS NOT NULL);
--해결 방법2
SELECT *
FROM emp
WHERE empno NOT IN (SELECT NVL(mgr, ?) -->NULL처리 함수를 통해 데이터에 적합한 형식(쿼리에 영향이 가지 않는)으로 넣어줄 수 있도록 고민해봐야 한다.
                    FROM emp);
                    
단일 컬럼을 리턴하는 서브쿼리에 대한 연산 ==> 복수 컬럼을 리턴하는 서브쿼리
PAIRWISE 연산 (순서쌍) ==> 동시에 만족

SELECT empno, mgr, deptno
FROM emp
WHERE empno IN (7499,7782);

7499, 7782 사번의 직원과 같은 부서, 같은 매니저인 모든 직원 정보 조회
매니저가 7698이면서 소속부서가 30인 경우
매니저가 7839이면서 소속부서가 10인 경우

==>mgr 컬럼과 deptno 컬럼의 연관성이 없다.

SELECT *
FROM emp
WHERE mgr IN (7698, 7839)
  AND deptno IN (10, 30); ==> 4가지의 경우가 발생, 하지만 문제에서는 2가지의 경우만 조회하길 원한다.
  
  
PAIRWISE 적용 (위의 쿼리와 결과가 다르다)
SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                          FROM emp
                          WHERE empno IN (7499,7782));

서브쿼리 구분 - 사용 위치
SELECT - SCALAR SUB QUERY
FROM - INLINE-VIEW
WHERE - SUB-QUERY

서브쿼리 구분 - 반환하는 행, 컬럼의 수(외울 필요는 없다.)
단일 행
    단일 컬럼(SCALAR SUB QUERY)
    복수 컬럼
복수 행
    단일 컬럼(많이 쓰는 형태)
    복수 컬럼

SCALAR SUB QUERY
단일 행, 단일 컬럼을 리턴하는 서브쿼리만 사용 가능
메인 쿼리의 하나의 컬럼처럼 인식;
SELECT 'X', (SELECT SYSDATE FROM dual)
FROM dual;

SCALAR SUB QUERY는 하나의 행, 하나의 컬럼을 반환해야 한다.
SELECT 'X', (SELECT empno, ename FROM emp WHERE ename = 'SMITH')
FROM dual;
--행은 하나지만 컬럼이 2개여서 에러가 발생한다.

다중행 하나의 컬럼을 리턴하는 스칼라 서브쿼리
SELECT 'X', (SELECT empno FROM emp)
FROM dual;                    
--컬럼은 하나지만 행이 여러개라서 에러가 발생한다.

emp테이블만 사용할 경우 해당 직원의 소속 부서 이름을 알 수가 없다. ==> JOIN
특정 부서의 부서 이름을 조회하는 쿼리
SELECT dname
FROM dept
WHERE deptno = 10;

--JOIN 복습
SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;
--위 쿼리를 스칼라 서브쿼리로 변경
SELECT empno, ename, emp.deptno, (SELECT dname FROM dept WHERE deptno = emp.deptno) --'deptno = 10'이라고 작성하면 모든 직원의 dname이 ACCOUNTING으로 나온다. 해결하기 위해 emp.deptno입력 
FROM emp;

서브쿼리 구분 - 메인쿼리의 컬럼을 서브쿼리에서 사용하는지 여부에 따른 구분
상호연관 서브쿼리(corelated sub query)
    . 메인쿼리가 실행되어야 서브쿼리가 실행이 가능하다.
    . 
비상호 연관 서브쿼리(non corelated sub query)
    . 서브쿼리가 단독적으로 실행 가능하다.
    . 메인쿼리의 테이블을 먼저 조회할 수도, 서브쿼리의 테이블을 먼저 조회할 수도 있다. ==> 오라클이 판단 했을 때 성능상 유리한 방향으로 실행한다.
    
--연습
모든 직원의 급여 평균 보다 많은 급여를 받는 직원 정보 조회하는 쿼리를 작성하세요.(sub query 이용)
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal) FROM emp);
생각해볼 문제, 위의 쿼리는 상호 연관 서브쿼리인가? 비상호 연관 서브쿼리인가? ==> 비상호 연관 서브쿼리

직원이 속한 부서의 급여 평균보다 많은 급여를 받는 직원
전체 직원의 급여 평균 ==> 직원이 속한 부서의 급여 평균

특정 부서의 급여 평균을 구하는 SQL
SELECT AVG(sal)
FROM emp
WHERE deptno = 10;
    
SELECT *
FROM emp a
WHERE sal > (SELECT AVG(sal) FROM emp WHERE deptno = a.deptno); ==> 상호 연관 서브쿼리

SELECT *
FROM emp a
WHERE sal > (SELECT AVG(sal) FROM emp WHERE deptno = a.deptno);

SELECT *
FROM dept;
    
INSERT INTO dept VALUES(99, 'ddit', 'daejeon');

emp테이블에 등록된 직원들은 10, 20, 30번 부서에만 소속이 되어있음
직원 소속되지 않은 부서 : 40, 99
--sub4
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno FROM emp);

직원이 한명이라도 존재하는 부서
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
                              WHERE cycle.pid = product.pid AND cycle.cid = 2) a; --서브쿼리에 있는 데이터를 메인쿼리에서 참조는 안된다.
                              
스칼라 서브쿼리를 이용한 방법
SELECT cnm FROM customer WHERE cid = 1;
SELECT pnm FROM product WHERE pid = 100;

SELECT cid, (SELECT cnm FROM customer WHERE cid = cycle.cid) cnm, pid, (SELECT pnm FROM product WHERE pid = cycle.pid) pnm, day, cnt
FROM cycle
WHERE cid = 1 AND pid IN(SELECT pid FROM cycle WHERE cid = 2);

조인을 이용한 방법 -- 일반적으로 더 좋은 쿼리 작성 방법(실행횟수가 더 작을 확률이 높다)
SELECT cycle.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM cycle, customer, product
WHERE cycle.cid = customer.cid AND cycle.pid = product.pid AND cycle.cid = 1 AND cycle.pid IN (SELECT pid FROM cycle WHERE cid =2);

