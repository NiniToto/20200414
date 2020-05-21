SELECT dt
FROM gis_dt;

dt 컬럼에는 데이터가 5/8 ~ 6/7에 해당하는 데이터 타입 자료가 저장되어 있는데
5/1 ~ 5/31에 해당하는 날짜(년월일)를 중복없이 조회하고 싶다.
원하는 결과 : 5/8 ~ 5/31 최대 24개의 행을 조회하고 싶은 상황

0.293초
SELECT TO_CHAR(dt, 'YYYYMMDD'), COUNT (*)
FROM gis_dt
WHERE dt BETWEEN TO_DATE('20200508', 'YYYYMMDD') AND TO_DATE('20200531 23:59:59', 'YYYYMMDD HH24:MI:SS')
GROUP BY TO_CHAR(dt, 'YYYYMMDD')
ORDER BY TO_CHAR(dt, 'YYYYMMDD');

1.EXISTS ==>

우리가 원하는 답의 최대 행의 결과 : 31

SELECT TO_CHAR(d, 'YYYYMMDD')
FROM
    (SELECT TO_DATE('20200501', 'YYYYMMDD') + (LEVEL - 1) d
    FROM dual
    CONNECT BY LEVEL <= 31) a
WHERE EXISTS (SELECT 'X'
                FROM gis_dt
                WHERE dt BETWEEN TO_DATE(TO_CHAR(d, 'YYYYMMDD') || '00:00:00', 'YYYYMMDDHH24:MI:SS') 
                             AND TO_DATE(TO_CHAR(d, 'YYYYMMDD') || '23:59:59', 'YYYYMMDDHH24:MI:SS'));

============================================================================================

PL/SQL ==> PL/SQL로 생성하는 것은 오라클 객체
        . 코드 자체가 오라클에 존재
        . 로직이 바뀌어도 일반 프로그래밍 언어는 수정할 필요가 없다
        
SQL ==> SQL 실행은 일반 언어에서 실행(java)
        .만약 sql과 관련된 로직이 바뀌면 java파일을 수정할 가능성이 크다.

PL/SQL : Procedual Language / Structured Query Language
SQL : 집합적, 로직이 별로 없다

개발을 하다보면 어떤 조건에 따라 조회해야 할 테이블 자체가 바뀌거나, 
로직을 스킵하는 등의 절차적인 부분이 필요할 때가 있다

DBMS상에서 복잡한 로직을 SQL로 작성하면 복잡하다(유지보수도 어려움)
일반적인 프로그래밍 언어에서 사용하는 조건제어(if, case), 반복문(for, while), 변수 등을 활용할 수 있는 PL/SQL이 등장

대입 연산자
java =
pl/sql :=

java에서 sysout ==> console에 출력
PL/SQL에도 존재
SET SERVEROUTPUT ON; 로그를 콘솔창에 출력가능하게끔 하는 설정

PL/SQL BLOCK의 기본구조
DECLARE : 선언부 (변수 등을 선언, 생략가능)
BEGIN : 실행부 (로직이 서술되는 부분)
EXCEPTION : 예외부 (예외가 발생 했을 때 CATCH하여 다른 로직을 실행하는 부분)(= try-catch)

PL/SQL 익명(이름이 없는, 일회성) 블록;

DECLARE
    /*JAVA : TYPE 변수명
    PL/SQL : 변수명 TYPE*/
    
    v_deptno NUMBER(2);
    v_dname VARCHAR2(14);
    
BEGIN
    /*dept 테이블의 10번 부서에 해당하는 부서번호, 부서명을 DECLARE절에 선언한 두개의 변수에 담기*/
    
    SELECT deptno, dname INTO v_deptno, v_dname
    FROM dept
    WHERE deptno = 10;
    
    /*JAVA의 SYSOUT*/
    DBMS_OUTPUT.PUT_LINE(v_deptno ||'     '|| v_dname);
END;
/

데이터 타입 참조
v_deptno, v_dname 두개의 변수 선언 ==> dept 테이블의 컬럼 값을 담으려고 선언
                                 ==> dept 테이블의 컬럼 데이터 타입과 동일하게 선언하고 싶은 상황
                                 
데이터 타입을 직접 선언하지 않고 테이블의 컬럼 타입을 참조하도록 선언할 수 있다.
테이블명.컬럼명%TYPE;
==> 테이블 구조가 바뀌어도 pl/sql 블록에 선언된 데이터 타입은 변경하지 않아도 자동으로 적용된다.
 
DECLARE
    v_deptno DEPT.DEPTNO%TYPE;
    v_dname DEPT.DNAME%TYPE;
BEGIN
    SELECT deptno, dname INTO v_deptno, v_dname
    FROM dept
    WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE(v_deptno ||'     '|| v_dname);
END;
/
 
함수를 사용하는 경우 : 회사만의 특이한 로직이 필요한 경우, ...

PROCEDURE : 이름이 있는 PL/SQL 블록, 리턴값이 없다.
            로직에 따라 처리 후 데이터를 다른 테이블 입력하는 등의 비즈니스 로직을 처리할 때 사용
            오라클 객체 ==> 오라클 서버에 저장이 된다.
            권한이 있는 사람들은 프로시져 이름을 통해 재사용이 가능
            
CREATE OR REPLACE PROCEDURE printdept (p_deptno IN dept.deptno%TYPE) IS
--선언부
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    
BEGIN
    SELECT deptno, dname INTO v_deptno, v_dname
    FROM dept
    WHERE deptno = p_deptno;
    
    DBMS_OUTPUT.PUT_LINE(v_deptno ||'         '|| v_dname);
