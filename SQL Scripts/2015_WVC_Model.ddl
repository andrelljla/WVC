-- Generated by Oracle SQL Developer Data Modeler 4.1.3.901
--   at:        2017-02-15 09:11:37 CST
--   site:      Oracle Database 11g
--   type:      Oracle Database 11g




CREATE TABLE WVC.ACCOUNT
  (
    ACCT_ID          NUMBER (*,0) NOT NULL ,
    FILE_NUM         NUMBER (*,0) ,
    FULL_NM          VARCHAR2 (100 CHAR) ,
    FRST_NM          VARCHAR2 (30 BYTE) ,
    LAST_NM          VARCHAR2 (30 CHAR) ,
    STRT_DT_KEY      NUMBER (*,0) ,
    END_DT_KEY       NUMBER (*,0) ,
    LAST_ACTV_DT_KEY NUMBER (*,0) ,
    STRT_DT          DATE ,
    END_DT           DATE ,
    LAST_ACTV_DT     DATE
  ) ;
CREATE UNIQUE INDEX WVC.ACCT_PK ON WVC.ACCOUNT
  (
    ACCT_ID ASC
  )
  ;
ALTER TABLE WVC.ACCOUNT ADD CONSTRAINT ACCT_PK PRIMARY KEY ( ACCT_ID ) ;


CREATE TABLE WVC.ACCOUNT_PATIENT
  (
    ACCT_ID    NUMBER (*,0) NOT NULL ,
    PATIENT_ID NUMBER (*,0) NOT NULL
  ) ;
CREATE UNIQUE INDEX WVC.ACCOUNT_PATIENT_PK ON WVC.ACCOUNT_PATIENT
  (
    ACCT_ID ASC , PATIENT_ID ASC
  )
  ;
ALTER TABLE WVC.ACCOUNT_PATIENT ADD CONSTRAINT ACCOUNT_PATIENT_PK PRIMARY KEY ( ACCT_ID, PATIENT_ID ) ;


CREATE TABLE WVC.CALENDAR_DIM
  (
    DATEKEY             NUMBER (*,0) NOT NULL ,
    DATECOMMENT         VARCHAR2 (255 BYTE) ,
    DATEVALUE           DATE NOT NULL ,
    DAY                 VARCHAR2 (10 BYTE) ,
    DAYOFWEEK           NUMBER (*,0) ,
    DAYOFMONTH          NUMBER (*,0) ,
    DAYOFYEAR           NUMBER (*,0) ,
    PREVIOUSDAY         DATE ,
    NEXTDAY             DATE ,
    WEEKOFYEAR          NUMBER (*,0) ,
    MONTH               VARCHAR2 (10 BYTE) ,
    SHORTMONTH          VARCHAR2 (5 BYTE) ,
    MONTHOFYEAR         NUMBER (*,0) ,
    QUARTEROFYEAR       NUMBER (*,0) ,
    YEAR                NUMBER (*,0) ,
    YEARMONTH_NUM       NUMBER (*,0) ,
    YEARMONTH_CHAR      VARCHAR2 (6 BYTE) ,
    MONTHYEAR_CHAR      VARCHAR2 (6 BYTE) ,
    MM_YEAR             VARCHAR2 (7 BYTE) ,
    MONTH_AGO_DATEKEY   NUMBER (*,0) ,
    YEAR_AGO_DATEKEY    NUMBER (*,0) ,
    DAYS_SINCE_19000101 NUMBER (*,0) ,
    DD_MON              VARCHAR2 (6 BYTE)
  ) ;
CREATE INDEX WVC.CALENDAR_DOMMOY_IX3 ON WVC.CALENDAR_DIM
  (
    DAYOFMONTH ASC ,
    MONTHOFYEAR ASC
  ) ;
CREATE INDEX WVC.CALENDAR_DOM_IX2 ON WVC.CALENDAR_DIM
  ( DAYOFMONTH ASC
  ) ;
CREATE INDEX WVC.CALENDAR_DOY_IX1 ON WVC.CALENDAR_DIM
  ( DAYOFYEAR ASC
  ) ;
