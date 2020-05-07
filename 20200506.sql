DML
�����͸� �Է�(INSERT), ����(UPDATE), ����(DELETE)�� �� ����ϴ� SQL

INSERT
����
INSERT INTO ���̺�� [(���̺��� �÷���, ...)] VALUES (�Է��� ��, ...);

ũ�� ���� �ΰ��� ���·� ���
1. ���̺��� ��� �÷��� ���� �Է��ϴ� ���, �÷����� �������� �ʾƵ� �ȴ�.
    ��, �Է��� ���� ������ ���̺� ���ǵ� �÷� ������ �νĵȴ�. DESC dept;
INSERT INTO ���̺�� VALUES (�Է��� ��, �Է��� ��2, ...);
2. �Է��ϰ��� �ϴ� �÷��� ����ϴ� ���
    ����ڰ� �Է��ϰ��� �ϴ� �÷��� �����Ͽ� �����͸� �Է��� ���
    ��, ���̺� NOT NULL ������ �Ǿ��ִ� �÷��� �����Ǹ� INSERT�� �����Ѵ�.
INSERT INTO ���̺�� (�÷�1, �÷�2) VALUES (�Է��� ��, �Է��� ��2);

3. SELECT ����� INSERT
    SELECT ������ �̿��ؼ� ������ ���� ��ȸ�Ǵ� ����� ���̺� �Է� ����
    ==> �������� �����͸� �ϳ��� ������ �Է� ����(ONE-QUERY) ==> ���� ������ ���� ������ ��ģ��.
    
    ����ڷκ��� �����͸� ���� �Է¹޴� ���(ex. ȸ������)�� ������ �Ұ�
    db�� �����ϴ� �����͸� ���� �����ϴ� ��쿡 Ȱ���� �����ϴ�.(�̷� ��찡 ����.)
    
INSERT INTO ���̺�� [(�÷���1, �÷���2, ...)]
SELECT ...
FROM...;

dept ���̺� deptno = 99, dname DDIT, loc daejeon ���� �Է��ϴ� INSERT ���� �ۼ�
INSERT INTO dept VALUES (99, 'DDIT', 'daejeon');
rollback;

INSERT INTO dept (loc, deptno, dname) VALUES ('daejeon', 99, 'DDIT');
������ �Է��� Ȯ�� �������� : commit - Ʈ����� �Ϸ�
������ �Է��� ��� �Ϸ��� : rollback - Ʈ����� ���
SELECT *
FROM dept;

���� INSERT ������ ������ ���ڿ�, ����� �Է��� ���
INSERT �������� ��Į�� ��������, �Լ��� ��� ����
EX : ���̺� �����Ͱ� �� ����� �Ͻ������� ��� �ϴ� ��찡 ����. ==> SYSDATE;

SELECT *
FROM emp;

emp ���̺��� ��� �÷� �� ������ 8��, NOT NULL�� 1��(empno)
empno�� 9999�̰� �̸��� �����̸�, hiredate�� �����Ͻø� �����ϴ� INSERT ������ �ۼ�
DESC emp;
INSERT INTO emp (empno, ename, hiredate) VALUES (9999, '�����', SYSDATE);
INSERT ���� ������� ���� �÷����� ���� NULL�� �Էµȴ�.

9998�� ������� jw����� �Է�, �Ի����ڴ� 2020�� 4�� 13�Ϸ� �����Ͽ� ������ �Է�
INSERT INTO emp (empno, ename, hiredate) VALUES (9998, 'jw', TO_DATE(20200413, 'yyyymmdd'));

*������ ���Ἲ

SELECT ����� ���̺� �Է��ϱ� (�뷮 �Է�)
DESC dept;

dept���̺��� ���� 4���� �����Ͱ� ���� ==>�Ʒ������� �����ϸ� 8���� �� ���̴�.
INSERT INTO dept
SELECT *
FROM dept;

rollback;

UPDATE ���� : ������ ����
UPDATE ���̺�� SET ������ �÷�1 = ������ ��1,
                  [������ �÷�2 = ������ ��2, ...]
[WHERE condition] - SELECT ������ ��� WHERE���� ����, ������ ���� �ν��ϴ� ������ ���;

dept ���̺� 99, ddit, daejeon
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');

SELECT *
FROM dept;

99�� �μ��� �μ����� ���IT��, ��ġ�� ���κ������� ����
UPDATE dept SET dname = '���it', loc = '���κ���'
WHERE deptno = 99; --where���� ������� ������ ��� ���� �μ���� ��ġ�� �����Ѵ�.

INSERT : ���� �� ���� ����
UPDATE, DELETE : ������ �ִ� �� ����, ���� ==> ������ �ۼ��� ��� �����ؾ� �Ѵ�.
                                            1. WHERE���� �������� �ʾҴ��� Ȯ���ؾ� �Ѵ�.
                                            2. UPDATE, DELETE ���� �����ϱ� ���� WHERE���� �����ؼ� SELECT�� �ؼ� ������ ���� ���� ������ Ȯ���ؾ� �Ѵ�.
                                            3. ORACLE ����ڴ� ROLLBACK�� ���ؼ� �ѹ��� �Ǽ��� ȸ���� �� �ִ�. COMMIT�� �� ������ ��...

���������� �̿��� ������ ����
INSERT INTO emp (empno, ename, job) VALUES (9999, 'brown', NULL);

SELECT *
FROM emp;

