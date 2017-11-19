create or replace procedure set_account_inactive (email in varchar2, pwd in varchar2,user_type in varchar2, mem_email in varchar2)
AS
valid number;
var1 varchar2(8);
begin
valid := feature0 (email, pwd, user_type); ---checks if the user is valid
if (valid = 1 and lower(user_type) = 'a') then
  select status into var1 from members_profile m where m.email_id = mem_email; --if the member is active or his status is null, set it to inactive
  if (lower(var1) = 'active' or var1 is null)  then 
  update members_profile m set m.status = 'inactive' where m.EMAIL_ID = mem_email;
  dbms_output.put_line('member''s account set to inactive');
  else
  DBMS_OUTPUT.PUT_LINE('account is already inactive');  --if account is already inactive, give error message.
  end if;
else dbms_output.put_line('user not authorized for the transaction'); 
end if;
exception
when no_data_found then
dbms_output.put_line ('member not present');
end;