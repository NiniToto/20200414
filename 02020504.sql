연산자

사칙 연산자 : +, -, *, / : 이항 연산자
삼항 연산자 : ? 1==1 ? true일 때 실행 : false일 때 실행

SQL 연산자
= : 컬럼|표현식 = 값 ==> 이항 연산자
IN : 컬럼|표현식 IN (집합)
    deptno IN (10, 30)

EXISTS 연산자
사용방법 : EXISTS (서브쿼리) -- 컬럼이 안온다!!
서브쿼리의 조회결과가 한 건이라도 있으면 TRUE
잘못된 사용 방법: WHERE deptno EXISTS (서브쿼리)

SELECT *
FROM emp
WHERE EXISTS (SELECT 'X'
              FROM dept); --서브쿼리에 별다른 조회 조건이 기술되어 있지 않으므로 서브쿼리는 항상 조회가 된다. ==> 해당 메인쿼리는 실행되고 결과는 emp테이블의 모든 데이터가 조회된다.

위 쿼리는 비상호 서브쿼리
일반적으로는 EXISTS 연산자를 상호연관 서브쿼리로 많이 사용한다.

EXISTS 연산자의 장점
만족하는 행을 하나라도 발견을 하면 더 이상 탐색을 하지 않고 중단한다.
행의 존재 여부에 관심이 있을 때 사용하기 때문이다.

매니저가 없는 직원 : KING
매니저 정보가 존재하는 직원 : 13

SELECT *
FROM emp e
WHERE EXISTS (SELECT 'X' --EXISTS에서 많이 쓰는 방법이다.
              FROM emp m
              WHERE e.mgr = m.empno);

IS NOT NULL을 통해서도 동일한 결과를 만들어 낼 수 있다.
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

JOIN을 통해서도 동일한 결과 가능
SELECT e.*
FROM emp e, emp m
WHERE e.mgr = m.empno;

--sub9
SELECT pid, pnm
FROM product
WHERE EXISTS (SELECT 'X' FROM cycle WHERE cid = 1 AND cycle.pid = product.pid);

--sub10
SELECT pid, pnm
FROM product
WHERE NOT EXISTS (SELECT 'X' FROM cycle WHERE cid = 1 AND cycle.pid = product.pid);

집합연산
{1,5,3} U {2,3} = {1,2,3,5}

{1,5,3} 교집합 {2,3} = {3}

{1,5,3} 차집합 {2,3} = {1,5}

SQL에만 존재하는 UNINO ALL(중복 데이터를 제거하지 않는다.)
{1,5,3} U {2,3} = {1,5,3,2,3}

SQL에서의 집합연산
연산자 : UNION, UNION ALL, INTERSECT, MINUS
두개의 SQL의 실행결과를 행으로 확장 (위, 아래로 결합된다.)

UNION연산자 : 중복제거 (수학적 개념의 집합과 동일)
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)

UNION

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698)

UNION ALL 연산자 : 중복허용
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)

UNION ALL

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698)

INTERSECT 교집합 : 두집합간 중복되는 요소만 조회
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698)

MINUS 차집합 : 위쪽 집합에서 아래쪽 집합 요소를 제거
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698)


SQL 집합연산의 특징
1. 열의 이름 : 첫번 째 SQL의 컬럼을 따라간다.
SELECT ename nm, empno no
FROM emp
WHERE empno IN (7369)

UNION

SELECT ename, empno 
FROM emp
WHERE empno IN (7698)

2. 정렬을 하고싶을 경우 마지막에 적용 가능
   개별 SQL에는 ORDER BY 불가 (인라인 뷰를 사용하여 메인쿼리에서 ORDER BY가 기술되지 않으면 가능)
SELECT ename nm, empno no
FROM emp
WHERE empno IN (7369)
--중간 쿼리에서 정렬불가능
UNION

SELECT ename, empno 
FROM emp
WHERE empno IN (7698)
ORDER BY nm; --ename을 nm으로 별칭을 사용하였으므로, 정렬도 nm으로만 실행 가능

3. SQL의 집합 연산자는 중복을 제거한다(수학적 집합 개념과 동일). 단, UNION ALL은 중복 허용

