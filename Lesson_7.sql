-- Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

select distinct u.name from (select * from users) as u join (select * from orders) as o on o.user_id = u.id group by name;

-- Выведите список товаров products и разделов catalogs, который соответствует товару.

select p.name as good_name, c.name as ctegoty from (select * from products) as p join (select * from catalogs) as c on p.catalog_id = c.id;

-- (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.

select fr.id, fr.from2, to.to2 from (select fl.id, ci.name as from2 from (select id, `from` from flights) fl join (select * from cities) ci on fl.from = ci.lable order by fl.id) fr join (select fl.id, ci.name as to2 from (select id, `to` from flights) fl join (select * from cities) ci on fl.to = ci.lable order by fl.id) `to` on fr.id = to.id order by fr.id;
