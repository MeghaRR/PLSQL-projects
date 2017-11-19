create or replace function feature0 (email in varchar2,pwd in varchar2, user_type in varchar2)return number
 AS
 var1 number;
 begin
 select count(*) into var1 from users_profile u where lower(u.email_id) = lower(email) and
 u.password = pwd and u.type = user_type;
 if var1 = 1 then
 return 1;
 else
 return -1;
 end if;
 end;