4. 두개의 집합에서 중복을 제거하기 위해 각각의 집합을 정렬하는 작업이 필요
    ==> 사용자에게 결과를 보내주는 반응성이 느려짐
    ==> UNION ALL을 사용할 수 있는 상황일 경우 UNION을 사용하지 않아야 속도적인 측면에서 유리하다.

    알고리즘(정렬-버블정렬,삽입정렬,순차정렬,...
          자료구조 - 트리구조(이진 트리, 밸런스 트리)
                    heap
                    stack, queue
                    list
    집합연산에서 중요한 사항 : 중복제거
    
버거 지수 : (버거킹의 개수 + 맥도날드의 개수 + KFC의 개수) / 롯데리아의 개수    
    
도시발전지수
SELECT *
FROM FASTFOOD;

시도+시군구를 기준으로 버거지수가 나와야 한다...

사용된 SQL 문법: WHERE, GROUP BY, COUNT, INLINE-VIEW, ROWNUM, ORDER BY, 별칭(컬럼, 테이블), ROUND, JOIN...

SELECT ROWNUM rn, a.*
FROM
    (SELECT a.SIDO, a.SIGUNGU, ac, bc, cc, dc, ROUND((ac+bc+cc)/dc, 3) burgerrate
    FROM
        (SELECT SIDO, SIGUNGU, COUNT(*) ac
            FROM FASTFOOD
            WHERE GB = '버거킹'
            GROUP BY SIDO, SIGUNGU) a, (SELECT SIDO, SIGUNGU, COUNT(*) bc
                                        FROM FASTFOOD
                                        WHERE GB = '맥도날드'
                                        GROUP BY SIDO, SIGUNGU) b, (SELECT SIDO, SIGUNGU, COUNT(*)cc
                                                                    FROM FASTFOOD
                                                                    WHERE GB = 'KFC'
                                                                    GROUP BY SIDO, SIGUNGU) c, (SELECT SIDO, SIGUNGU, COUNT(*) dc
                                                                                                FROM FASTFOOD
                                                                                                WHERE GB = '롯데리아'
                                                                                                GROUP BY SIDO, SIGUNGU) d
    WHERE a.SIDO = b.SIDO AND a.SIGUNGU = b.SIGUNGU                                                                                              
      AND b.SIDO = c.SIDO AND b.SIGUNGU = c.SIGUNGU
      AND c.SIDO = d.SIDO AND c.SIGUNGU = d.SIGUNGU
      
    ORDER BY burgerrate DESC) a;


SELECT COUNT(deptno)
FROM emp
WHERE deptno = 10
GROUP BY deptno;

SELECT COUNT(deptno)
FROM emp
WHERE deptno = 20
GROUP BY deptno;

SELECT (SELECT COUNT(deptno) FROM emp WHERE deptno = 10 GROUP BY deptno) + (SELECT COUNT(deptno) FROM emp WHERE deptno = 20 GROUP BY deptno)
FROM dual;


SELECT *
FROM tax;

(필수)과제 1] fastfood 테이블과 tax테이블을 이용하여 다음과 같이 조회되도록 SQL 작성
 1.시도 시군구별 도시발전지수를 구하고(지수가 높은 도시가 순위가 높다.) 
 2.인당 연말 신고액이 높은 시도 시군구별로 순위를  구하여
 3.도시발전지수와 인당 신고액 순위가 같은 데이터끼리 조인하여 아래와 같이 컬럼이 조회되도록 SQL 작성
 
순위, 햄버거 시도, 햄버거 시군구, 햄버거 도시발전지수, 국세청 시도, 국세청 시군구, 국세청 연말정산 금액 1인당 신고액

과제 2] 햄버거 도시발전 지수를 구하기 위해 4개의 인라인 뷰를 사용하였는데 (fastfood 테이블을 4번 사용)
이를 개선하여 테이블을 한번만 읽는 형태로 쿼리를 개선 (fastfood 테이블을 1번만 사용)
CASE, DECODE...를 사용

과제 3] 햄버거 지수 SQL을 다른 형태로 도전하기...



과제1]

