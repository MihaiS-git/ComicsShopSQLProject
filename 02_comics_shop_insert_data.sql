USE ComicsShop;

INSERT INTO comics_categories
VALUES('Super Heroes'),
				('Fairy Tales'),
				('Robots'),
				('Monsters');

INSERT INTO comics
VALUES ('Comic 1', 'Lorem Ipsum 1', 10.50, 100, 1, 1),
				('Comic 2', 'Lorem Ipsum 2', 5.25, 50, 1, 2),
				('Comic 3', 'Lorem Ipsum 3', 2.50, 27, 1, 3),
				('Comic 4', 'Lorem Ipsum 4', 7.25, 75, 1, 4),
				('Comic 5', 'Lorem Ipsum 5', 5.50, 20, 1, 1),
				('Comic 6', 'Lorem Ipsum 6', 2.50, 84, 1, 2),
				('Comic 7', 'Lorem Ipsum 7', 11.75, 65, 1, 3),
				('Comic 8', 'Lorem Ipsum 8', 3.75, 74, 1, 4)

INSERT INTO authors
VALUES ('John', 'Doe'),
				('Janne', 'Doe'),
				('John', 'Thomas'),
				('Tom', 'Box'),
				('Fred', 'Tim')

INSERT INTO comics_authors
VALUES (1,1),
				(1,4),
				(2,2),
				(2,5),
				(3,3),
				(3,1),
				(4,4),
				(4,2),
				(5,5),
				(5,3),
				(6,1),
				(6,4),
				(7,2),
				(7,5),
				(8,3),
				(8,1)

INSERT INTO addresses
VALUES ('France', 'Ille de France', 'Paris', 'Victor Hugo', 5, 2, 1, 10, '400255'),
				('USA', 'Columbia', 'Washington DC', '4th', 47, 1, 2, 2, '111445'),
				('USA', 'Chicago', 'Chicago', '12th', 112, 3, 2, 14, '114756'),
				('France', 'Bordeaux', 'Bordeaux', 'Ancienne Mairie', 34, 2, 2, 27, '401247'),
				('France', 'Calais', 'Calais', 'Ancienne Rue', 14, 1, 1, 12, '402447'),
				('USA', 'Florida', 'Miami', '2nd', 225, 1, 2, 12, '115887'),
				('Romania', 'Cluj', 'Cluj-Napoca', 'Eroilor', 7, 1, 2, 20, '400255'),
				('Romania', 'Brasov', 'Brasov', 'Victoriei', 24, 3, 4, 85, '265447'),
				('Romania', 'Ilfov', 'Bucuresti', 'Aviatorilor', 37, 2, 3, 47, '100234'),
				('Romania', 'Iasi', 'Iasi', 'Cobzei', 3, 2, 3, 36, '300457')

INSERT INTO customers
VALUES ('Claire', 'Papin', 'claire_mail@test.com', 1),
				('Birdie', 'Cherry', 'birdie_mail@test.com', 2),
				('Lonely', 'Cherry', 'lonely_mail@test.com', 2),
				('Tommy', 'Burton', 'kido_mail@test.com', 3),
				('Jean', 'Papin', 'jean@test.com', 1),
				('Amen', 'Koutan', 'amen_mail@test.com', 4),
				('Moboutu', 'Seseseko', 'moboutu@test.com', 5),
				('David', 'Timos',  'david@test.com', 6),
				('Pop', 'Ionut',  'ionut@test.com', 7),
				('Tomescu', 'Anton',  'anton@test.com', 8),
				('Bucurescu', 'Zamfira',  'zamfira@test.com', 9),
				('Mos', 'Ion',  'mosion@test.com', 10),
				('Mos', 'Anisia',  'anisia@test.com', 10)
				

INSERT INTO orders (customer_id, shipping_status, date_created, last_updated)
VALUES(1,  'delivered', '2023-05-05', '2023-05-07'),
				(2,  'pending', '2023-05-28', '2023-05-28'),
				(3,  'pending', '2023-05-28', '2023-05-28'),
				(4,  'delivered', '2023-05-15', '2023-05-17'),
				(5,  'delivered', '2023-05-14', '2023-05-17'),
				(6,  'delivered', '2023-05-10', '2023-05-12'),
				(7,  'delivered', '2023-05-12', '2023-05-13'),
				(8,  'delivered', '2023-05-10', '2023-05-12'),
				(9,  'pending', '2023-05-29', '2023-05-29'),
				(10,  'delivered', '2023-05-11', '2023-05-11'),
				(11,  'delivered', '2023-05-10', '2023-05-12'),
				(12,  'pending', '2023-05-27', '2023-05-27'),
				(13,  'delivered', '2023-05-10', '2023-05-12'),
				(7,  'pending', '2023-05-29', '2023-05-29'),
				(6,  'pending', '2023-05-28', '2023-05-28'),
				(11,  'delivered', '2023-05-12', '2023-05-14'),
				(7,  'delivered', '2023-05-05', '2023-05-07'),
				(9,  'delivered', '2023-05-02', '2023-05-04'),
				(12,  'delivered', '2023-05-16', '2023-05-18'),
				(11,  'pending', '2023-05-27', '2023-05-27')

INSERT INTO order_item (order_id, comic_id, comic_quantity, sale_price)
VALUES
  (1, 1, 1, 10.50),
  (1, 7, 2, 11.75),
  (1, 4, 3, 7.25),
  (2, 2, 3, 5.25),
  (2, 7, 1, 11.75),
  (3, 8, 5, 3.75),
  (4, 2, 3, 5.25),
  (5, 8, 3, 3.75),
  (5, 2, 3, 5.25),
  (6, 2, 3, 5.25),
  (7, 6, 5, 2.50),
  (7, 4, 5, 7.25),
  (7, 1, 5, 10.50),
  (8, 5, 1, 5.50),
  (9, 6, 30, 1.50),
  (9, 3, 30, 4.25),
  (9, 7, 30, 7.25),
  (10, 5, 3, 5.50),
  (10, 2, 3, 5.25),
  (11, 6, 2, 2.50),
  (12, 3, 1, 2.50),
  (13, 4, 1, 7.25),
  (14, 5, 1, 5.50),
  (15, 6, 1, 2.50),
  (16, 7, 1, 11.75),
  (17, 8, 1, 3.75),
  (18, 1, 1, 10.50),
  (19, 2, 1, 5.25),
  (20, 3, 1, 2.50)

UPDATE orders
SET total_price = (
    SELECT SUM(oi.comic_quantity * oi.sale_price)
    FROM order_item oi
    WHERE oi.order_id = orders.order_id
)
WHERE EXISTS (
    SELECT 1
    FROM order_item oi
    WHERE oi.order_id = orders.order_id
);
