NVL(expr1, expr2)
expr1 == null
    return expr2
expr1 != null
    return expr1
    
NVL2(expr1, expr2, expr3)
if expr1 != null
    return expr2
else
    return expr3

--pseudo code(의사 코드)

NULLIF(expr1, expr2)
if expr1 == expr2
    return null
else 
    return expr1
    
sal 컬럼의 값이 3000이면 null을 리턴
SELECT empno, ename, sal, NULLIF(sal, 3000)
FROM emp;

가변인자 : 함수의 인자의 개수가 정해져 있지 않음
        가변인자들의 타입은 동일해야함
COALESCE(expr1, expr2, ...)
if expr1 != null
    return expr1
else
    coalesce(expr2, expr3, ...)
null이 아닌 가장 먼저 나오는 인자를 리턴

mgr 컬럼 null
comm 컬럼 null

SELECT empno, ename, comm, sal, coalesce(comm, sal)
FROM emp;

--fn4
SELECT empno, ename, mgr, NVL(mgr, 9999) mgr_n, NVL2(mgr, mgr, 9999) mgr_n_1, coalesce(mgr, 9999, empno)
FROM emp;

--fn5
SELECT userid, usernm, reg_dt, NVL(reg_dt, SYSDATE) n_reg_dt
FROM users
WHERE userid != 'brown';

--Condtion
조건에 따라 컬럼 혹은 표현식을 다른 값으로 대체
java의 if, switch 같은 개념
1. case 구문
2. decode 함수

1.CASE

CASE
    WHEN 참/거짓을 판별할 수 있는 식 THEN 리턴할 값
    [WHEN 참/거짓을 판별할 수 있는 식 THEN 리턴할 값]
    [ELSE 리턴할 값 (참인 WHEN 절이 없을 경우 실행)]
END

/*
emp 테이블에 등록된 직원들에게 보너스를 추가적으로 지급할 예정
해당 직원의 job이 SALESMAN일 경우 SAL 5% 인상된 금액을 보너스로 지급
해당 직원의 job이 MANAGER일 경우 SAL 10% 인상된 금액을 보너스로 지급
해당 직원의 job이 PRESIDENT일 경우 SAL 20% 인상된 금액을 보너스로 지급
그 외 직원들은 SAL만큼만 지급
*/

SELECT empno, ename, job, sal,
    CASE
        WHEN job = 'SALESMAN' THEN SAL*1.05
        WHEN job = 'MANAGER' THEN SAL*1.1
        WHEN job = 'PRESIDENT' THEN SAL*1.2
        ELSE sal * 1
    END bonus    
FROM emp;

2. DECODE(expr1, 
                search1, return1, 
                search2, return2, 
                ...
                [default]) --가변인자
                
if expr 1 == search1
    return return1
else if expr1 == search2
    return return2
else if expr1 == search3
    return return3
...
else
    return default;
    
--코드의 가독성은 decode가 좋지만 ==밖에 사용할 수 없으므로 복잡해지는 경우에는 case를 쓰는게 좋다

SELECT empno, ename, job, sal,
        DECODE(job, 'SALESMAN', sal*1.05, 'MANAGER', sal*1.10, 'PRESIDENT', sal*1.20, sal) bonus
FROM emp;

--cond1
SELECT empno, ename, DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS', 'DDIT') dname
FROM emp;

SELECT empno, ename,
        CASE
            WHEN deptno = 10 THEN 'ACCOUNTING'
            WHEN deptno = 20 THEN 'RESEARCH'
            WHEN deptno = 30 THEN 'SALES'
            WHEN deptno = 40 THEN 'OPERATIONS'
            ELSE 'DDIT'
        END dname
FROM emp;

--cond2
SELECT empno, ename, hiredate,
    CASE
        WHEN MOD(TO_CHAR(SYSDATE, 'yyyy') - TO_CHAR(hiredate, 'yyyy'), 2)  = 0 THEN '건강검진 대상자'
        WHEN MOD(TO_CHAR(SYSDATE, 'yyyy') - TO_CHAR(hiredate, 'yyyy'), 2)  = 1 THEN '건강검진 비대상자'
    END contact_to_doctor       
FROM emp;
/*
TO_CHAR로 문자형이지만, 묵시적 형변환이 되어서 자동 숫자 계산
*/

SELECT empno, ename, hiredate, DECODE(MOD(TO_CHAR(SYSDATE, 'yyyy') - TO_CHAR(hiredate, 'yyyy'), 2), 0, '건강검진 대상자', 1, '건강검진 비대상자')
FROM emp;


--cond3
SELECT userid, usernm, alias, reg_dt,
        CASE
        WHEN MOD(TO_CHAR(SYSDATE+365, 'yyyy') - TO_CHAR(reg_dt, 'yyyy'), 2) = 0 THEN '건강검진 대상자'
        WHEN MOD(TO_CHAR(SYSDATE+365, 'yyyy') - TO_CHAR(reg_dt, 'yyyy'), 2)  = 1 THEN '건강검진 비대상자'
        WHEN reg_dt IS NULL THEN '건강검진 비대상자'
    END contacttodoctor      
FROM users;

SELECT userid, usernm, null alias, reg_dt,
        CASE
        WHEN MOD(TO_CHAR(SYSDATE+365, 'yyyy'),2) = MOD(TO_CHAR(reg_dt, 'yyyy'), 2)  THEN '건강검진 대상자'
        ELSE '건강검진 비대상자'
    END contacttodoctor      
FROM users;





























