Comment 'БД для склада ответственного хранения. Требуется принимать товар на хранение от возвращать по заказу от Поклажедателя,
 т.е. отправляется тому же юр. лицу, от которого принимали. Свойства товара разделены на обязательные (артикул, наименование),
и необязательные (габариты, вес, кол-во внутри упаковки, наименование на английском). Необязательные свойства выбелены в отдельные
таблицы, чтобы не денормализовать БД null-значениями.
ER -диаграмма прикреплена отдельным файлом.' 


use warehouse;

drop table if exists warehouses;
create table warehouses (
	id serial primary key,
	name varchar(255),
	address varchar(255)
	);

drop table if exists customers;
create table customers (
	id serial primary key,
	name varchar(255),
	address varchar(255),
	INN smallint unsigned not null
	);

drop table if exists contracts;
create table contracts (
	id serial primary key,
	customer_id bigint unsigned not null,
	contract_number varchar(50),
	contract_date date,
	foreign key (customer_id) references customers(id)	
	);

drop table if exists goods;
create table goods (
	id serial primary key,
	article varchar(50),
	name varchar(50)
	);

drop table if exists goods_dimensions;
create table goods_dimensions (
	goods_id bigint unsigned not null primary key,
	goods_length mediumint unsigned not null,
	goods_width mediumint unsigned not null,
	goods_height mediumint unsigned not null,
	foreign key (goods_id) references goods(id)
	);

drop table if exists goods_weight;
create table goods_weight (
	goods_id bigint unsigned not null primary key,
	goods_weight mediumint unsigned not null,
	foreign key (goods_id) references goods(id)
	);

drop table if exists goods_contained;
create table goods_contained (
	goods_id bigint unsigned not null primary key,
	goods_contained mediumint unsigned not null comment 'количества товара в упаковке, если больше 1',
	foreign key (goods_id) references goods(id)
	);

drop table if exists goods_translation;
create table goods_translation (
	goods_id bigint unsigned not null primary key,
	name_translation varchar(255) not null,
	foreign key (goods_id) references goods(id)
	);

drop table if exists inbound_orders;
create table inbound_orders (
	id serial primary key,
	customer_id bigint unsigned not null,
	planned_date date,
	actual_date datetime,
	foreign key (customer_id) references customers(id)
	);

drop table if exists inbound_goods;
create table inbound_goods (
	goods_id bigint unsigned not null primary key,
	inbound_order_id bigint unsigned not null,
	planned_quantity mediumint unsigned not null,
	actual_quantity mediumint unsigned not null,
	warehouse_id bigint unsigned not null,
	foreign key (goods_id) references goods(id),
	foreign key (inbound_order_id) references inbound_orders(id),
	foreign key (warehouse_id) references warehouses(id)
	);


drop table if exists outbound_orders;
create table outbound_orders (
	id serial primary key,
	planned_date date,
	actual_date datetime
	);

drop table if exists outbound_goods;
create table outbound_goods (
	goods_id bigint unsigned not null primary key,
	outbound_order_id bigint unsigned not null,
	planned_quantity mediumint unsigned not null,
	actual_quantity mediumint unsigned not null,
	foreign key (goods_id) references goods(id),
	foreign key (outbound_order_id) references outbound_orders(id)
	);

drop table if exists quarantine;
create table quarantine (
	id serial primary key,
	goods_id bigint unsigned not null,
	blocked_at datetime  comment 'блокировка товара в базе в случае проблемы с качестом товара',
	unblocked_at datetime,
	foreign key (goods_id) references goods(id)
	);

-- Заполнение таблиц --

INSERT INTO `warehouses` (`id`, `name`, `address`) VALUES ('1', 'Lefflershire', '7381 Etha Spring Apt. 768\nLake Prudence, TN 44751-7493');
INSERT INTO `warehouses` (`id`, `name`, `address`) VALUES ('2', 'West Hubert', '96536 Lawson Tunnel Suite 554\nWest Abdulchester, ID 46942-4836');
INSERT INTO `warehouses` (`id`, `name`, `address`) VALUES ('3', 'Haagmouth', '07918 Kozey Fords Apt. 853\nNew Misty, WV 42485-3237');
INSERT INTO `warehouses` (`id`, `name`, `address`) VALUES ('4', 'Port Eribertoville', '656 Oberbrunner Causeway\nEast Jesus, GA 46807');
INSERT INTO `warehouses` (`id`, `name`, `address`) VALUES ('5', 'Ollietown', '54990 Gulgowski Row\nPort Carleytown, UT 13149-9943');

INSERT INTO `customers` (`id`, `name`, `address`, `INN`) VALUES ('1', 'Hamill Ltd', '120 Schaefer Rapid Apt. 629\nHyattshire, AK 28835', 39223);
INSERT INTO `customers` (`id`, `name`, `address`, `INN`) VALUES ('2', 'Bednar-Champlin', '575 Goyette Skyway Suite 598\nThadton, OR 28404-3625', 50245);
INSERT INTO `customers` (`id`, `name`, `address`, `INN`) VALUES ('3', 'Ondricka LLC', '7497 Tatum Ramp\nWest Bella, AZ 65702-6429', 60635);
INSERT INTO `customers` (`id`, `name`, `address`, `INN`) VALUES ('4', 'Strosin PLC', '885 Berge Well\nCarterhaven, GA 33121', 31360);
INSERT INTO `customers` (`id`, `name`, `address`, `INN`) VALUES ('5', 'Williamson LLC', '06974 Wuckert Harbors\nLonzofurt, MT 65340', 65535);

