-- Создайте функцию, которая принимает кол-во сек и форматирует их в кол-во дней, часов, минут и секунд.
-- Пример: 123456 ->'1 days 10 hours 17 minutes 36 seconds '

drop function if exists format_time;

delimiter //
create function format_time(seconds int unsigned)
    returns
        text
    deterministic
begin
    declare days int;
    declare hours int;
    declare minutes int;

    set days = floor(seconds / 86400);
    set seconds = seconds - days * 86400;

    set hours = floor(seconds / 3600);
    set seconds = seconds - hours * 3600;

    set minutes = floor(seconds / 60);
    set seconds = seconds - minutes * 60;

    return concat(days, ' days ', hours, ' hours ', minutes, ' minutes ', seconds, ' seconds ');

end //

select format_time(156) as format_time;

# Выведите только четные числа от 1 до 10 включительно. (Через функцию / процедуру)
# Пример: 2,4,6,8,10 (можно сделать через шаг +  2: х = 2, х+=2)

drop procedure if exists even_numbers;

delimiter //
create procedure even_numbers()
begin
    declare number int default 10;
    declare result text default '';
    declare counts int default 2;

    while counts <= number
        do

            set result = concat(result, ' ', counts);
            set counts = counts + 2;

        end while;
    select result;

end //

call even_numbers();

