Create database SQL_project 

DROP TABLE IF EXISTS BOOKS;
CREATE TABLE IF NOT EXISTS BOOKS(
	Book_ID				SERIAL PRIMARY KEY,
	Title				VARCHAR(60),
	Author				VARCHAR(30),
	Genre				VARCHAR(15),
	Published_Year		INT,
	Price				NUMERIC(10,2),
	Stock				INT
);

DROP TABLE IF EXISTS CUSTOMERS;
CREATE TABLE IF NOT EXISTS CUSTOMERS(
	Customer_ID			SERIAL PRIMARY KEY,
	Name				VARCHAR(50),
	Email				VARCHAR(50),
	Phone				INT,
	City				VARCHAR(30),
	Country				VARCHAR(60)
);

DROP TABLE IF EXISTS ORDERS;
CREATE TABLE IF NOT EXISTS ORDERS(
	Order_ID			SERIAL PRIMARY KEY,
	Customer_ID			INT,
	Book_ID				INT,
	Order_Date			DATE,
	Quantity			INT,
	Total_Amount		NUMERIC
);


COPY BOOKS(Book_ID,Title,Author,Genre,Published_Year,Price,Stock)
FROM 'D:\SQL files.xlsx\SQL Project\Books.csv'
CSV HEADER;

COPY CUSTOMERS(Customer_ID,Name,Email,Phone,City,Country)
FROM 'D:\SQL files.xlsx\SQL Project\Customers.csv'
CSV HEADER;

COPY ORDERS(Order_ID,Customer_ID,Book_ID,Order_Date,Quantity,Total_Amount)
FROM 'D:\SQL files.xlsx\SQL Project\Orders.csv'
CSV HEADER;


-- ********     [BASIC QUERIES]   *********
-- 1) Retrieve all books in the "Fiction" genre
SELECT * FROM BOOKS
WHERE UPPER(GENRE) = 'FICTION'

-- 2) Find books published after the year 1950
SELECT * FROM BOOKS
WHERE PUBLISHED_YEAR >1950;

-- 3) List all customers from the Canada
SELECT * FROM CUSTOMERS
WHERE UPPER(COUNTRY) = 'CANADA';

-- 4) Show orders placed in November 2023
SELECT * FROM ORDERS
WHERE ORDER_DATE BETWEEN '2023-11-01' AND '2023-11-30'
ORDER BY ORDER_DATE ASC

-- 5) Retrieve the total stock of books available
SELECT SUM(STOCK) AS REMANING_STOCK
FROM BOOKS

-- 6) Find the details of the most expensive book
SELECT * FROM BOOKS
ORDER BY PRICE DESC LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book
SELECT * FROM ORDERS
WHERE QUANTITY > 1

-- 8) Retrieve all orders where the total amount exceeds $20
SELECT * FROM ORDERS
WHERE TOTAL_AMOUNT >= 20;

-- 9) List all genres available in the Books table
SELECT DISTINCT GENRE FROM BOOKS

--10) Find the book with the lowest stock
SELECT * FROM BOOKS
ORDER BY STOCK ASC LIMIT 1

-- 11) Calculate the total revenue generated from all orders
SELECT SUM(TOTAL_AMOUNT) AS REVENUE_AMOUNT FROM ORDERS


-- ********     [ADVANCE QUERIES]   *********
-- 1) Retrieve the total number of books sold for each genre

SELECT B.GENRE, SUM(O.QUANTITY) AS SOLD_QUANTITY
FROM ORDERS O
JOIN BOOKS B
ON B.BOOK_ID = O.BOOK_ID
GROUP BY GENRE

-- 2) Find the average price of books in the "Fantasy" genre
SELECT AVG(PRICE) AS AVG_REVINUE FROM BOOKS
WHERE UPPER(GENRE) = 'FANTASY'

-- 3) List customers who have placed at least 2 orders
SELECT  CUSTOMER_ID, COUNT(ORDER_ID) AS ORDER_COUNT
FROM ORDERS
GROUP BY CUSTOMER_ID
HAVING COUNT(ORDER_ID) >=2

-- 4) Find the most frequently ordered book
SELECT BOOK_ID, COUNT(ORDER_ID) AS ORDERS_COUNT
FROM ORDERS
GROUP BY BOOK_ID
ORDER BY ORDERS_COUNT DESC LIMIT 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre
SELECT * FROM BOOKS
WHERE UPPER(GENRE) = 'FANTASY'
ORDER BY PRICE DESC LIMIT 3

-- 6) Retrieve the total quantity of books sold by each author
SELECT B.AUTHOR, SUM(O.QUANTITY) SOLD_BY_AUTHOR
FROM ORDERS O
JOIN BOOKS B
ON B.BOOK_ID = O.BOOK_ID
GROUP BY B.AUTHOR

-- 7) List the cities where customers who spent over $30 are located
SELECT DISTINCT C.CITY
FROM ORDERS O
JOIN CUSTOMERS C
ON C.CUSTOMER_ID = O.CUSTOMER_ID
WHERE O.TOTAL_AMOUNT >= 30

-- 8) Find the customer who spent the most on orders
SELECT C.NAME,C.CUSTOMER_ID, SUM(O.TOTAL_AMOUNT) AS MOST
FROM ORDERS O
JOIN CUSTOMERS C
ON C.CUSTOMER_ID = O.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID
ORDER BY MOST DESC LIMIT 1

-- 9) Calculate the stock remaining after fulfilling all orders
SELECT B.BOOK_ID, B.TITLE,B.STOCK - COALESCE(SUM(O.QUANTITY),0) AS REMANING_QNTY
FROM ORDERS O
LEFT JOIN BOOKS B
ON B.BOOK_ID = O.BOOK_ID
GROUP BY B.BOOK_ID


SELECT B.BOOK_ID, B.TITLE,B.STOCK, COALESCE(SUM(O.QUANTITY),0) AS ORDER_QNTY,
	B.STOCK - COALESCE(SUM(O.QUANTITY),0) AS REMANING_QNTY
FROM ORDERS O
LEFT JOIN BOOKS B
ON B.BOOK_ID = O.BOOK_ID
GROUP BY B.BOOK_ID








