--join1
SELECT lprod.lprod_gu,lprod.lprod_nm, prod.prod_id, prod.prod_name -- 하나의 테이블에만 존재하는 컬럼은 테이블.컬럼 형식을 사용하지 않아도 된다.
FROM prod, lprod  --lprod가 상위 테이블이므로 먼저 기술해주는게 가독성면에서 좋다.
WHERE prod.prod_lgu = lprod_gu;
--기본적으로 oracle에서 50개의 행만을 먼저 출력해주는 페이징처리가 되어있다.
SELECT lprod.lprod_gu,lprod.lprod_nm, prod.prod_id, prod.prod_name
FROM prod JOIN lprod ON(prod.prod_lgu = lprod_gu);

--join2
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer, prod
WHERE buyer.buyer_id = prod.prod_buyer;

SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer JOIN prod ON(buyer.buyer_id = prod.prod_buyer);

--join2_1
SELECT COUNT(*)
FROM buyer, prod
WHERE buyer.buyer_id = prod.prod_buyer;

--join2_2
--buyer_name별 건수 조회 쿼리 작성
SELECT buyer.buyer_name, COUNT(buyer.buyer_name)
FROM buyer, prod
WHERE buyer.buyer_id = prod.prod_buyer
GROUP BY buyer.buyer_name;

--join3
--3개의 테이블을 조인
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member, cart, prod
WHERE member.mem_id = cart.cart_member AND cart.cart_prod = prod.prod_id;

SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member JOIN (cart JOIN prod ON( cart.cart_prod = prod.prod_id)) ON (member.mem_id = cart.cart_member);

--
SELECT *
FROM customer;

SELECT *
FROM product;

SELECT *
FROM cycle;

--join 4
SELECT customer.CID, customer.CNM, cycle.pid, cycle.day, cycle.cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid AND (cnm = 'brown' OR cnm = 'sally');

SELECT CID, CNM, pid, day, cnt
FROM customer NATURAL JOIN cycle
WHERE cnm = 'brown' OR cnm = 'sally';

--join 5
SELECT customer.CID, customer.CNM, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid AND cycle.pid = product.pid AND (cnm = 'brown' OR cnm = 'sally');

--join 6
SELECT customer.CID, customer.CNM, cycle.pid, product.pnm, SUM(cycle.cnt) cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid AND cycle.pid = product.pid
GROUP BY customer.CID, customer.CNM, cycle.pid, product.pnm;

--join7
SELECT product.pid, product.pnm, SUM(cycle.cnt) cnt
FROM cycle, product
WHERE cycle.pid = product.pid
GROUP BY product.pid, product.pnm; -- Group Function 안에 사용한 컬럼은 Group by절에 기술하지 않고 사용하는 것도 가능하다.

--join8



























