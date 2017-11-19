create or replace function function15 (second_conn in varchar2) return number --function that gets called from procedure summary_report.
as
Cursor C1 is Select b.connection_email_id from first_degree_connection a, first_degree_connection b
	where a.member_email_id = second_conn and a.connection_email_id = b.member_email_id and b.CONNECTION_EMAIL_ID!=a.MEMBER_EMAIL_ID
	and b.connection_email_id NOT IN
  (select connection_email_id from first_degree_connection where member_email_id = second_conn);
rec1 first_degree_connection.connection_email_id%type;
count1 number;
BEGIN
Open C1;
	Loop
	Fetch C1 into rec1 ;
  Exit When C1%NotFound;
	if (rec1 IS NOT NULL) then
    	insert into temp_tablef15 values(rec1); --temp_table15 is first created to store values returned from cursor.
	end if;
	End Loop;
	Close C1;
  select count(distinct(conn_email)) into count1 from TEMP_TABLEF15; --count of distinct 2nd deg conn for the member is returned to the calling procedure
  delete from TEMP_TABLEF15; 
  return count1;
END;