CREATE UNIQUE INDEX WVC.CALENDAR_PK ON WVC.CALENDAR_DIM
  (
    DATEKEY ASC
  )
  ;
ALTER TABLE WVC.CALENDAR_DIM ADD CONSTRAINT CALENDAR_PK PRIMARY KEY ( DATEKEY ) ;


CREATE TABLE WVC.FINANCIAL_TRANSACTION
  (
    FINCL_TXN_ID      NUMBER (*,0) NOT NULL ,
    ACCT_ID           NUMBER (*,0) NOT NULL ,
    DATE_KEY          NUMBER (*,0) NOT NULL ,
    FINCL_TXN_ACTN_ID NUMBER (*,0) NOT NULL ,
    FINCL_TXN_AMT     NUMBER (12,5) ,
    FINCL_TXN_CMNT    VARCHAR2 (255 BYTE)
  ) ;
CREATE UNIQUE INDEX WVC.FINCL_TXN_PK ON WVC.FINANCIAL_TRANSACTION
  (
    FINCL_TXN_ID ASC
  )
  ;
ALTER TABLE WVC.FINANCIAL_TRANSACTION ADD CONSTRAINT FINCL_TXN_PK PRIMARY KEY ( FINCL_TXN_ID ) ;


CREATE TABLE WVC.FINANCIAL_TXN_ACTION_TYPE
  (
    FINCL_TXN_ACTN_ID NUMBER (*,0) NOT NULL ,
    ACTN_CD           VARCHAR2 (10 CHAR) ,
    ACTN_DESCR        VARCHAR2 (255 CHAR)
  ) ;
CREATE UNIQUE INDEX WVC.FINCL_TXN_ACTN_TYP_PK ON WVC.FINANCIAL_TXN_ACTION_TYPE
  (
    FINCL_TXN_ACTN_ID ASC
  )
  ;
CREATE UNIQUE INDEX WVC.FNCL_TXN_ACTN_TYP_UK ON WVC.FINANCIAL_TXN_ACTION_TYPE
  (
    ACTN_CD ASC , ACTN_DESCR ASC
  )
  ;
ALTER TABLE WVC.FINANCIAL_TXN_ACTION_TYPE ADD CONSTRAINT FINCL_TXN_ACTN_TYP_PK PRIMARY KEY ( FINCL_TXN_ACTN_ID ) ;
ALTER TABLE WVC.FINANCIAL_TXN_ACTION_TYPE ADD CONSTRAINT FNCL_TXN_ACTN_TYP_UK UNIQUE ( ACTN_CD , ACTN_DESCR ) ;


CREATE TABLE WVC.IMPORT_200001_201512
  (
    CLNT_NM           VARCHAR2 (100 BYTE) ,
    TRNS_CR           VARCHAR2 (5 BYTE) ,
    PATIENT_NM        VARCHAR2 (100 BYTE) ,
    SRVC_CD           VARCHAR2 (10 CHAR) ,
    DESCR             VARCHAR2 (255 CHAR) ,
    QTY               VARCHAR2 (10 BYTE) ,
    EXPEN             NUMBER ,
    AMT               NUMBER ,
    ACTN_CD           VARCHAR2 (10 CHAR) ,
    DATE_KEY          NUMBER ,
    FILE_NUM          VARCHAR2 (10 BYTE) ,
    FULL_NM           VARCHAR2 (100 CHAR) ,
    FRST_NM           VARCHAR2 (30 BYTE) ,
    LAST_NM           VARCHAR2 (30 CHAR) ,
    ACCT_ID           NUMBER (*,0) ,
    FINCL_TXN_ACTN_ID NUMBER (*,0) ,
    SRVC_TXN_ACTN_ID  NUMBER (*,0)
  ) ;


CREATE TABLE WVC.INVOICE_TRANSACTION
  (
    INVC_TXN_ID       NUMBER (*,0) NOT NULL ,
    ACCT_ID           NUMBER (*,0) ,
    DATE_KEY          NUMBER (*,0) ,
    FINCL_TXN_ACTN_ID NUMBER (*,0) ,
    INVC_NUM          NUMBER (*,0) ,
    INVC_TAX_AMT      NUMBER (12,5) ,
    INVC_AMT          NUMBER (12,5)
  ) ;
