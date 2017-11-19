Create or Replace PROCEDURE feature13(email in VARCHAR2,pwd in VARCHAR2,user_type in VARCHAR2,Keyword Varchar2) AS
KeywordArray Apex_Application_Global.Vc_arr2;
QueryStatement varchar2(200);
SQLStatement varchar2(200);
status number;
TYPE Cur_Typ IS REF CURSOR;
C1 Cur_Typ;
email1 members_profile.email_id%type;
con1 FIRST_DEGREE_CONNECTION.CONNECTION_EMAIL_ID%type;
Begin
KeywordArray:=Apex_Util.String_To_Table(Keyword,' ');
QueryStatement:=' ';
For I in 1..KeywordArray.Count
Loop
If (I=1)Then  
  QueryStatement:= QueryStatement||'UPPER(summary) LIKE ''%'||Upper(KeywordArray(i))||'%''';
Else
  QueryStatement:= QueryStatement||' and '|| 'UPPER(summary) LIKE ''%'||Upper(KeywordArray(i))||'%''';
End if;
End loop;
SQLStatement := ('Select email_id From members_profile where '||QueryStatement);

status:=feature0(email,pwd,user_type);
IF status = 1 and user_type = 'M' THEN
DBMS_OUTPUT.PUT_LINE('List of First Degree connection of '||email||' with requested keyword ');
OPEN C1 FOR SQLStatement;
LOOP
  FETCH C1 INTO email1;
  Exit When C1%NotFound;
  If  email1 is not NULL  Then
  select distinct connection_email_id into con1 from FIRST_DEGREE_CONNECTION where MEMBER_EMAIL_ID = email and CONNECTION_EMAIL_ID = email1;
  DBMS_OUTPUT.PUT_LINE(con1);
  End If;
END LOOP;
CLOSE C1;
ELSE
 DBMS_OUTPUT.PUT_LINE('Member with email-id '||email||' doesnt have privileges');
END IF;

Exception
When No_Data_Found Then
Dbms_output.put_line('No connections with given keywords.');
End;

-----------------------------------------------------

create or replace PROCEDURE feature13(email in VARCHAR2,pwd in VARCHAR2,user_type in VARCHAR2,Keyword Varchar2) AS
KeywordArray Apex_Application_Global.Vc_arr2;
QueryStatement varchar2(2000);
SQLStatement varchar2(2000);
status number;
TYPE Cur_Typ IS REF CURSOR;
C1 Cur_Typ;
cursor C2 is select distinct a.connection_email_id from FIRST_DEGREE_CONNECTION a,temp_values b 
where a.member_email_id=email and a.connection_email_id=b.temp_email;
email1 members_profile.email_id%type;
--sum1 members_profile.summary%type; 
con1 FIRST_DEGREE_CONNECTION.CONNECTION_EMAIL_ID%type;
Begin
KeywordArray:=Apex_Util.String_To_Table(Keyword,' ');
QueryStatement:=' ';
For I in 1..KeywordArray.Count
Loop
If (I=1)Then  
  QueryStatement:= QueryStatement||'UPPER(summary) LIKE ''%'||Upper(KeywordArray(i))||'%''';
Else
  QueryStatement:= QueryStatement||' and '|| 'UPPER(summary) LIKE ''%'||Upper(KeywordArray(i))||'%''';
End if;
End loop;

/*SQLStatement := ('select connection_email_id from FIRST_DEGREE_CONNECTION 
where MEMBER_EMAIL_ID ='||email||' and 
CONNECTION_EMAIL_ID IN (select email_id from members_profile 
where '||QueryStatement||')'); */

SQLStatement := ('Select email_id From members_profile where '||QueryStatement);

status:=feature0(email,pwd,user_type);
IF status = 1 and user_type = 'M' THEN
DBMS_OUTPUT.PUT_LINE('List of First Degree connection of '||email||' with requested keyword ');
OPEN C1 FOR SQLStatement;
LOOP
  FETCH C1 INTO email1;
  --If  email1 is not NULL  Then
  --Exit When C1%NotFound;
  insert into TEMP_VALUES values(email1);
  /*select distinct connection_email_id into con1 from FIRST_DEGREE_CONNECTION 
  where MEMBER_EMAIL_ID = email and CONNECTION_EMAIL_ID = email1;
  DBMS_OUTPUT.PUT_LINE(con1);*/
  --End If;
END LOOP;
CLOSE C1;

OPEN C2;
LOOP
  FETCH C2 INTO con1;
  --If  con1 is not NULL  Then
  --Exit When C1%NotFound;
  --insert into TEMP_VALUES values(email1);
  /*select distinct connection_email_id into con1 from FIRST_DEGREE_CONNECTION 
  where MEMBER_EMAIL_ID = email and CONNECTION_EMAIL_ID = email1;*/
  DBMS_OUTPUT.PUT_LINE(con1);
  --End If;
END LOOP;
CLOSE C2;
delete from TEMP_VALUES;
ELSE
 DBMS_OUTPUT.PUT_LINE('Member with email-id '||email||' doesnt have privileges');
END IF;

Exception
When No_Data_Found Then
Dbms_output.put_line('No first degree connection found for the given keywords.');
End;

set serveroutput on;
exec feature13('pranay@mylinkedin.com','pranay','M','business');

create table temp_values(temp_email varchar2(50));   
