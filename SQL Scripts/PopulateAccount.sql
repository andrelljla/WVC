
-- Prepare to build accounts from data in the stg_txn_journal table
-- Build t_account and t_dupFile based on txn_journal data 
drop table t_account;
create table t_account as 
  select distinct file_number, last_name, first_name, min(date_key) start_date_key, max(date_key) end_date_key 
  from stg_txn_journal group by file_number, last_name, first_name;
drop table t_dupFiles;
create table t_dupFiles as select file_number, count(*) num_dups 
  from t_account group by file_number 
  having count(*)>1;


-- Handle Start/End Dates
DECLARE
  
  -- Singleton account: New File_Number, not identified as a duplicate/reuse in stage, and not existing in ACCOUNT
  cursor  c_SingletonAccount is
            select file_number, last_name, first_name, start_date_key, end_date_key from t_account 
            -- Perform existince check on file_number/first_name/last_name in account
            where file_number||upper(trim(last_name))||upper(trim(first_name)) not in (select file_number||upper(last_name)||upper(first_name) from account);

  cursor  c_DuplicateFileInStage is
            select file_number from t_dupFiles;
            
  vEarliestStartDateKey integer := 0;
  vEarliestEndDateKey   integer := 0;
  vLatestStartDateKey   integer := 0;
  
BEGIN
  
  -- Process duplicate/reuse files in the staging table
  FOR dup in c_DuplicateFileInStage LOOP
  
    -- set the end date the new account in t_account associated with the file number to end-of-time
    update t_account ta set end_date_key = 39991231
      where ta.file_number = dup.file_number
      and ta.end_date_key = (select max(end_date_key) from t_account ta2 where ta2.file_number = dup.file_number);
      
  END LOOP;
  
  -- Reset end Dates for all non-duplicate accounts
  update t_account ta set end_date_key = 39991231 where ta.file_number not in (select file_number from t_dupFiles);

  -- Process new singletons 
  FOR acct IN c_SingletonAccount LOOP
      
    -- Write the account record
    --create_account_new_file_number(acct.file_number, acct.first_name, acct.last_name, acct.start_date_key);
    create_account_with_dates(acct.file_number, acct.first_name, acct.last_name, acct.start_date_key, acct.end_date_key);
    
    
    -- delete the transactional record
    delete from t_account where file_number = acct.file_number; 
    
  END LOOP;
  
END;
/

commit; 
drop table t_account;
drop table t_dupFiles;