(SELECT ROWNUM rn, a.*
FROM
    (SELECT a.SIDO, a.SIGUNGU, ac, bc, cc, dc, ROUND((ac+bc+cc)/dc, 3) burgerrate
    FROM
        (SELECT SIDO, SIGUNGU, COUNT(*) ac
            FROM FASTFOOD
            WHERE GB = '버거킹'
            GROUP BY SIDO, SIGUNGU) a, (SELECT SIDO, SIGUNGU, COUNT(*) bc
                                        FROM FASTFOOD
                                        WHERE GB = '맥도날드'
                                        GROUP BY SIDO, SIGUNGU) b, (SELECT SIDO, SIGUNGU, COUNT(*)cc
                                                                    FROM FASTFOOD
                                                                    WHERE GB = 'KFC'
                                                                    GROUP BY SIDO, SIGUNGU) c, (SELECT SIDO, SIGUNGU, COUNT(*) dc
                                                                                                FROM FASTFOOD
                                                                                                WHERE GB = '롯데리아'
                                                                                                GROUP BY SIDO, SIGUNGU) d
    WHERE a.SIDO = b.SIDO AND a.SIGUNGU = b.SIGUNGU                                                                                              
      AND b.SIDO = c.SIDO AND b.SIGUNGU = c.SIGUNGU
      AND c.SIDO = d.SIDO AND c.SIGUNGU = d.SIGUNGU
      
    ORDER BY burgerrate DESC) a) A

(SELECT ROWNUM rn, a.*
FROM
    (SELECT SIDO, SIGUNGU, ROUND(sal/people, 2) tax
     FROM tax
     ORDER BY tax DESC)a) B



과제 1]]
SELECT A.*, b.*
FROM (SELECT ROWNUM rn, a.*
      FROM
        (SELECT a.SIDO, a.SIGUNGU, ROUND((ac+bc+cc)/dc, 3) burgerrate
         FROM
            (SELECT SIDO, SIGUNGU, COUNT(*) ac
             FROM FASTFOOD
             WHERE GB = '버거킹'
             GROUP BY SIDO, SIGUNGU) a, (SELECT SIDO, SIGUNGU, COUNT(*) bc
                                         FROM FASTFOOD
                                         WHERE GB = '맥도날드'
                                         GROUP BY SIDO, SIGUNGU) b, (SELECT SIDO, SIGUNGU, COUNT(*)cc
                                                                    FROM FASTFOOD
                                                                    WHERE GB = 'KFC'
                                                                    GROUP BY SIDO, SIGUNGU) c, (SELECT SIDO, SIGUNGU, COUNT(*) dc
                                                                                                FROM FASTFOOD
                                                                                                WHERE GB = '롯데리아'
                                                                                                GROUP BY SIDO, SIGUNGU) d
    WHERE a.SIDO = b.SIDO AND a.SIGUNGU = b.SIGUNGU                                                                                              
      AND b.SIDO = c.SIDO AND b.SIGUNGU = c.SIGUNGU
      AND c.SIDO = d.SIDO AND c.SIGUNGU = d.SIGUNGU
      
    ORDER BY burgerrate DESC) a) A, (SELECT ROWNUM rn, a.*
                                     FROM
                                         (SELECT SIDO, SIGUNGU, ROUND(sal/people, 2) tax
                                          FROM tax
                                          ORDER BY tax DESC)a) B
    WHERE A.rn = B.rn;

과제 2]]
SELECT SIDO, SIGUNGU, ROUND(COUNT(CASE WHEN GB = '버거킹' OR GB = '맥도날드' OR GB = 'KFC' THEN 1 END) 
                               / (CASE WHEN COUNT(CASE WHEN GB = '롯데리아' THEN 1 END) > 0 THEN COUNT(CASE WHEN GB = '롯데리아' THEN 1 END)
                                       WHEN COUNT(CASE WHEN GB = '롯데리아' THEN 1 END) = 0 THEN 1 END), 2) a 
FROM fastfood
GROUP BY SIDO, SIGUNGU
ORDER BY a DESC;
--롯데리아가 0인 곳은 어떻게 해야되나... 모르겠네...
SELECT SIDO, SIGUNGU, CASE
                         WHEN GB = '버거킹' THEN 
                         WHEN GB = '맥도날드' THEN 
                         WHEN GB = 'KFC' THEN 
                         WHEN GB = '롯데리아' THEN 
                      END
FROM fastfood;

SELECT SIDO, SIGUNGU, 
                        COUNT(CASE 
                            WHEN GB = '버거킹' OR GB = '맥도날드' OR GB = 'KFC' THEN 1
                        END) / COUNT(CASE WHEN GB = '롯데리아' THEN 1 END) a
FROM fastfood
GROUP BY SIDO, SIGUNGU, GB
ORDER BY a DESC;

SELECT SIDO, SIGUNGU, COUNT(CASE WHEN GB = '버거킹' OR GB = '맥도날드' OR GB = 'KFC' THEN 1 END) a, COUNT(CASE WHEN GB = '롯데리아' THEN 1 END) b
FROM fastfood
GROUP BY SIDO, SIGUNGU
ORDER BY a DESC, b DESC;


