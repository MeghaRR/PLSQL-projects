create or replace procedure selectSkill(fd_email_id in varchar2,fd_password in varchar2,user_type in varchar2,enter_skill in number,name_skill skill_n)
as
c_skill number;
e_skill number;
n_skill number;

m_skills number;
valid number;
flag number;
a number;
b skills.skill_name%type;
begin

valid:= feature0(fd_email_id,fd_password,user_type);

if valid=1 and user_type='M' then    --check if user is valid and is authorized
select count(distinct skill_name) into c_skill from members_skills where email_id=fd_email_id;      --check total skills present

dbms_output.put_line(10-c_skill ||'skills can be entered');

	if (c_skill<9 and (enter_skill+c_skill)<=10) then    -- --check if skill count is not above 10

	if(name_skill.count=enter_skill) then       --check if user has given correct number of skills to be selected
	for i in 1..enter_skill loop

  
	select count(*) into e_skill from skills where skill_name=name_skill(i);
		if(e_skill!=1 ) then      --checks if skills is present in skills database
		flag:=1;     --if skill not present set flag =1
		else
		flag:=0;     --if skill present set flag =0
		end if;


			if(flag=1) then     --if skills not present in skills database then adds in database
			insert into skills values (name_skill(i));
			insert into members_skills values (mem_skill_id_seq.nextval,name_skill(i),fd_email_id);
			c_skill:=c_skill+1;      --increase count of skills by 1
			dbms_output.put_line('you have a new skill updated successfully: '|| name_skill(i));
			else
			dbms_output.put_line(name_skill(i)|| ' skill already present in skills database ');
			end if;

				if(flag=0) then      --if skill present in skill database
				select count(*) into m_skills from members_skills where email_id= fd_email_id and skill_name=name_skill(i);    --check in member skill database 
					if(m_skills!=1 ) then       -- add if not present
						insert into members_skills values (mem_skill_id_seq.nextval,name_skill(i),fd_email_id);
						c_skill:=c_skill+1;       --increase count of skills by 1
						dbms_output.put_line('you have a new skill updated successfully: '||name_skill(i));
					else
						dbms_output.put_line(name_skill(i)|| ' skill already exists in your profile ');
					end if;
				end if;
	end loop;
  else
	dbms_output.put_line('Please enter correct number of skills');
  end if;
  
	else
	dbms_output.put_line('you cannot have more than 10 skills');
	end if;
else
dbms_output.put_line('invalid login');
end if;

EXCEPTION
WHEN no_data_found THEN
  dbms_output.put_line('Data not found');

end;