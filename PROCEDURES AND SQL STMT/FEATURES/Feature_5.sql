create or replace PROCEDURE feature5 (email VARCHAR2,pwd VARCHAR2,user_type VARCHAR2,org VARCHAR2,jobp VARCHAR2,jobsd DATE,jobed DATE,description VARCHAR2,email1 VARCHAR2)
AS
status number;
BEGIN
status:=feature0(email,pwd,user_type); -- function call to check login status
IF status=1 and user_type ='M' THEN
  INSERT INTO members_work_exp  
  Values(expid.nextval,org,jobp,jobsd,jobed,description,email1);
  DBMS_OUTPUT.PUT_LINE('WORK EXPERIENCE UPDATED');
ELSE 
 DBMS_OUTPUT.PUT_LINE('Member with email id ' ||email|| ' doesnt have privileges');
END IF;
END;