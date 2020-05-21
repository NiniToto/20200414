SELECT A.ename, A.sal, A.deptno, B.LV sal_lv
FROM
(SELECT ROWNUM rna, ename, sal, deptno
FROM
(SELECT ename, sal, deptno
FROM emp
ORDER BY deptno, sal DESC))A, (SELECT ROWNUM rnb, LV
                                 FROM
                                    (SELECT *
                                       FROM
                                           (SELECT deptno, COUNT(*) cnt
                                              FROM emp
                                          GROUP BY deptno) a, (SELECT LEVEL lv
                                                                 FROM dual
                                                               CONNECT BY LEVEL <= 6) b
                                                                WHERE a.cnt >= lv                     
                                                               ORDER BY deptno, lv)) B
WHERE A.rna = B.rnb;
     
     
SELECT *
FROM
    (SELECT deptno, COUNT(*) cnt
     FROM emp
     GROUP BY deptno) a, (SELECT LEVEL lv
                          FROM dual
                          CONNECT BY LEVEL <= 6) b
WHERE lv <= a.cnt                     
ORDER BY deptno, lv; 

위의 복잡한 쿼리를 분석함수를 이용하여 간단히 
SELECT ename, sal, deptno, RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_rank
FROM emp;

RANK 관련 함수 : RANK, DENSE_RANK, ROW_NUMBER
RANK : 순위 구하기, 동일 값에 대해서는 동일한 순위를 부여하고 후순위는 +1
        ex) 1등이 3명이면, 2등3등은 없고 후순위는 4등
DENSE_RANK : 순위 구하기, 동일한 값에 대해서는 동일한 순위를 부여하고 후순위는 그대로 유지
        ex) 1등이 3명이면, 그 다음 후순위는 2등
ROW_NUMBER : 정렬순서대로 1부터 순차적인 값을 부여, 순위의 중복이 없다.        
SELECT ename, sal, deptno, 
       RANK() OVER (PARTITION BY deptno ORDER BY sal) sal_rank,
       DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal) sal_dense_rank,
       ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal) sal_row_number
FROM emp;

ana1]
전체 직원 대상 급여 랭크
부서별 급여합 ==> GROUP BY deptno
전체 직원의 급여합 ==> X
SELECT ename, sal, deptno, 
       RANK() OVER (ORDER BY sal DESC, empno) sal_rank,
       DENSE_RANK() OVER (ORDER BY sal DESC, empno) sal_dense_rank,
       ROW_NUMBER() OVER (ORDER BY sal DESC, empno) sal_row_number
FROM emp;

no_ana2]
분석함수를 사용하지 않고 기존 지식으로만 구현한 쿼리
SELECT a.*, b.cnt
FROM
    (SELECT empno, ename, deptno
     FROM emp) a, (SELECT deptno, COUNT(*) cnt
                     FROM emp
                  GROUP BY deptno) b
WHERE a.deptno = b.deptno              
ORDER BY a.deptno, a.empno;

분석함수 : 기존에 배운 집계함수(그룹함수) 5가지를 분석함수에서도 제공
그룹함수 - SUM, MAX, MIN, AVG, COUNT

SELECT empno, ename, deptno, COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

ana2]
SELECT empno, ename, sal, deptno, ROUND(AVG(sal) OVER (PARTITION BY deptno),2) avg
FROM emp;

ana3]
SELECT empno, ename, sal, deptno, MAX(sal) OVER (PARTITION BY deptno) max, MIN(sal) OVER (PARTITION BY deptno) min
FROM emp;

그룹 내 행 순서 : 
LAG     : 특정 행의 이전
LEAD    : 특정 행의 이후

전체직원 급여 순위에서 자신보다 급여 랭크가 한단계 낮은 사람의 급여 가져오기
단, 급여가 같을 때는 입사일자가 빠른 사람
SELECT empno, ename, hiredate, sal, LEAD(sal) OVER (ORDER BY sal DESC, hiredate) lead_sal
FROM emp
ORDER BY sal DESC;