INSERT INTO `contracts` (`id`, `customer_id`, `contract_number`, `contract_date`) VALUES ('1', '1', '833480246', '1980-04-08');
INSERT INTO `contracts` (`id`, `customer_id`, `contract_number`, `contract_date`) VALUES ('2', '2', '228699', '1989-04-06');
INSERT INTO `contracts` (`id`, `customer_id`, `contract_number`, `contract_date`) VALUES ('3', '3', '609346354', '2014-01-22');
INSERT INTO `contracts` (`id`, `customer_id`, `contract_number`, `contract_date`) VALUES ('4', '4', '84273', '1993-11-03');
INSERT INTO `contracts` (`id`, `customer_id`, `contract_number`, `contract_date`) VALUES ('5', '5', '1138', '1992-03-23');

INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('1', '8277', 'adipisci');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('2', '2068', 'quia');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('3', '7870', 'at');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('4', '3804', 'commodi');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('5', '9994', 'ex');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('6', '7157', 'ratione');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('7', '4150', 'quia');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('8', '3740', 'maxime');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('9', '2333', 'eum');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('10', '1494', 'aliquid');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('11', '6628', 'autem');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('12', '2119', 'provident');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('13', '5305', 'accusamus');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('14', '8952', 'asperiores');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('15', '3097', 'explicabo');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('16', '2164', 'saepe');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('17', '1835', 'ducimus');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('18', '7050', 'nihil');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('19', '4316', 'voluptas');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('20', '8247', 'error');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('21', '9047', 'et');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('22', '2140', 'est');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('23', '1361', 'quam');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('24', '4938', 'laboriosam');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('25', '6705', 'magni');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('26', '4639', 'aut');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('27', '2839', 'reiciendis');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('28', '3740', 'quisquam');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('29', '2550', 'ut');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('30', '2330', 'rerum');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('31', '7176', 'et');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('32', '6052', 'modi');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('33', '7611', 'qui');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('34', '5151', 'omnis');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('35', '1782', 'quia');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('36', '6291', 'dolor');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('37', '9741', 'eum');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('38', '1339', 'excepturi');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('39', '8363', 'et');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('40', '7600', 'cumque');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('41', '6226', 'odit');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('42', '1234', 'ut');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('43', '5174', 'dolore');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('44', '2745', 'aperiam');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('45', '8804', 'hic');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('46', '7285', 'autem');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('47', '1265', 'ipsam');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('48', '8416', 'necessitatibus');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('49', '8964', 'maiores');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('50', '5499', 'odio');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('51', '6866', 'nisi');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('52', '7286', 'ut');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('53', '2063', 'alias');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('54', '8468', 'omnis');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('55', '2209', 'sunt');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('56', '2518', 'ducimus');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('57', '5319', 'doloribus');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('58', '8806', 'ex');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('59', '2237', 'similique');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('60', '4459', 'est');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('61', '6932', 'quo');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('62', '7798', 'totam');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('63', '9233', 'vitae');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('64', '7923', 'qui');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('65', '3457', 'natus');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('66', '2883', 'maxime');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('67', '9456', 'sint');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('68', '9372', 'numquam');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('69', '9766', 'fuga');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('70', '5467', 'aliquid');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('71', '3505', 'sit');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('72', '4780', 'voluptas');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('73', '1498', 'adipisci');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('74', '3251', 'modi');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('75', '4059', 'dolorum');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('76', '1965', 'ab');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('77', '5379', 'voluptates');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('78', '7759', 'tempora');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('79', '1531', 'sunt');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('80', '9175', 'quia');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('81', '8003', 'molestiae');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('82', '4632', 'qui');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('83', '9107', 'aut');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('84', '7761', 'commodi');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('85', '6353', 'autem');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('86', '3089', 'debitis');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('87', '7596', 'impedit');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('88', '1909', 'perferendis');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('89', '7368', 'cumque');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('90', '7615', 'aut');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('91', '4347', 'consequuntur');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('92', '3205', 'excepturi');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('93', '4551', 'culpa');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('94', '4151', 'doloribus');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('95', '4348', 'ratione');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('96', '2933', 'expedita');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('97', '2385', 'laboriosam');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('98', '6670', 'et');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('99', '9695', 'amet');
INSERT INTO `goods` (`id`, `article`, `name`) VALUES ('100', '6076', 'veritatis');

