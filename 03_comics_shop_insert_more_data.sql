USE [ComicsShop];

--insert more data in the comics table(active = 0)
/*Insert more comics in the comics table*/
BEGIN TRAN
INSERT INTO comics 
VALUES ('Comic 9', 'Lorem Ipsum 9', 1.50, 25, 0, 1),
				('Comic 10', 'Lorem Ipsum 10', 1.55, 25, 0, 2),
				('Comic 11', 'Lorem Ipsum 11', 0.50, 25, 0, 3),
				('Comic 12', 'Lorem Ipsum 12', 0.25, 25, 0, 4),
				('Comic 13', 'Lorem Ipsum 13', 0.50, 25, 0, 1),
				('Comic 14', 'Lorem Ipsum 14', 0.50, 25, 0, 2),
				('Comic 15', 'Lorem Ipsum 15', 0.75, 25, 0, 3),
				('Comic 16', 'Lorem Ipsum 16', 0.75, 25, 0, 4)
SELECT * FROM comics
ROLLBACK TRAN

/*update active = 1 where active was 0*/
BEGIN TRAN
UPDATE comics
SET active = 1
WHERE active = 0
SELECT * FROM comics
ROLLBACK TRAN

/*add +10 to the price for comics in category 4*/
BEGIN TRAN
UPDATE COMICS
SET unit_price = unit_price + 10
WHERE category_id = 4
SELECT * FROM comics
ROLLBACK TRAN

/*delete comics where unit_price < 1*/
BEGIN TRAN
DELETE comics
WHERE unit_price IS NOT NULL AND unit_price < 1
SELECT * FROM comics
ROLLBACK TRAN
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
BEGIN TRAN
/*create a bonus_comics table*/
CREATE TABLE bonus_comics (
	comic_id BIGINT PRIMARY KEY IDENTITY,
	title VARCHAR(255),
	description VARCHAR(255),
	unit_price DECIMAL(5,2),
	units_stock INT,
	active BIT,
	category_id BIGINT FOREIGN KEY REFERENCES comics_categories(id)
);

/*add values in the bonus_comics table*/
INSERT INTO bonus_comics 
VALUES ('BonusComic 1', 'Bonus Lorem Ipsum 1', 0.75, 100, 1, 1),
				('BonusComic 2', 'Bonus Lorem Ipsum 2', 0.25, 100, 1, 2),
				('BonusComic 3', 'Bonus Lorem Ipsum 3', 0.50, 100, 1, 3),
				('BonusComic 4', 'BonusLorem Ipsum 4', 0.15, 100, 1, 4),
				('Comic 5', 'Bonus Lorem Ipsum 5', NULL, 2000, 0, 1),
				('Comic 6', 'Bonus Lorem Ipsum 6', NULL, 2000, 0, 2),
				('Comic 7', 'Bonus Lorem Ipsum 7', NULL, 2000, 0, 3),
				('Comic 8', 'Bonus Lorem Ipsum 8', NULL, 2000, 0, 4)
SELECT * FROM bonus_comics
ROLLBACK TRAN
-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
--a. o interogare cu operatia de reuniune: cu UNION [ALL] sau OR;
/*Afisati toate revistele din categoriile 1 si 4 din tabelele comics si bonus_comics, ordonate dupa categorie*/

SELECT * FROM comics
WHERE category_id = 1 OR category_id = 4
UNION ALL
SELECT * FROM bonus_comics
WHERE category_id = 1 OR category_id = 4
ORDER BY category_id

--b. o interogare cu operatia de intersectie: cu INTERSECT sau IN;
/*Afisati titlurile comune din tabelele comics si bonus_comics*/
SELECT title FROM comics
INTERSECT
SELECT  title FROM bonus_comics
ORDER BY title

/*Afisati informatiile revistelor din tabelul comics care sunt in lista 'Comic 5', 'Comic 6','Comic 7','Comic 8'*/
SELECT * FROM comics
WHERE title IN ('Comic 5', 'Comic 6','Comic 7','Comic 8')
ORDER BY title

/*Afisati titlurile revistelor din tabelul comics care sunt identice cu titlurile revistelor 'Comic 5', 'Comic 6' din tabelul bonus_comics*/
SELECT title FROM comics
INTERSECT
SELECT  title FROM bonus_comics
WHERE title IN ('Comic 5', 'Comic 6')

--c. o interogare cu operatia de diferenta: cu EXCEPT sau NOT IN;
/*Afisati titlurile revistelor din tabelul comics care nu se regasesc si in tabelul bonus_comics*/
SELECT title FROM comics
EXCEPT
SELECT title FROM bonus_comics
ORDER BY title
/*Afisati titlurile revistelor din tabelul comics care nu sunt in lista 'Comic 5', 'Comic 6','Comic 7','Comic 8'*/
SELECT title FROM comics
WHERE title NOT IN ('Comic 5', 'Comic 6','Comic 7','Comic 8')
ORDER BY title

