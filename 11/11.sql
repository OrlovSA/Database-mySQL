-- Практическое задание по теме “Оптимизация запросов”

-- 1 Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, 
--   catalogs и products в таблицу logs помещается время и дата создания записи, 
-- 	 название таблицы, идентификатор первичного ключа и содержимое поля name.

set autocommit = 0;
start transaction;
drop table if exists logs;
create table logs (
	created_at datetime default now(),
	table_name varchar(25),
	id integer,
	field_name_value varchar(255)
)
engine=archive;
drop procedure if exists write_log;
drop trigger if exists users_insert_trg;
drop trigger if exists products_insert_trg;
drop trigger if exists catalogs_insert_trg;
delimiter //

create procedure write_log(in table_name_ varchar(25), in id_ integer, in field_name_value_ varchar(255))
begin
	insert into logs(table_name, id, field_name_value) 
	values(table_name_, id_, field_name_value_);
end//

create trigger users_insert_trg after insert on users
for each row begin
	call write_log("users", new.id, new.name);
end//

create trigger catalogs_insert_trg after insert on catalogs
for each row begin
	call write_log("catalogs", new.id, new.name);
end//

create trigger products_insert_trg after insert on products
for each row begin
	call write_log("products", new.id, new.name);
end//

delimiter ; 