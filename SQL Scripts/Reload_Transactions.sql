-- create empty import table
create table wvc_txnjrnl_import as select * from wvc_txnjrnl_import_2000_201701 where 1=0;

-- delete from the history import table the period to be reloaded
delete from WVC_TXNJRNL_IMPORT_2000_201701
where date_key in (select datekey from calendar_dim where year=2016 and monthofyear=6);

-- delete the invoice transactions for the period to be reloaded
delete from invoice_transaction 
where date_key in (select datekey from calendar_dim where year=2016 and monthofyear=6);

-- delete the financial transactions for the period to be reloaded
delete from financial_transaction 
where date_key in (select datekey from calendar_dim where year=2016 and monthofyear=6);

-- delete the service transactions for the period to be reloaded
delete from service_transaction 
where date_key in (select datekey from calendar_dim where year=2016 and monthofyear=6);

commit;