INSERT INTO `goods_contained` (`goods_id`, `goods_contained`) VALUES ('1', 103);
INSERT INTO `goods_contained` (`goods_id`, `goods_contained`) VALUES ('2', 675);
INSERT INTO `goods_contained` (`goods_id`, `goods_contained`) VALUES ('3', 89);
INSERT INTO `goods_contained` (`goods_id`, `goods_contained`) VALUES ('4', 858);
INSERT INTO `goods_contained` (`goods_id`, `goods_contained`) VALUES ('5', 39);
INSERT INTO `goods_contained` (`goods_id`, `goods_contained`) VALUES ('6', 294);
INSERT INTO `goods_contained` (`goods_id`, `goods_contained`) VALUES ('7', 526);
INSERT INTO `goods_contained` (`goods_id`, `goods_contained`) VALUES ('8', 128);
INSERT INTO `goods_contained` (`goods_id`, `goods_contained`) VALUES ('9', 638);
INSERT INTO `goods_contained` (`goods_id`, `goods_contained`) VALUES ('10', 648);
INSERT INTO `goods_contained` (`goods_id`, `goods_contained`) VALUES ('11', 364);
INSERT INTO `goods_contained` (`goods_id`, `goods_contained`) VALUES ('12', 102);
INSERT INTO `goods_contained` (`goods_id`, `goods_contained`) VALUES ('13', 905);
INSERT INTO `goods_contained` (`goods_id`, `goods_contained`) VALUES ('14', 409);
INSERT INTO `goods_contained` (`goods_id`, `goods_contained`) VALUES ('15', 496);
INSERT INTO `goods_contained` (`goods_id`, `goods_contained`) VALUES ('16', 918);
INSERT INTO `goods_contained` (`goods_id`, `goods_contained`) VALUES ('17', 151);
INSERT INTO `goods_contained` (`goods_id`, `goods_contained`) VALUES ('18', 39);
INSERT INTO `goods_contained` (`goods_id`, `goods_contained`) VALUES ('19', 573);
INSERT INTO `goods_contained` (`goods_id`, `goods_contained`) VALUES ('20', 183);
INSERT INTO `goods_contained` (`goods_id`, `goods_contained`) VALUES ('21', 511);
INSERT INTO `goods_contained` (`goods_id`, `goods_contained`) VALUES ('22', 236);
INSERT INTO `goods_contained` (`goods_id`, `goods_contained`) VALUES ('23', 316);
INSERT INTO `goods_contained` (`goods_id`, `goods_contained`) VALUES ('24', 306);
INSERT INTO `goods_contained` (`goods_id`, `goods_contained`) VALUES ('25', 705);

INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('1', 520, 801, 638);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('2', 553, 950, 1560);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('3', 718, 62, 843);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('4', 120, 913, 1027);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('5', 535, 213, 150);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('6', 854, 257, 1760);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('7', 665, 950, 1517);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('8', 977, 1148, 1075);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('9', 551, 153, 451);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('10', 603, 360, 206);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('11', 211, 995, 1138);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('12', 178, 1114, 1350);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('13', 884, 44, 161);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('14', 648, 445, 1639);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('15', 500, 277, 1667);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('16', 1015, 851, 1602);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('17', 68, 499, 286);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('18', 544, 496, 225);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('19', 912, 109, 1518);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('20', 715, 252, 750);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('21', 20, 292, 176);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('22', 696, 409, 255);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('23', 148, 1094, 1625);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('24', 183, 1092, 1074);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('25', 1173, 454, 1683);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('26', 1111, 278, 1155);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('27', 902, 329, 408);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('28', 527, 114, 1627);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('29', 231, 49, 403);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('30', 539, 1149, 1695);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('31', 257, 702, 671);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('32', 374, 1198, 1111);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('33', 40, 216, 1585);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('34', 359, 201, 1048);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('35', 1004, 884, 247);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('36', 576, 323, 1230);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('37', 1185, 449, 430);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('38', 809, 268, 111);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('39', 1147, 878, 1231);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('40', 1098, 856, 303);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('41', 1093, 636, 287);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('42', 51, 510, 347);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('43', 1199, 438, 840);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('44', 662, 542, 1613);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('45', 867, 927, 1296);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('46', 132, 482, 984);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('47', 425, 968, 921);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('48', 668, 712, 1148);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('49', 60, 741, 495);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('50', 958, 521, 826);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('51', 845, 234, 804);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('52', 808, 1146, 166);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('53', 476, 630, 837);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('54', 35, 20, 283);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('55', 119, 799, 70);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('56', 1131, 761, 653);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('57', 412, 336, 1186);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('58', 878, 681, 338);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('59', 487, 943, 329);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('60', 406, 17, 1021);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('61', 556, 969, 977);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('62', 1101, 985, 800);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('63', 357, 37, 1377);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('64', 1078, 204, 640);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('65', 401, 345, 1035);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('66', 41, 839, 732);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('67', 482, 340, 347);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('68', 1103, 947, 1525);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('69', 133, 473, 474);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('70', 63, 266, 680);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('71', 498, 110, 1673);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('72', 901, 1078, 1098);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('73', 598, 417, 305);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('74', 656, 383, 1454);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('75', 1106, 1022, 567);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('76', 283, 666, 133);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('77', 1019, 108, 957);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('78', 437, 569, 972);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('79', 952, 717, 1548);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('80', 49, 1065, 993);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('81', 866, 781, 1279);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('82', 1143, 448, 1706);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('83', 172, 736, 736);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('84', 1051, 1104, 1687);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('85', 690, 473, 1554);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('86', 1064, 285, 852);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('87', 1037, 521, 486);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('88', 426, 646, 1497);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('89', 649, 232, 1732);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('90', 577, 221, 966);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('91', 429, 1165, 1407);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('92', 367, 454, 356);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('93', 1035, 1179, 182);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('94', 1083, 387, 1712);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('95', 69, 280, 802);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('96', 1166, 711, 1350);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('97', 430, 689, 797);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('98', 922, 691, 1160);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('99', 341, 535, 1394);
INSERT INTO `goods_dimensions` (`goods_id`, `goods_length`, `goods_width`, `goods_height`) VALUES ('100', 55, 503, 132);

