SELECT COUNT(*) cnt
FROM
    (SELECT deptno
     FROM emp
     GROUP BY deptno); --INLINE-VIEW를 통해서 해당 결과를 테이블로 만든다.
     
DBMS : DataBase Management System
==> db
RDBMS : Relational DataBase Management System
==> 관계형 데이터베이스 관리 시스템

JOIN 문법의 종류
ANSI - 표준
벤더사의 문법(ORACLE)

NATURAL JOIN : -- 활용도가 떨어진다
    . 조인하려는 두 테이블의 연결고리 컬럼의 이름이 같을 경우
    . emp, dept 테이블에는 deptno라는 공통된(동일한 이름, 타입) 연결고리 컬럼이 존재하는 경우
    . 다른 ANSI-SQL 문법을 통해서 대체가 가능하고, 조인 테이블들의 컬럼명이 동일하지 않으면 사용이 불가능하기 때문에
      사용빈도는 다소 낮다.
    
JOIN의 경우 다른 테이블의 컬럼을 사용할 수 있기 때문에
SELECT할 수 있는 컬럼의 개수가 많아진다. ==> 가로 확장         (cf. 세로 확장 ==> 집합 연산

조인하려고 하는 컬럼을 별도로 기술하지 않음
SELECT *
FROM emp NATURAL JOIN dept;
--두 테이블의 이름이 동일한 컬럼(deptno)으로 연결한다.

ORACLE의 경우 조인 문법을 ANSI 문법처럼 세분화하지 않음
오라클 조인 문법
    1. 조인할 테이블 목록을 FROM 절에 기술하며 구분자는 콜론(,)
    2. 연결고리 조건을 WHERE절에 기술하면 된다. (ex :  WHERE emp.deptno = dept.deptno)
    
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

deptno가 10번인 직원들만 조회
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno AND emp.deptno = 10; --동시에 만족해야하는 조건이므로 AND가 와야하고 확정자를 통해 emp.deptno처럼 명시적으로 표시해줘야 한다.

ANSI-SQL : JOIN with USING -- 많이 사용하지 않는다.
    . join 하려는 테이블간 이름이 같은 컬럼이 2개 이상일 때
    . 개발자가 하나의 컬럼으로만 조인하고 싶을 때 조인 컬럼명을 기술
    
SELECT *
FROM emp JOIN dept USING (deptno);

ANSI-SQL : JOIN with ON -- 많이 사용한다.
    . 조인하려는 두 테이블간 컬럼명이 다를 때
    . ON절에 연결고리 조건을 기술
    
SELECT *
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

--ORACLE문법으로 다시 작성해보기 ==> ANSI-SQL에서 사용한 3가지 문법이 모두 하나로 표현 가능.
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;


JOIN의 논리적인 구분
1. SELF JOIN : 조인하려는 테이블이 서로 같을 때
    ex)
    EMP 테이블의 한 행은 직원의 정보를 나타내고 직원의 정보 중 mgr 컬럼은 해당 직원의 관리자 사번을 표시
    해당 직원의 관리자의 이름을 알고싶을 때

ANSI-SQL로 SQL 조인 :
    . 조인하려고 하는 테이블 EMP(직원), EMP(직원의 관리자)
    . 연결고리 컬럼 : 직원.mgr = 관리자.empno
    . 조인 컬럼 이름이 다르다(MGR, EMPNO)
    . NATURAL JOIN, JOIN with USING은 사용이 불가능한 형태
    . JOIN with ON을 사용
    
SELECT *
FROM emp e JOIN emp m ON (e.mgr = m.empno); --테이블에 alias를 줌으로써 같은 테이블 간에도 구분을 명확하게 할 수 있다.

NONEQUI JOIN : 연결고리 조건이 = 이 아닐 때

그 동안 WHERE에서 사용한 연산자 : =, !=, <>, <=, <, >, >=, AND, OR, NOT, LIKE(%,_), IN,BETWEEN AND

SELECT *
FROM emp;

SELECT *
FROM salgrade;

SELECT emp.empno, emp.ename, emp.sal, salgrade.grade
FROM emp JOIN salgrade ON (emp.sal BETWEEN salgrade.losal AND salgrade.hisal);

--ORACLE 조인 문법으로 변경
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
WHERE dept.deptno IN (10,30); --ON절 안에 조인할려고 하는 대상을 넣어주는 것이 구분하기에 더 쉽다.


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

-- =에 대한 강박관념을 가지지 말고 논리적으로 생각해보기.

--join1
SELECT lprod.lprod_gu,lprod.lprod_nm, prod.prod_id, prod.prod_name -- 하나의 테이블에만 존재하는 컬럼은 테이블.컬럼 형식을 사용하지 않아도 된다.
FROM prod, lprod  --lprod가 상위 테이블이므로 먼저 기술해주는게 가독성면에서 좋다.
WHERE prod.prod_lgu = lprod_gu;
--기본적으로 oracle에서 50개의 행만을 먼저 출력해주는 페이징처리가 되어있다.
SELECT lprod.lprod_gu,lprod.lprod_nm, prod.prod_id, prod.prod_name
FROM prod JOIN lprod ON(prod.prod_lgu = lprod_gu);























