truncate table stg_txn_journal;
insert into stg_txn_journal select * from stg_txn_journal_2000_2016;

select count(*) from STG_TXN_JOURNAL;

-- Get Names and Keys
update STG_TXN_JOURNAL set
  -- Get Date_Key from appointment_date
  date_key = (select datekey from CALENDAR_DIM where datevalue = appointment_date)
;

update STG_TXN_JOURNAL set
  account_key = get_account_key(file_number, last_name, first_name, date_key)
;
  
/*
-- Populate the Visit table based on the distinct account_key/date_key combinations
insert into visit (visit_date_key, account_key) 
  select distinct date_key, account_key from stg_txn_journal;
*/

update STG_TXN_JOURNAL set
  -- Get Date_Key from appointment_date
  visit_key = get_visit_key(account_key, date_key)
;

-- Ensure all rows have date_key
select count(*) from STG_TXN_JOURNAL where date_key is null or account_key is null or visit_key is null;

--create table stg_invoice as 
truncate table stg_invoice_old;
--insert into stg_invoice_old select * From stg_txn_journal where transaction_type_code = 'I';
insert into invoice (invoice_number, tax_amount, total_amount, visit_key) 
  select line_item_code, line_item_unit_cost, line_item_amount, visit_key from stg_txn_journal where transaction_type_code='I';

/*
declare 

  invoiceTotal    number := 0;
  
begin

  for inv1 in (select invoice_number, visit_key from invoice) loop
  
    -- get the sum of transaction items
    select sum(line_item_amount) into invoiceTotal from stg_txn_journal t where upper(transaction_type_code) in ('I','S','T','X') and t.visit_key = inv1.visit_key;
    
    -- write the sum of transaction items to invoice
    update invoice set total_amount = invoiceTotal where invoice_number = inv1.invoice_number;
    
  end loop;
  
end;

update invoice i
  set total_amount = select sum(line_item_amount) from stg_txn_journal t 
  where upper(transaction_type_code) in ('I','S','T','X') and i.visit_key = t.visit_key
;
*/

delete from stg_txn_journal where transaction_type_code = 'I';

/*
select transaction_type_code, line_item_description, count(*) from stg_txn_journal 
  where transaction_type_code not in ('T','S','X')
  group by transaction_type_code, line_item_description order by count(*) desc;
*/
truncate table stg_payment;
insert into stg_payment select * From stg_txn_journal where upper(transaction_type_code) not in ('I','S','T','X');

--create table stg_payment as select * From stg_txn_journal where upper(transaction_type_code) not in ('I','S','T','X');
select count(*) from stg_payment;
delete from stg_txn_journal where transaction_type_code not in ('I','S','T','X');

select transaction_type_code, count(*) from stg_txn_journal group by transaction_type_code;

insert into visit_detail (visit_key, patient_name, seen_by, transaction_type_code, line_item_code, line_item_description, line_item_unit_cost, line_item_amount)
  select visit_key, patient_name, seen_by, transaction_type_code, line_item_code, line_item_description, line_item_unit_cost, line_item_amount  
  from stg_txn_journal where transaction_type_code in ('S','T','X');
commit;


/*
-- Populate account_key
declare   
  accountKey  integer := 0;

begin  

  for c1 in (select * from stg_txn_journal) loop
--    dbms_output.put_line(c1.file_number||','||c1.last_name||','||c1.first_name||','||c1.date_key);
    accountKey := get_account_key(c1.file_number, c1.last_name, c1.first_name, c1.date_key);
--    dbms_output.put_line('accountKey = '||accountKey);
    
  
  end loop;
end;

update STG_TXN_JOURNAL set
  account_key = get_account_key(file_number, last_name, first_name, date_key)
;

-- Populate the Visit table based on the distinct account_key/date_key combinations
insert into visit (visit_date_key, account_key) 
  select distinct date_key, account_key from stg_txn_journal;

-- commit all changes
commit;

end;

select  file_number, last_name, first_name, appointment_date, date_key, account_key, visit_key, transaction_type_code, 
        line_item_code, line_item_description, line_item_quantity, line_item_unit_cost, line_item_amount
  from  stg_txn_journal
  where visit_key is null
  ;


select transaction_type_code, line_item_description, count(*) from stg_invoice group by transaction_type_code, line_item_description order by count(*) desc;

truncate table stg_txn_journal;
create table stx_txn_journal_2000_2016 as select * From stg_txn_journal;

select file_number, last_name, first_name, count(*) from account acct group by file_number, last_name, first_name HAVING COUNT(*) >1;

select * from account where file_number=1338;
select distinct transaction_type_code from stg_txn_journal;
select sum(line_item_amount) from stg_txn_journal t where upper(transaction_type_code) in ('I','S','T','X') and t.visit_key = 103589
select * from stg_txn_journal where visit_key = 34889;

*/
