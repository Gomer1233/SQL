-- Пусть задан некоторый пользователь. 
-- Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.

select mess.* from (select initiator_user_id, target_user_id from friend_request where status = 'approved') as friend join (select from_user_id as most_activ_friend, count(from_user_id) as mess_quant from messages where to_user_id = 2 group by from_user_id) mess on friend.initiator_user_id = mess.most_activ_friend or friend.target_user_id = mess.most_activ_friend order by mess_quant desc limit 1;

-- Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.

select user.id, user.name, user.age, liker.total_q from (select likes.user_id, sum(quan) as total_q from (select user_id, count(*) as quan from likes where status_post_id = 'liked' group by user_id union all select user_id, count(*) as quan from likes where status_photo_id = 'liked' group by user_id order by quan desc) as likes group by likes.user_id) as liker join (select id, name, timestampdiff(year, birthday, now()) as age from users) as user where user.id = liker.user_id order by liker.total_q desc limit 10;

-- Определить кто больше поставил лайков (всего) - мужчины или женщины?
select t2.gender, count(*) as total_l from (select user_id, status_post_id, status_photo_id from likes where status_photo_id = 'liked' or status_post_id = 'liked') as t1 left join (select gender, id from users) as t2 on t1.user_id = t2.id group by gender;

-- Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.
-- Условия:
-- <5 комментариев
-- <5 сообщений
-- <5 постов
-- <5 лайков

select t1.user_id, sum(t1.total_c) total_activiti from (select * from (select user_id, count(*) as total_c from comments group by user_id) mess where total_c < 5 union all select * from (select from_user_id, count(*) as total_c from messages group by from_user_id) mess where total_c < 5 union all select * from (select user_id, count(*) as total_c from posts group by user_id) mess where total_c < 5 union all select * from (select user_id, count(*) as total from likes where status_photo_id = 'liked' or status_post_id = 'liked' group by user_id) as lik where lik.total < 5) t1 group by t1.user_id order by total_activiti limit 10;

