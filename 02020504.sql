������

��Ģ ������ : +, -, *, / : ���� ������
���� ������ : ? 1==1 ? true�� �� ���� : false�� �� ����

SQL ������
= : �÷�|ǥ���� = �� ==> ���� ������
IN : �÷�|ǥ���� IN (����)
    deptno IN (10, 30)

EXISTS ������
����� : EXISTS (��������) -- �÷��� �ȿ´�!!
���������� ��ȸ����� �� ���̶� ������ TRUE
�߸��� ��� ���: WHERE deptno EXISTS (��������)

SELECT *
FROM emp
WHERE EXISTS (SELECT 'X'
              FROM dept); --���������� ���ٸ� ��ȸ ������ ����Ǿ� ���� �����Ƿ� ���������� �׻� ��ȸ�� �ȴ�. ==> �ش� ���������� ����ǰ� ����� emp���̺��� ��� �����Ͱ� ��ȸ�ȴ�.

�� ������ ���ȣ ��������
�Ϲ������δ� EXISTS �����ڸ� ��ȣ���� ���������� ���� ����Ѵ�.

EXISTS �������� ����
�����ϴ� ���� �ϳ��� �߰��� �ϸ� �� �̻� Ž���� ���� �ʰ� �ߴ��Ѵ�.
���� ���� ���ο� ������ ���� �� ����ϱ� �����̴�.

�Ŵ����� ���� ���� : KING
�Ŵ��� ������ �����ϴ� ���� : 13

SELECT *
FROM emp e
WHERE EXISTS (SELECT 'X' --EXISTS���� ���� ���� ����̴�.
              FROM emp m
              WHERE e.mgr = m.empno);

IS NOT NULL�� ���ؼ��� ������ ����� ����� �� �� �ִ�.
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

JOIN�� ���ؼ��� ������ ��� ����
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

���տ���
{1,5,3} U {2,3} = {1,2,3,5}

{1,5,3} ������ {2,3} = {3}

{1,5,3} ������ {2,3} = {1,5}

SQL���� �����ϴ� UNINO ALL(�ߺ� �����͸� �������� �ʴ´�.)
{1,5,3} U {2,3} = {1,5,3,2,3}

SQL������ ���տ���
������ : UNION, UNION ALL, INTERSECT, MINUS
�ΰ��� SQL�� �������� ������ Ȯ�� (��, �Ʒ��� ���յȴ�.)

UNION������ : �ߺ����� (������ ������ ���հ� ����)
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)

UNION

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698)

UNION ALL ������ : �ߺ����
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)

UNION ALL

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698)

INTERSECT ������ : �����հ� �ߺ��Ǵ� ��Ҹ� ��ȸ
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698)

MINUS ������ : ���� ���տ��� �Ʒ��� ���� ��Ҹ� ����
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698)


SQL ���տ����� Ư¡
1. ���� �̸� : ù�� ° SQL�� �÷��� ���󰣴�.
SELECT ename nm, empno no
FROM emp
WHERE empno IN (7369)

UNION

SELECT ename, empno 
FROM emp
WHERE empno IN (7698)

2. ������ �ϰ���� ��� �������� ���� ����
   ���� SQL���� ORDER BY �Ұ� (�ζ��� �並 ����Ͽ� ������������ ORDER BY�� ������� ������ ����)
SELECT ename nm, empno no
FROM emp
WHERE empno IN (7369)
--�߰� �������� ���ĺҰ���
UNION

SELECT ename, empno 
FROM emp
WHERE empno IN (7698)
ORDER BY nm; --ename�� nm���� ��Ī�� ����Ͽ����Ƿ�, ���ĵ� nm���θ� ���� ����

3. SQL�� ���� �����ڴ� �ߺ��� �����Ѵ�(������ ���� ����� ����). ��, UNION ALL�� �ߺ� ���

