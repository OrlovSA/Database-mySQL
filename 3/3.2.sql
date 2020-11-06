-- Будет ооооочень много коментов, это я пытаюсь разобратся во всем незнакомом.

drop database if exists snet2910; -- удаляем базу если имеется 
create database snet2910 character set = utf8mb4; -- создаем базу с кодировкой 
use snet2910; -- переходим к базе

drop table if exists users; -- удаляем таблицу если есть
-- создаем таблицу
create table users( 
	id serial primary key, -- serial primary key задает № строке отталкиваясь от предыдущего чила самостоятельно, первый равен 0.
	firstname varchar(50) comment 'Имя пользователя', -- строковое значение до 50 символов из 255 возможных 
	lastname varchar(50) comment 'Фамилия пользователя',
	email varchar(120) unique comment 'почта пользователя', -- unique проверка на уникальность в базе данных
	phone varchar(20) unique comment 'телефон пользователя',
	birtday date comment 'дата рождения пользователя',  -- date способ ханнение даты YYYY-MM-DD от '1000-01-01' до '9999-12-31'.
	hometown varchar(100) comment 'город пользователя', 
	gender char(1) comment 'пол пользователя', -- также строковое занчение char(1) если известна длина строк, это быстрей оробатывается но занимает больше места.
	photo_id bigint unsigned comment 'аватарку пользователя', -- bigint числовое значение 64 бит, unsigned запрешает отрицательные
																		-- числа и сдвигает возможное числа на половину в +
	created_at datetime default now() comment 'Вреям строки сообщения', -- получает системное время при создании строки по умолчанию с учетом часового пояса
	pass char(30) comment 'пароль пользоватея', 
	likes int default null
) comment 'таблица с пользователями';

alter table users add index (phone);  -- добавляем индекс
alter table users add index users_firstname_lastname_idx (firstname, lastname); 

drop table if exists settings;
create table settings(
	user_id serial primary key,
	can_see ENUM('all', 'friends_of_friends', 'friends', 'nobody'),
	can_comment ENUM('all', 'friends_of_friends', 'friends', 'nobody'),
	can_message ENUM('all', 'friends_of_friends', 'friends', 'nobody'),
	foreign key (user_id) references users(id)
);

drop table if exists messages;
create table messages(
	id serial primary key,
	from_user_id bigint unsigned not null comment 'добавляем пользователя написавшего сообщение', -- not null проверяем что значение не равняется ничему null, иначе ошибка
	to_user_id bigint unsigned not null comment 'добавляем пользователя кому пишет сообщение',
	message text not null comment 'сообщение', -- еще один типо хранения текстовых на подобие varchar
	is_read bool default 0, -- булевое со значением по умолчанию 0
	created_at datetime default now() comment 'время строки сообщения',
	foreign key (from_user_id) references users(id) , -- берем для строки from_user_id из таблици users и строки (id) данные о пользователе (если их там нет вернет null)
	foreign key (to_user_id) references users(id),
	likes int default null
) comment 'таблица с сообщениями';

alter table messages add index messages_from_user_id (from_user_id); 
alter table messages add index messages_to_user_id (to_user_id); 

drop table if exists friend_requests;
create table friend_requests(
	initiator_user_id bigint unsigned not null,
	target_user_id bigint unsigned not null,
	status enum('requested', 'approved', 'unfriended', 'declined'), -- enum список пеерменных также может принемать значение "" =  0 или Null
	requested_at datetime default now() comment 'Вреям строки сообщения',
	confirmed_at datetime default current_timestamp on update current_timestamp,
	primary key(initiator_user_id, target_user_id), -- создаем в строке уникальную записи из 2х переменных 
	index (initiator_user_id),-- индексируем
	index (target_user_id),
	foreign key (initiator_user_id) references users(id),
	foreign key (target_user_id) references users(id)
)comment 'таблица с отношениями пользователей';

drop table if exists communities;
create table communities (
	id serial primary key,
	name varchar(150),
	index(name)
) comment 'группы';

drop table if exists users_communities;
create table users_communities(
	user_id bigint unsigned not null,
	community_id  bigint unsigned not null,
	primary key(user_id, community_id),
	foreign key (user_id) references users(id),
	foreign key (community_id) references communities(id)
) comment 'связи группы';

drop table if exists posts;
create table posts(
	id serial primary key,
	user_id bigint unsigned not null,
	post text,
	attachments json, -- тип данных json набор списков и словарей с типами данных и самими данными.
	metadata json,
	created_at datetime default current_timestamp,
	updated_at datetime default current_timestamp on update current_timestamp,
	foreign key (user_id) references users(id),
	likes int default null
) comment 'посты';

drop table if exists comments;
create table comments (
	id serial primary key,
	user_id bigint unsigned not null,
	post_id bigint unsigned not null,
	comment text,
	created_at datetime default current_timestamp,
	updated_at datetime default current_timestamp on update current_timestamp,
	foreign key (user_id) references users(id),
	foreign key (post_id) references posts(id),
	likes int default null
) comment 'коменты под пост';

-- добавил коменты под коментами
drop table if exists comments_comments;
create table comments_comments (
	id serial primary key,
	user_id bigint unsigned not null,
	comments_id bigint unsigned not null,
	comment text,
	created_at datetime default current_timestamp,
	updated_at datetime default current_timestamp on update current_timestamp,
	foreign key (user_id) references users(id),
	foreign key (comments_id) references comments(id),
	likes int default null
) comment 'коменты коментов';

drop table if exists photos;
create table photos(
	id serial primary key,
	filename varchar(255),
	user_id bigint unsigned not null,
	description text,
	created_at datetime default current_timestamp,
	foreign key (user_id) references users(id),
	likes int default null
) comment 'фото';

drop table if exists likes_posts;
create table likes_posts(
	user_id bigint not null,
	post_id bigint not null,
	primary key(user_id, post_id),
	created_at datetime default current_timestamp,
	updated_at datetime default current_timestamp on update current_timestamp,
	foreign key (user_id) references users(id),
	foreign key (post_id) references posts(id)
) comment 'лайки поста';

drop table if exists likes_users;
create table likes_users (
	user_id bigint not null,
	user_id_to bigint not null,
	primary key(user_id, user_id_to),
	created_at datetime default current_timestamp,
	updated_at datetime default current_timestamp on update current_timestamp,
	foreign key (user_id) references users(id),
	foreign key (user_id_to) references users(id)
) comment 'лайки пользователей';

drop table if exists likes_comments;
create table likes_comments (
	user_id bigint not null,
	comments_id bigint not null,
	primary key(user_id, comments_id),
	created_at datetime default current_timestamp,
	updated_at datetime default current_timestamp on update current_timestamp,
	foreign key (user_id) references users(id),
	foreign key (comments_id) references comments(id)
) comment 'лайки коментариев';

drop table if exists likes_comments_comments;
create table likes_comments_comments (
	user_id bigint not null,
	comments_comments_id bigint not null,
	primary key(user_id, comments_comments_id),
	created_at datetime default current_timestamp,
	updated_at datetime default current_timestamp on update current_timestamp,
	foreign key (user_id) references users(id),
	foreign key (comments_comments_id) references comments_comments(id)
) comment 'лайки подкоментов';

drop table if exists likes_photos;
create table likes_photos (
	user_id bigint not null,
	photos_id bigint not null,
	primary key(user_id, photos_id),
	created_at datetime default current_timestamp,
	updated_at datetime default current_timestamp on update current_timestamp,
	foreign key (user_id) references users(id),
	foreign key (photos_id) references photos(id)
) comment 'лайки фото';