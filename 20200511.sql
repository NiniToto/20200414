부모-자식 관계 테이블

    1. 테이블 생성 시 순서
      1] 부모(dept)
      2] 자식(emp)
      
    2. 데이터 생성 시 (INSERT) 순서
      1] 부모(dept)
      2] 자식(emp)
      
    3. 데이터 삭제 시 (DELETE) 순서
      1] 자식(emp)
      2] 부모(dept)

테이블 변경 시(테이블이 이미 생성되어 있는 경우) 제약조건 추가 삭제
DROP TABLE emp_test;

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2)
);

테이블 생성 시 제약조건을 특별히 생성하지 않음

테이블 변경을 통한 PRIMARY KEY 추가
문법 : ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건명 제약조건타입 (적용할 컬럼[, ...]);
제약조건 타입 : UNIQUE, PRIMARY KEY, FOREIGN KEY, CHECK (+ NOT NULL)
ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test PRIMARY KEY (empno);

DESC emp_test;

테이블 변경 시 제약조건 삭제
문법 : ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;
ALTER TABLE emp_test DROP CONSTRAINT pk_emp_test;

테이블 생성 이후 FOREIGN KEY(외래키) 추가 실습
emp_test.deptno => dept_test.deptno;
참조되는 쪽에 INDEX가 꼭 있어야 한다.
dept_test테이블의 deptno에 인덱스 생성 되어있는지 확인
ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건명 제약조건타입 (컬럼) REFERENCES 참조테이블명 (참조테이블컬럼명)

ALTER TABLE emp_test ADD CONSTRAINT fk_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test (deptno);
                            
삭제는 동일
ALTER TABLE emp_test DROP CONSTRAINT fk_emp_test_dept_test;

제약조건 활성화/비활성화
테이블에 설정된 제약조건을 삭제하는 것이 아니라 잠시 기능을 끄고, 켜는 설정
문법 : ALTER TABLE 테이블명 ENABLE/DISABLE CONSTRAINT 제약조건명;

위에서 설정한 fk_emp_test_dept_test FOREIGN KEY 제약조건을 비활성화
ALTER TABLE emp_test DISABLE CONSTRAINT fk_emp_test_dept_test;

dept(부모)테이블에는 99번 부서만 존재하는 상황
SELECT *
FROM dept_test;

fk_emp_test_dept_test 제약조건이 비활성화
SELECT *
FROM emp_test;

emp_test테이블에는 99번 부서 이외의 값이 입력 가능한 상황
INSERT INTO emp_test VALUES (9999, 'brown', 88);

현재 상황 : emp_test 테이블에 dept_test 테이블에 존재하지 않는 88번 부서를 사용하고 있는 상황 ==> 데이터의 무결성이 깨진 상태
            fk_emp_test_dept_test 제약조건은 비활성화된 상태
ALTER TABLE emp_test ENABLE CONSTRAINT fk_emp_test_dept_test; --데이터 무결성을 지킬 수 없으므로 활성화될 수 없다.

emp, dept 테이블에는 현재 PRIMARY KEY, FOREIGN KEY 제약이 걸려 있지 않은 상황
emp테이블은 empno를 key로
dept테이블은 deptno를 key로 하는 PRIMARY KEY 제약을 추가하고
emp.deptno ==> dept.deptno를 참조하도록 FOREIGN KEY를 추가

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
ALTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY (deptno);

ALTER TABLE emp ADD CONSTRAINT fk_emp_dept FOREIGN KEY (deptno) REFERENCES dept (deptno);

DESC emp;
DESC dept;

제약조건 확인
1. 툴에서 제공해주는 메뉴(테이블 선택 => 제약조건 tab)
2. USER_CONSTRAINTS
   (SELECT *
    FROM USER_CONSTRAINTS);
2.1 USER_CONS_COLUMNS
    (SELECT *
    FROM USER_CONS_COLUMNS);

컬럼확인
1.툴
2.SELECT *
3.DESC
4.DATA DICTIONARY, 오라클에서 내부적으로 관리하는 view
  (SELECT *
  FROM USER_TAB_COLUMNS
  WHERE TABLE_NAME = 'EMP');

SELECT 'SELECT * FROM ' || TABLE_NAME || ';'
FROM USER_TABLES;

테이블, 컬럼 주석 : USER_TAB_COMMENTS, USER_COL_COMMENTS;
SELECT *
FROM user_tab_comments;

테이블의 개수가 많은 경우 : 
테이블 명명 => 카테코리 + 일련번호

테이블의 주석 생성하기
문법 : COMMENT ON TABLE 테이블명 IS '주석';
COMMENT ON TABLE emp IS '직원';

컬럼주석 확인
SELECT *
FROM user_col_comments
WHERE TABLE_NAME = 'EMP';

컬럼 주석 생성
COMMENT ON COLUMN 테이블명.컬럼명 IS '주석';

COMMENT ON COLUMN emp.empno IS '사번';
COMMENT ON COLUMN emp.ename IS '이름';
COMMENT ON COLUMN emp.hiredate IS '입사일자';

comment1]
SELECT *
FROM user_tab_comments;

SELECT *
FROM user_col_comments;

SELECT t.table_name, t.table_type, t.comments tab_comment, c.column_name, c.comments col_comment
FROM user_tab_comments t, user_col_comments c
WHERE t.table_name = c.table_name 
  AND (t.table_name = 'CUSTOMER' OR t.table_name = 'PRODUCT' OR t.table_name = 'CYCLE' OR t.table_name = 'DAILY');

SELECT t.table_name, t.table_type, t.comments tab_comment, c.column_name, c.comments col_comment
FROM user_tab_comments t, user_col_comments c
WHERE t.table_name = c.table_name 
  AND t.table_name IN('CUSTOMER', 'PRODUCT', 'CYCLE', 'DAILY'); -- IN연산자를 사용하자!