/*
d. o interogare cu INNER JOIN si o interogare cu unul dintre operatorii: 
LEFT JOIN, RIGHT JOIN, FULL JOIN; 
una dintre interogari va extrage date din trei tabele aflate in relatie many-to-many;
*/
/*Afisati informatiile despre customers si adresele acestora cu exceptia celor care au adresa in 'France'*/
SELECT DISTINCT customers.address_id,  customers.first_name, customers.last_name, customers.email, addresses.address_id, addresses.country, addresses.city, addresses.street, addresses.street_number
FROM customers
JOIN addresses ON customers.address_id = addresses.address_id
WHERE addresses.country NOT IN ('France')
GROUP BY customers.address_id,  customers.first_name, customers.last_name, customers.email, addresses.address_id, addresses.country, addresses.city, addresses.street, addresses.street_number
ORDER BY  addresses.country, addresses.city, addresses.street, addresses.street_number

/*Afisati informatiile despre customers si adresele acestora doar daca adresa este din 'Romania'*/
SELECT DISTINCT customers.address_id,  customers.first_name, customers.last_name, customers.email, addresses.address_id, addresses.country, addresses.city, addresses.street, addresses.street_number
FROM customers
JOIN addresses ON customers.address_id = addresses.address_id
WHERE addresses.country = 'Romania'
GROUP BY customers.address_id,  customers.first_name, customers.last_name, customers.email, addresses.address_id, addresses.country, addresses.city, addresses.street, addresses.street_number
ORDER BY  addresses.country, addresses.city, addresses.street, addresses.street_number

/*Afisati informatiile despre customers si adresele acestora*/
SELECT DISTINCT customers.address_id,  customers.first_name, customers.last_name, customers.email, addresses.address_id, addresses.country, addresses.city, addresses.street, addresses.street_number
FROM customers
INNER JOIN addresses ON customers.address_id = addresses.address_id
ORDER BY  addresses.country, addresses.city, addresses.street, addresses.street_number

-------------------LEFT JOIN-------------------------------------------------------------------------------
/*Afisati informatiile despre customers si adresele complete ale acestora*/
SELECT c.address_id, c.first_name, c.last_name, c.email, a.address_id, a.country, a.city, a.state, 
a.street, a.street_number, a.zip_code, a.block_number, a.staircase_number, a.apartment_number
FROM customers AS c
LEFT JOIN addresses AS a 
ON c.address_id = a.address_id
ORDER BY a.country, c.first_name

-------------------RIGHT JOIN-------------------------------------------------------------------------------
/*Afisati informatiile despre customers si adresele complete ale acestora*/
SELECT c.address_id, c.first_name, c.last_name, c.email, a.address_id, a.country, a.city, a.state, 
a.street, a.street_number, a.zip_code, a.block_number, a.staircase_number, a.apartment_number
FROM customers AS c
RIGHT JOIN addresses AS a 
ON c.address_id = a.address_id
ORDER BY a.country, c.first_name

--------------JOIN ON 3 TABLES(comics, comics_authors, authors)--------------------
--o interogare cu INNER JOIN interogarea va extrage date din trei tabele aflate in relatie many-to-many;
/*Afisati titlul revistei, descrierea si autorul*/
SELECT c.comic_id, ca.comic_id, ca.author_id, a.author_id, c.title, c.description, a.author_first_name, a.author_last_name
FROM comics c
JOIN comics_authors ca
ON c.comic_id = ca.comic_id
JOIN authors a
ON ca.author_id = a.author_id
ORDER BY a.author_first_name, c.comic_id, ca.comic_id, ca.author_id, a.author_id, c.title, c.description, a.author_last_name

/*Afisati numarul total de comics care au autorul John Doe*/
SELECT COUNT(title)  AS NumberOfComics FROM (
SELECT c.title, c.description, a.author_first_name, a.author_last_name
FROM comics c
JOIN comics_authors ca
ON c.comic_id = ca.comic_id
JOIN authors a
ON ca.author_id = a.author_id
WHERE author_first_name = 'John' and author_last_name = 'Doe'
) AS NumberOfComics

--e. o interogare care contine o subinterogare in clauza WHERE: cu IN sau EXISTS;
/*Afisati numarul total de reviste la care apar ca autori John Doe si Janne Doe*/
SELECT COUNT(title)  AS NumberOfComics FROM (
SELECT c.title, c.description, a.author_first_name, a.author_last_name
FROM comics c
JOIN comics_authors ca
ON c.comic_id = ca.comic_id
JOIN authors a
ON ca.author_id = a.author_id
WHERE author_first_name IN (
	SELECT author_first_name FROM authors
	WHERE author_last_name = 'Doe'
)
) AS NumberOfComics