INSERT INTO `goods_translation` (`goods_id`, `name_translation`) VALUES ('1', 'harum');
INSERT INTO `goods_translation` (`goods_id`, `name_translation`) VALUES ('2', 'magni');
INSERT INTO `goods_translation` (`goods_id`, `name_translation`) VALUES ('3', 'sit');
INSERT INTO `goods_translation` (`goods_id`, `name_translation`) VALUES ('4', 'placeat');
INSERT INTO `goods_translation` (`goods_id`, `name_translation`) VALUES ('5', 'veniam');
INSERT INTO `goods_translation` (`goods_id`, `name_translation`) VALUES ('6', 'aut');
INSERT INTO `goods_translation` (`goods_id`, `name_translation`) VALUES ('7', 'sed');
INSERT INTO `goods_translation` (`goods_id`, `name_translation`) VALUES ('8', 'labore');
INSERT INTO `goods_translation` (`goods_id`, `name_translation`) VALUES ('9', 'qui');
INSERT INTO `goods_translation` (`goods_id`, `name_translation`) VALUES ('10', 'rerum');
INSERT INTO `goods_translation` (`goods_id`, `name_translation`) VALUES ('11', 'incidunt');
INSERT INTO `goods_translation` (`goods_id`, `name_translation`) VALUES ('12', 'sit');
INSERT INTO `goods_translation` (`goods_id`, `name_translation`) VALUES ('13', 'aperiam');
INSERT INTO `goods_translation` (`goods_id`, `name_translation`) VALUES ('14', 'sed');
INSERT INTO `goods_translation` (`goods_id`, `name_translation`) VALUES ('15', 'quam');
INSERT INTO `goods_translation` (`goods_id`, `name_translation`) VALUES ('16', 'sequi');
INSERT INTO `goods_translation` (`goods_id`, `name_translation`) VALUES ('17', 'nobis');
INSERT INTO `goods_translation` (`goods_id`, `name_translation`) VALUES ('18', 'officia');
INSERT INTO `goods_translation` (`goods_id`, `name_translation`) VALUES ('19', 'ut');
INSERT INTO `goods_translation` (`goods_id`, `name_translation`) VALUES ('20', 'voluptas');

INSERT INTO `goods_weight` (`goods_id`, `goods_weight`) VALUES ('1', 6583);
INSERT INTO `goods_weight` (`goods_id`, `goods_weight`) VALUES ('2', 18397);
INSERT INTO `goods_weight` (`goods_id`, `goods_weight`) VALUES ('3', 11178);
INSERT INTO `goods_weight` (`goods_id`, `goods_weight`) VALUES ('4', 18124);
INSERT INTO `goods_weight` (`goods_id`, `goods_weight`) VALUES ('5', 16533);
INSERT INTO `goods_weight` (`goods_id`, `goods_weight`) VALUES ('6', 32882);
INSERT INTO `goods_weight` (`goods_id`, `goods_weight`) VALUES ('7', 299);
INSERT INTO `goods_weight` (`goods_id`, `goods_weight`) VALUES ('8', 27614);
INSERT INTO `goods_weight` (`goods_id`, `goods_weight`) VALUES ('9', 14019);
INSERT INTO `goods_weight` (`goods_id`, `goods_weight`) VALUES ('10', 13980);
INSERT INTO `goods_weight` (`goods_id`, `goods_weight`) VALUES ('11', 17828);
INSERT INTO `goods_weight` (`goods_id`, `goods_weight`) VALUES ('12', 1378);
INSERT INTO `goods_weight` (`goods_id`, `goods_weight`) VALUES ('13', 17473);
INSERT INTO `goods_weight` (`goods_id`, `goods_weight`) VALUES ('14', 27671);
INSERT INTO `goods_weight` (`goods_id`, `goods_weight`) VALUES ('15', 11545);
INSERT INTO `goods_weight` (`goods_id`, `goods_weight`) VALUES ('16', 11786);
INSERT INTO `goods_weight` (`goods_id`, `goods_weight`) VALUES ('17', 16597);
INSERT INTO `goods_weight` (`goods_id`, `goods_weight`) VALUES ('18', 17281);
INSERT INTO `goods_weight` (`goods_id`, `goods_weight`) VALUES ('19', 5702);
INSERT INTO `goods_weight` (`goods_id`, `goods_weight`) VALUES ('20', 8256);
INSERT INTO `goods_weight` (`goods_id`, `goods_weight`) VALUES ('21', 4140);
INSERT INTO `goods_weight` (`goods_id`, `goods_weight`) VALUES ('22', 21500);
INSERT INTO `goods_weight` (`goods_id`, `goods_weight`) VALUES ('23', 34929);
INSERT INTO `goods_weight` (`goods_id`, `goods_weight`) VALUES ('24', 10493);
INSERT INTO `goods_weight` (`goods_id`, `goods_weight`) VALUES ('25', 12810);
INSERT INTO `goods_weight` (`goods_id`, `goods_weight`) VALUES ('26', 9715);
INSERT INTO `goods_weight` (`goods_id`, `goods_weight`) VALUES ('27', 861);
INSERT INTO `goods_weight` (`goods_id`, `goods_weight`) VALUES ('28', 25055);
INSERT INTO `goods_weight` (`goods_id`, `goods_weight`) VALUES ('29', 4044);
INSERT INTO `goods_weight` (`goods_id`, `goods_weight`) VALUES ('30', 15455);

