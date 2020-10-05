-- 1.Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.

alter table users drop column created_at;
alter table users add column created_at varchar(20);
alter table users add column updated_at varchar(20);
update users set created_at=now();
update users set updated_at=now();

-- 2.Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10. Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.

alter table users add column created_at_2 datetime;
update users set created_at_2 = created_at;
alter table users add column updated_at_2 datetime;
update users set updated_at_2 = updated_at;
alter table users drop column created_at;
alter table users drop column updated_at;
alter table users change column created_at_2 created_at datetime;
alter table users change column updated_at_2 updated_at datetime;

-- 3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако нулевые запасы должны выводиться в конце, после всех записей.

alter table users add column null_id char(1) default 1;
update users set null_id=null where phone=0;
select * from users order by -null_id desc, phone asc;

-- 4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий (may, august)

UPDATE users SET birthmonth = CASE 
WHEN month(birthday) = 1 then 'January' 
WHEN month(birthday) = 2 then 'February'
WHEN month(birthday) = 3 then 'March'
WHEN month(birthday) = 4 then 'April'
WHEN month(birthday) = 5 then 'May'
WHEN month(birthday) = 6 then 'June'
WHEN month(birthday) = 7 then 'July'
WHEN month(birthday) = 8 then 'August'
WHEN month(birthday) = 9 then 'September'
WHEN month(birthday) = 10 then 'October'
WHEN month(birthday) = 11 then 'November'
WHEN month(birthday) = 12 then 'December'
END;
select * from users where birthmonth like '_ay' OR birthmonth like '_ugust';

-- 5.(по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.

alter table users add column fake_id varchar(10);
update users set fake_id = case id when 5 then 1 when 1 then 2 when 2 then 3 end;
select * from users order by -fake_id desc limit 3;

-- Практическое задание теме «Агрегация данных»
-- 1. Подсчитайте средний возраст пользователей в таблице users.

select AVG(timestampdiff(year, birthday, curdate())) as Average_age from users;

-- 2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения.

select dayname(date_format(birthday, '2020-%m-%d')) as day, count(dayname(date_format(birthday, '2020-%m-%d'))) as quantity from users group by dayname(date_format(birthday, '2020-%m-%d'));

-- 3. (по желанию) Подсчитайте произведение чисел в столбце таблицы.