--f. o interogare care contine o subinterogare in clauza FROM;
/*Afisati numarul total de reviste la care apar ca autori John Doe si Janne Doe*/
SELECT COUNT(title)  AS NumberOfComics FROM (
SELECT c.title, c.description, a.author_first_name, a.author_last_name
FROM comics c
JOIN comics_authors ca
ON c.comic_id = ca.comic_id
JOIN authors a
ON ca.author_id = a.author_id
WHERE author_first_name IN ('John', 'Janne')
) AS NumberOfComics

/*
g. 2 interogari cu clauza GROUP BY; una dintre ele va contine si clauza HAVING; 
se vor folosi cel putin 2 operatori de agregare dintre: COUNT, SUM, AVG, MIN, MAX;
*/

select * from comics
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
select avg(units_stock) as AvgUnitsStock, category_id from comics
group by category_id
having avg(units_stock)<40
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
select avg(unit_price) as AvgUnitPrice, category_id from comics
group by category_id
having avg(unit_price)>4

select sum(units_stock), category_id from comics
group by category_id
having sum(units_stock)>150



/*Afisati numarul total de reviste de pe stock care au pretul unitar mai mare decat 0 si sunt active pentru vanzare*/
SELECT SUM(TotalUnits) AS TotalGeneral FROM(
SELECT SUM(units_stock) TotalUnits FROM(
SELECT * FROM bonus_comics
GROUP BY comic_id, title, description, unit_price, units_stock, active, category_id
HAVING unit_price > 0 AND active = 1) AS Total

UNION ALL

SELECT SUM(units_stock) TotalUnits FROM(
SELECT * FROM comics
GROUP BY comic_id, title, description, unit_price, units_stock, active, category_id
HAVING unit_price > 0 AND active = 1) AS Total
) AS TotalFinal
--------------------------------------------------------------------------------------------------
/*Afisati numarul total de reviste indiferent de pret sau daca sunt active pentru vanzare*/
SELECT SUM(TotalUnits) AS TotalGeneral FROM(
SELECT SUM(units_stock) TotalUnits FROM(
SELECT * FROM bonus_comics
GROUP BY comic_id, title, description, unit_price, units_stock, active, category_id
) AS Total

UNION ALL

SELECT SUM(units_stock) TotalUnits FROM(
SELECT * FROM comics
GROUP BY comic_id, title, description, unit_price, units_stock, active, category_id
) AS Total
) AS TotalFinal
--------------------------------------------------------------------------------------------------

/*Afisati pretul mediu al comenzilor(orders) care sunt deja livrate*/
SELECT AVG(total_price) AS Average FROM (
SELECT order_id, customer_id, total_price, shipping_status, date_created FROM orders
GROUP BY order_id, customer_id, total_price, shipping_status, date_created
HAVING  AVG(total_price)>10
) AS AveragePriceDelivered

/*Afisati pretul celei mai scumpe comenzi(order) livrata*/
SELECT MAX(total_price) AS Average FROM (
SELECT order_id, customer_id, total_price, shipping_status, date_created FROM orders
GROUP BY order_id, customer_id, total_price, shipping_status, date_created
HAVING  MAX(total_price)<100
) AS AveragePriceDelivered
----------------------------------------------------------------------------------------------------------------------

/*Afisati pretul celei mai ieftine comenzi(order) livrata*/
SELECT MIN(total_price) AS Average FROM (
SELECT order_id, customer_id, total_price, shipping_status, date_created FROM orders
GROUP BY order_id, customer_id, total_price, shipping_status, date_created
HAVING  shipping_status = 'delivered'
) AS AveragePriceDelivered

/*h. o interogare imbricata cu unul dintre operatorii ANY sau ALL, 
unde operatorul relational este din multimea {=, <, <=, >, >=, <>}.*/

/*Sa se afiseze 3 customers care au facut comenzi intre '2023-05-10' si '2023-05-12'*/
SELECT TOP(5) * FROM customers 
WHERE customer_id = ANY(
SELECT distinct customer_id FROM orders
WHERE date_created BETWEEN '2023-05-10' AND '2023-05-12'
)
/*Sa se afiseze cele mai scumpe 5 reviste din comics care au pretul unitar mai mare decat toate revistele din bonus_comics, in ordine descrescatoare*/
SELECT TOP(5) * FROM comics
WHERE unit_price > ALL (
SELECT unit_price FROM bonus_comics
WHERE unit_price IS NOT NULL
)
ORDER BY unit_price DESC

--------expresii aritmetice in clauza SELECT------------Obs. Se pot utiliza view-uri in cel mult cinci interogari.--------------------------------------

/*Creati un view in care sa aveti calculat pretul total pentru fiecare comanda(order)*/
CREATE VIEW CheckTotalPrice AS
SELECT order_id, SUM(comic_quantity * sale_price)  AS TotalPrice 
FROM order_item 
GROUP BY order_id

SELECT * FROM CheckTotalPrice

/*Afisati alaturat tabelul de orders si view-ul creat pentru verificarea pretului total al comenzilor*/
SELECT * FROM orders
LEFT JOIN CheckTotalPrice
ON orders.order_id = CheckTotalPrice.order_id