CREATE UNIQUE INDEX WVC.INVC_TXN_PK ON WVC.INVOICE_TRANSACTION
  (
    INVC_TXN_ID ASC
  )
  ;
ALTER TABLE WVC.INVOICE_TRANSACTION ADD CONSTRAINT INVC_TXN_PK PRIMARY KEY ( INVC_TXN_ID ) ;


CREATE TABLE WVC.MV_INVOICE_ANALYSIS_DAILY_HIST
  (
    DATE_KEY          NUMBER (*,0) NOT NULL ,
    TRANSACTION_DT    DATE NOT NULL ,
    DAY               VARCHAR2 (10 BYTE) ,
    DAY_OF_MONTH      NUMBER (*,0) ,
    DAY_OF_YEAR       NUMBER (*,0) ,
    MONTH             VARCHAR2 (10 BYTE) ,
    YEAR              NUMBER (*,0) ,
    YEAR_AGO_DATEKEY  NUMBER (*,0) ,
    WEEK_OF_YEAR      NUMBER (*,0) ,
    INVOICE_AMOUNT    NUMBER ,
    YTD_INVOICE_TOTAL NUMBER
  ) ;


CREATE TABLE WVC.PATIENT
  (
    PATIENT_ID NUMBER (*,0) NOT NULL ,
    BREED_ID   NUMBER (*,0) NOT NULL ,
    PATIENT_NM VARCHAR2 (100 CHAR) ,
    BIRTH_DT   DATE ,
    DECSD_DT   DATE
  ) ;
CREATE UNIQUE INDEX WVC.PATIENT_PK ON WVC.PATIENT
  (
    PATIENT_ID ASC
  )
  ;
ALTER TABLE WVC.PATIENT ADD CONSTRAINT PATIENT_PK PRIMARY KEY ( PATIENT_ID ) ;


CREATE TABLE WVC.SERVICE_TRANSACTION
  (
    SRVC_TXN_ID      NUMBER (*,0) NOT NULL ,
    ACCT_ID          NUMBER (*,0) NOT NULL ,
    PATIENT_ID       NUMBER (*,0) ,
    DATE_KEY         NUMBER (*,0) NOT NULL ,
    SRVC_TXN_ACTN_ID NUMBER (*,0) NOT NULL ,
    SRVC_LINE_ASGNMT VARCHAR2 (10 BYTE) ,
    PATIENT_NM       VARCHAR2 (30 BYTE) ,
    LINE_ITEM_QTY    NUMBER (10,3) ,
    LINE_ITEM_PRC    NUMBER (10,3) ,
    LINE_ITEM_AMT    NUMBER (12,5)
  ) ;
CREATE UNIQUE INDEX WVC.SRVC_TXN_PK ON WVC.SERVICE_TRANSACTION
  (
    SRVC_TXN_ID ASC
  )
  ;
ALTER TABLE WVC.SERVICE_TRANSACTION ADD CONSTRAINT SRVC_TXN_PK PRIMARY KEY ( SRVC_TXN_ID ) ;


CREATE TABLE WVC.SERVICE_TXN_ACTION_TYPE
  (
    SRVC_TXN_ACTN_ID NUMBER (*,0) NOT NULL ,
    ACTN_CD          VARCHAR2 (10 CHAR) ,
    ACTN_DESCR       VARCHAR2 (255 CHAR)
  ) ;
CREATE UNIQUE INDEX WVC.SRVC_TXN_ACTN_TYP_PK ON WVC.SERVICE_TXN_ACTION_TYPE
  (
    SRVC_TXN_ACTN_ID ASC
  )
  ;
CREATE UNIQUE INDEX WVC.SRVC_TXN_ACTN_TYP_UK ON WVC.SERVICE_TXN_ACTION_TYPE
  (
    ACTN_CD ASC , ACTN_DESCR ASC
  )
  ;
ALTER TABLE WVC.SERVICE_TXN_ACTION_TYPE ADD CONSTRAINT SRVC_TXN_ACTN_TYP_PK PRIMARY KEY ( SRVC_TXN_ACTN_ID ) ;
ALTER TABLE WVC.SERVICE_TXN_ACTION_TYPE ADD CONSTRAINT SRVC_TXN_ACTN_TYP_UK UNIQUE ( ACTN_CD , ACTN_DESCR ) ;


