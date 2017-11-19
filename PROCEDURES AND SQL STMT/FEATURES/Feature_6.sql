create or replace procedure remove_group (email in varchar2, pwd in varchar2, user_type in varchar2, grp_name in varchar2)
AS
var1 number;
valid number;
begin 
valid := feature0 (email, pwd, user_type); --check if the user is authorized
if (valid = 1 and lower(user_type) = 'm') then
  select m.member_group_id into var1 from members_group m where m.email_id = email and -- check whether the member is a part of the group
  m.community_id = (select c.community_id from community c where c.community_name = grp_name);
 
 if var1 is not null then --if member is a part of the group, then remove him/her
 delete from members_group m where m.EMAIL_ID = email and 
 m.community_id = (select c.community_id from community c where c.community_name = grp_name);
 DBMS_OUTPUT.PUT_LINE('group deleted from members profile');
 end if;
 else
 dbms_output.put_line('member not valid');
 end if;
 exception
 when no_data_found then
 dbms_output.put_line('member does not belong to the group');
 end;