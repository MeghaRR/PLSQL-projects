create or replace PROCEDURE feature2(u_email_id in varchar2,u_password in varchar2,u_type varchar2)
      IS
      l_email_id users_profile.email_id%type;
      l_password users_profile.PASSWORD%type;
      l_last_login users_profile.LAST_LOGIN%type;
      l_user_type users_profile.type%type;
      l_status members_profile.status%type;
      BEGIN
      
      --Query to validate the user
      
      select email_id,password,type into l_email_id,l_password,l_user_type 
      from users_profile 
      where email_id = u_email_id and password = u_password; 
    
        --Condition to check whether the user is a member or an admin
    
      if (lower(l_user_type) = 'm')then
      select mp.status into l_status 
      from users_profile up,MEMBERS_PROFILE mp
      where up.email_id = u_email_id and up.password = u_password and mp.EMAIL_ID = u_email_id;
       --Check the status of user if user is inactive then print inactive status else update the login time
            if (lower(l_status)!='active')then
            dbms_output.put_line('Member '||l_email_id||' is inactive');
          else
      --Set admin's last login
          update users_profile set last_login = sysdate where email_id = l_email_id;
          dbms_output.put_line('Member successfully logged in');
          end if;
      else
          update users_profile set last_login = sysdate where email_id = l_email_id;
          dbms_output.put_line('Admin successfully logged in');
      end if;    
          exception
          when no_data_found then
          dbms_output.put_line('User data not found');
      END;