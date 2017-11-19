create or replace PROCEDURE feature16(
    u_email_id IN VARCHAR2,
    u_password IN VARCHAR2,
    u_user_type in varchar2,
    u_time TIMESTAMP)
IS
--Cursor to select email and last login of member
  CURSOR c1
  IS
    SELECT email_id,
      last_login
    FROM users_profile
    WHERE type = 'M';
--Cursor declaration to select expiry_date and recommendation id of members
  CURSOR c2
  IS
    SELECT member_recommendation_id,expiry_date
    FROM recommendations;
    --Local variable declaration
  l_email_id users_profile.email_id%type;
  l_password users_profile.PASSWORD%type;
  l_user_type users_profile.type%type;
  output_var c1%rowtype;
  recommendation_var c2%rowtype;
  valid number;
  
BEGIN
  valid := feature0(u_email_id,u_password,u_user_type);

  IF(valid=1 and u_user_type = 'A')THEN
  --Set time to test time related features
    UPDATE CURRENT_TIME
    SET new_time = u_time;
    OPEN c1;
    LOOP
      FETCH c1
      INTO output_var;
      EXIT WHEN c1%notfound;
  --Condition to check the last login of user and set inactive 
      IF((trunc(extract(day from u_time - output_var.last_login)))>365)THEN
        UPDATE members_profile
        SET status = 'inactive'
        WHERE email_id = output_var.email_id;
      END IF;   
    END LOOP;
    DBMS_OUTPUT.PUT_line('Few Member''s status set to inactive');
    CLOSE c1;
 	
--Condition to check expired recommendation and update recommendation if expired 
    open c2;
    loop 
    fetch c2 into recommendation_var;
    if((trunc(extract(day from u_time-recommendation_var.expiry_date)))>1)then
    UPDATE recommendations
        SET RECOMMENDATIONS_STATUS = 'inactive'
        WHERE member_recommendation_id = recommendation_var.member_recommendation_id;
        END IF;
      EXIT
    WHEN c2%notfound;
    end loop;
    close c2;
    DBMS_OUTPUT.PUT_LINE('Few Recommendations set to inactive');
    --Logged in user is not admin    
  ELSE
    dbms_output.put_line('User is not an admin');
  END IF;
EXCEPTION
WHEN no_data_found THEN
  dbms_output.put_line('User data not found');
END;