create or replace procedure New_connection(email_user in varchar2,pass_user in varchar2,type_user in varchar2,conn_email_id in varchar2)
is
lower_email_user varchar2(50);
lower_conn_email_id varchar2(50);
user_verified integer;
verify_conn_email_id integer;
temp_connection_time Timestamp;
begin
temp_connection_time := sysdate;
lower_email_user := LOWER(email_user);  ----converts email id of the user  into lower case.
lower_conn_email_id := LOWER(conn_email_id);---converts the email id of the connection into lower case.
user_verified := FEATURE0(lower_email_user, pass_user,type_user);---verifies the user id, password and type of a particular user.
select count(*) into verify_conn_email_id from users_profile where email_id = lower_conn_email_id;
If (user_verified = 1) and ( verify_conn_email_id = 1)and (type_user='M')and (lower_conn_email_id!=lower_email_user) then---if profile of the user , connection user already exists and if the user is of type M then insert values.
INSERT INTO first_degree_connection VALUES (id_seq.nextval,lower_conn_email_id,lower_email_user,temp_connection_time);
INSERT INTO first_degree_connection VALUES (id_seq.nextval,lower_email_user,lower_conn_email_id,temp_connection_time);
dbms_output.put_line('New Connection Created');
else
dbms_output.put_line('User is not a Member or Connection Email Id is invalid');
end if;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Duplicate key attempted to be inserted. Please check insert or update statements.');
end;