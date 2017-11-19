create or replace procedure summary_report (email in varchar2, pwd in varchar2, user_type in varchar2 )
AS
cursor c1 is select count(skill_name)as count_skills ,m.skill_name from members_skills m group by m.skill_name order by count_skills desc; -- explicit cursor to select top 3 skills
cursor c15 is select distinct(member_email_id) from FIRST_DEGREE_CONNECTION; --cursor for counting avg number of second degree connections 
valid number;
count_active_mem number;
count_inactive_mem number;
count_skills number;
count_skills1 number;
top3_skills number;
skill_name1 varchar2(20);
var1 number;
var2 number; 
var3 varchar2(50);
count_second_conn number; --count of 2nd deg conections for each member
sum_second_conn number := 0; --stores the sum of 2nd deg connections for all members
begin
valid := feature0 (email, pwd, user_type); --call to a function that checks the login information
if (valid = 1 and user_type = 'A') then
  
  /*print the number of active and inactive members*/
  select count(*) into count_active_mem from members_profile where lower(status) = 'active'; --active members
  dbms_output.put_line('number of active members = ' || count_active_mem);
  select count(*) into count_inactive_mem from members_profile where lower(status) = 'inactive'; --inactive members
  dbms_output.put_line('number of inactive members = ' || count_inactive_mem);
  
  /*get top 3 skills */
  dbms_output.put_line('top 3 skills are : ');
  open c1;
  loop
  fetch c1 into count_skills1, skill_name1;
  exit when c1%ROWCOUNT = 4;
  dbms_output.put_line(skill_name1 ||' - ' || count_skills1);
  end loop;
  close c1;
  
  /*average number of first degree connections*/
  select count(*) into var1 from first_degree_connection; --count the total number of connections of all members
  select count(distinct(member_email_id)) into var2 from FIRST_DEGREE_CONNECTION; --count the total number of members 
  DBMS_OUTPUT.PUT_LINE('average number of first degree connections = ' || round(var1/var2) ); --divide the total# connections by #members, and round the value
  
  /*average number of 2nd degree connections*/
  /*created a function that returns the count of distinct 2nd deg conn for each member --> function15
  add up each value that is returned
  divide the value by #members */
  open c15;
  loop
  fetch c15 into var3;
  exit when c15%NOTFOUND;
  count_second_conn := function15 (var3); --function15 returns count of 2nd deg connection for each member fetched by cursor c15.
  sum_second_conn := count_second_conn + sum_second_conn ; --sum of all member's 2nd deg connections calculated
  END LOOP;
  close c15;
  DBMS_OUTPUT.PUT_LINE('average number of second degree connections is = ' || round(sum_second_conn/var2));
  
else
  dbms_output.put_line('user does not have enough privileges'); --if the user is not an admin/ enters wrong login credentials. (if valid != 1)
end if;  
end;