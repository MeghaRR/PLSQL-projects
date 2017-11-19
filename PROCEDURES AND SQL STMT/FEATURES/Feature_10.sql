create or replace PROCEDURE feature10(
    fd_conn_email_id IN VARCHAR2,
    fd_mem_email_id  IN VARCHAR2,
    reco_desc        IN VARCHAR2)
IS
  counter NUMBER;
  recommendation_counter number;
  
BEGIN
--Check whether user is a first degree connection or not
  SELECT COUNT(*)
  INTO counter
  FROM first_degree_connection
  WHERE CONNECTION_EMAIL_ID = fd_conn_email_id
  AND member_email_id = fd_mem_email_id;
  --Check whether has user has already recommended   
  SELECT COUNT(*)
  INTO recommendation_counter
  FROM recommendations
  WHERE RECOMMENDERS_EMAIL_ID = fd_mem_email_id
  AND RECEIVERS_EMAIL_ID = fd_conn_email_id;
   --Condition to allow user to recommend if he is a first degree connection and has never recommended
  IF (counter = 1 AND recommendation_counter!=1 )THEN
    INSERT
    INTO recommendations VALUES
      (
        mem_reco_id.nextval,
        fd_mem_email_id,
        fd_conn_email_id,
        reco_desc,
        sysdate,
        sysdate+interval '2' YEAR,
        'active'
      );
    --Condition to print if user has already recommended other user	    
  elsif(counter = 1 AND recommendation_counter = 1)THEN
    DBMS_OUTPUT.PUT_LINE(
    'User has already recommended cant recommend again');
 --Condition to print user is not a first degree connection      
  ELSE
    dbms_output.put_line('User '||fd_conn_email_id||
    ' is not a first degree connection of '||fd_mem_email_id);
  END IF;
EXCEPTION
WHEN no_data_found THEN
  dbms_output.put_line('Data not found');
END;