-- 1 Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
-- 2 Выведите список товаров products и разделов catalogs, который соответствует товару.
-- 3 (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name).
-- Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.



-- 1.

select id from users u2
where exists (select * from orders o where user_id = u2.id);

-- 2.

select p.name, c.name
from products as p
join catalogs as c
where p.catalog_id = c.id;

-- 3.

use homework

drop table if exists flights;
create table flights(
	id serial primary key,
	`from` varchar (50),
	`to` varchar (50)
);

drop table if exists cities;
create table cities(
	id serial primary key,
	lable varchar (50),
	name varchar (50)
);

INSERT INTO `flights` (`id`, `from`, `to`) VALUES ('1', 'Moscow', 'Saint-Petersburg');
INSERT INTO `flights` (`id`, `from`, `to`) VALUES ('2', 'Krasnodar', 'Krasnoyarsk');

INSERT INTO `cities` (`id`, `lable`, `name`) VALUES ('1', 'Moscow', 'Москва');
delete from cities where id = 4;
INSERT INTO `cities` (`id`, `lable`, `name`) VALUES ('2', 'Saint-Petersburg', 'Санкт-Петербург');
INSERT INTO `cities` (`id`, `lable`, `name`) VALUES ('3', 'Krasnodar', 'Краснодар');
INSERT INTO `cities` (`id`, `lable`, `name`) VALUES ('4', 'Krasnoyarsk', 'Красноярск');


select f.id, c1.name, c2.name
from flights as f
join cities as c1
join cities as c2
where f.`from` = c1.lable and f.`to` = c2.lable;