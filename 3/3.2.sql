-- ����� ��������� ����� ��������, ��� � ������� ���������� �� ���� ����������.

drop database if exists snet2910; -- ������� ���� ���� ������� 
create database snet2910 character set = utf8mb4; -- ������� ���� � ���������� 
use snet2910; -- ��������� � ����

drop table if exists users; -- ������� ������� ���� ����
-- ������� �������
create table users( 
	id serial primary key, -- serial primary key ������ � ������ ������������ �� ����������� ���� ��������������, ������ ����� 0.
	firstname varchar(50) comment '��� ������������', -- ��������� �������� �� 50 �������� �� 255 ��������� 
	lastname varchar(50) comment '������� ������������',
	email varchar(120) unique comment '����� ������������', -- unique �������� �� ������������ � ���� ������
	phone varchar(20) unique comment '������� ������������',
	birtday date comment '���� �������� ������������',  -- date ������ �������� ���� YYYY-MM-DD �� '1000-01-01' �� '9999-12-31'.
	hometown varchar(100) comment '����� ������������', 
	gender char(1) comment '��� ������������', -- ����� ��������� �������� char(1) ���� �������� ����� �����, ��� ������� ������������� �� �������� ������ �����.
	photo_id bigint unsigned comment '�������� ������������', -- bigint �������� �������� 64 ���, unsigned ��������� �������������
																		-- ����� � �������� ��������� ����� �� �������� � +
	created_at datetime default now() comment '����� ������ ���������', -- �������� ��������� ����� ��� �������� ������ �� ��������� � ������ �������� �����
	pass char(30) comment '������ �����������', 
	likes int default null
) comment '������� � ��������������';

alter table users add index (phone);  -- ��������� ������
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
	from_user_id bigint unsigned not null comment '��������� ������������ ����������� ���������', -- not null ��������� ��� �������� �� ��������� ������ null, ����� ������
	to_user_id bigint unsigned not null comment '��������� ������������ ���� ����� ���������',
	message text not null comment '���������', -- ��� ���� ���� �������� ��������� �� ������� varchar
	is_read bool default 0, -- ������� �� ��������� �� ��������� 0
	created_at datetime default now() comment '����� ������ ���������',
	foreign key (from_user_id) references users(id) , -- ����� ��� ������ from_user_id �� ������� users � ������ (id) ������ � ������������ (���� �� ��� ��� ������ null)
	foreign key (to_user_id) references users(id),
	likes int default null
) comment '������� � �����������';

alter table messages add index messages_from_user_id (from_user_id); 
alter table messages add index messages_to_user_id (to_user_id); 

drop table if exists friend_requests;
create table friend_requests(
	initiator_user_id bigint unsigned not null,
	target_user_id bigint unsigned not null,
	status enum('requested', 'approved', 'unfriended', 'declined'), -- enum ������ ���������� ����� ����� ��������� �������� "" =  0 ��� Null
	requested_at datetime default now() comment '����� ������ ���������',
	confirmed_at datetime default current_timestamp on update current_timestamp,
	primary key(initiator_user_id, target_user_id), -- ������� � ������ ���������� ������ �� 2� ���������� 
	index (initiator_user_id),-- �����������
	index (target_user_id),
	foreign key (initiator_user_id) references users(id),
	foreign key (target_user_id) references users(id)
)comment '������� � ����������� �������������';

drop table if exists communities;
create table communities (
	id serial primary key,
	name varchar(150),
	index(name)
) comment '������';

drop table if exists users_communities;
create table users_communities(
	user_id bigint unsigned not null,
	community_id  bigint unsigned not null,
	primary key(user_id, community_id),
	foreign key (user_id) references users(id),
	foreign key (community_id) references communities(id)
) comment '����� ������';

drop table if exists posts;
create table posts(
	id serial primary key,
	user_id bigint unsigned not null,
	post text,
	attachments json, -- ��� ������ json ����� ������� � �������� � ������ ������ � ������ �������.
	metadata json,
	created_at datetime default current_timestamp,
	updated_at datetime default current_timestamp on update current_timestamp,
	foreign key (user_id) references users(id),
	likes int default null
) comment '�����';

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
) comment '������� ��� ����';

-- ������� ������� ��� ���������
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
) comment '������� ��������';

drop table if exists photos;
create table photos(
	id serial primary key,
	filename varchar(255),
	user_id bigint unsigned not null,
	description text,
	created_at datetime default current_timestamp,
	foreign key (user_id) references users(id),
	likes int default null
) comment '����';

drop table if exists likes_posts;
create table likes_posts(
	user_id bigint not null,
	post_id bigint not null,
	primary key(user_id, post_id),
	created_at datetime default current_timestamp,
	updated_at datetime default current_timestamp on update current_timestamp,
	foreign key (user_id) references users(id),
	foreign key (post_id) references posts(id)
) comment '����� �����';

drop table if exists likes_users;
create table likes_users (
	user_id bigint not null,
	user_id_to bigint not null,
	primary key(user_id, user_id_to),
	created_at datetime default current_timestamp,
	updated_at datetime default current_timestamp on update current_timestamp,
	foreign key (user_id) references users(id),
	foreign key (user_id_to) references users(id)
) comment '����� �������������';

drop table if exists likes_comments;
create table likes_comments (
	user_id bigint not null,
	comments_id bigint not null,
	primary key(user_id, comments_id),
	created_at datetime default current_timestamp,
	updated_at datetime default current_timestamp on update current_timestamp,
	foreign key (user_id) references users(id),
	foreign key (comments_id) references comments(id)
) comment '����� �����������';

drop table if exists likes_comments_comments;
create table likes_comments_comments (
	user_id bigint not null,
	comments_comments_id bigint not null,
	primary key(user_id, comments_comments_id),
	created_at datetime default current_timestamp,
	updated_at datetime default current_timestamp on update current_timestamp,
	foreign key (user_id) references users(id),
	foreign key (comments_comments_id) references comments_comments(id)
) comment '����� �����������';

drop table if exists likes_photos;
create table likes_photos (
	user_id bigint not null,
	photos_id bigint not null,
	primary key(user_id, photos_id),
	created_at datetime default current_timestamp,
	updated_at datetime default current_timestamp on update current_timestamp,
	foreign key (user_id) references users(id),
	foreign key (photos_id) references photos(id)
) comment '����� ����';