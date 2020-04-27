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

--pseudo code(�ǻ� �ڵ�)

NULLIF(expr1, expr2)
if expr1 == expr2
    return null
else 
    return expr1
    
sal �÷��� ���� 3000�̸� null�� ����
SELECT empno, ename, sal, NULLIF(sal, 3000)
FROM emp;

�������� : �Լ��� ������ ������ ������ ���� ����
        �������ڵ��� Ÿ���� �����ؾ���
COALESCE(expr1, expr2, ...)
if expr1 != null
    return expr1
else
    coalesce(expr2, expr3, ...)
null�� �ƴ� ���� ���� ������ ���ڸ� ����

mgr �÷� null
comm �÷� null

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
���ǿ� ���� �÷� Ȥ�� ǥ������ �ٸ� ������ ��ü
java�� if, switch ���� ����
1. case ����
2. decode �Լ�

1.CASE

CASE
    WHEN ��/������ �Ǻ��� �� �ִ� �� THEN ������ ��
    [WHEN ��/������ �Ǻ��� �� �ִ� �� THEN ������ ��]
    [ELSE ������ �� (���� WHEN ���� ���� ��� ����)]
END

/*
emp ���̺� ��ϵ� �����鿡�� ���ʽ��� �߰������� ������ ����
�ش� ������ job�� SALESMAN�� ��� SAL 5% �λ�� �ݾ��� ���ʽ��� ����
�ش� ������ job�� MANAGER�� ��� SAL 10% �λ�� �ݾ��� ���ʽ��� ����
�ش� ������ job�� PRESIDENT�� ��� SAL 20% �λ�� �ݾ��� ���ʽ��� ����
�� �� �������� SAL��ŭ�� ����
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
                [default]) --��������
                
if expr 1 == search1
    return return1
else if expr1 == search2
    return return2
else if expr1 == search3
    return return3
...
else
    return default;
    
--�ڵ��� �������� decode�� ������ ==�ۿ� ����� �� �����Ƿ� ���������� ��쿡�� case�� ���°� ����

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
        WHEN MOD(TO_CHAR(SYSDATE, 'yyyy') - TO_CHAR(hiredate, 'yyyy'), 2)  = 0 THEN '�ǰ����� �����'
        WHEN MOD(TO_CHAR(SYSDATE, 'yyyy') - TO_CHAR(hiredate, 'yyyy'), 2)  = 1 THEN '�ǰ����� ������'
    END contact_to_doctor       
FROM emp;
/*
TO_CHAR�� ������������, ������ ����ȯ�� �Ǿ �ڵ� ���� ���
*/

SELECT empno, ename, hiredate, DECODE(MOD(TO_CHAR(SYSDATE, 'yyyy') - TO_CHAR(hiredate, 'yyyy'), 2), 0, '�ǰ����� �����', 1, '�ǰ����� ������')
FROM emp;


--cond3
SELECT userid, usernm, alias, reg_dt,
        CASE
        WHEN MOD(TO_CHAR(SYSDATE+365, 'yyyy') - TO_CHAR(reg_dt, 'yyyy'), 2) = 0 THEN '�ǰ����� �����'
        WHEN MOD(TO_CHAR(SYSDATE+365, 'yyyy') - TO_CHAR(reg_dt, 'yyyy'), 2)  = 1 THEN '�ǰ����� ������'
        WHEN reg_dt IS NULL THEN '�ǰ����� ������'
    END contacttodoctor      
FROM users;

SELECT userid, usernm, null alias, reg_dt,
        CASE
        WHEN MOD(TO_CHAR(SYSDATE+365, 'yyyy'),2) = MOD(TO_CHAR(reg_dt, 'yyyy'), 2)  THEN '�ǰ����� �����'
        ELSE '�ǰ����� ������'
    END contacttodoctor      
FROM users;





























