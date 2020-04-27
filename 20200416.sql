SELECT *          -- 모든 컬럼 정보를 조회
FROM prod;        -- 데이터를 조회할 테이블 기술

--특정 컬럼에 대해서만 조회 : SELECT 컬럼 1, 컬럼 2, ...
--prod_id, prod_name컬럼만 prod 테이블에서 조회;

SELECT prod_id, prod_name
FROM prod;

--prod 테이블에서 모든 데이터를 조회하는 쿼리를 작성하세요
SELECT *
FROM lprod;

--buyer 테이블에서 buyer_id, buyer_nmae 컬럼만 조회하는 쿼리를 작성하세요.
SELECT buyer_id, buyer_name
FROM buyer;

--cart 테리블에서 모든 데이터를 조회하는 쿼리를 작성하세요.
SELECT *
FROM cart;

--member 테이블에서 mem_id, mem_pass, mem_name 컬럼만 조회하는 쿼리를 작성하세요.
SELECT mem_id, mem_pass, mem_name
FROM member;

--SQL 연산 : JAVA와 다르게 대입 X, 일반적 사칙연산,
/* 
sql 데이터 타입 : 문자, 숫자, 날짜(date);
users 테이블이 (4/14 만들어 놓음) 존재
users 테이블의 모든 데이터를 조회;
*/

/*
날짜 타입에 대한 연산 : 날짜는 +, - 연산 가능
date type + 정수 :  date에서 정수날 만큼 미래로 이동
date type - 정수 :  date에서 정수날 만큼 과거로 이동
*/

SELECT userid, reg_dt, reg_dt + 5, reg_dt - 5
FROM users;

/*
컬럼 별칭 : 기존 컬럼명을 변경하고 싶을 때
syntax : 기존 컬럼명 [as] 별칭명칭
별칭 명칭에 공백이 표현되어야 할 경우 ""으로 묶는다.
또한 오라클에서는 객체명을 대문자 처리 하기 때문에 
소문자로 별칭을 지정하기 위해서도 ""을 사용한다.
*/

SELECT userid as id, userid id2, userid 아이디
FROM users;

SELECT prod_id id, prod_name name
FROM prod;

SELECT lprod_gu gu, lprod_nm nm
FROM lprod;

SELECT buyer_id 바이어아이디, buyer_name 이름
FROM buyer;

--문자열 연산(결합연산) : || (문자열 결합은 + 연산자가 아니다)
SELECT userid || 'test', reg_dt + 5, 'test', 15
FROM users;

SELECT 'name:' || userid, reg_dt + 364
FROM users;

SELECT '경 ' || userid || ' 축' 
FROM users;

SELECT userid || usernm
FROM users;

SELECT userid || usernm id_name,
     CONCAT(userid, usernm) AS concat_id_name
FROM users;

--sel_con1
/*
user_tables :  oracle에서 관리하는 테이블 정보를 담고 있는 뷰 --> data dictionary
*/

SELECT table_name
FROM user_tables;

SELECT 'SELECT * FROM ' || table_name || ';' AS query
FROM user_tables;

/*
테이블의 구성 컬럼을 확인할 줄 알아야 한다.
1.  tool(sql developer)을 통해 확인
    테이블 - 확인하고자 하는 테이블
    
2.  SELECT *
    FROM 테이블
    전체 조회 -> 모든 커럼이 표시
    
3.  DESC 테이블명

4. data dictionary : user_tab_columns
*/

DESC emp;

SELECT *
FROM user_tab_columns;

/*
지금까지 배운 SELECT 구분
조회하고자 하는 컬럼 기술 : SELECT
조회할 테이블 기술 : FROM
조회할 행을 제한하는 조건을 기술 : WHERE
WHERE 절에 기술한 조건이 참(TRUE)일 때 결과를 조회
*/

--sql의 비교 연산 : =

SELECT *
FROM users
WHERE userid = 'cony';

SELECT *
FROM users
WHERE userid = 'brown';

DESC emp;

SELECT *
FROM emp;

SELECT *
FROM dept;

--emp 테이블에서 직원이 속한 부서번호가 30번 보다 큰 부서에 속하 직원을 조회
SELECT *
FROM emp
WHERE deptno >= 30;

-- != 다를 때, users 테이블에서 사용자 아이디(userid)가 brown이 아닌 사용자를 조회

SELECT *
FROM users
WHERE userid != 'brown';

/*
SQL 리터럴
숫자 : 20, 30.4, ...
문자 : 싱글 퀘테이션
날짜 : TO_DATE('날짜문자열', '날짜 문자열의 형식')
*/

--1982년 1월 1일 이후에 입사한 직원만 조회
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('19820101', 'YYYYMMDD');

SELECT *
FROM emp
WHERE hiredate < TO_DATE('19820101', 'YYYYMMDD');


