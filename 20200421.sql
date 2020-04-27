����¡ ó��.rownum.inline-VIEW(����Ŭ ����)
    . ����¡ ����
    . ���ε� ����


�Լ� : ������ ���ȭ�� �ڵ�
 ==> ���� ���(ȣ��)�ϴ� ���� �Լ��� �����Ǿ� �ִ� �κ��� �и� ==> ���������� ���̼��� ����
 �Լ��� ������� ���� ���
 ==> ȣ���ϴ� �κп� �Լ� �ڵ带 ���� ����ؾ� �ϹǷ�, �ڵ尡 ������� ==> �������� ��������.
 
 ����Ŭ �Լ��� ����
 �Է� ���� : 
    . single row function
    . multi row function
 ������ ���� : 
    . ���� �Լ� : ����Ŭ���� �������ִ� �Լ�
    . ����� ���� �Լ� : �����ڰ� ���� ������ �Լ�(pl/sql ��� ��)


���α׷��־��, �ĺ��̸� �ο�, ... ==> �߿��� ��Ģ

DUAL TABLE
SYS ������ ���� �ִ� ���̺�
����Ŭ�� ��� ����ڰ� �������� ����� �� �ִ� ���̺�
Ư¡ : 
. �Ѱ��� ��, �ϳ��� �÷�(dummy) - ���� 'X';
��� �뵵 : 
. �Լ��� �׽�Ʈ�� ����
. merge ����
. ������ ����

����Ŭ ���� �Լ� �׽�Ʈ(��ҹ��� ����)
LOWER, UPPER, INITCAP : ���ڷ� ���ڿ� �ϳ��� �޴´�.

SELECT LOWER ('Hello, World'), UPPER ('Hello, World'), INITCAP ('hello, world')
FROM dual;

SELECT LOWER ('Hello, World'), UPPER ('Hello, World'), INITCAP ('hello, world')
FROM emp;

�Լ��� where�������� ����� �����ϴ�.
emp ���̺��� SMITH ����� �̸��� �빮�ڷ� ����Ǿ� ����

SELECT *
FROM emp
WHERE ename = UPPER('smith'); --���̺��� ������ ���� �빮�ڷ� ����Ǿ� �����Ƿ� ��ȸ�Ǽ� 0

SELECT *
FROM emp
WHERE LOWER(ename) = 'smith'; --�̷� �����ε� �ۼ��� ������, ���� ����� �ùٸ� ����̴�.

���ڿ� ���� �Լ�
CONCAT : 2���� ���ڿ��� �Է¹޾�, ������ ���ڿ��� ��ȯ�Ѵ�.

SELECT CONCAT('start', 'end')
FROM dual;

SELECT table_name, tablespace_name, CONCAT('start', 'end'), CONCAT(table_name, tablespace_name),
        'SELECT * FROM ' || table_name || ';'
FROM user_tables;

SELECT CONCAT(table_name, ';'),
        CONCAT('SELCECT * FROM ', CONCAT(table_name,';')) 
FROM user_tables;

SELECT CONCAT('SELECT * FROM ', CONCAT(table_name, ';')) 
FROM user_tables;

/*

SUBSTR(���ڿ�, �����ε���, �����ε���) : ���ڿ��� �����ε������� �����ε��������� �κ� ���ڿ�
�����ε����� 1���� ����  --cf) JAVA�� ���� 0���� ����

LENGTH(���ڿ�) : ���ڿ��� ���̸� ��ȯ

INSTR(���ڿ�, ã�� ���ڿ�, [�˻� ���� �ε���]) : ���ڿ����� ã�� ���ڿ��� �����ϴ���, ������ ��� ã�� ���ڿ��� �ε���(��ġ) ��ȯ

LPAD, RPAD(���ڿ�, ���߰� ���� ��ü ���ڿ� ����, �е� ���ڿ�)

REPLACE(���ڿ�, �˻��� ���ڿ�, ������ ���ڿ�) : ���ڿ����� �˻��� ���ڿ� ã�� ������ ���ڿ��� ����

TRIM(���ڿ�) : ���ڿ��� �� �ڿ� �����ϴ� ������ ����, ���ڿ� �߰��� �ִ� ������ �ش���� �ʴ´�.

*/

SELECT SUBSTR('Hello, World', 1, 6) sub,
        LENGTH('Hello, World') len,
        INSTR('Hello, World', 'o') ins,
        INSTR('Hello, World', 'o', 6) ins2, -- 3��° ���ڴ� ���� ��ġ
        INSTR('Hello, World', 'o', INSTR('Hello, World', 'o') + 1) ins3,
        LPAD('hello', 15, '*') lp, RPAD('hello', 15, '*') rp,    
        LPAD('hello', 15) lp2, RPAD('hello', 15) rp2,
        REPLACE('Hello, World', 'll', 'LL') rep,
        TRIM('   Hello     ') tr,
        TRIM('H' FROM 'Hello') tr2
FROM dual;


NUMBER ���� �Լ�
ROUND(����, �ݿø� ��ġ) --��ġ�� default�� 0
    ROUND(105.54, 1) : �Ҽ��� ù° �ڸ����� ����� ���� ==> 105.5
TRUNC(����, ���� ��ġ) --��ġ�� default�� 0
    TRUNC(105.54, 1) : 105.5