CREATE TABLE WVC.SPECIES_BREED
  (
    BREED_ID  NUMBER (*,0) NOT NULL ,
    SPECIE_CD VARCHAR2 (10 CHAR) ,
    BREED_CD  VARCHAR2 (10 CHAR) ,
    DESCR     VARCHAR2 (255 CHAR)
  ) ;
CREATE UNIQUE INDEX WVC.BREED_PK ON WVC.SPECIES_BREED
  (
    BREED_ID ASC
  )
  ;
ALTER TABLE WVC.SPECIES_BREED ADD CONSTRAINT BREED_PK PRIMARY KEY ( BREED_ID ) ;


CREATE TABLE WVC.STG_IMPORT
  (
    CLNT_NM           VARCHAR2 (100 BYTE) ,
    SRVC_LN_ASGNMT    VARCHAR2 (5 BYTE) ,
    PATIENT_NM        VARCHAR2 (100 BYTE) ,
    SRVC_CD           VARCHAR2 (10 CHAR) ,
    DESCR             VARCHAR2 (255 CHAR) ,
    QTY               VARCHAR2 (10 BYTE) ,
    EXPEN             NUMBER ,
    AMT               NUMBER ,
    ACTN_CD           VARCHAR2 (10 CHAR) ,
    DATE_KEY          NUMBER ,
    FILE_NUM          VARCHAR2 (10 BYTE) ,
    FULL_NM           VARCHAR2 (100 CHAR) ,
    FRST_NM           VARCHAR2 (30 BYTE) ,
    LAST_NM           VARCHAR2 (30 CHAR) ,
    ACCT_ID           NUMBER (*,0) ,
    FINCL_TXN_ACTN_ID NUMBER (*,0) ,
    SRVC_TXN_ACTN_ID  NUMBER (*,0)
  ) ;


ALTER TABLE WVC.ACCOUNT_PATIENT ADD CONSTRAINT ACCT_PATIENT_ACCT_FK FOREIGN KEY ( ACCT_ID ) REFERENCES WVC.ACCOUNT ( ACCT_ID ) ;

ALTER TABLE WVC.ACCOUNT_PATIENT ADD CONSTRAINT ACCT_PATIENT_PATIENT_FK FOREIGN KEY ( PATIENT_ID ) REFERENCES WVC.PATIENT ( PATIENT_ID ) ;

ALTER TABLE WVC.FINANCIAL_TRANSACTION ADD CONSTRAINT FINCL_TXN_ACCT_FK FOREIGN KEY ( ACCT_ID ) REFERENCES WVC.ACCOUNT ( ACCT_ID ) ;

ALTER TABLE WVC.FINANCIAL_TRANSACTION ADD CONSTRAINT FINCL_TXN_ACTN_TYP_FK FOREIGN KEY ( FINCL_TXN_ACTN_ID ) REFERENCES WVC.FINANCIAL_TXN_ACTION_TYPE ( FINCL_TXN_ACTN_ID ) ;

ALTER TABLE WVC.FINANCIAL_TRANSACTION ADD CONSTRAINT FINCL_TXN_DATEDIM_FK FOREIGN KEY ( DATE_KEY ) REFERENCES WVC.CALENDAR_DIM ( DATEKEY ) ;

ALTER TABLE WVC.INVOICE_TRANSACTION ADD CONSTRAINT INVC_TXN_ACCT_FK FOREIGN KEY ( ACCT_ID ) REFERENCES WVC.ACCOUNT ( ACCT_ID ) ;

ALTER TABLE WVC.INVOICE_TRANSACTION ADD CONSTRAINT INVC_TXN_ACTN_TYP_FK FOREIGN KEY ( FINCL_TXN_ACTN_ID ) REFERENCES WVC.FINANCIAL_TXN_ACTION_TYPE ( FINCL_TXN_ACTN_ID ) ;

