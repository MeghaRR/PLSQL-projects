create or replace procedure feature17 (email in varchar2,pwd in varchar2, user_type in varchar2) 
  AS
    valid number;
    rec1 varchar2(50);
    rec2 varchar2(50);
    rec3 varchar2(50);
	rec4 varchar2(50);
	rec5 varchar2(50);
	
  Cursor C1 is Select b.connection_email_id from first_degree_connection a, first_degree_connection b
	where a.member_email_id = email and a.connection_email_id = b.member_email_id and b.CONNECTION_EMAIL_ID!=a.MEMBER_EMAIL_ID
	and b.connection_email_id NOT IN
  (select connection_email_id from first_degree_connection where member_email_id = email); --cursor to get the second degree conn of a given member, and store the records in a temp table
  
  cursor c2 is select m2.email_id from members_work_exp m1 ,members_work_exp m2 where m1.ORGANIZATION_NAME = m2.ORGANIZATION_NAME and 
  m2.email_id != m1.EMAIL_ID and m1.email_id = email and m2.email_id not in (select connection_email_id from first_degree_connection where member_email_id = email); --get members working in the same organization as that of the given member (such that they are not his/her first degree connections), and store the records in a temp table.
  
  cursor c3 is select distinct(pymk) into rec3 from temp_table171; --cursor that retrives upto 10 distinct records from the temp table. 
  
  cursor c4 is select m2.email_id from members_education m1 ,members_education m2 where m1.university = m2.university and 
  m2.email_id != m1.EMAIL_ID and m1.email_id = email and m2.email_id not in (select connection_email_id from first_degree_connection where member_email_id = email); --get members studying in the same university as that of the given member (such that they are not his/her first degree connections), and store the records in a temp table.
  
  cursor c5 is select m2.email_id from members_group m1 ,members_group m2 where m1.community_id = m2.community_id and 
  m2.email_id != m1.EMAIL_ID and m1.email_id = email and m2.email_id not in (select connection_email_id from first_degree_connection where member_email_id = email); --get members having same groups as that of the given member (such that they are not his/her first degree connections), and store the records in a temp table.
  
  
  begin
  valid := feature0 (email,pwd,user_type); --checks if the user is valid
 
  if valid = 1 and user_type = 'M' then
  
  open c1;
  loop
  fetch c1 into rec1;
  exit when c1%notfound;
  insert into temp_table171 values (rec1); --temp_table171 is first created to store values returned from cursor.
  end loop;
  close c1;
  
  Open C2;
	Loop
	Fetch C2 into rec2 ;
  Exit When C2%NotFound;
	if (rec2 IS NOT NULL) then    
    	insert into temp_table171 values(rec2); --temp_table171 is first created to store values returned from cursor.
	end if;
	End Loop;
	Close C2;  
  
   Open C4;
	Loop
	Fetch C4 into rec4 ;
  Exit When C4%NotFound;
	if (rec4 IS NOT NULL) then
    	insert into temp_table171 values(rec4); --temp_table171 is first created to store values returned from cursor.
	end if;
	End Loop;
	Close C4;  
	
	Open C5;
	Loop
	Fetch C5 into rec5 ;
  Exit When C5%NotFound;
	if (rec5 IS NOT NULL) then
    	insert into temp_table171 values(rec5); --temp_table171 is first created to store values returned from cursor.
	end if;
	End Loop;
	Close C5;  
  
  DBMS_OUTPUT.PUT_LINE('Recommendations for the member ' || email  || ' are ' );
  open c3;
  loop
  fetch c3 into rec3;
  exit WHEN (C3%NOTFOUND) OR (C3%ROWCOUNT = 11);
  DBMS_OUTPUT.PUT_LINE(rec3);
  end loop;
  close c3;
  
  delete from TEMP_TABLE171; --delete the values from the temp table
  
  ELSE
  DBMS_OUTPUT.PUT_LINE('Invalid member');
  END IF;
  
  END;