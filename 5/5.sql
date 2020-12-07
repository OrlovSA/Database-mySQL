-- 1  Пусть в таблице users поля created_at и updated_at оказались незаполненными. 
-- 	  Заполните их текущими датой и временем.

-- приводим таблици к дано.
UPDATE users 
	set created_at=null
UPDATE users 
	set updated_at=null

-- решение
UPDATE users
	set created_at= CURRENT_TIMESTAMP

-- 2  Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и
--    в них долгое время помещались значения в формате 20.10.2017 8:10. Необходимо преобразовать поля к типу 
--    DATETIME, сохранив введённые ранее значения.

-- приводим таблици к дано.
UPDATE users
	set created_at=null
UPDATE users
	set updated_at=null
ALTER TABLE users
	MODIFY COLUMN created_at VARCHAR(100) NULL;
ALTER TABLE users
	MODIFY COLUMN updated_at VARCHAR(100) NULL;
UPDATE users
	set created_at= '20.10.2017 8:10'
UPDATE users
	set updated_at= '20.10.2017 8:10'

-- решение
UPDATE users SET created_at = STR_TO_DATE(created_at, "%d.%m.%Y %k:%i");

ALTER TABLE users MODIFY created_at DATETIME

UPDATE users SET updated_at = STR_TO_DATE(updated_at, "%d.%m.%Y %k:%i");

ALTER TABLE users MODIFY updated_at DATETIME

-- 3  В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0,
--    если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи
--    таким образом, чтобы они выводились в порядке увеличения значения value. 
--    Однако нулевые запасы должны выводиться в конце, после всех записей.

-- приводим таблици к дано.
insert  INTO storehouses_products (value) VALUES
  ('1'),
  ('3'),
  ('0'),
  ('5'),
  ('2'),
  ('1');

 -- решение

select DISTINCT value from storehouses_products
	ORDER BY value = 0 ASC, value ASC;

-- 4(по желанию) Из таблицы users необходимо извлечь пользователей, 
-- родившихся в августе и мае. Месяцы заданы в виде списка английских названий
--  (may, august)

SELECT 
    firstname,
    lastname,
    DATE_FORMAT (birtday,'%M') as Month_ FROM users where (substring(birtday, 6, 2)) = '08' or 
   (substring(birtday, 6, 2)) = '05' limit 10; 
  
  
  -- (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. 
  -- SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.
  
  
  -- хз что хотят в дз...
  
  
  -- 1 Подсчитайте средний возраст пользователей в таблице users.
  
  use snet2910;
select avg((to_days(now()) - to_days(birthday))/365.25) from users;

-- 2 Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
-- Следует учесть, что необходимы дни недели текущего года, а не года рождения.

select
    count(*),
    case(weekday(concat (2020, (substring(birthday, 5, 6)))))
        when 0 then 'Monday'
        when 1 then 'Tuesday'
        when 2 then 'Wednesday'
        when 3 then 'Thursday'
        when 4 then 'Friday'
        when 5 then 'Saturday'
        when 6 then 'Sunday'
    end as birthday2020
from users group by birthday2020;
  