VIEW : 쿼리
논리적인 데이터 집합 =  SQL      (물리적인 데이터 집합이 아니다.)
문법 : CREATE [OR REPLACE] VIEW 뷰이름 [컬럼별칭1, 컬럼별칭2 ,...] AS
        SELECT 쿼리;
(VIEW를 생성하기 위해서는 CREATE VIEW 권한을 갖고 있어야 한다.(DBA설정)
-SYSTEM 계정을 통해서 GRANT CREATE VIEW TO 계정(뷰생성권한을 부여할)

emp테이블에서 sal, comm컬럼을 제외한 6가지 컬럼만 조회가 가능한 v_emp view를 생성
SELECT *
FROM emp;

CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

SELECT *
FROM v_emp;

v_emp VIEW를 조회할 수 있도록 권한 부여
1. 권한 부여 전 hr계정에서 v_emp VIEW 조회
SELECT *
FROM WONWOO.v_emp; --접속 이름이 아니라 사용자 이름으로 해야한다.

2.hr계정으로 권한 부여
GRANT SELECT ON v_emp TO HR;

3.hr계정에서 v_emp 다시 조회
SELECT *
FROM WONWOO.v_emp;

VIEW 사용 용도
  . 데이터 보안(불필요한 컬럼 공개를 제한)
  . 자주 사용하는 복잡한 쿼리를 재사용
    . INLINE-VIEW를 사용해도 동일한 결과를 만들 수 있으나 MAIN쿼리가 길어지는 단점이 있다.
    
실습
v_emp_dept 뷰를 생성
emp, dept 테이블을 deptno컬럼으로 조인하고
emp.empno, ename, dept.deptno, dname 4개의 컬럼으로 구성

CREATE OR REPLACE VIEW v_emp_dept AS
SELECT emp.empno, ename, dept.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT *
FROM v_emp_dept;

VIEW 삭제
문법 : DROP VIEW 뷰이름;

VIEW를 통한 DML 처리
SIMPLE VIEW일 때만 가능
SIMPLE VIEW : 조인되지 않고, 함수, GROUP BY, ROWNUM을 사용하지 않은 간단한 형태의 VIEW
COMPLEX VIEW : 그 외

v_emp : SIMPLE VIEW

SELECT *
FROM v_emp;

v_emp를 통해 7369 SMITH 사원의 이름을 brown으로 변경
UPDATE v_emp SET ename = 'brown'
WHERE empno = 7369;

v_emp에는 sal 컬럼이 없으므로 실행할 수 없다.
UPDATE v_emp SET sal = 1000
WHERE empno = 7369;

ROLLBACK;

SELECT *
FROM emp;


SEQUENCE
유일한 정수값을 생성해주는 오라클 객체
인조 식별자 값을 생성할 때 주로 사용

식별자 ==> 해당 행을 유일하게 구별할 수 있는 값
본질 <==> 인조 식별자

일반적으로 어떤 테이블(엔터티)의 식별자를 정하는 방법은
[누가], [언제], [무엇을]

게시판의 게시글 : 게시글 작성자가, 언제, 어떤 글을, 작성 했는지
게시글의 식별자 : 작성자id, 작성일자, 글제목
    ==> 본질 식별자가 너무 복잡하기 때문에 개발의 용이성을 위해
        본질 식별자를 대체할 수 있는 (중복되지 않는) 인조 식별자를 이용


개발을 하다보면 유일한 값을 생성해야할 때가 있다.
ex : 사번, 학번, 게시글 번호, ...
     사번, 학번 : 체계
     게시글 번호 : 체계가 없지만 겹치지 않는 순번
     
체계가 있는 경우는 자동화되지 보다는 사람의 손을 타는 경우가 많음
체계가 없는 경우는 자동화가 가능 ==> SEQUENCE 객체를 활용하여 손쉽게 구현 가능
                                ==> 중복되지 않는 정수 값을 반환
                                
중복되지 않는 값을 생성하는 방법
1. KEY TABLE을 생성
    ==> SELECT FOR UPDATE 동시성을 방지할 수 있다.
    ==> 손이 좀 많이 가는 방법이다.
    ==> 하지만 값을 이쁘게 유지하는게 가능하다.(SEQUENCE 에서는 불가능하다)

2. JAVA의 UUID 클래스를 활용, 별도의 라이브러리 활용(유료) ==> 금융권, 보험, 카드사...같은 곳에서 사용한다.

3. ORCLE DB - SEQUENCE

SEQUENCE 생성
문법 : CREATE SEQUENCE 시퀀스명;

seq_emp 시퀀스 생성
CREATE SEQUENCE seq_emp;

사용법 : 객체에서 제공해주는 함수를 통해서 값을 받아온다.
NEXTVAL : 시퀀스를 통해 새로운 값을 받아온다.
CURRVAL : 시퀀스 객체의 NEXTVAL을 통해 얻어온 값을 다시한번 확인할 때 사용
            (트랜잭션에서 NEXTVAL 실행하고 나서 사용이 가능);
            
SELECT seq_emp.NEXTVAL            
FROM dual;

NEXTVAL을 실행하면 지속적으로 증가하므로 CURRVAL을 통해서 여러 곳에서 읽어온 값을 그대로 사용 가능하다.
SELECT seq_emp.CURRVAL            
FROM dual;

SELECT *
FROM emp_test;

SEQUENCE 를 통한 중복되지 않는 empno 값 생성하여 INSERT하기
INSERT INTO emp_test VALUES (seq_emp.NEXTVAL, 'sally', 88);