SELECT SIDO, SIGUNGU, COUNT(CASE WHEN GB = '버거킹' OR GB = '맥도날드' OR GB = 'KFC' THEN 1 END)a
FROM fastfood
GROUP BY SIDO, SIGUNGU
ORDER BY a DESC;

SELECT SIDO, SIGUNGU, COUNT(CASE WHEN GB = '롯데리아' THEN 1 END) a
FROM fastfood
WHERE (CASE WHEN GB = '롯데리아' THEN 1 END) != 0
GROUP BY SIDO, SIGUNGU
ORDER BY a ASC;

과제 3]]
버거 지수 : (버거킹의 개수 + 맥도날드의 개수 + KFC의 개수) / 롯데리아의 개수
다른 형태로 표현..
--3.1
SELECT a.SIDO, a.SIGUNGU, a.A, b.B, ROUND(b.B / a.A, 2) burgerrate
FROM (SELECT SIDO, SIGUNGU, COUNT(GB) A
     FROM fastfood
     WHERE GB = '롯데리아'
     GROUP BY SIDO, SIGUNGU) a, (SELECT SIDO, SIGUNGU, COUNT(GB) B
                                 FROM fastfood
                                 WHERE GB = '버거킹' OR GB = '맥도날드' OR GB = 'KFC'
                                 GROUP BY SIDO, SIGUNGU) b
WHERE a.SIDO = b.SIDO AND A.SIGUNGU = b.SIGUNGU
ORDER BY burgerrate DESC;    

--3.2
1번에서 인라인뷰, 2번에서 스칼라서브쿼리, 그럼 3번에서는 서브쿼리사용해보자..

SELECT aa.SIDO, aa.SIGUNGU, aa.A, bb.A, ROUND(aa.A/bb.A, 2) burgerrate
FROM 
(SELECT SIDO, SIGUNGU, COUNT(*) A
FROM fastfood a
WHERE ID IN (SELECT ID
             FROM fastfood
             WHERE SIDO = a.SIDO AND SIGUNGU = a.SIGUNGU AND (GB = '맥도날드' OR GB = '버거킹' OR GB = 'KFC')) --굳이 안해도 되는 상호 연관, 없어도 상관없음
GROUP BY SIDO, SIGUNGU) aa, 

(SELECT SIDO, SIGUNGU, COUNT(*) A
FROM fastfood a
WHERE ID IN (SELECT ID
             FROM fastfood
             WHERE GB = '롯데리아')
GROUP BY SIDO, SIGUNGU) bb
WHERE aa.SIDO = bb.SIDO AND aa.SIGUNGU = bb.SIGUNGU
ORDER BY burgerrate DESC;

SELECT SIDO, SIGUNGU, COUNT(*) A
FROM fastfood a
WHERE ID IN (SELECT ID
             FROM fastfood
             WHERE SIDO = a.SIDO AND SIGUNGU = a.SIGUNGU AND (GB = '맥도날드' OR GB = '버거킹' OR GB = 'KFC'))
GROUP BY SIDO, SIGUNGU;
       
SELECT SIDO, SIGUNGU, COUNT(*) A
FROM fastfood a
WHERE ID IN (SELECT ID
             FROM fastfood
             WHERE GB = '롯데리아')
GROUP BY SIDO, SIGUNGU;

SELECT GB
FROM fastfood
GROUP BY GB;

SELECT a.SIDO, a.SIGUNGU, a.A, b.B, ROUND(a.A/b.B, 2) burgerrate
FROM
    (SELECT SIDO, SIGUNGU, COUNT(*) A
     FROM fastfood
     WHERE GB NOT IN('맘스터치', '파파이스')
     GROUP BY SIDO, SIGUNGU
     
     MINUS
    
     SELECT SIDO, SIGUNGU, COUNT(*)
     FROM fastfood
     WHERE GB IN('롯데리아')
     GROUP BY SIDO, SIGUNGU)a, (SELECT SIDO, SIGUNGU, COUNT(*) B
                                FROM fastfood
                                WHERE GB IN('롯데리아')
                                GROUP BY SIDO, SIGUNGU)b
WHERE a.SIDO = b.SIDO AND a.SIGUNGU = b.SIGUNGU
ORDER BY burgerrate DESC;

