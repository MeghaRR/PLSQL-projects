create or replace PROCEDURE feature12(email in VARCHAR2,pwd in VARCHAR2,user_type in VARCHAR2)
AS
status number;
Cursor C1 is Select distinct b.connection_email_id from first_degree_connection a, first_degree_connection b
    where a.member_email_id = email and a.connection_email_id = b.member_email_id and b.CONNECTION_EMAIL_ID!=a.MEMBER_EMAIL_ID
    and b.connection_email_id NOT IN
  (select connection_email_id from first_degree_connection where member_email_id = email);
  --cursor to get the 2nd degree connection by doing self-join of first_degree_connection table and excluding repeated records. 
rec1 first_degree_connection.connection_email_id%type;
BEGIN
status:=feature0(email,pwd,user_type); --function call to check login status
DBMS_OUTPUT.PUT_LINE('LIST OF SECOND DEGREE CONNECTION');
IF status = 1 and user_type = 'M' THEN 
    Open C1;
    Loop
    Fetch C1 into rec1 ;
    if (rec1 IS NOT NULL) then
        Exit When C1%NotFound;
        DBMS_OUTPUT.PUT_LINE(rec1);
    else
        DBMS_OUTPUT.PUT_LINE('NO SECOND DEGREE CONNECTION ' );
        Exit When C1%NotFound;
    end if;
    End Loop;
    Close C1;
ELSE
 DBMS_OUTPUT.PUT_LINE('Member with email-id '||email||' doesnt have privileges');
END IF;
END;


  



exec feature12('megha@mylinkedin.com','megha','M');
exec feature12('pranay@mylinkedin.com','pranay','M');