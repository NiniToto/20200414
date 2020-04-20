/*
테이블에는 저장,조회 순서가 없다.
==> ORDER BY 컬럼명 정렬방식, ...
*/

참고*
ORDER BY 컬럼순서 번호
==> SELECT의 3번째 컬럼을 기준으로 정렬
단점) SELECT 컬럼의 순서가 바뀌거나, 컬럼이 추가가 되면 원래 의도대로 동작하지 않을 가능성이 있음

SELECT *
FROM emp
ORDER BY 3;

별칭으로 정렬이 가능하다
컬럼에다가 연산을 통해 새로운 컬럼을 만드는 경우
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
--null값의 연산의 항상 null이므로 WHERE comm != 0으로만 적용해도 알맞는 답이 나온다.

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
페이징 처리를 하는 이유
1. 데이터가 너무 많아서
    . 한 화면에 담으면 사용성이 떨어진다.
    . 성능면에서 느려진다.

오라클에서 페이징 처리 방법 ==> ROWNUM
*/

ROWNUM : SELECT 순서대로 1번부터 차례대로 번호를 부여해주는 특수 KEYWORD

SELECT ROWNUM, empno, ename
FROM emp;

SELCET 절에 *표기하고 콤바를 통해 다른 표현(ex ROWNUM)을 기술할 경우
*앞에 어떤 테이블에 대한건지 테이블 명칭, 별칭을 기술해야 한다.

SELECT ROWNUM, e.*
FROM emp e;

페이징 처리를 위해 필요한 사항 : 
1. 페이지 사이즈(10)
2. 데이터 정렬 기준

1page : 1 ~ 10
2page : 11 ~ 20 (11 ~ 14)

-- 1페이지 페이징 쿼리
SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 10;

-- 2페이지 페이징 쿼리
SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 11 AND 20;

ROWNUM의 특징
1. ORACLE에만 존재
    . 다른 DBMS의 경우 페이징 처리를 위한 별도의 키워드가 제공 (ex. LIMIT)
2. 1번부터 순차적으로 읽는 경우만 가능
    ROWNUM BETWEEN 1 AND 10 ==> 1 ~ 10
    ROWNUM BETWEEN 11 AND 20 ==> 1 ~ 10을 SKIP 하고 11~ 20을 읽으려고 시도 --> X
    
    WHERE 절에서 ROWNUM을 사용할 경우 다음 형태
    ROWNUM = 1;
    ROWNUM BETWEEN 1 AND N;
    ROWNUM <, <= N; ( 1~ N )

SELECT ROWNUM, empno, ename
FROM emp
ORDER BY empno;

SELECT ROWNUM, empno, ename
FROM emp
ORDER BY ename;

ROWNUM은 ORDER BY 이전에 실행된다.
SELECT -> ROWNUM -> ORDER BY

ROWNUM의 실행순서에 의해 정렬이 된 상태로 ROWNUM을 부여하려면 IN-LINE VIEW 를 사용해야한다.
**IN-LINE : 직접 기술을 했다;

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

--sql에서는 변수를 선언하기 위해 : 을 사용
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

IN-LINE VIEW와 비교를 위해 VIEW를 직접 생성(선행학습, 나중에 나온다)
VIEW - 쿼리

DML - Data Manipulation Language : SELECT, INSERT, UPDATE, DELETE
DDL - Data Definition Language : CREATE, DROP, MODIFY, RENAME

CREATE OR REPLACE VIEW emp_ord_by_ename AS
    SELECT empno, ename
    FROM emp
    ORDER BY ename;
    
IN-LINE VIEW로 작성한 쿼리
SELECT *
FROM (SELECT empno, ename
        FROM emp
        ORDER BY ename);
        
VIEW로 작성한 쿼리
SELECT *
FROM emp_ord_by_ename;

emp 테이블에 데이터를 추가하면
IN-LINE VIEW, VIEW를 사용한 쿼리의 결과는 어떻게 영향을 받을까?

--view 테이블은 틀린 말로, view는 sql이기떄문에 실체가 없다.

쿼리 작성 시 문제점 찾아가기
JAVA : 디버깅
SQL : 디버깅 툴이 없다.

페이징 처리 == 정렬, ROWNUM
정렬, ROWNUM을 하나의 쿼리에서 실행할 경우 ROWNUM이후 정렬을 하여 숫자가 섞이는 현상 발생
==>IN-LINE VIEW로 해결
1. 정렬에 대한 IN-LINE VIEW
2. ROWNUM에 대한 IN-LINE VIEW

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






