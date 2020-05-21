CROSS JOIN

부서번호 별, 전체 행 별 SAL 합을 구하는 3번째 방법
SELECT DECODE(lv, 1, deptno, 2, null) deptno, SUM(sal) sal
FROM emp, (SELECT LEVEL lv
            FROM dual
            CONNECT BY LEVEL <= 2)
GROUP BY DECODE(lv, 1, deptno, 2, null)
ORDER BY 1;

계층형 쿼리
START WITH : 계층 쿼리의 시작점 기술
CONNECT BY : 계층(행)간 연결고리를 표현

xx회사부터(최상위 노드) 하향식으로 조직구조를 탐색하는 오라클 계층형 쿼리 작성
1. 시작점을 선택 : xx회사
2. 계층간(행과 행) 연결고리 표현 
    PRIOR : 내가 현재 읽고 있는 행을 표현
    아무것도 붙이지 않음 : 내가 앞으로 읽을 행을 표현
    
SELECT dept_h.*, LPAD(' ', (LEVEL-1)*3) || deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT *
FROM dept_h;

h_2]
SELECT LEVEL lv, deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;


상향식
시작점 : 디자인팀

h_3]
SELECT deptcd, LPAD(' ', (LEVEL-1)*3) ||deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;

SELECT deptcd, LPAD(' ', -(LEVEL-3)*3) ||deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;

h_4]
DESC h_sum;

SELECT LPAD(' ', (LEVEL-1) * 3) || s_id s_id, value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;

h_5]

SELECT LPAD(' ', (LEVEL-1) * 3) || org_cd org_cd, no_emp
FROM no_emp
START WITH org_cd = 'xx회사'
CONNECT BY PRIOR org_cd = parent_org_cd;

SELECT *
FROM no_emp;

CONNECT BY 이후에 이어서 PRIOR가 오지 않아도 상관 없다.
PRIOR는 현재 읽고 있는 행을 지칭하는 키워드
SELECT LPAD(' ', (LEVEL-1) * 3) || org_cd org_cd, no_emp
FROM no_emp
START WITH org_cd = 'xx회사'
CONNECT BY parent_org_cd = PRIOR org_cd;

Pruning branch - 가지 치기
WHERE절을 START WITH보다 먼저 작성하지만 실행은 가장 마지막에 된다.
*실행 순서 : FROM -> START WITH CONNECT BY -> WHERE 

WHERE절에 조건을 기술했을 때,
CONNECT BY 절에 기술했을 때의 차이를 비교

1. WHERE절에 조건을 기술한 경우 : 계층형 쿼리를 실행 후 가장 마지막에 적용
SELECT LEVEL lv, deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, p_deptcd
FROM dept_h
WHERE deptnm != '정보기획부'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

2. CONNECT BY절에 조건을 기술한 경우 : 연결 중에 조건이 실행 
SELECT LEVEL lv, deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd AND deptnm != '정보기획부';

계층형 쿼리에서 사용할 수 있는 특수 함수
1. CONNECT_BY_ROOT(column) : 해당 컬럼의 최상위 데이터를 조회

SELECT LEVEL lv, deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, p_deptcd,
             CONNECT_BY_ROOT(deptnm)
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

2. SYS_CONNECT_BY_PATH(column, 구분자) : 해당 행을 오기까지 거쳐온 행의 column들을 표현하고 구분자를 통해 연결
SELECT LEVEL lv, deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, p_deptcd,
             CONNECT_BY_ROOT(deptnm), 
             LTRIM(SYS_CONNECT_BY_PATH(deptnm, '_'), '_')
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

3. CONNECT_BY_ISLEAF : 해당 행이 연결이 더이상 없는 마지막 노드인지 (LEAF 노드)
                       (LEAF노드 : 1, NO LEAF노드 : 0);
SELECT LEVEL lv, deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, p_deptcd,
             CONNECT_BY_ROOT(deptnm), 
             LTRIM(SYS_CONNECT_BY_PATH(deptnm, '_'), '_'),
             CONNECT_BY_ISLEAF
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;                       
                       
DESC board_test;

h6]
SELECT seq, LPAD(' ', (LEVEL-1)*3) || title title
FROM board_test 
START WITH parent_seq IS NULL 
CONNECT BY PRIOR seq = parent_seq;

h7] 최신글이 위로 오도록 정렬
계층형 쿼리를 정렬 시 계층 구조를 유지하면서 정렬하는 기능이 제공
ORDER SIBLINGS BY

SELECT seq, LPAD(' ', (LEVEL-1)*3) || title title
FROM board_test 
START WITH parent_seq IS NULL 
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq DESC;
--case, decode x

SELECT seq, LPAD(' ', (LEVEL-1)*3) || title title, seq + parent_seq ps
FROM board_test 
START WITH parent_seq IS NULL 
CONNECT BY PRIOR seq = parent_seq 
ORDER SIBLINGS BY ps, seq DESC;

ALTER TABLE board_test ADD (qp_no NUMBER);

UPDATE board_test SET qp_no =4
WHERE seq IN (4,10,11,5,8,6,7);
UPDATE board_test SET qp_no =2
WHERE seq IN (2,3);
UPDATE board_test SET qp_no =1
WHERE seq IN (1,9);

SELECT qp_no, CONNECT_BY_ROOT(seq), seq, LPAD(' ', (LEVEL-1)*3) || title title, seq + parent_seq ps
FROM board_test 
START WITH parent_seq IS NULL 
CONNECT BY PRIOR seq = parent_seq 
ORDER SIBLINGS BY ps, seq DESC;


전체 직원중에 가장 높은 급여를 받는 사람의 급여정보
가장 높은 급여를 받는 사람의 이름

SELECT ename
FROM emp
WHERE sal = (SELECT MAX(sal)
                FROM emp);
emp 테이블을 2번 읽어서 목적을 달성 ==> 효율적인 방법 ==> WINDOW / ANALYSIS FUNCTION



SELECT A.ename, A.sal, A.deptno, B.LV
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


SELECT *
FROM 
(SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno) a,
(SELECT LEVEL lv
FROM dual
CONNECT BY LEVEL <= 6) b
WHERE a.cnt >= lv
ORDER BY deptno, lv;