MOD(������, ����) --������ ����

SELECT ROUND(105.54, 1) round1,
        ROUND(105.55, 1) round2,
        ROUND(105.55, 0) round3,
        ROUND(105.55, -1) round4
FROM dual;

SELECT TRUNC(105.54, 1) trunc1,
        TRUNC(105.55, 1) trunc2,
        TRUNC(105.55, 0) trunc3,
        TRUNC(105.55, -1) trunc4
FROM dual;

SELECT MOD(10, 3)
FROM dual;

SELECT MOD(sal, 1000), sal
FROM emp;

��¥ ���� �Լ�
SYSDATE : ������� ����Ŭ �����ͺ��̽� ������ ���� �ð�, ��¥�� ��ȯ�Ѵ�.
            �Լ������� ���ڰ� ���� �Լ�
            (���ڰ� ���� ��� JAVA : �޼ҵ�()
                            SQL : �Լ���
            );
date type +- ���� : ���� +-
���� 1 = �Ϸ�
1/24 = 1�ð�
1/24/60 = 1��

SELECT SYSDATE, SYSDATE + 5
FROM dual;

���ͷ�
    ���� : 
    ���� : ''
    ��¥ : TO_DATE('��¥ ���ڿ�', '����')

--data �ǽ� fn1
 SELECT TO_DATE('20191231', 'YYYYMMDD') LASTDAY,
        TO_DATE('20191231', 'YYYYMMDD') - 5 LASTDAY_BEFORE5,
        SYSDATE NOW,
        SYSDATE - 3 NOW_BEFORE3
 FROM dual;
 
 TO_DATE(���ڿ�, ����) : ���ڿ��� ���˿� �°� �ؼ��Ͽ� ��¥ Ÿ������ ����ȯ
 TO_CHAR(��¥, ����) : ��¥Ÿ���� ���˿� �°� ���ڿ��� ��ȯ
 YYYY : �⵵
 MM : ��
 DD : ��
 D : �ְ����� (1~7, 1-�Ͽ���, ..., 7-�����)
 IW : ���� (52~53)
 HH : �ð�(12�ð�)
 HH24 : 24�ð� ǥ��
 MI : ��
 SS : ��
 
 ����ð�(SYSDATE) �ú��� �������� ǥ�� ==> TO_CHAR�� �̿��Ͽ� ����ȯ
 SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS') now,
        TO_CHAR(SYSDATE, 'D') d,
        TO_CHAR(SYSDATE - 3, 'YYYY/MM/DD HH24:MI:SS') now_before3,
        TO_CHAR(SYSDATE - 1/24, 'YYYY/MM/DD HH24:MI:SS') now_before_1hour
 FROM dual;

 SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') DT_DASH,
        TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') DT_DASH_WITH_TIME,
        TO_CHAR(SYSDATE, 'DD-MM-YYYY') DT_DD_MM_YYYY,
        TO_CHAR(SYSDATE, 'IW') DT_IW
 FROM dual;
 
 MONTHS_BETWEEN(DATE1, DATE2): DATE1�� DATE2 ������ �������� ��ȯ
 4���� ��¥ �����Լ��߿��� ���󵵰� ����
 SELECT MONTHS_BETWEEN(TO_DATE('2020/04/21', 'YYYY/MM/DD'),TO_DATE('2020/03/21', 'YYYY/MM/DD')),
        MONTHS_BETWEEN(TO_DATE('2020/04/22', 'YYYY/MM/DD'),TO_DATE('2020/03/21', 'YYYY/MM/DD'))
 FROM dual;
 
 ADD_MONTHS(DATE1, ������ ������) : DATE1�� ���� �ι�° �Էµ� ������ ��ŭ ������ DATE
 ���� ��¥�κ��� 5���� �� ��¥
 SELECT ADD_MONTHS(SYSDATE, 5) dt1,
        ADD_MONTHS(SYSDATE, -5) dt2
 FROM dual;
 
 NEXT_DAY(DATE1, �ְ�����) : DATE1���� �����ϴ� ù��° �ְ������� ��¥�� ��ȯ
 SELECT NEXT_DAY(SYSDATE, 7)
 FROM dual;
 
 LAST_DAY(DATE1) : DATE1�� ���� ���� ������ ��¥�� ��ȯ
 SELECT LAST_DAY(SYSDATE)
 FROM dual; ��¥�� ���� ���� ù��° ��¥ ���ϱ� ( 1�� )
 
SELECT
    last_day(add_months(SYSDATE,-1) ) + 1,
    add_months(last_day(SYSDATE) + 1,-1),
    TO_DATE(TO_CHAR(SYSDATE,'YYYYMM')
    || '01','YYYYMMDD')
FROM
    dual;
    
    
 --fn3
 SELECT '201912' PARAM,
        (LAST_DAY(TO_DATE('201912', 'yyyymm')) -
        LAST_DAY(ADD_MONTHS(TO_DATE('201912', 'yyyymm'), -1) + 1)) DT
 FROM dual;
 
  SELECT '201912' PARAM,
        TO_CHAR(LAST_DAY(TO_DATE('201912', 'yyyymm')), 'dd') dt 
 FROM dual;
 
 SELECT '201912' PARAM,
        TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'yyyymm')), 'dd') dt 
 FROM dual;













 