ALTER TABLE WVC.INVOICE_TRANSACTION ADD CONSTRAINT INVC_TXN_DATEDIM_FK FOREIGN KEY ( DATE_KEY ) REFERENCES WVC.CALENDAR_DIM ( DATEKEY ) ;

ALTER TABLE WVC.PATIENT ADD CONSTRAINT PATIENT_BREED_FK FOREIGN KEY ( BREED_ID ) REFERENCES WVC.SPECIES_BREED ( BREED_ID ) ;

ALTER TABLE WVC.SERVICE_TRANSACTION ADD CONSTRAINT SRVC_TXN_ACCT_PATIENT_FK FOREIGN KEY ( ACCT_ID, PATIENT_ID ) REFERENCES WVC.ACCOUNT_PATIENT ( ACCT_ID, PATIENT_ID ) ;

ALTER TABLE WVC.SERVICE_TRANSACTION ADD CONSTRAINT SRVC_TXN_ACTN_TYP_FK FOREIGN KEY ( SRVC_TXN_ACTN_ID ) REFERENCES WVC.SERVICE_TXN_ACTION_TYPE ( SRVC_TXN_ACTN_ID ) ;

ALTER TABLE WVC.SERVICE_TRANSACTION ADD CONSTRAINT SRVC_TXN_DATEDIM_FK FOREIGN KEY ( DATE_KEY ) REFERENCES WVC.CALENDAR_DIM ( DATEKEY ) ;

CREATE OR REPLACE VIEW WVC.V_FINANCIAL_TRANSACTION_RPT ( ACCOUNT_ID, FILE_NUMBER, LAST_NAME, FIRST_NAME, TRANSACTION_DT, TRANSACTION_AMOUNT ) AS
select  a.acct_id account_id
        , a.file_num file_number
        , a.last_nm last_name
        , a.frst_nm first_name
        , c.datevalue transaction_dt
        , f.fincl_txn_amt transaction_amount
    from  financial_transaction f
        , account a
        , calendar_dim c
        , financial_txn_action_type ft
    where a.acct_id = f.acct_id
    and f.date_key = c.datekey
    and f.fincl_txn_actn_id = ft.fincl_txn_actn_id 
;





CREATE OR REPLACE VIEW WVC.V_INVOICE_ANALYTICS_DAILY ( DATE_KEY, TRANSACTION_DT, DAY, DAY_OF_WEEK, DAY_OF_MONTH, DAY_OF_YEAR, MONTH, YEAR, YEAR_AGO_DATEKEY, WEEK_OF_YEAR, INVOICE_AMOUNT, YTD_INVOICE_TOTAL ) AS
select  c.datekey date_key
      , c.datevalue transaction_dt
      , c.day day
      , c.dayofweek day_of_week
      , c.dayofmonth day_of_month
      , c.dayofyear day_of_year
      , c.month month
      , c.year
      , c.year_ago_datekey
      , c.weekofyear week_of_year
      , sum(i.invc_amt) invoice_amount
      , (select sum(i1.invc_amt) 
          from invoice_transaction i1 
          where i1.date_key in 
          (
            select datekey from calendar_dim c1 where c1.datekey <= c.datekey and c.year = c1.year
          )
        ) ytd_invoice_total
  from  invoice_transaction i
      , account a
      , calendar_dim c
      , financial_txn_action_type ft
  where a.acct_id = i.acct_id
  and i.date_key = c.datekey
  and i.fincl_txn_actn_id = ft.fincl_txn_actn_id
  group by c.datekey 
      , c.datevalue 
      , c.day
      , c.dayofweek
      , c.dayofmonth 
      , c.dayofyear 
      , c.month 
      , c.monthofyear
      , c.year
      , c.year_ago_datekey
      , c.weekofyear 
;





