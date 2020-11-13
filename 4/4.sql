-- CRUD (������)
-- create INSERT
-- read SELECT
-- update UPDATE
-- delete DELETE, TRUNCATE

-- INSERT

INSERT INTO users 
SET
	firstname='�������',
	lastname='������',
	email='dcolquita@ucla.edu',
	phone=9744906651,
	birtday='1987-11-26',
	hometown='����',
	gender='m',
	photo_id=4,
	pass='1487c1cf7c24df739fc9e7460a2c79',
	likes=5;

-- INSERT ... select

insert into users 
select * from test.users limit 101,10; -- ��������� ������ � ���� ������� �� ������� ������ ��


-- select
select * from users; -- �������� ������ �� ���� ������� �������
select * from users limit 10; -- �������� ������ 10
select * from users limit 10 offset 10; -- ���������� ������ 10 (offset), �������� 10 
select * from users limit 8,3; -- select * from communities limit 3 offset 8;
select lastname, firstname, phone from users limit 10; -- �������� ������ �� 3� ��������
select lastname, firstname, phone from users order by lastname asc limit 10; -- ��������� �� ������� � ���. ������� asc - ����, desc - ����.
select lastname, firstname, phone from users order by lastname, firstname limit 10; -- �������� ���������� �� ���������� ��������
select 'hello!' limit 10; -- ���������� ��� ������ ������
select 3*8 limit 10; -- �������� �������������� ���������
select concat(lastname, ' ', firstname) as username from users limit 10; -- ������� ������ � ���. �-��� concat, �������� ����� username ��� ������� � �������������� �������
select concat(substring(firstname, 1,1),'. ',lastname) as persons from users limit 10; -- "��������" ��� �� ������� �������
select distinct hometown from users limit 10; -- �������� ������ ���������� ������
select * from users where hometown = 'berg' limit 10; -- � ������� ����������� where �������� ������������� �� ������������ ������
select lastname, firstname, hometown from users 
	where hometown = 'berg' or hometown ='town' or hometown ='haven' limit 10;-- ����������� where � "���"

select lastname, firstname, hometown, gender from users 
	where hometown = 'berg' or gender = 'm' limit 10;-- ����������� where � "���"

select lastname, firstname, hometown, gender from users 
	where hometown = 'berg' and gender = 'm' limit 10;-- ����������� where � "�"

select lastname, firstname, hometown from users where hometown in ('berg', 'town', 'haven') limit 10; -- in ��������� �������� ��������� �������� � where 

select lastname, firstname, hometown from users where hometown != 'berg' limit 10; -- ����� �� ������
select lastname, firstname, hometown from users where hometown <> 'berg' limit 10; -- ���������� �����������

select lastname, firstname, birtday from users where birtday >= '1985-01-01' limit 10; -- ������� ������ ��� �����

select lastname, firstname, birtday from users where birtday >= '1985-01-01' and birtday <= '1990-01-01' limit 10; -- ������� ����� ���������� ������� 

select lastname, firstname, birtday from users where birtday between '1985-01-01' and '1990-01-01' limit 10; -- ���������� �����������

select lastname, firstname from users where lastname like 'm%' limit 10; -- ����� ���������, ������������ �� "��" � ���������� ����� 0 ��� ����� �������� (%)
select lastname, firstname from users where lastname like '%n' limit 10;-- ����� ���������, ��������������� �� "��" � ���������� ����� ���� 0 ��� ����� �������� ��� ����� �������� (%)
select lastname, firstname from users where lastname like 'a_n' limit 10;

select count(*) from users limit 10; -- ����� 208 ������� � �������������
select count(hometown) from users limit 10; -- 204, null �� ���������
select count(distinct hometown) from users limit 10; -- ������� ���� ��������

select hometown, count(*) from users group by hometown limit 10; -- ���������� �� ������ � �������, ������� ������������� � ������ ������

select hometown, count(*) from users group by hometown having count(*) >= 10 limit 10; -- �������� ������, ��� ������������� � ������ ������  >= 10

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

-- DDL ������� �� ���������
ALTER TABLE users CHANGE birtday birthday date NULL; -- ������������� �������
ALTER TABLE
users MODIFY COLUMN pass char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL; -- ������ ���-�� �������� ��� �������
