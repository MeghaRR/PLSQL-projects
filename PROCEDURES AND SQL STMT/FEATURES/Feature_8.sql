create or replace procedure get_Prof_profile(fd_email_id in varchar2,fd_password in varchar2,user_type in varchar2)

is 
v_summ members_profile.summary%type;
v_skills members_skills.skill_name%type;
v_group community.community_name%type;
valid number;
i number;

org_name members_work_exp.organization_name%type;
job_pos members_work_exp.job_position%type;
job_desc members_work_exp.job_description%type;

uni members_education.university%type;
maj members_education.majors%type;
qual members_education.qualification%type;

ph_num members_contact_info.phone%type;
fb members_contact_info.facebook_url%type;
twitt members_contact_info.twitter_url%type;
sec_email members_email.secondary_email_id%type;
v_website members_website.website%type;

cursor c1 is select organization_name, job_position,job_description from members_work_exp where email_id=fd_email_id order by job_start_date desc;   --cursor to get professional information
cursor c2 is select university, majors,qualification from members_education where email_id=fd_email_id order by degree_start_date desc;              --cursor to get educational information
cursor c3 is select skill_name from members_skills where email_id=fd_email_id;                                --cursor to store members skill
cursor c4 is select community_name from community where community_id = (select community_id from members_group where email_id=fd_email_id);          --cursor to store members groups
cursor c5 is select phone,facebook_url,twitter_url from members_contact_info where email_id=fd_email_id;                       --cursor to store members contact info
cursor c6 is select secondary_email_id from members_email where member_email_id=fd_email_id;                                   --cursor to store members email ids
cursor c7 is select website from members_website where member_info_id= (select member_info_id from members_contact_info where email_id=fd_email_id);     --cursor to store members websites info


begin

valid:= feature0(fd_email_id,fd_password,user_type);

if valid=1 then           --check if user is authorized


select summary into v_summ from members_profile where email_id=fd_email_id;                  --cursor to get summary of member
dbms_output.put_line('Summary: ' || v_summ);  

open c1;
i:=1;
loop
fetch c1 into org_name,job_pos,job_desc;                                     --professional profile
exit when c1%notfound;
dbms_output.put_line('Work experience ' ||i|| ' : ');
dbms_output.put_line( 'organization_name: '|| org_name );
dbms_output.put_line('job_position : '  ||job_pos );
dbms_output.put_line('job_description: ' || job_desc);
i:=i+1;
end loop;
close c1;

open c2;
i:=1;
loop
fetch c2 into uni,maj,qual;                                                --educational profile
exit when c2%notfound;
dbms_output.put_line('Education '||i|| ' : ');
dbms_output.put_line( 'university_name: '|| uni );
dbms_output.put_line('majors : '  ||maj);
dbms_output.put_line('qualifications: ' || qual);
i:=i+1;
end loop;
close c2;

open c3;
dbms_output.put_line('skills : ');                                        --skills data
loop
fetch c3 into v_skills;
exit when c3%notfound;
dbms_output.put_line( v_skills );
end loop;
close c3;

open c4;
dbms_output.put_line('groups : ');                                        --members group
loop
fetch c4 into v_group;
exit when c4%notfound;
dbms_output.put_line( v_group );
end loop;
close c4;

open c5;
loop
fetch c5 into ph_num,fb,twitt;                                            --contact info
exit when c5%notfound;
dbms_output.put_line('Contact information : ');
dbms_output.put_line( 'phone: '|| ph_num );
dbms_output.put_line('facebook_url : '  ||fb);
dbms_output.put_line('twitter_url: ' || twitt);
end loop;
close c5;

open c6;
dbms_output.put_line('email ids : ');             --email ids
dbms_output.put_line(fd_email_id );
loop
fetch c6 into sec_email;
exit when c6%notfound;

dbms_output.put_line( sec_email );
end loop;
close c6;

open c7;
dbms_output.put_line('websites : ');                                  --websites
loop
fetch c7 into v_website;
exit when c7%notfound;
dbms_output.put_line( v_website );
end loop;
close c7;



else
dbms_output.put_line('invalid login');
end if;

EXCEPTION
WHEN no_data_found THEN
  dbms_output.put_line('Data not found');
When others then
dbms_output.put_line('Data not entered correctly');

end;