INSERT INTO `inbound_orders` (`id`, `customer_id`, `planned_date`, `actual_date`) VALUES ('1', '1', '2004-02-19', '1981-10-01 05:44:45');
INSERT INTO `inbound_orders` (`id`, `customer_id`, `planned_date`, `actual_date`) VALUES ('2', '2', '2004-03-14', '2006-05-14 09:30:28');
INSERT INTO `inbound_orders` (`id`, `customer_id`, `planned_date`, `actual_date`) VALUES ('3', '3', '2012-09-26', '2005-10-28 20:10:19');
INSERT INTO `inbound_orders` (`id`, `customer_id`, `planned_date`, `actual_date`) VALUES ('4', '4', '1992-12-16', '2003-05-19 01:16:39');
INSERT INTO `inbound_orders` (`id`, `customer_id`, `planned_date`, `actual_date`) VALUES ('5', '5', '1981-04-20', '1977-10-23 17:23:32');
INSERT INTO `inbound_orders` (`id`, `customer_id`, `planned_date`, `actual_date`) VALUES ('6', '1', '1993-02-12', '2005-04-19 13:38:07');
INSERT INTO `inbound_orders` (`id`, `customer_id`, `planned_date`, `actual_date`) VALUES ('7', '2', '2012-07-25', '2019-07-11 07:02:15');
INSERT INTO `inbound_orders` (`id`, `customer_id`, `planned_date`, `actual_date`) VALUES ('8', '3', '1999-09-16', '2001-01-22 12:04:08');
INSERT INTO `inbound_orders` (`id`, `customer_id`, `planned_date`, `actual_date`) VALUES ('9', '4', '1978-06-01', '2018-02-07 22:48:57');
INSERT INTO `inbound_orders` (`id`, `customer_id`, `planned_date`, `actual_date`) VALUES ('10', '5', '1980-01-14', '1985-12-12 12:49:29');
INSERT INTO `inbound_orders` (`id`, `customer_id`, `planned_date`, `actual_date`) VALUES ('11', '1', '2002-11-08', '2016-01-15 09:50:38');
INSERT INTO `inbound_orders` (`id`, `customer_id`, `planned_date`, `actual_date`) VALUES ('12', '2', '1973-04-24', '1996-01-22 20:50:28');
INSERT INTO `inbound_orders` (`id`, `customer_id`, `planned_date`, `actual_date`) VALUES ('13', '3', '2003-11-23', '1997-12-22 11:00:32');
INSERT INTO `inbound_orders` (`id`, `customer_id`, `planned_date`, `actual_date`) VALUES ('14', '4', '1975-12-01', '1973-07-25 05:02:16');
INSERT INTO `inbound_orders` (`id`, `customer_id`, `planned_date`, `actual_date`) VALUES ('15', '5', '1983-10-29', '1985-07-13 11:51:05');
INSERT INTO `inbound_orders` (`id`, `customer_id`, `planned_date`, `actual_date`) VALUES ('16', '1', '1976-06-29', '1977-07-10 00:43:26');
INSERT INTO `inbound_orders` (`id`, `customer_id`, `planned_date`, `actual_date`) VALUES ('17', '2', '1975-06-20', '2000-09-26 23:10:46');
INSERT INTO `inbound_orders` (`id`, `customer_id`, `planned_date`, `actual_date`) VALUES ('18', '3', '2018-08-01', '1999-07-14 20:42:50');
INSERT INTO `inbound_orders` (`id`, `customer_id`, `planned_date`, `actual_date`) VALUES ('19', '4', '1997-08-17', '1970-11-26 10:27:50');
INSERT INTO `inbound_orders` (`id`, `customer_id`, `planned_date`, `actual_date`) VALUES ('20', '5', '1985-10-04', '1991-11-18 05:53:54');

INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('1', '1', 3, 2, '1');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('2', '2', 1, 4, '2');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('3', '3', 6, 1, '3');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('4', '4', 9, 7, '4');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('5', '5', 3, 2, '5');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('6', '6', 2, 7, '1');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('7', '7', 2, 5, '2');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('8', '8', 9, 2, '3');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('9', '9', 5, 4, '4');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('10', '10', 3, 6, '5');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('11', '11', 9, 5, '1');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('12', '12', 7, 2, '2');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('13', '13', 3, 2, '3');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('14', '14', 9, 7, '4');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('15', '15', 6, 5, '5');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('16', '16', 6, 4, '1');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('17', '17', 3, 3, '2');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('18', '18', 5, 6, '3');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('19', '19', 6, 2, '4');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('20', '20', 1, 8, '5');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('21', '1', 2, 8, '1');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('22', '2', 5, 8, '2');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('23', '3', 2, 8, '3');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('24', '4', 5, 7, '4');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('25', '5', 6, 8, '5');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('26', '6', 9, 3, '1');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('27', '7', 4, 1, '2');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('28', '8', 9, 8, '3');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('29', '9', 6, 9, '4');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('30', '10', 4, 1, '5');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('31', '11', 4, 3, '1');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('32', '12', 4, 9, '2');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('33', '13', 9, 6, '3');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('34', '14', 5, 1, '4');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('35', '15', 3, 2, '5');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('36', '16', 8, 6, '1');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('37', '17', 7, 5, '2');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('38', '18', 1, 2, '3');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('39', '19', 1, 7, '4');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('40', '20', 1, 2, '5');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('41', '1', 3, 5, '1');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('42', '2', 8, 3, '2');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('43', '3', 6, 5, '3');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('44', '4', 3, 2, '4');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('45', '5', 3, 9, '5');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('46', '6', 6, 5, '1');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('47', '7', 7, 3, '2');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('48', '8', 2, 2, '3');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('49', '9', 6, 4, '4');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('50', '10', 4, 8, '5');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('51', '11', 8, 7, '1');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('52', '12', 2, 3, '2');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('53', '13', 3, 8, '3');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('54', '14', 5, 4, '4');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('55', '15', 5, 1, '5');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('56', '16', 6, 1, '1');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('57', '17', 5, 9, '2');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('58', '18', 1, 2, '3');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('59', '19', 2, 7, '4');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('60', '20', 5, 4, '5');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('61', '1', 4, 7, '1');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('62', '2', 2, 5, '2');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('63', '3', 9, 8, '3');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('64', '4', 3, 8, '4');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('65', '5', 2, 6, '5');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('66', '6', 2, 8, '1');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('67', '7', 7, 3, '2');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('68', '8', 4, 5, '3');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('69', '9', 2, 1, '4');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('70', '10', 9, 5, '5');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('71', '11', 3, 6, '1');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('72', '12', 4, 7, '2');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('73', '13', 7, 9, '3');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('74', '14', 5, 2, '4');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('75', '15', 5, 3, '5');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('76', '16', 1, 4, '1');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('77', '17', 8, 2, '2');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('78', '18', 4, 8, '3');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('79', '19', 1, 9, '4');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('80', '20', 9, 4, '5');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('81', '1', 5, 3, '1');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('82', '2', 4, 7, '2');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('83', '3', 5, 2, '3');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('84', '4', 5, 1, '4');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('85', '5', 2, 9, '5');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('86', '6', 6, 6, '1');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('87', '7', 7, 3, '2');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('88', '8', 4, 5, '3');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('89', '9', 2, 1, '4');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('90', '10', 9, 8, '5');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('91', '11', 5, 2, '1');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('92', '12', 9, 8, '2');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('93', '13', 7, 1, '3');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('94', '14', 1, 8, '4');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('95', '15', 5, 9, '5');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('96', '16', 2, 3, '1');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('97', '17', 1, 9, '2');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('98', '18', 5, 9, '3');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('99', '19', 7, 8, '4');
INSERT INTO `inbound_goods` (`goods_id`, `inbound_order_id`, `planned_quantity`, `actual_quantity`, `warehouse_id`) VALUES ('100', '20', 9, 7, '5');

INSERT INTO `outbound_orders` (`id`, `planned_date`, `actual_date`) VALUES ('1', '1983-03-31', '1979-09-24 16:13:49');
INSERT INTO `outbound_orders` (`id`, `planned_date`, `actual_date`) VALUES ('2', '1982-10-21', '2013-07-29 21:53:20');
INSERT INTO `outbound_orders` (`id`, `planned_date`, `actual_date`) VALUES ('3', '1975-01-24', '1985-05-11 05:25:52');
INSERT INTO `outbound_orders` (`id`, `planned_date`, `actual_date`) VALUES ('4', '1972-02-13', '2018-07-24 17:03:46');
INSERT INTO `outbound_orders` (`id`, `planned_date`, `actual_date`) VALUES ('5', '2006-07-05', '1998-03-31 14:23:38');
INSERT INTO `outbound_orders` (`id`, `planned_date`, `actual_date`) VALUES ('6', '2008-06-11', '1975-05-10 15:22:51');
INSERT INTO `outbound_orders` (`id`, `planned_date`, `actual_date`) VALUES ('7', '1995-05-26', '1984-01-21 02:52:46');
INSERT INTO `outbound_orders` (`id`, `planned_date`, `actual_date`) VALUES ('8', '2013-07-18', '1996-10-07 03:58:08');
INSERT INTO `outbound_orders` (`id`, `planned_date`, `actual_date`) VALUES ('9', '2001-01-11', '2008-05-20 17:15:32');
INSERT INTO `outbound_orders` (`id`, `planned_date`, `actual_date`) VALUES ('10', '1993-03-05', '2000-05-27 20:28:05');
INSERT INTO `outbound_orders` (`id`, `planned_date`, `actual_date`) VALUES ('11', '2008-02-18', '1998-03-11 02:54:57');
INSERT INTO `outbound_orders` (`id`, `planned_date`, `actual_date`) VALUES ('12', '1999-11-24', '2017-01-08 18:50:34');
INSERT INTO `outbound_orders` (`id`, `planned_date`, `actual_date`) VALUES ('13', '1994-04-14', '2019-02-26 02:00:46');
INSERT INTO `outbound_orders` (`id`, `planned_date`, `actual_date`) VALUES ('14', '2014-04-15', '1990-07-03 19:01:46');
INSERT INTO `outbound_orders` (`id`, `planned_date`, `actual_date`) VALUES ('15', '2015-03-13', '2000-12-15 13:09:40');
INSERT INTO `outbound_orders` (`id`, `planned_date`, `actual_date`) VALUES ('16', '1970-06-12', '2016-10-26 14:01:41');
INSERT INTO `outbound_orders` (`id`, `planned_date`, `actual_date`) VALUES ('17', '1994-03-04', '1972-08-27 17:29:22');
INSERT INTO `outbound_orders` (`id`, `planned_date`, `actual_date`) VALUES ('18', '1980-02-01', '1988-01-18 01:17:21');
INSERT INTO `outbound_orders` (`id`, `planned_date`, `actual_date`) VALUES ('19', '2000-10-12', '1976-02-16 19:51:54');
INSERT INTO `outbound_orders` (`id`, `planned_date`, `actual_date`) VALUES ('20', '1976-07-30', '1982-08-28 20:47:04');

INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('1', '1', 5, 1);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('2', '2', 5, 7);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('3', '3', 5, 9);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('4', '4', 2, 1);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('5', '5', 5, 3);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('6', '6', 5, 5);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('7', '7', 9, 4);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('8', '8', 4, 3);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('9', '9', 2, 7);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('10', '10', 1, 2);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('11', '11', 1, 1);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('12', '12', 7, 2);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('13', '13', 4, 9);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('14', '14', 4, 3);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('15', '15', 8, 8);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('16', '16', 4, 7);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('17', '17', 9, 8);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('18', '18', 3, 5);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('19', '19', 2, 9);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('20', '20', 4, 6);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('21', '1', 4, 5);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('22', '2', 1, 4);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('23', '3', 2, 3);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('24', '4', 2, 4);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('25', '5', 8, 2);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('26', '6', 5, 1);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('27', '7', 9, 8);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('28', '8', 3, 6);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('29', '9', 7, 1);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('30', '10', 7, 9);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('31', '11', 6, 5);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('32', '12', 3, 2);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('33', '13', 6, 5);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('34', '14', 7, 6);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('35', '15', 4, 4);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('36', '16', 8, 2);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('37', '17', 1, 9);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('38', '18', 8, 5);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('39', '19', 8, 3);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('40', '20', 3, 8);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('41', '1', 4, 2);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('42', '2', 9, 8);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('43', '3', 1, 4);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('44', '4', 5, 7);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('45', '5', 8, 6);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('46', '6', 3, 8);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('47', '7', 6, 1);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('48', '8', 5, 6);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('49', '9', 4, 8);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('50', '10', 2, 4);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('51', '11', 7, 4);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('52', '12', 3, 3);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('53', '13', 5, 7);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('54', '14', 3, 2);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('55', '15', 5, 1);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('56', '16', 2, 3);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('57', '17', 6, 8);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('58', '18', 5, 4);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('59', '19', 2, 4);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('60', '20', 1, 9);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('61', '1', 8, 8);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('62', '2', 2, 8);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('63', '3', 7, 5);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('64', '4', 6, 4);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('65', '5', 8, 8);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('66', '6', 7, 9);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('67', '7', 6, 5);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('68', '8', 6, 1);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('69', '9', 5, 2);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('70', '10', 8, 2);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('71', '11', 8, 5);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('72', '12', 3, 6);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('73', '13', 6, 2);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('74', '14', 9, 7);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('75', '15', 8, 8);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('76', '16', 1, 3);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('77', '17', 1, 5);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('78', '18', 4, 5);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('79', '19', 9, 1);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('80', '20', 1, 1);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('81', '1', 9, 2);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('82', '2', 2, 4);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('83', '3', 8, 7);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('85', '5', 1, 1);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('86', '6', 1, 2);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('87', '7', 3, 9);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('88', '8', 1, 4);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('89', '9', 2, 7);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('90', '10', 8, 2);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('91', '11', 2, 1);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('92', '12', 4, 6);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('93', '13', 9, 3);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('94', '14', 7, 1);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('95', '15', 7, 9);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('96', '16', 7, 6);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('97', '17', 4, 3);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('98', '18', 5, 4);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('99', '19', 5, 2);
INSERT INTO `outbound_goods` (`goods_id`, `outbound_order_id`, `planned_quantity`, `actual_quantity`) VALUES ('100', '20', 1, 9);

INSERT INTO `quarantine` (`id`,`goods_id`, `blocked_at`, `unblocked_at`) VALUES ('1', '1', '1973-09-18 06:18:41', '1973-10-16 22:55:50');
INSERT INTO `quarantine` (`id`,`goods_id`, `blocked_at`, `unblocked_at`) VALUES ('2', '2', '2010-05-27 04:24:35', '2017-12-18 06:04:00');
INSERT INTO `quarantine` (`id`,`goods_id`, `blocked_at`, `unblocked_at`) VALUES ('3', '3', '2018-11-23 04:32:44', '1973-02-23 10:06:57');
INSERT INTO `quarantine` (`id`,`goods_id`, `blocked_at`, `unblocked_at`) VALUES ('4', '4', '2005-04-18 14:20:09', '1992-11-10 20:34:09');
INSERT INTO `quarantine` (`id`,`goods_id`, `blocked_at`, `unblocked_at`) VALUES ('5','1', '1980-12-15 14:13:25', '1986-12-07 03:59:49');
INSERT INTO `quarantine` (`id`,`goods_id`, `blocked_at`, `unblocked_at`) VALUES ('6','6', '1988-08-20 04:26:37', '2004-02-06 02:51:21');
INSERT INTO `quarantine` (`id`,`goods_id`, `blocked_at`, `unblocked_at`) VALUES ('7','7', '2008-06-07 14:17:32', '2020-09-14 09:31:30');
INSERT INTO `quarantine` (`id`,`goods_id`, `blocked_at`, `unblocked_at`) VALUES ('8','8', '1982-02-26 02:06:26', '2008-10-25 19:17:12');
INSERT INTO `quarantine` (`id`,`goods_id`, `blocked_at`, `unblocked_at`) VALUES ('9','9', '1980-02-07 04:25:58', '1996-12-23 08:03:08');
INSERT INTO `quarantine` (`id`,`goods_id`, `blocked_at`, `unblocked_at`) VALUES ('10', '1', '1996-05-30 20:55:52', '2015-02-01 15:17:24');

