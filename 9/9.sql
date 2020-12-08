-- 1 В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.
-- 2 Создайте представление, которое выводит название name товарной позиции из таблицы products
--  и соответствующее название каталога name из таблицы catalogs.
-- 3 по желанию) Пусть имеется таблица с календарным полем created_at. В ней размещены разряженые календарные записи за август
--  2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. Составьте запрос, который выводит полный список дат за август,
--  выставляя в соседнем поле значение 1, если дата присутствует в исходном таблице и 0, если она отсутствует.
-- 4 (по желанию) Пусть имеется любая таблица с календарным полем created_at. Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.

--  Практическое задание по теме “Администрирование MySQL” (эта тема изучается по вашему желанию)
-- 1 Создайте двух пользователей которые имеют доступ к базе данных shop. Первому пользователю shop_read должны быть доступны только запросы на чтение данных,
--  второму пользователю shop — любые операции в пределах базы данных shop.
-- 2 (по желанию) Пусть имеется таблица accounts содержащая три столбца id, name, password, содержащие первичный ключ, 
-- имя пользователя и его пароль. Создайте представление username таблицы accounts, предоставляющий доступ к столбца id
--  и name. Создайте пользователя user_read, который бы не имел доступа к таблице accounts, однако, мог бы извлекать записи из представления username.

-- Практическое задание по теме “Хранимые процедуры и функции, триггеры"
-- 1 Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
-- с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
-- 2 В таблице products есть два текстовых поля: name с названием товара и description с его описанием. Допустимо присутствие обоих полей или одно из них.
--  Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены.
--  При попытке присвоить полям NULL-значение необходимо отменить операцию.
-- 3 (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. Числами Фибоначчи называется последовательность в которой
--  число равно сумме двух предыдущих чисел. Вызов функции FIBONACCI(10) должен возвращать число 55.


-- 1.

start transaction;
select * from users where users.id = 1;
insert into sample.users select * from shop_1.users where users.id = 1;
delete from shop_1.users where users.id = 1;
commit;

-- 2. 

create view prod_cat as
select p.name prod, c.name cat
from products as p
join catalogs as c
where p.catalog_id = c.id;

select * from prod_cat;

-- 4.

delimiter //
drop procedure if exists delete_old_entries//
create procedure delete_old_entries()
begin
	drop table if exists latest_5_entries;
	create temporary table latest_5_entries select * from users order by created_at desc limit 5;
	truncate table users;
	insert into users select * from latest_5_entries;	
end//

call delete_old_entries ();

-- Хранимые процедуры

-- 1. 
select current_time();

delimiter //
drop procedure if exists Hello//
create procedure Hello()
begin
	set @time = current_time();
	select
		case
			when @time >= '00:00:00' and @time < '06:00:00' then 'Доброй ночи!'
			when @time >= '06:00:00' and @time < '12:00:00' then 'Доброе утро'
			when @time >= '12:00:00' and @time < '18:00:00' then 'Добрый день'
			when @time >= '18:00:00' and @time < '23:59:59' then 'Добрый вечер'
		end as greeting;
end//

call Hello();

-- 2.

delimiter //
drop trigger if exists products_not_null//
create trigger products_not_null before insert on products
for each row
begin 
  	IF new.name is NULL and new.description is NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Введите Name или Description';
  	END IF;
end//

drop trigger products_not_null;

-- Проверка:
INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  (NULL, NULL, 7890.00, 1);