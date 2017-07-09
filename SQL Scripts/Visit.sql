
CREATE TABLE Visit
  (
    Visit_ID        INTEGER NOT NULL ,
    Visit_Date_Key  INTEGER NOT NULL ,
    Account_Key     INTEGER NOT NULL ,
    Insert_User     VARCHAR2 (30) ,
    Insert_DateTime DATE ,
    Update_User     VARCHAR2 (30) ,
    Update_DateTime DATE
  ) ;
ALTER TABLE Visit ADD CONSTRAINT Visit_PK PRIMARY KEY ( Visit_ID ) ;
ALTER TABLE Visit ADD CONSTRAINT Visit_UK UNIQUE ( Visit_Date_Key , Account_Key ) ;
ALTER TABLE Visit ADD CONSTRAINT Visit_Account_FK FOREIGN KEY ( Account_Key ) REFERENCES Account ( Account_ID ) ;
ALTER TABLE Visit ADD CONSTRAINT Visit_Calendar_FK FOREIGN KEY ( Visit_Date_Key ) REFERENCES WVC.CALENDAR_DIM ( DATEKEY ) ;

  CREATE OR REPLACE TRIGGER "WVC"."VISIT_BI_TRG" 
  BEFORE INSERT 
  ON visit
  FOR EACH ROW
  -- Optionally restrict this trigger to fire only when really needed
   WHEN (new.visit_id is null) DECLARE
  v_id visit.visit_id%TYPE;
BEGIN
  -- Select a new value from the sequence into a local variable. As David
  -- commented, this step is optional. You can directly select into :new.qname_id
  SELECT wvc_dimension.nextval INTO v_id FROM DUAL;

  -- :new references the record that you are about to insert into qname. Hence,
  -- you can overwrite the value of :new.qname_id (qname.qname_id) with the value
  -- obtained from your sequence, before inserting
  :new.visit_id := v_id;
  :new.insert_user := USER;
  :new.insert_datetime := SYSDATE;
  
END visit_bi_trg;
/
ALTER TRIGGER "WVC"."VISIT_BI_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger ACCOUNT_BU_TRG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "WVC"."VISIT_BU_TRG" 
  BEFORE UPDATE 
  ON visit
  FOR EACH ROW

BEGIN

  :new.update_user := USER;
  :new.update_datetime := SYSDATE;
  
END visit_bu_trg;
/
ALTER TRIGGER "WVC"."VISIT_BU_TRG" ENABLE;

