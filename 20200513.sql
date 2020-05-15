CREATE TABLE dept_test2 AS
SELECT *
FROM dept
WHERE 1 = 1;

SELECT *
FROM dept_test2;

idx1]
CREATE UNIQUE INDEX idx_u_dept_test2_01 ON dept_test2 (deptno);
CREATE INDEX idx_dept_test2_02 ON dept_test2 (dname);
CREATE INDEX idx_dept_test2_03 ON dept_test2 (deptno, dname);

idx3]
1. (empno) 
2. (ename) 
3. (deptno, empno)
4. (deptno sal) 
5. (empno, deptno)
6. (hiredate, deptno)

1. (empno) UI
2. (ename) NUI
3. (deptno) NUI
4. (deptno sal) NUI
5. (hiredate, deptno) NUI

CREATE UNIQUE INDEX idx_u_emp_01 ON emp (empno);
CREATE INDEX idx_emp_02 ON emp (ename);
CREATE INDEX idx_emp_03 ON emp (deptno); --> 04번과 중복되므로 빼도 된다.
CREATE INDEX idx_emp_04 ON emp (deptno sal); --> deptno, sal, mgr
CREATE INDEX idx_emp_05 ON emp (hiredate, deptno); --> group by만 사용되고 where절이 없으므로 컬럼 순서는 상관없다. 
-->아예 deptno sal mgr hiredate 4개 모두 합치는 것도 고려

-->인덱스를 통합해서 하나의 쿼리?컬럼?에 대해서 포기하더라도 인덱스 수를 줄이는 것도 고려해야한다.

EXPLAIN PLAN FOR
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.deptno = :deptno
AND emp.empno LIKE :empno || '%';

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 568005898
 
----------------------------------------------------------------------------------------
| Id  | Operation                    | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |         |     1 |    58 |     4   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                |         |     1 |    58 |     4   (0)| 00:00:01 |
|   2 |   TABLE ACCESS BY INDEX ROWID| DEPT    |     1 |    20 |     1   (0)| 00:00:01 |
|*  3 |    INDEX UNIQUE SCAN         | PK_DEPT |     1 |       |     0   (0)| 00:00:01 |
|*  4 |   TABLE ACCESS FULL          | EMP     |     1 |    38 |     3   (0)| 00:00:01 |
----------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - access("DEPT"."DEPTNO"=TO_NUMBER(:DEPTNO))
   4 - filter("EMP"."DEPTNO"=TO_NUMBER(:DEPTNO) AND TO_CHAR("EMP"."EMPNO") LIKE 
              :EMPNO||'%')



Plan hash value: 50904946
 
-------------------------------------------------------------------------------------------
| Id  | Operation                    | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
-------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |            |     1 |    58 |     2   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                |            |     1 |    58 |     2   (0)| 00:00:01 |
|   2 |   TABLE ACCESS BY INDEX ROWID| DEPT       |     1 |    20 |     1   (0)| 00:00:01 |
|*  3 |    INDEX UNIQUE SCAN         | PK_DEPT    |     1 |       |     0   (0)| 00:00:01 |
|*  4 |   TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    38 |     1   (0)| 00:00:01 |
|*  5 |    INDEX RANGE SCAN          | IDX_EMP_03 |     5 |       |     0   (0)| 00:00:01 |
-------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - access("DEPT"."DEPTNO"=TO_NUMBER(:DEPTNO))
   4 - filter(TO_CHAR("EMP"."EMPNO") LIKE :EMPNO||'%')
   5 - access("EMP"."DEPTNO"=TO_NUMBER(:DEPTNO))


수업시간에 배운 조인
==> 논리적인 조인 형태를 이야기한다. 기술적인 이야기가 아니다.
inner join : 조인에 성공하는 데이터만 조회하는 조인 기업
outer join : 조인에 실패해도 기준이 되는 테이블의 컬럼 정보는 조회하는 조인 기법
cross join : 묻지마 조인(카티션 프러덕트), 조인 조건을 기술하지 않아서 연결 가능한 모든 경우의 수로 조인되는 기법
self join : 같은 테이블끼리 조인하는 형태

개발자가 DBMS에 SQL을 실행 요청하면 DBMS는 SQL을 분석해서 어떻게 두 테이블을 연결할지를 결정한다.
이때 사용하는 3가지 물리적인 조인 방식이 있다. (기술적인 이야기이다.)
1. Nested Loop JOIN
2. Sort Merge JOIN
3. Hash JOIN

1. Nested Loop JOIN
 . 이중 루프와 유사
 . 가장 일반적인 조인 방법
 . 소량의 데이터를 조인할 때 사용
 . 빠른 응답성이 보장된다. ==> 조인된 결과를 실시간으로 보내주기 때문에...

2. Sort Merge JOIN
 . 조인 컬럼에 인덱스가 없는 경우
 . 대량의 데이터를 조인하는 경우에 사용
 . 조인되는 테이블을 각각 조인되는 컬럼으로 정렬한다. ==> 조인 조건에 해당하는 데이터를 찾기는 유리하다.
 . 정렬이 끝나야 연결이 가능하므로 응답성이 느리다.
 . 많이 사용되지는 않는다. ==> Hash JOIN으로 대체
 . 단, 조인 조건이 = 이 아니어도 사용 가능하다.
 
3. Hash JOIN
 . 조인 컬럼에 인덱스가 없을 경우
 . 조인 테이블의 건수가 한쪽이 많고 한쪽이 적은 경우 ==> Hash 값 테이블을 빨리 만드는게 중요하기 때문에... ==> 테이블을 빨리 만들고 보내서 비교하는게 유리하기 때문이다.
 . 연결 조건이 = 인 경우만 사용 가능하다.
 . HASH 함수 : 입력값의 길이,타입과 관계없이 Hash 함수 값으로 치환해주는 함수 (Hash 함수 값들의 길이는 동일, 복구가 불가능한 특징이 있다.)
 . Hash 함수 값이 같은 데이터끼리 연결한다. ==> 정렬 작업이 필요 없다.
 . Nested Loop join의 단점인 single I/O에 대한 부담도 없다. ==> cpu자원 이용

INDEX를 활용하지 못하는 경우
1. 컬럼을 가공 (좌변을 가공하지 마라와 일맥상통)
- 인덱스의 기준이 된 컬럼을 WHERE절에서 가공하면 다른 값이 된다.
2. 부정형 연산
- != 와 같은 형태는 데이터를 찾기가 힘들다.
3. NULL 비교
- IS (NOT)NULL... INDEX에는 NULL의 데이터가 포함되지 않기때문에... ==> NOT NULL 제약의 중요성 ==> 데이터가 무조건 들어간다고 판단되면 NOT NULL 제약조건을 걸어주는게 오라클에게 유리하다.
4. LIKE 연산시 선행 와일드 카드 
- '%T'와 같은 경우


SELECT *
FROM emp;
idx4]

CREATE UNIQUE INDEX idx_u_emp_01 ON emp (empno);
CREATE INDEX idx_dept_01 ON dept (deptno, loc);
CREATE INDEX idx_emp_02 ON emp (deptno, sal);


3. (emp) deptno, empno (dept) deptno
4. (emp) deptno, sal
5. (emp) deptno (dept) deptno, loc
