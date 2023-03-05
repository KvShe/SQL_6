-- Cоздание процедуры, которая решает следующую задачу
-- Выбрать для одного пользователя 5 пользователей в случайной комбинации, которые удовлетворяют хотя бы одному критерию:
-- 1) из одного города
-- 2) состоят в одной группе
-- 3) друзья друзей

use homework_5_3;
drop procedure if exists five_random_users;
delimiter //
create procedure five_random_users(id int)
begin
    select p1.user_id
    from profiles as p1
             join profiles as p2 on p1.hometown = p2.hometown
    where p2.user_id = id
      and p1.user_id != id

    union

    select p1.user_id
    from users_communities as p1
             join users_communities as p2 on p1.community_id = p2.community_id
    where p2.user_id = id
      and p1.user_id != id

    union

    select f3.target_user_id
    from friend_requests as f1
             join friend_requests as f2
                  on (f1.initiator_user_id = f2.target_user_id or f2.initiator_user_id = f1.target_user_id)
             join friend_requests as f3
                  on (f2.initiator_user_id = f3.target_user_id or f3.initiator_user_id = f2.target_user_id)
    where (f2.status = 'approved' and f3.status = 'approved')
      and (f1.initiator_user_id = id or f1.target_user_id = id)
      and (f3.target_user_id != id and f3.initiator_user_id != id)

    order by rand()
    limit 5;
end //
delimiter ;

# call five_random_users(1);

-- Cоздание функции, вычисляющей коэффициент популярности пользователя
-- Количество лайков делим на количество контента
drop function if exists popularity_ratio;
delimiter //
create function popularity_ratio(id bigint unsigned)
returns double reads sql data
begin
    declare amount_likes int default 0;
    declare amount_media int default 0;

    select count(*) into amount_likes from likes where user_id = id;
    select count(*) into amount_media from media where user_id = id;

    return round(amount_likes / amount_media, 2);
end //
delimiter ;

select popularity_ratio(2);
