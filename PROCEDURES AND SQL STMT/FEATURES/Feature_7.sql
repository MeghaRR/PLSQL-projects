create or replace procedure feature7(u_email_id varchar2)
as 
--Cursor declaration to select top 3 skills of employee

  cursor c1 is SELECT * FROM (select skill_name from skills_endorsement 
  where ENDORSEE_EMAIL_ID = u_email_id
  group by SKILL_NAME 
  order by count(skill_name) desc)
  where rownum < 4;
  top skills_endorsement.skill_name%type;
  counter number;
  begin
  select count(*)into counter from skills_endorsement where ENDORSEE_EMAIL_ID = u_email_id;
  
--Condition to check whether user user is valid or not
  if(counter>=1)then
  open c1;
  loop
   fetch c1 into top;
     exit when c1%notfound;
   dbms_output.put_line(top);
  end loop;
 close c1;
 else
 DBMS_OUTPUT.PUT_LINE('User profile does not exist');
 end if;
end;