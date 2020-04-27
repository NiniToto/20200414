 --fn3
 SELECT '201912' PARAM,
        (LAST_DAY(TO_DATE('201912', 'yyyymm')) -
        LAST_DAY(ADD_MONTHS(TO_DATE('201912', 'yyyymm'), -1) + 1)) DT
 FROM dual;
 
  SELECT '201912' PARAM,
        TO_CHAR(LAST_DAY(TO_DATE('201912', 'yyyymm')), 'dd') dt 
 FROM dual;
 
 SELECT '201912' PARAM,
        TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'yyyymm')), 'dd') dt 
 FROM dual;
 
 EXPLAIN PLAN FOR
 SELECT *
 FROM emp
 WHERE empno = '7369';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

/*
EXPLAIN PLAN FOR;
TABLE(DBMS_XPLAN.DISPLAY);

실행 계획을 보는 순서 (id)
* 들여쓰기 되어있으면 자식 오퍼레이션
1.위 -> 아래
  *단, 자식 오퍼레이션이 있으면 자식부터 읽는다.

--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 | 테이블의 전체 행을 읽었다
--------------------------------------------------------------------------
 읽은 순서 : 1 => 0
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7369) 형변환을 알아서 했음

*/

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

/*
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter(TO_CHAR("EMPNO")='7369') -- 모든 행에 대해 TO_CHAR 함수가 수행되었다. 잘못된 사용방법
*/

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7300 + '69';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

/*
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7369) -- 자동적으로 7369로 검색
*/

SELECT ename, sal, TO_CHAR(sal, 'L009,999.00')
FROM emp;


NULL과 관련된 함수
NVL
NVL2
NULLIF
COALESCE;

왜 null 처리를 해야할까?
NULL에 대한 연산결과는 NULL이다.

예를 들어서 emp 테이블에 존재하는 sal, comm 두개의 컬럼 값을 합한 값을 알고 싶어서
다음과 같이 SQL을 작성.

SELECT empno, ename, sal, comm, sal + comm sal_plus_comm
FROM emp;

SELECT empno, ename, sal, comm, NVL(sal + comm, sal) sal_plus_comm
FROM emp;

SELECT empno, ename, sal, comm, sal + NVL(comm, 0) sal_plus_comm
FROM emp;


NVL(expr1, expr2)
expr1이 null이면 expr2값을 리턴하고 expr1이 null이 아니면 expr1을 리턴

REG_DT 컬럼이 NULL일 경우 현재 날짜가 속한 월의 마지막 일자로 표현
SELECT userid, usernm, reg_dt
FROM users;

SELECT userid, usernm, NVL(reg_dt, LAST_DAY(SYSDATE))
FROM users;
























