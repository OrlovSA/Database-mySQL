create database if not exists 1111;
use 1111;

drop table if exist user;
create table users(
	id serial primary key,
    firstname varchar(50),
    lastname varchar(50) comment 'Фамилия пользоватиля',
    email varchar(120),
    phone varchar(20),
    birtday date,
    hometown varchar(100)
    gender char(1),
    photo_id bigint unsigned not null,
    created_at datetime default now(),
    pass char(30)
);


drop table if exist user;
create table messages(
	id serial primary key,
	from_user_id bigint unsigned not null,
	to_user_id bigint unsigned not null,
	message text not null,
	is_read bool,
	created_at datetime default now(),
	foreign key (from_user_id) references users(id),
	foreign key (to_user_id) references users(id)
);

drop table if exists frend_requests;
create table frend_requests(
	initiator_user_id bigint unsigned not null,
	target_user_id bigint unsigned not null,
	status enum('requested', 'approved', 'unfrinded', 'declined'),
	requested_at datetime default now(),
	confirmed_at datetime default current_timestamp on update current_timestamp,
	primary key(initiator_user_id, target_user_id)
);


insert into test_tb1 value (1, 'test_name');