-- CRUD (данные)
-- create INSERT
-- read SELECT
-- update UPDATE
-- delete DELETE, TRUNCATE

-- INSERT

INSERT INTO users 
SET
	firstname='Евгений',
	lastname='Грачев',
	email='dcolquita@ucla.edu',
	phone=9744906651,
	birtday='1987-11-26',
	hometown='Омск',
	gender='m',
	photo_id=4,
	pass='1487c1cf7c24df739fc9e7460a2c79',
	likes=5;

-- INSERT ... select

insert into users 
select * from test.users limit 101,10; -- добавляем данные в нашу таблицу из таблицы другой БД


-- select
select * from users; -- выбираем данные из всех колонок таблицы
select * from users limit 10; -- выбираем первые 10
select * from users limit 10 offset 10; -- пропускаем первые 10 (offset), выбираем 10 
select * from users limit 8,3; -- select * from communities limit 3 offset 8;
select lastname, firstname, phone from users limit 10; -- выбираем данные из 3х столбцов
select lastname, firstname, phone from users order by lastname asc limit 10; -- сортируем по фамилии в алф. порядке asc - возр, desc - убыв.
select lastname, firstname, phone from users order by lastname, firstname limit 10; -- возможна сортировка по нескольким столбцам
select 'hello!' limit 10; -- используем для вывода строки
select 3*8 limit 10; -- работают арифметические операторы
select concat(lastname, ' ', firstname) as username from users limit 10; -- склейка строки с пом. ф-ции concat, добавили алиас username для столбца в результирующей выборке
select concat(substring(firstname, 1,1),'. ',lastname) as persons from users limit 10; -- "обрезаем" имя до первого символа
select distinct hometown from users limit 10; -- получаем только уникальные строки
select * from users where hometown = 'berg' limit 10; -- с помощью ограничения where выбираем пользователей из определённого города
select lastname, firstname, hometown from users 
	where hometown = 'berg' or hometown ='town' or hometown ='haven' limit 10;-- ограничения where с "или"

select lastname, firstname, hometown, gender from users 
	where hometown = 'berg' or gender = 'm' limit 10;-- ограничения where с "или"

select lastname, firstname, hometown, gender from users 
	where hometown = 'berg' and gender = 'm' limit 10;-- ограничения where с "и"

select lastname, firstname, hometown from users where hometown in ('berg', 'town', 'haven') limit 10; -- in позволяет задавать несколько значений в where 

select lastname, firstname, hometown from users where hometown != 'berg' limit 10; -- город НЕ Москва
select lastname, firstname, hometown from users where hometown <> 'berg' limit 10; -- аналогично предыдущему

select lastname, firstname, birtday from users where birtday >= '1985-01-01' limit 10; -- условие больше или равно

select lastname, firstname, birtday from users where birtday >= '1985-01-01' and birtday <= '1990-01-01' limit 10; -- выборка между значениями условий 

select lastname, firstname, birtday from users where birtday between '1985-01-01' and '1990-01-01' limit 10; -- аналогично предыдущему

select lastname, firstname from users where lastname like 'm%' limit 10; -- поиск подстроки, начинающейся на "Ки" и содержащей далее 0 или более символов (%)
select lastname, firstname from users where lastname like '%n' limit 10;-- поиск подстроки, заканчивающейся на "ко" и содержащей перед этим 0 или более символов или более символов (%)
select lastname, firstname from users where lastname like 'a_n' limit 10;

select count(*) from users limit 10; -- всего 208 записей о пользователях
select count(hometown) from users limit 10; -- 204, null не считается
select count(distinct hometown) from users limit 10; -- подсчёт уник значений

select hometown, count(*) from users group by hometown limit 10; -- группируем по городу и считаем, сколько пользователей в каждом городе

select hometown, count(*) from users group by hometown having count(*) >= 10 limit 10; -- выбираем строки, где пользователей в каждом городе  >= 10

-- UPDATE 
update users
set hometown ='town' where hometown ='berg';

update friend_requests 
	set status = 'approved'
	where initiator_user_id = 2 and target_user_id = 4

-- DELETE
delete from users where id = 101;


-- TRUCATE

truncate table photos;

-- DDL командв на изменение
ALTER TABLE users CHANGE birtday birthday date NULL; -- переименовали столбец
ALTER TABLE
users MODIFY COLUMN pass char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL; -- менякм кол-во символов для колонки
