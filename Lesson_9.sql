-- В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции

begin;
update users set id = 3 where name = 'Andrew';
insert into sample.users select * from shop.users where id = 1;delete select * from users where id = 1;
delete select * from users where id = 1;
commit;

-- Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs.

create view c_p as select c.name cat_name, p.name prod_name from products p join catalogs c on p.catalog_id = c.id;

--(по желанию) Пусть имеется любая таблица с календарным полем created_at. Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей

begin;
create view t as select * from users order by created_at desc limit 5;
delete from users where id not in (select id from t);
commit;

-- Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

USE shop
DROP FUNCTION IF EXISTS hello;
delimiter //
CREATE FUNCTION hello()
RETURNS text DETERMINISTIC
BEGIN
	DECLARE greetings varchar(20);
	SET greetings = 'pppp';
		IF TIME_FORMAT(CURRENT_TIME, '%H') > '24' AND TIME_FORMAT(CURRENT_TIME, '%H') < '06' THEN set greetings = 'Good night!';
		ELSEIF TIME_FORMAT(CURRENT_TIME, '%H') > '06' AND TIME_FORMAT(CURRENT_TIME, '%H') < '12' THEN set greetings = 'Good morning!';
		ELSEIF TIME_FORMAT(CURRENT_TIME, '%H') > '12' AND TIME_FORMAT(CURRENT_TIME, '%H') < '18' THEN set greetings = 'Good day!';
		ELSEIF TIME_FORMAT(CURRENT_TIME, '%H') > '18' AND TIME_FORMAT(CURRENT_TIME, '%H') < '24' THEN set greetings = 'Good evening!';
		END IF;
	RETURN greetings;
END//

select hello()

--В таблице products есть два текстовых поля: name с названием товара и description с его описанием. Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию.

DROP TRIGGER if EXISTS prod;
delimiter //
CREATE TRIGGER prod BEFORE INSERT ON products
FOR EACH ROW
BEGIN
	IF new.name IS NULL and NEW.description IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Name and Description cant be Null';
	END IF;
END//

-- (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. Вызов функции FIBONACCI(10) должен возвращать число 55.

DELIMITER //
CREATE FUNCTION fibonacci(mult int)
RETURNS int DETERMINISTIC
BEGIN
	DECLARE num1 int DEFAULT 0;
	DECLARE num2 int DEFAULT 1;
	DECLARE num3 int DEFAULT 0;
	DECLARE my_count int DEFAULT 1;
	WHILE my_count < mult DO
		set num3 = num1 + num2;
		set num1 = num2;
		set num2 = num3;
		set my_count = my_count + 1;
	END WHILE;		
	RETURN num3;
END//