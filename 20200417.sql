/*
select���� ���� : 
-��¥ ���� ( +, - ) : ��¥ + ����, -���� : ��¥���� +-������ �� ���� Ȥ�� �̷��� ����Ʈ Ÿ�� ��ȯ
-���� ����
-���ڿ� ����
    ���ͷ� : ǥ�� ���
    -���� : ���ڷ� ǥ��
    -���� : �̱� �����̼� ���                cf) java������ ���� �����̼� ���
            ���տ��� : +�� �ƴ϶� || ���     cf) java������ +
    -��¥ : TO_DATE('��¥ ���ڿ�', '��¥ ���ڿ��� ���� ����')
            TO_DATE('20200417', yyyymmdd')
    
WHERE : ����� ���ǿ� �����ϴ� �ุ ��ȸ�ǵ��� ����

SELECT *
FROM users
WHERE userid = 'brown';
*/

/*sal���� 1000���� ũ�ų� ����, 2000���� �۰ų� ���� ������ ��ȸ --> BETWEEN AND;
�񱳴�� �÷� / �� BETWEEN ���۰� AND ���ᰪ
���۰��� ���ᰪ�� ��ġ�� �ٲٸ� ���� �������� ����
*/

SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

SELECT *
FROM emp
WHERE sal >= 1000
  AND sal <= 2000;

--exclusive or (��Ÿ�� or) : a or b �� �߿� �ϳ��� ���̾�� true, �� �� ���� ��쿡�� false.

SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('19820101', 'yyyymmdd') AND TO_DATE('19830101', 'yyyymmdd');

/*
IN ������
�÷�|Ư���� IN (��1, ��2, ...)
�÷��̳� Ư������ ��ȣ���� ���߿� �ϳ��� ��ġ�� �ϸ� TRUE
*/

SELECT *
FROM emp
WHERE deptno IN (10, 30);
-- deptno�� 10�̰ų� 30�� ����, deptno = 10 or deptno = 30

SELECT *
FROM emp
WHERE deptno = 10 OR deptno = 30;

--IN �ǽ� where3
SELECT userid as ���̵�, usernm �̸�, alias ����
FROM users
WHERE userid IN ('brown', 'cony', 'sally');

/*
���ڿ� ��Ī ���� : LIKE ����     cf) java : .startsWith(prefix), .endsWith(suffix)
����ŷ ���ڿ� : % - ��� ���ڿ�(���� ����)
              _ - � ���ڿ��̵��� �� �ϳ��� ����
-���ڿ��� �Ϻΰ� ������ TRUE

�÷�|Ư���� LIKE ���� ���ڿ�

'cony' : cony�� ���ڿ�
'co%'   : ���ڿ��� co�� �����ϰ� �ڿ��� � ���ڿ��̵� �� �� �ִ� ���ڿ�
        ex) 'cony', 'con', 'co' -> ��� ��;
'%co%'  : co�� �����ϴ� ���ڿ�
        ex) 'cony', 'sally cony' -> ��� ��;
'co__'  : co�� �����ϰ� �ڿ� �ΰ��� ���ڰ� ���� ���ڿ�
        ex) 'cony', 
'_on_'  : ��� �α��ڰ� on�̰� �յڷ� � ���ڿ��̵��� �ϳ��� ���ڰ� �� �� �ִ� ���ڿ�
*/

--���� �̸�(ename)�� �빮�� S�� �����ϴ� ������ ��ȸ
SELECT *
FROM emp
WHERE ename LIKE 'S%';

--where4

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '��%';

--where5

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%��%';

/*
NULL ��
SQL �񱳿����� : =

MGR�÷� ���� ���� ��� ������ ��ȸ
*/
SELECT *
FROM emp
WHERE mgr = NULL;

/*
SQL���� NULL ���� ���� ��� �Ϲ����� �񱳿����� (=)�� ��� ���ϰ�,
IS �����ڸ� ���
*/
SELECT *
FROM emp
WHERE mgr IS NULL;

/*
���� �ִ� ��Ȳ���� � �� : =, != <>,
NULL : IS NULL, IS NOT NULL
*/
--emp���̺��� mgr �÷� ���� NULL�� �ƴ� ������ ��ȸ

SELECT *
FROM emp
WHERE mgr IS NOT NULL;

--where6
SELECT *
FROM emp
WHERE comm IS NOT NULL;

--NOT ����
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839);
--> WHERE mgr != 7698 AND mgr != 7839

SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839, NULL);

SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839) OR mgr IS NULL;

--IN�����ڸ� �񱳿����ڷ� ����

--where7
SELECT *
FROM emp
WHERE job = 'SALESMAN' 
    AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

--where8
SELECT *
FROM emp
WHERE deptno != 10
    AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');
--where9
SELECT *
FROM emp
WHERE deptno NOT IN ( 10 )
    AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

--where10
SELECT *
FROM emp
WHERE deptno IN ( 20, 30 )
    AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');
     
--where11
SELECT *
FROM emp
WHERE job = 'SALESMAN' 
    OR hiredate >= TO_DATE('19810601', 'YYYYMMDD');
    
--where12
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno LIKE '78%';

--where13
SELECT *
FROM emp
WHERE job = 'SALESMAN' 
    OR empno >= 7800 AND empno < 7900;

SELECT *
FROM emp
WHERE job = 'SALESMAN' 
    OR empno BETWEEN 7800 AND  7899; 

/*
������ �켱����
AND�� OR���� �켱������ �����Ƿ�
OR�� ���� ����Ϸ��� ()�� ����ؾ� �Ѵ�.
*/

--where14
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno LIKE '78%' AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

/*
table���� ��ȸ, ����� ������ ����.(�������� ����)
--> ���нð��� ���հ� ������ ����

����, SQL������ �����͸� �����Ϸ��� ������ ������ �ʿ��ϴ�.
ORDER BY �÷��� [��������], �÷���2 [��������], ...

������ ���� : ��������(default) -ASC, �������� -DESC
*/

--���� �̸����� ���� ��������
SELECT *
FROM emp
ORDER BY ename ASC;

--���� �̸����� ���� ��������
SELECT *
FROM emp
ORDER BY ename DESC;

--job�� �������� ���� ���������ϰ� job�� ���� ��� �Ի����ڷ� �������� ����
SELECT *
FROM emp
ORDER BY job ASC, hiredate DESC;











