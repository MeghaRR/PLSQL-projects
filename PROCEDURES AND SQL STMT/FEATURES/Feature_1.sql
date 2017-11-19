create or replace procedure Create_an_account(email_id_user in varchar2,pass_id_user in varchar2,type_user in varchar2, name_user in varchar2,city_user in varchar2,country_user in varchar2,summary_mem in varchar2)
is
lower_email_id_user varchar2(50);
user_verified integer;
temp_current_time Timestamp;
Begin
temp_current_time := sysdate;
lower_email_id_user := LOWER(email_id_user);----converts email id entered into lower case
user_verified := FEATURE0(lower_email_id_user, pass_id_user,type_user);----verifies the email id , password and type of an individual user
If (user_verified = 1) then 
dbms_output.put_line('User already exists');---if feature returns 1, it means user is already in the databaseand no need of creating that user profile.
else
If (type_user = 'M')then---Checks if the user is a member 
Insert into users_profile values(lower_email_id_user,pass_id_user,type_user,name_user,city_user,country_user,temp_current_time,temp_current_time);
Insert into members_profile values(lower_email_id_user,'active',summary_mem);
dbms_output.put_line('New User Profile Created');
else
dbms_output.put_line('Invalid User Login');
end if;
end if;
end;