##
##
-- Выборки
##
##

-- 1. История блокировки выбранного товара (таблица quarantine), поклажедатель товара (customer).

select 
	goods_id,
	blocked_at,
	unblocked_at,
	(select c.name from customers c where c.id in 
 		(select io.customer_id from inbound_orders io where io.id in 
 			(select ig.inbound_order_id from inbound_goods ig where ig.goods_id = q.goods_id ))limit 1) customer_name
 from quarantine q where goods_id = 1;

-- 2. Данные о товаре: артикул, наименование (таблица goods), дата приемки (таблица inbound_order), склад (таблица warehouse), кол-во на остатке 
-- (разница между данными в таблицах inbound_goods, outbound_goods).

select 
	g.article,
	g.name,
	io.actual_date as date_of_receiving,
	w.name as warehouse_name,
	(select actual_quantity from inbound_goods where goods_id = 4) - (select actual_quantity from outbound_goods where goods_id = 4) on_stock
from goods as g 
join inbound_goods as ig
join inbound_orders as io
join warehouses as w 
where g.id = 4 and io.id = ig.inbound_order_id and ig.goods_id = g.id and w.id = ig.warehouse_id;


##
##
-- Представления
##
##


-- 1. Показать Все данные об одной приемке: артикул товара (таблица goods), наименование (goods), ДШВ (goods_dimensions), вес (goods_weight), 
-- дата получения (inbound_orders), количество (inbound_goods).

-- Сначала создаем представление, которое включает все приемки, чтобы не зашивать в представление изменяемый параметр запроса:

create or replace view show_all_inbound_data as
select 
	io.id as inbound_order_id,
	io.actual_date,
	c.name as customer,
	g.article,	g.name,
	ig.actual_quantity as received_quantity,
	gw.goods_weight,
	gd.goods_length, gd.goods_width, gd.goods_height
from inbound_orders io
join customers c on c.id = io.customer_id 
join goods g
join inbound_goods ig
left join goods_weight gw
on gw.goods_id = g.id
left join goods_dimensions gd
on gd.goods_id = g.id
where ig.inbound_order_id = io.id and g.id = ig.goods_id;	

-- выбираем из представления, например, конкретную приемку:

select * from show_all_inbound_data where inbound_order_id = 1;


-- 2. Показать список всех отгрузок с данными: номер, дата (таблица outbound_goods), поклажедатель (customers).

create or replace view show_outbound_orders as
select 
	oo.id,
	oo.actual_date,
	c.name as customer 
from outbound_orders oo
join outbound_goods og on og.outbound_order_id = oo.id
join inbound_goods ig on ig.goods_id = og.goods_id 
join inbound_orders io on io.id = ig.inbound_order_id 
join customers c on c.id = io.customer_id
group by oo.id;

-- Выбираем из представления, например, все заказы одного поклажедателя:

select * from show_outbound_orders where customer = 'Hamill Ltd';



##
##
-- Хранимая процедура
##
##

-- Процедура выбирает данные из входящей заявки на склад (формуляр, где все данные в одной большой таблице), и вставляет в соответствующе таблицы БД,

-- Сначала создаем исходную таблицу, которую будет обрабатвывать процедура:

drop table if exists inbound_document;
create table inbound_document (
	inbound_order_id smallint primary key not null,
	customer varchar(255),
	planned_date date,
	actual_date date,
	planned_quantity smallint,
	actual_quantity smallint,
	warehouse_id smallint,
	article varchar(255),
	name varchar(255),
	goods_length smallint,
	goods_width smallint,
	goods_height smallint,
	goods_weight smallint	
);

select * from inbound_document;


-- Теперь сама процедура:


delimiter //
drop procedure if exists break_down_inbound_order//
create procedure break_down_inbound_order ()
begin
	insert into inbound_orders (customer_id, planned_date, actual_date)
		select c.id,
		ind.planned_date,
		ind.actual_date 
		from inbound_document ind
		join customers c on c.name = ind.customer;

	insert into goods (article, name)
		select article,
		name 
		from inbound_document ind where not exists
			(select article,
			name
			from goods g where g.article = ind.article and g.name = ind.name);

	insert into inbound_goods (goods_id, inbound_order_id, planned_quantity, actual_quantity, warehouse_id)
		select g.id, 
		ind.inbound_order_id,
		ind.planned_quantity,
		ind.actual_quantity,
		ind.warehouse_id
		from goods g
		join inbound_document ind on g.article = ind.article;

	insert into goods_dimensions (goods_id, goods_length, goods_width, goods_height)
		select g.id,
		ind.goods_length,
		ind.goods_width,
		ind.goods_height
		from goods g
		join inbound_document ind on g.article = ind.article 
			where ind.goods_length is not null 
			or ind.goods_width is not null 
			or ind.goods_height is not null;

	insert into goods_weight (goods_id, goods_weight)
		select g.id, 
		ind.goods_weight
		from goods g 
		join inbound_document ind on g.article = ind.article where ind.goods_weight is not null;
end//

call break_down_inbound_order(); 