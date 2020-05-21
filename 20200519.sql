CROSS JOIN

�μ���ȣ ��, ��ü �� �� SAL ���� ���ϴ� 3��° ���
SELECT DECODE(lv, 1, deptno, 2, null) deptno, SUM(sal) sal
FROM emp, (SELECT LEVEL lv
            FROM dual
            CONNECT BY LEVEL <= 2)
GROUP BY DECODE(lv, 1, deptno, 2, null)
ORDER BY 1;

������ ����
START WITH : ���� ������ ������ ���
CONNECT BY : ����(��)�� ������� ǥ��

xxȸ�����(�ֻ��� ���) ��������� ���������� Ž���ϴ� ����Ŭ ������ ���� �ۼ�
1. �������� ���� : xxȸ��
2. ������(��� ��) ����� ǥ�� 
    PRIOR : ���� ���� �а� �ִ� ���� ǥ��
    �ƹ��͵� ������ ���� : ���� ������ ���� ���� ǥ��
    
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


�����
������ : ��������

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
START WITH org_cd = 'xxȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;

SELECT *
FROM no_emp;

CONNECT BY ���Ŀ� �̾ PRIOR�� ���� �ʾƵ� ��� ����.
PRIOR�� ���� �а� �ִ� ���� ��Ī�ϴ� Ű����
SELECT LPAD(' ', (LEVEL-1) * 3) || org_cd org_cd, no_emp
FROM no_emp
START WITH org_cd = 'xxȸ��'
CONNECT BY parent_org_cd = PRIOR org_cd;

Pruning branch - ���� ġ��
WHERE���� START WITH���� ���� �ۼ������� ������ ���� �������� �ȴ�.
*���� ���� : FROM -> START WITH CONNECT BY -> WHERE 

WHERE���� ������ ������� ��,
CONNECT BY ���� ������� ���� ���̸� ��

1. WHERE���� ������ ����� ��� : ������ ������ ���� �� ���� �������� ����
SELECT LEVEL lv, deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, p_deptcd
FROM dept_h
WHERE deptnm != '������ȹ��'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

2. CONNECT BY���� ������ ����� ��� : ���� �߿� ������ ���� 
SELECT LEVEL lv, deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd AND deptnm != '������ȹ��';

������ �������� ����� �� �ִ� Ư�� �Լ�
1. CONNECT_BY_ROOT(column) : �ش� �÷��� �ֻ��� �����͸� ��ȸ

SELECT LEVEL lv, deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, p_deptcd,
             CONNECT_BY_ROOT(deptnm)
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

2. SYS_CONNECT_BY_PATH(column, ������) : �ش� ���� ������� ���Ŀ� ���� column���� ǥ���ϰ� �����ڸ� ���� ����
SELECT LEVEL lv, deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, p_deptcd,
             CONNECT_BY_ROOT(deptnm), 
             LTRIM(SYS_CONNECT_BY_PATH(deptnm, '_'), '_')
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

3. CONNECT_BY_ISLEAF : �ش� ���� ������ ���̻� ���� ������ ������� (LEAF ���)
                       (LEAF��� : 1, NO LEAF��� : 0);
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

h7] �ֽű��� ���� ������ ����
������ ������ ���� �� ���� ������ �����ϸ鼭 �����ϴ� ����� ����
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


��ü �����߿� ���� ���� �޿��� �޴� ����� �޿�����
���� ���� �޿��� �޴� ����� �̸�

SELECT ename
FROM emp
WHERE sal = (SELECT MAX(sal)
                FROM emp);
emp ���̺��� 2�� �о ������ �޼� ==> ȿ������ ��� ==> WINDOW / ANALYSIS FUNCTION



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