9999�� ������ deptno, job �ΰ��� �÷��� SMITH ����� ������ �����ϰ� ����
UPDATE emp SET deptno = (SELECT deptno
                         FROM emp
                         WHERE ename = 'SMITH' ),
               job = (SELECT job
                      FROM emp
                      WHERE ename = 'SMITH' )
WHERE empno = 9999;

�Ϲ����� UPDATE ���������� �÷����� ���������� �ۼ��Ͽ� ��ȿ���� �����Ѵ�.
==> MERGE ������ ���� ��ȿ���� ������ �� �ִ�.

ROLLBACK;

DELETE : ���̺� �����ϴ� �����͸� ����
����
DELETE [FROM] ���̺��
[WHERE condition]

������
1. Ư�� �÷��� ���� ���� ==> �ش� �÷��� NULL�� UPDATE
   DELETE ���� �� ��ü�� ����
2. UPDATE ���������� DELETE ������ �����ϱ� ���� SELECT�� ���� ���� ����� �Ǵ� ���� ��ȸ, Ȯ���ؾ� �Ѵ�.

���� �׽�Ʈ ������ �Է�
INSERT INTO emp (empno, ename, job) VALUES (9999, 'brown', NULL);

����� 9999�� ���� �����ϴ� ���� �ۼ�
DELETE emp
WHERE empno = 9999;

SELECT *
FROM emp
WHERE empno = 9999;

ROLLBACK;

�Ʒ� ������ �ǹ� : emp ���̺��� ��� ���� ����
DELETE emp;

UPDATE, DELETE ���� ��� ���̺� �����ϴ� �����Ϳ� ����, ������ �ϴ� ���̱� ������
��� ���� �����ϱ� ���� WHERE ���� ����� �� �ְ�,
WHERE ���� SELECT ������ ����� ������ ������ �� �ִ�.
���� ��� ���������� ���� ���� ������ �����ϴ�.

�Ŵ����� 7698�� �������� ��� �����ϰ� ���� ��

DELETE emp
WHERE empno IN
              (SELECT empno
               FROM emp
               WHERE mgr = 7698);
               
SELECT *            
FROM emp;

ROLLBACK;

DML : SELECT, INSERT, UPDATE, DELETE
WHERE ���� ��� ������ DML : SELECT, UPDATE, DELETE
    3���� ������ �����͸� �ĺ��ϴ� WHERE ���� ���� �� �ִ�.
    �����͸� �ĺ��ϴ� �ӵ��� ���� ������ ���� ������ �¿�ȴ�.
    ==>INDEX ��ü�� ���� �ӵ� ����� �����ϴ�
    
INSERT : ������� �ű� �����͸� �Է� �ϴ� ��
         ������� �ĺ��ϴ°� �߿��ϴ�.
         ==> �����ڰ� �� �� �ִ� Ʃ�� ����Ʈ�� ���� ����

���̺��� �����͸� ����� ��� (��� ������ �����)
1. DELETE : WHERE ���� ������� ������ �ȴ�.
2. TRUNCATE
   ���� : TRUNCATE TABLE ���̺��
   Ư¡ : 1) ������ �α׸� ������ ���� ==> ������ �Ұ���
         2) �α׸� ������ �ʱ� ������ ���� �ӵ��� ������ ==> �ȯ�濡���� �� ������� ����(������ �ȵǱ� ������)
                                                    ==> �׽�Ʈ ȯ�濡�� �ַ� ����Ѵ�.
                                                    
�����͸� �����Ͽ� ���̺� ����                                                    

CREATE TABLE emp_copy AS
SELECT *
FROM emp;

SELECT *
FROM emp_copy;

emp_copy ���̺��� TRUNCATE ����� ���� ��� �����͸� ����
TRUNCATE TABLE emp_copy;

ROLLBACK;

Ʈ����� : ������ ���� ����
ex : ATM - ��ݰ� �Ա��� �� �� ���������� �̷������ ������ �߻����� �ʴ´�.
����Ŭ������ ù��° DML�� ������ �Ǹ� Ʈ������� �������� �ν�
Ʈ������� ROLLBACK, COMMIT�� ���ؼ� ���ᰡ �ȴ�.

Ʈ����� ���� �� ���ο� DML�� ����Ǹ� ���ο� Ʈ������� ������ �Ǵ� ���̴�.

��� ����ϴ� �Խ����� �����غ���,
�Խñ� �Է��� �� �Է� �ϴ� �� : ����, ����, ÷������, ...
RDBMS������ �Ӽ��� �ߺ��� ��� ������ ����Ƽ(���̺�)�� �и��� �Ѵ�.
�Խñ� ���̺�(����, ����) / �Խñ� ÷������ ���̺�(÷�����Ͽ� ���� ����)

�Խñ��� �ϳ� ����� �ϴ���
�Խñ� ���̺�� �Խñ� ÷������ ���̺� �����͸� �űԷ� ����� �ؾ��Ѵ�.
INSERT INTO �Խñ� ���̺� (����, ����, �����, ����Ͻ�, ...) VALUES (...);
INSERT INTO �Խñ� ÷������ ���̺� (÷�����ϸ�, ÷������ ������, ...) VALUES (...);

�ΰ��� INSERT ������ �Խñ� ����� Ʈ������̴�.
��, �ΰ��߿� �ϳ��� ������ ����� �Ϲ������� ROLLBACK�� ���� �ΰ��� INSERT ������ ����Ѵ�.