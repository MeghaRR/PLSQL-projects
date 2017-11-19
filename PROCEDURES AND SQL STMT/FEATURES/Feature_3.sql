create or replace procedure Usage_report(email_user in varchar2,pass_user in varchar2,type_user in varchar2, k in number)
is
lower_email_user varchar2(50);
user_verified integer;
days_first_created integer;
number_first_degree_con integer;
number_k_first_degree_con integer;
number_recom integer;
number_active_recom integer;
begin
lower_email_user := LOWER(email_user);---converts email id of the user  into lower case.
user_verified := FEATURE0(lower_email_user, pass_user,type_user);---verifies the user id, password and type of a particular user.
If (type_user='M') and (user_verified=1) then----checks if the  user already exists in the system and is a Member .

Select trunc(sysdate)-trunc(creation_time) into days_first_created from users_profile where  users_profile.email_id = email_user;---Calculates the number of days from sysdate and creation time.
dbms_output.put_line('The number of days since the member first created account in the system'||','||days_first_created);

Select count(connection_email_id) into number_first_degree_con from first_degree_connection f where f.member_email_id = email_user;---Calculates the first degree connections of the member.
dbms_output.put_line('The number of 1st-degree connections the member currently has'||','||number_first_degree_con);

Select count(distinct connection_email_id) into number_k_first_degree_con from first_degree_connection f where f.member_email_id = email_user and (trunc(sysdate)-trunc(f.connection_time))<=k;---Calculates the number of 1st degree connections the member has newly created in the last k days.
dbms_output.put_line('The number of 1st-degree connections the member has newly created in the last k days'||','||number_k_first_degree_con);

Select count(distinct receivers_email_id) into number_recom from recommendations r,first_degree_connection f where r.recommenders_email_id=f.member_email_id and r.recommenders_email_id= email_user;---Calculates the number of recommendations, member has written for his first degree connections.
dbms_output.put_line('The number of recommendations the member has written for his/her 1st-degree connections'||','||number_recom);

Select count(*) into number_active_recom from recommendations r where r.receivers_email_id=email_user and ( trunc(sysdate)- trunc(r.creation_date))<=730;--Calcualtes the number of active recommendations member has received. 
dbms_output.put_line('The number of active recommendations the member has received'||','||number_active_recom);

else
dbms_output.put_line('Invalid user login');
end if;
end;