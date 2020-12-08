-- 1 Проанализировать запросы, которые выполнялись на занятии, определить возможные корректировки 
-- и/или улучшения (JOIN пока не применять).
-- 2 Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека,
-- который больше всех общался с нашим пользователем.
-- 3 Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.
-- 4 Определить кто больше поставил лайков (всего) - мужчины или женщины?
-- 5 Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.

-- 2.

select
	id,
	(select count(*) talks from messages m where m.to_user_id = u.id and m.from_user_id in 
		(select fr4.initiator_user_id from friend_requests fr4 where fr4.target_user_id = u.id and fr4.status = 'approved')) +
	(select count(*) talks from messages m2 where m2.to_user_id = u.id and m2.from_user_id in 
		(select fr5.target_user_id from friend_requests fr5 where fr5.initiator_user_id = u.id and fr5.status = 'approved')) msgs_from_friends
from users u where u.id = 1;

-- 3.

select count(*) from photo_likes pl 
where who_likes in (select id from users u where timestampdiff(year, u.birthday, now())<14);

-- 4.

select 
	(select count(*) who_likes from photo_likes pl where pl.who_likes in 
		(select id from users u where u.gender = 'f')) likes_by_women,
	(select count(*) who_likes from photo_likes pl where pl.who_likes in 
		(select id from users u where u.gender = 'm')) likes_by_men;

-- 5.

select
	id,
	((select count(*) who_likes from photo_likes pl where pl.who_likes = u.id) +
	(select count(*) from_user_id from messages m2 where m2.from_user_id = u.id) +
	(select count(*) user_id from photos p where p.user_id = u.id) +
	(select count(*) initiator_user_id from friend_requests fr where fr.initiator_user_id = u.id)) as total_activities
from users u order by total_activities;