CREATE OR REPLACE VIEW WVC.V_INVOICE_ANALYTICS_DETAIL ( ACCOUNT_ID, FILE_NUMBER, LAST_NAME, FIRST_NAME, DATE_KEY, TRANSACTION_DT, DAY, DAY_OF_WEEK, DAY_OF_MONTH, DAY_OF_YEAR, MONTH, MONTH_OF_YEAR, YEAR, YEAR_AGO_DATEKEY, WEEK_OF_YEAR, INVOICE_AMOUNT ) AS
select  a.acct_id account_id
      , a.file_num file_number
      , a.last_nm last_name
      , a.frst_nm first_name
      , c.datekey date_key
      , c.datevalue transaction_dt
      , c.day day
      , c.dayofweek day_of_week
      , c.dayofmonth day_of_month
      , c.dayofyear day_of_year
      , c.month month
      , c.monthofyear month_of_year
      , c.year
      , c.year_ago_datekey
      , c.weekofyear week_of_year
      , i.invc_amt invoice_amount
  from  invoice_transaction i
      , account a
      , calendar_dim c
      , financial_txn_action_type ft
  where a.acct_id = i.acct_id
  and i.date_key = c.datekey
  and i.fincl_txn_actn_id = ft.fincl_txn_actn_id 
;





CREATE OR REPLACE VIEW WVC.V_INVOICE_TRANSACTION_RPT ( ACCOUNT_ID, FILE_NUMBER, LAST_NAME, FIRST_NAME, TRANSACTION_DT, INVOICE_NUMBER, TAXABLE_AMOUNT, INVOICE_AMOUNT ) AS
select  a.acct_id account_id
        , a.file_num file_number
        , a.last_nm last_name
        , a.frst_nm first_name
        , c.datevalue transaction_dt
        , i.invc_num invoice_number
        , i.invc_tax_amt taxable_amount
        , i.invc_amt invoice_amount
    from  invoice_transaction i
        , account a
        , calendar_dim c
        , financial_txn_action_type ft
    where a.acct_id = i.acct_id
    and i.date_key = c.datekey
    and i.fincl_txn_actn_id = ft.fincl_txn_actn_id 
;





CREATE SEQUENCE WVC.seq_codes START WITH 1 NOCACHE ORDER ;
CREATE OR REPLACE TRIGGER WVC.TRG_BI_ACCOUNT BEFORE
  INSERT ON WVC.ACCOUNT FOR EACH ROW WHEN (NEW.ACCT_ID IS NULL) BEGIN :NEW.ACCT_ID := WVC.seq_codes.NEXTVAL;
END;
/

CREATE SEQUENCE WVC.seq_transaction START WITH 1 NOCACHE ORDER ;
CREATE OR REPLACE TRIGGER WVC.TRG_BI_FINCL_TXN BEFORE
  INSERT ON WVC.FINANCIAL_TRANSACTION FOR EACH ROW WHEN (NEW.FINCL_TXN_ID IS NULL) BEGIN :NEW.FINCL_TXN_ID := WVC.seq_transaction.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER WVC.TRG_BI_FINCL_TXN_ACTN_TYP BEFORE
  INSERT ON WVC.FINANCIAL_TXN_ACTION_TYPE FOR EACH ROW WHEN (NEW.FINCL_TXN_ACTN_ID IS NULL) BEGIN :NEW.FINCL_TXN_ACTN_ID := WVC.seq_codes.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER WVC.TRG_BI_INVC_TXN BEFORE
  INSERT ON WVC.INVOICE_TRANSACTION FOR EACH ROW WHEN (NEW.INVC_TXN_ID IS NULL) BEGIN :NEW.INVC_TXN_ID := WVC.seq_transaction.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER WVC.TRG_BI_SRVC_TXN BEFORE
  INSERT ON WVC.SERVICE_TRANSACTION FOR EACH ROW WHEN (NEW.SRVC_TXN_ID IS NULL) BEGIN :NEW.SRVC_TXN_ID := WVC.seq_transaction.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER WVC.TRG_BI_SRVC_TXN_ACTN_TYP BEFORE
  INSERT ON WVC.SERVICE_TXN_ACTION_TYPE FOR EACH ROW WHEN (NEW.SRVC_TXN_ACTN_ID IS NULL) BEGIN :NEW.SRVC_TXN_ACTN_ID := WVC.seq_codes.NEXTVAL;
END;
/


-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                            13
-- CREATE INDEX                            15
-- ALTER TABLE                             24
-- CREATE VIEW                              4
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           6
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          2
-- CREATE MATERIALIZED VIEW                 0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0