ana5]
SELECT empno, ename, hiredate, sal, LAG(sal) OVER (ORDER BY sal DESC, hiredate) lag_sal
FROM emp
ORDER BY sal DESC;

SELECT empno, ename, hiredate, sal, LAG(sal) OVER (ORDER BY sal DESC, hiredate) lag_sal
FROM emp;

ana6]
SELECT empno, ename, hiredate, job, sal,  LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate) lag_sal
FROM emp;

no_ana3]
SELECT a.empno, a.ename, a.sal, SUM(b.sal) c_sum
FROM
(SELECT a.*, ROWNUM rn
FROM
(SELECT empno, ename, sal
 FROM emp
 ORDER BY sal)a)a,

(SELECT a.*, ROWNUM rn
FROM
(SELECT empno, ename, sal
 FROM emp
 ORDER BY sal)a)b

WHERE a.rn >= b.rn
GROUP BY a.empno, a.ename, a.sal
ORDER BY a.sal;

그룹 내 행순서 - WINDOWING
SELECT empno, ename, deptno, sal, SUM(sal) OVER (ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp;
UNBOUNDED PRECEDING : 자기 자신을 포함해서 이전 행

물리적 행 지정
ex) ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING;
SELECT empno, ename, deptno, sal, SUM(sal) OVER (ORDER BY sal ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) c_sum
FROM emp;

ana7]
SELECT empno, ename, deptno, sal, SUM(sal) OVER (PARTITION BY deptno ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp;

WINDOWING
ROWS : 물리적 ROW를 지칭
RANGE : 논리적인 ROW를 지칭, 같은 값을 같은 범위로 인식
DEFAULT : 

SELECT empno, ename, deptno, sal, 
        SUM(sal) OVER (ORDER BY sal ROWS UNBOUNDED PRECEDING) rows_sum,
        SUM(sal) OVER (ORDER BY sal RANGE UNBOUNDED PRECEDING) range_sum,
        SUM(sal) OVER (ORDER BY sal ) c_sum
FROM emp;

계층 누적합
SELECT *
FROM no_emp;

SELECT LPAD(' ', (LEVEL-1)*4) || org_cd org_cd, no_emp,
        CONNECT_BY_ISLEAF leaf, LEVEL lv
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;

SELECT LPAD(' ', (LEVEL-1) * 4) || org_cd org_cd, total
FROM
    (SELECT org_cd, parent_org_cd, lv, SUM(total) total
    FROM
        (SELECT a.*, SUM(no_emp_c) OVER (PARTITION BY gp ORDER BY rn ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) total
        FROM
            (SELECT a.*, ROWNUM rn, lv + ROWNUM gp, COUNT(*) OVER (PARTITION BY org_cd) cnt, no_emp / COUNT(*) OVER (PARTITION BY org_cd) no_emp_c
             FROM
                (SELECT org_cd, parent_org_cd, no_emp,
                        CONNECT_BY_ISLEAF leaf, LEVEL lv
                FROM no_emp
                START WITH org_cd = 'XX회사'
                CONNECT BY PRIOR org_cd = parent_org_cd) a
             START WITH leaf = 1
             CONNECT BY PRIOR parent_org_cd = org_cd) a)
    GROUP BY org_cd, parent_org_cd, lv)
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;



DROP TABLE gis_dt;
CREATE TABLE gis_dt AS
SELECT SYSDATE + ROUND(DBMS_RANDOM.value(-12, 18)) dt,
       '블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다 블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다' v1,
       '블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다 블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다' v2,
       '블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다 블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다' v3,
       '블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다 블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다' v4,
       '블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다 블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다블록의 사이즈를 강제로 키우기 위한 더미 데이터 입니다' v5
FROM dual
CONNECT BY LEVEL <= 1000000;

CREATE INDEX idx_n_gis_dt_01 ON gis_dt (dt);

dt컬럼의 년월일 정보를 중복을 제거해서 조회하는 것
20200501~20200630 : 최대 61행으로 축약

SELECT dt
FROM gis_dt;