4. �ΰ��� ���տ��� �ߺ��� �����ϱ� ���� ������ ������ �����ϴ� �۾��� �ʿ�
    ==> ����ڿ��� ����� �����ִ� �������� ������
    ==> UNION ALL�� ����� �� �ִ� ��Ȳ�� ��� UNION�� ������� �ʾƾ� �ӵ����� ���鿡�� �����ϴ�.

    �˰���(����-��������,��������,��������,...
          �ڷᱸ�� - Ʈ������(���� Ʈ��, �뷱�� Ʈ��)
                    heap
                    stack, queue
                    list
    ���տ��꿡�� �߿��� ���� : �ߺ�����
    
���� ���� : (����ŷ�� ���� + �Ƶ������� ���� + KFC�� ����) / �Ե������� ����    
    
���ù�������
SELECT *
FROM FASTFOOD;

�õ�+�ñ����� �������� ���������� ���;� �Ѵ�...

���� SQL ����: WHERE, GROUP BY, COUNT, INLINE-VIEW, ROWNUM, ORDER BY, ��Ī(�÷�, ���̺�), ROUND, JOIN...

SELECT ROWNUM rn, a.*
FROM
    (SELECT a.SIDO, a.SIGUNGU, ac, bc, cc, dc, ROUND((ac+bc+cc)/dc, 3) burgerrate
    FROM
        (SELECT SIDO, SIGUNGU, COUNT(*) ac
            FROM FASTFOOD
            WHERE GB = '����ŷ'
            GROUP BY SIDO, SIGUNGU) a, (SELECT SIDO, SIGUNGU, COUNT(*) bc
                                        FROM FASTFOOD
                                        WHERE GB = '�Ƶ�����'
                                        GROUP BY SIDO, SIGUNGU) b, (SELECT SIDO, SIGUNGU, COUNT(*)cc
                                                                    FROM FASTFOOD
                                                                    WHERE GB = 'KFC'
                                                                    GROUP BY SIDO, SIGUNGU) c, (SELECT SIDO, SIGUNGU, COUNT(*) dc
                                                                                                FROM FASTFOOD
                                                                                                WHERE GB = '�Ե�����'
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

(�ʼ�)���� 1] fastfood ���̺�� tax���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� SQL �ۼ�
 1.�õ� �ñ����� ���ù��������� ���ϰ�(������ ���� ���ð� ������ ����.) 
 2.�δ� ���� �Ű���� ���� �õ� �ñ������� ������  ���Ͽ�
 3.���ù��������� �δ� �Ű�� ������ ���� �����ͳ��� �����Ͽ� �Ʒ��� ���� �÷��� ��ȸ�ǵ��� SQL �ۼ�
 
����, �ܹ��� �õ�, �ܹ��� �ñ���, �ܹ��� ���ù�������, ����û �õ�, ����û �ñ���, ����û �������� �ݾ� 1�δ� �Ű��

���� 2] �ܹ��� ���ù��� ������ ���ϱ� ���� 4���� �ζ��� �並 ����Ͽ��µ� (fastfood ���̺��� 4�� ���)
�̸� �����Ͽ� ���̺��� �ѹ��� �д� ���·� ������ ���� (fastfood ���̺��� 1���� ���)
CASE, DECODE...�� ���

���� 3] �ܹ��� ���� SQL�� �ٸ� ���·� �����ϱ�...



����1]

(SELECT ROWNUM rn, a.*
FROM
    (SELECT a.SIDO, a.SIGUNGU, ac, bc, cc, dc, ROUND((ac+bc+cc)/dc, 3) burgerrate
    FROM
        (SELECT SIDO, SIGUNGU, COUNT(*) ac
            FROM FASTFOOD
            WHERE GB = '����ŷ'
            GROUP BY SIDO, SIGUNGU) a, (SELECT SIDO, SIGUNGU, COUNT(*) bc
                                        FROM FASTFOOD
                                        WHERE GB = '�Ƶ�����'
                                        GROUP BY SIDO, SIGUNGU) b, (SELECT SIDO, SIGUNGU, COUNT(*)cc
                                                                    FROM FASTFOOD
                                                                    WHERE GB = 'KFC'
                                                                    GROUP BY SIDO, SIGUNGU) c, (SELECT SIDO, SIGUNGU, COUNT(*) dc
                                                                                                FROM FASTFOOD
                                                                                                WHERE GB = '�Ե�����'
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



���� 1]]
SELECT A.*, b.*
FROM (SELECT ROWNUM rn, a.*
      FROM
        (SELECT a.SIDO, a.SIGUNGU, ROUND((ac+bc+cc)/dc, 3) burgerrate
         FROM
            (SELECT SIDO, SIGUNGU, COUNT(*) ac
             FROM FASTFOOD
             WHERE GB = '����ŷ'
             GROUP BY SIDO, SIGUNGU) a, (SELECT SIDO, SIGUNGU, COUNT(*) bc
                                         FROM FASTFOOD
                                         WHERE GB = '�Ƶ�����'
                                         GROUP BY SIDO, SIGUNGU) b, (SELECT SIDO, SIGUNGU, COUNT(*)cc
                                                                    FROM FASTFOOD
                                                                    WHERE GB = 'KFC'
                                                                    GROUP BY SIDO, SIGUNGU) c, (SELECT SIDO, SIGUNGU, COUNT(*) dc
                                                                                                FROM FASTFOOD
                                                                                                WHERE GB = '�Ե�����'
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

���� 2]]
SELECT SIDO, SIGUNGU, ROUND(COUNT(CASE WHEN GB = '����ŷ' OR GB = '�Ƶ�����' OR GB = 'KFC' THEN 1 END) 
                               / (CASE WHEN COUNT(CASE WHEN GB = '�Ե�����' THEN 1 END) > 0 THEN COUNT(CASE WHEN GB = '�Ե�����' THEN 1 END)
                                       WHEN COUNT(CASE WHEN GB = '�Ե�����' THEN 1 END) = 0 THEN 1 END), 2) a 
FROM fastfood
GROUP BY SIDO, SIGUNGU
ORDER BY a DESC;
--�Ե����ư� 0�� ���� ��� �ؾߵǳ�... �𸣰ڳ�...
SELECT SIDO, SIGUNGU, CASE
                         WHEN GB = '����ŷ' THEN 
                         WHEN GB = '�Ƶ�����' THEN 
                         WHEN GB = 'KFC' THEN 
                         WHEN GB = '�Ե�����' THEN 
                      END
FROM fastfood;

SELECT SIDO, SIGUNGU, 
                        COUNT(CASE 
                            WHEN GB = '����ŷ' OR GB = '�Ƶ�����' OR GB = 'KFC' THEN 1
                        END) / COUNT(CASE WHEN GB = '�Ե�����' THEN 1 END) a
FROM fastfood
GROUP BY SIDO, SIGUNGU, GB
ORDER BY a DESC;

SELECT SIDO, SIGUNGU, COUNT(CASE WHEN GB = '����ŷ' OR GB = '�Ƶ�����' OR GB = 'KFC' THEN 1 END) a, COUNT(CASE WHEN GB = '�Ե�����' THEN 1 END) b
FROM fastfood
GROUP BY SIDO, SIGUNGU
ORDER BY a DESC, b DESC;


SELECT SIDO, SIGUNGU, COUNT(CASE WHEN GB = '����ŷ' OR GB = '�Ƶ�����' OR GB = 'KFC' THEN 1 END)a
FROM fastfood
GROUP BY SIDO, SIGUNGU
ORDER BY a DESC;

SELECT SIDO, SIGUNGU, COUNT(CASE WHEN GB = '�Ե�����' THEN 1 END) a
FROM fastfood
WHERE (CASE WHEN GB = '�Ե�����' THEN 1 END) != 0
GROUP BY SIDO, SIGUNGU
ORDER BY a ASC;

���� 3]]
���� ���� : (����ŷ�� ���� + �Ƶ������� ���� + KFC�� ����) / �Ե������� ����
�ٸ� ���·� ǥ��..
--3.1
SELECT a.SIDO, a.SIGUNGU, a.A, b.B, ROUND(b.B / a.A, 2) burgerrate
FROM (SELECT SIDO, SIGUNGU, COUNT(GB) A
     FROM fastfood
     WHERE GB = '�Ե�����'
     GROUP BY SIDO, SIGUNGU) a, (SELECT SIDO, SIGUNGU, COUNT(GB) B
                                 FROM fastfood
                                 WHERE GB = '����ŷ' OR GB = '�Ƶ�����' OR GB = 'KFC'
                                 GROUP BY SIDO, SIGUNGU) b
