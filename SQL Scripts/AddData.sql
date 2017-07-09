-- delete the ZZZ rows
delete from WVC_TXNJRNL_IMPORT where action_cd = 'ZZZ';

/* Financial Transactions Types */
Insert into financial_txn_action_type (actn_cd, actn_descr)
  select distinct action_cd, item_desc from WVC_TXNJRNL_IMPORT
  where action_cd not in ('T','S','X')
  and action_cd not in (select distinct actn_cd from financial_txn_action_type);

/* Service Transaction Types */
--Insert into financial_txn_action_type (actn_cd, actn_descr) values ('S','Professional Service');
--Insert into financial_txn_action_type (actn_cd, actn_descr) values ('T','Taxable Item');
--Insert into financial_txn_action_type (actn_cd, actn_descr) values ('X','Miscellaneous Charge');

/* Account */
insert into account (file_num, frst_nm, last_nm, strt_dt_key, end_dt_key, last_actv_dt_key)
select distinct 
  to_number(file_num), 
  first_name, 
  last_name,
  min(date_key),
  39991231,
  max(date_key)
from WVC_TXNJRNL_IMPORT i
group by to_number(file_num), first_name, last_name
order by to_number(file_num), min(date_key)
;

-- Update reuse accounts end_date to last visit date 
update account acct set END_DT_KEY = 
(
  select max(date_key) from wvc_txnjrnl_import imp where imp.file_num = acct.file_num and imp.last_name = acct.last_nm
)
where acct.file_num in 
  (select file_num from account group by file_num having count(*) >1)
;

/*  View reuse accounts
select * from account where file_num in (select file_num from account group by file_num having count(*) >1) order by file_num;
*/

-- Update newer reuse account end_date back to end-of-time
update account set end_dt_key = 39991231
where acct_id in 
(
select acct_id from account a1 
  where file_num in (select file_num from account group by file_num having count(*) >1)
  and strt_dt_key = (select max(strt_dt_key) from account a3 where a1.file_num = a3.file_num)
)
;

/* One-off historical cleanup
select * from wvc_txnjrnl_import where file_num = 784;
select * from account where file_num = 784;
update account set end_dt_key = last_actv_dt_key where acct_id = 725;
*/

/* populate invoice_transactions table */ 
insert into invoice_transaction (acct_id, date_key, fincl_txn_actn_id, invc_num, invc_tax_amt, invc_amt)
  select  
          acct.acct_id,
 --         i1.file_num,
          to_number(i1.date_key),
          ftat.FINCL_TXN_ACTN_ID,
          i1.item_cd, 
          to_number(i1.tax_amt),
          to_number(i1.total_amt)
  from WVC_TXNJRNL_IMPORT i1, account acct, FINANCIAL_TXN_ACTION_TYPE ftat
  where i1.file_num = acct.file_num
  and i1.date_key between acct.strt_dt_key and acct.end_dt_key
  and i1.action_cd = ftat.actn_cd
  and i1.action_cd = 'I'
  and i1.date_key > (select max(last_loaded_date_key) from txn_load_history)
  order by i1.date_key, i1.file_num
  ;

/* populate financial_transaction table */ 
insert into financial_transaction (acct_id, date_key, fincl_txn_actn_id, fincl_txn_amt, fincl_txn_cmnt)
  select  
          acct.acct_id,
          to_number(i1.date_key),
          ftat.FINCL_TXN_ACTN_ID,
          to_number(i1.total_amt),
          i1.item_desc
  from WVC_TXNJRNL_IMPORT i1, account acct, FINANCIAL_TXN_ACTION_TYPE ftat
  where i1.file_num = acct.file_num
  and i1.date_key between acct.strt_dt_key and acct.end_dt_key
  and i1.action_cd = ftat.actn_cd
  and i1.action_cd not in ('I','S','T','X')
  and i1.date_key > (select max(last_loaded_date_key) from txn_load_history)
  order by i1.date_key, i1.file_num
  ;

/* populate service_transactions table */
/*
insert into service_transaction (acct_id, patient_id, date_key, srvc_txn_actn_id, srvc_line_asgnmt, patient_nm, line_item_qty, line_item_prc, lime_item_amt)
  select  
          acct.acct_id,
          p.patient_id,
          to_number(i1.date_key),
          stat.SRVC_TXN_ACTN_ID,
          null, --- ????
          p.patient_nm,
          i1.item_qty,
          i1.expense_amt,
          i1.total_amt
  from WVC_TXNJRNL_IMPORT i1, account acct, SERVICE_TXN_ACTION_TYPE stat, patient p, account_patient ap
  where i1.file_num = acct.file_num
  and i1.date_key between acct.strt_dt_key and acct.end_dt_key
  and i1.action_cd = stat.actn_cd
  and i1.action_cd in ('S','T','X')
  and i1.patient_name = P.PATIENT_NM
  and acct.acct_id = ap.acct_id
--  and i1.date_key > (select max(last_loaded_date_key) from txn_load_history)
  order by i1.date_key, i1.file_num
  ;
*/

/* Log the update */
insert into txn_load_history (clinic_cd, load_dtm, last_loaded_date_key) values ('WVC',sysdate, (select max(date_key) from wvc_txnjrnl_import));
commit;