END;
/

프로시저 실행 방법 : EXEC 프로시저 이름;

EXEC printdept;

인자가 있는 printdept 실행
EXEC printdept(10);
EXEC printdept(20);
EXEC printdept(30);

PL/SQL 에서는 SELECT 쿼리를 실행 헀을 때 데이터가 한건도 안나올 경우 NO_DATA_FOUND 예외를 던진다.
EXEC printdept(50);

pro_1]
CREATE OR REPLACE PROCEDURE printemp (p_empno IN emp.empno%TYPE) IS
    v_ename  emp.ename%TYPE;
    v_dname  dept.dname%TYPE;
BEGIN 
    SELECT ename, dname INTO v_ename, v_dname
    FROM emp, dept
    WHERE emp.deptno = dept.deptno AND empno = p_empno;
    
    DBMS_OUTPUT.PUT_LINE(v_ename ||'         '|| v_dname);
END;
/

EXEC printemp(7369);--simth
EXEC printemp(7499);--allen
EXEC printemp(7839);--king

pro_2]
CREATE OR REPLACE PROCEDURE registdept_test (p_deptno IN dept.deptno%TYPE, p_dname IN dept.dname%TYPE, p_loc IN dept.loc%TYPE) IS
    
BEGIN
    INSERT INTO dept_test (deptno, dname, loc) VALUES (p_deptno, p_dname, p_loc);
END;
/

EXEC registdept_test(99,'ddit','daejeon');

SELECT *
FROM dept_test;

pro_3]
CREATE OR REPLACE PROCEDURE UPDATEdept_test (p_deptno IN dept.deptno%TYPE, p_dname IN dept.dname%TYPE, p_loc IN dept.loc%TYPE) IS
    
BEGIN
    UPDATE dept_test SET deptno = p_deptno, dname = p_dname,  loc = p_loc;
END;
/

EXEC UPDATEdept_test(99,'ddit_m','daejeon');

SELECT *
FROM dept_test;


복합변수
조회결과를 컬럼당 하나의 변수에 담는 작업 번거롭다
==> 복합 변수를 사용하여 불편함을 해소

0. %TYPE : 컬럼
1. %ROWTYPE : 특정 테이블의 행의 모든 컬럼을 저장할 수 있는 참조 변수 타입
    (유사 : %TYPE - 특정 테이블의 컬럼 타입을 참조)
2. PL/SQL RECORD : 행을 저장할 수 있는 타입, 컬럼을 개발자가 직접 기술
                    테이블의 모든 컬럼을 사용하는게 아니라 컬럼중 일부만 사용하고 싶을 때
3. PL/SQL TABLE TYPE : 여러개의 행, 컬럼을 저장할 수 있는 타입

%ROWTYPE
익명블럭으로 dept 테이블의 10번 부서정보를 조회하여 %ROWTYPE으로 선언한 변수에
결과값을 저장하고 DBMS_OUTPUT.PUT_LINE을 이용하여 출력


DECLARE
        v_dept_row dept%ROWTYPE;
BEGIN
        SELECT * INTO v_dept_row
        FROM dept
        WHERE deptno = 10;
        
        DBMS_OUTPUT.PUT_LINE(v_dept_row.deptno || '/' || v_dept_row.dname || '/' || v_dept_row.loc);
END;
/

%RECORD : 행을 저장할 수 있는 변수타입, 컬럼 정보는 개발자가 직접 선언할 수 있다.
dept테이블에서 deptno, dname 두개 컬럼만 행단위로 저장하고 싶을 때

DECLARE
    /*deptno, dname 컬럼 두개를 같이 저장할 수 있는 TYPE을 생성*/
    TYPE dept_rec IS RECORD(
        deptno dept.deptno%TYPE,
        dname dept.dname%TYPE);
        
        /*새롭게 만든 타입으로 변수를 선언 (class만들고 인스턴스 생성)*/
        v_dept_rec dept_rec;
BEGIN
    SELECT deptno, dname INTO v_dept_rec
    FROM dept
    WHERE deptno = 10;

    DBMS_OUTPUT.PUT_LINE(v_dept_rec.deptno || '     ' || v_dept_rec.dname);
END;
/

복수행을 리턴할 때 비교
SELECT 결과가 복수행이기 때문에 하나의 행 정보를 담을 수 있는 ROWTYPE 변수에는
값을 담을 수가 없어 에러 발생
==> 여러 행을 저장할 수 있는 TABLE TYPE 사용

DECLARE
        v_dept_row dept%ROWTYPE;
BEGIN
        SELECT * INTO v_dept_row
        FROM dept
        
        DBMS_OUTPUT.PUT_LINE(v_dept_row.deptno || '/' || v_dept_row.dname || '/' || v_dept_row.loc);
END;
/

TABLE TYPE : 여러행을 저장할 수 있는 타입
문법
TYPE 타입명 IS TABLE OF 행 타입 INDEX BY 인덱스에 대한 타입;
dept 테이블의 행 정보를 저장할 수 있는 테이블 TYPE
    java : ArrayList<Dept> dept_tab = new ArrayList<Dept>();
    
    java에서는 인덱스가 정수(BINARY_INTEGER), 
    PL/SQL에서는 인덱스가 정수(BINARY_INTEGER), 문자열(VARCHAR(2))
    
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    
DECLARE
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    v_dept dept_tab;
BEGIN
    SELECT * BULK COLLECT INTO v_dept --여러 행을 한꺼번에 가져올 때 사용하는 키워드 :  BULK COLLECT INTO
    FROM dept;
END;
/