WHERE a.SIDO = b.SIDO AND A.SIGUNGU = b.SIGUNGU
ORDER BY burgerrate DESC;    

--3.2
1������ �ζ��κ�, 2������ ��Į�󼭺�����, �׷� 3�������� ������������غ���..

SELECT aa.SIDO, aa.SIGUNGU, aa.A, bb.A, ROUND(aa.A/bb.A, 2) burgerrate
FROM 
(SELECT SIDO, SIGUNGU, COUNT(*) A
FROM fastfood a
WHERE ID IN (SELECT ID
             FROM fastfood
             WHERE SIDO = a.SIDO AND SIGUNGU = a.SIGUNGU AND (GB = '�Ƶ�����' OR GB = '����ŷ' OR GB = 'KFC')) --���� ���ص� �Ǵ� ��ȣ ����, ��� �������
GROUP BY SIDO, SIGUNGU) aa, 

(SELECT SIDO, SIGUNGU, COUNT(*) A
FROM fastfood a
WHERE ID IN (SELECT ID
             FROM fastfood
             WHERE GB = '�Ե�����')
GROUP BY SIDO, SIGUNGU) bb
WHERE aa.SIDO = bb.SIDO AND aa.SIGUNGU = bb.SIGUNGU
ORDER BY burgerrate DESC;

SELECT SIDO, SIGUNGU, COUNT(*) A
FROM fastfood a
WHERE ID IN (SELECT ID
             FROM fastfood
             WHERE SIDO = a.SIDO AND SIGUNGU = a.SIGUNGU AND (GB = '�Ƶ�����' OR GB = '����ŷ' OR GB = 'KFC'))
GROUP BY SIDO, SIGUNGU;
       
SELECT SIDO, SIGUNGU, COUNT(*) A
FROM fastfood a
WHERE ID IN (SELECT ID
             FROM fastfood
             WHERE GB = '�Ե�����')
GROUP BY SIDO, SIGUNGU;

SELECT GB
FROM fastfood
GROUP BY GB;

SELECT a.SIDO, a.SIGUNGU, a.A, b.B, ROUND(a.A/b.B, 2) burgerrate
FROM
    (SELECT SIDO, SIGUNGU, COUNT(*) A
     FROM fastfood
     WHERE GB NOT IN('������ġ', '�����̽�')
     GROUP BY SIDO, SIGUNGU
     
     MINUS
    
     SELECT SIDO, SIGUNGU, COUNT(*)
     FROM fastfood
     WHERE GB IN('�Ե�����')
     GROUP BY SIDO, SIGUNGU)a, (SELECT SIDO, SIGUNGU, COUNT(*) B
                                FROM fastfood
                                WHERE GB IN('�Ե�����')
                                GROUP BY SIDO, SIGUNGU)b
WHERE a.SIDO = b.SIDO AND a.SIGUNGU = b.SIGUNGU
ORDER BY burgerrate DESC;

