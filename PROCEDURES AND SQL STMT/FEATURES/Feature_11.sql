create or replace procedure endorse_skill(email in varchar2,pwd in varchar2,fd_skill_name in varchar2,user_type in varchar2,endorsee_emailid in varchar2)
as
valid number;
var1 number;
var2 number;
var3 number;
begin
valid:=feature0(email,pwd,user_type); --check whether user is authorized
if valid=1 then
select count(*) into var1 from first_degree_connection f where f.member_email_id= email and f.connection_email_id= endorsee_emailid; --check whether endorser and endorsee are first degree connection
if var1=1 then
	select count(*) into var2 from members_skills m where m.email_id= endorsee_emailid and lower(m.skill_name)=lower(fd_skill_name); --check whether the endorsee has the skill to be endorsed
		if var2=1 then
		select count(*) into var3 from skills_endorsement se where se.email_id=email and se.endorsee_email_id=endorsee_emailid and lower(se.skill_name)=lower(fd_skill_name); --do not allow to endorse, if skill is already endorsed
			if var3=1 then 
			dbms_output.put_line('The skill you are trying to endorse is already endorsed by you');
			else 
			insert into skills_endorsement values (skl_endo_id_seq.nextval,fd_skill_name,email,endorsee_emailid);  --allow endorsing if skill not endorsed
      	dbms_output.put_line('Skill successfully endorsed');
			end if;
		else
		dbms_output.put_line('The skill you are trying to endorse does not exist for the member');
		end if;
	else
	dbms_output.put_line('The member for whom you are trying to endorse skill is not your first degree connection');
	end if;
else
dbms_output.put_line('invalid login');
end if;

EXCEPTION
WHEN no_data_found THEN
  dbms_output.put_line('Data not found');
When others then
dbms_output.put_line('Data not entered correctly');

end;