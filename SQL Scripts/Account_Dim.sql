--------------------------------------------------------
--  DDL for Sequence WVC_DIMENSION
--------------------------------------------------------
DROP SEQUENCE wvc_dimension;
CREATE SEQUENCE  "WVC"."WVC_DIMENSION"  MINVALUE 10001 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 16677 NOCACHE  ORDER  NOCYCLE ;

drop table account cascade constraints;
drop table visit;

--------------------------------------------------------
--  DDL for Table ACCOUNT
--------------------------------------------------------

  CREATE TABLE "WVC"."ACCOUNT" 
   (	"ACCOUNT_ID" NUMBER(*,0), 
	"START_DATE_KEY" NUMBER(*,0), 
	"END_DATE_KEY" NUMBER(*,0), 
	"FILE_NUMBER" NUMBER(*,0), 
	"LAST_NAME" VARCHAR2(50 BYTE), 
	"FIRST_NAME" VARCHAR2(50 BYTE), 
	"STREET_ADDRESS_LINE1" VARCHAR2(255 BYTE), 
	"STREET_ADDRESS_LINE2" VARCHAR2(255 BYTE), 
	"CITY" VARCHAR2(50 BYTE), 
	"STATE" VARCHAR2(2 BYTE), 
	"ZIP_CODE" VARCHAR2(10 BYTE), 
	"INSERT_USER" VARCHAR2(30 BYTE), 
	"INSERT_DATETIME" DATE, 
	"UPDATE_USER" VARCHAR2(30 BYTE), 
	"UPDATE_DATETIME" DATE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Index ACCOUNT_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "WVC"."ACCOUNT_PK" ON "WVC"."ACCOUNT" ("ACCOUNT_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Index ACCOUNT__UK
--------------------------------------------------------

  CREATE UNIQUE INDEX "WVC"."ACCOUNT__UK" ON "WVC"."ACCOUNT" ("FILE_NUMBER", "LAST_NAME", "FIRST_NAME") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  Constraints for Table ACCOUNT
--------------------------------------------------------

  ALTER TABLE "WVC"."ACCOUNT" ADD CONSTRAINT "ACCOUNT__UK" UNIQUE ("FILE_NUMBER", "LAST_NAME", "FIRST_NAME")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
  ALTER TABLE "WVC"."ACCOUNT" ADD CONSTRAINT "ACCOUNT_PK" PRIMARY KEY ("ACCOUNT_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
  ALTER TABLE "WVC"."ACCOUNT" MODIFY ("END_DATE_KEY" NOT NULL ENABLE);
  ALTER TABLE "WVC"."ACCOUNT" MODIFY ("START_DATE_KEY" NOT NULL ENABLE);
  ALTER TABLE "WVC"."ACCOUNT" MODIFY ("ACCOUNT_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Ref Constraints for Table ACCOUNT
--------------------------------------------------------

  ALTER TABLE "WVC"."ACCOUNT" ADD CONSTRAINT "ACCOUNT_ENDDATE_FK" FOREIGN KEY ("END_DATE_KEY")
	  REFERENCES "WVC"."CALENDAR_DIM" ("DATEKEY") ENABLE;
  ALTER TABLE "WVC"."ACCOUNT" ADD CONSTRAINT "ACCOUNT_STARTDT_FK" FOREIGN KEY ("START_DATE_KEY")
	  REFERENCES "WVC"."CALENDAR_DIM" ("DATEKEY") ENABLE;
--------------------------------------------------------
--  DDL for Trigger ACCOUNT_BI_TRG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "WVC"."ACCOUNT_BI_TRG" 
  BEFORE INSERT 
  ON account
  FOR EACH ROW
  -- Optionally restrict this trigger to fire only when really needed
   WHEN (new.account_id is null) DECLARE
  v_id account.account_id%TYPE;
BEGIN
  -- Select a new value from the sequence into a local variable. As David
  -- commented, this step is optional. You can directly select into :new.qname_id
  SELECT wvc_dimension.nextval INTO v_id FROM DUAL;

  -- :new references the record that you are about to insert into qname. Hence,
  -- you can overwrite the value of :new.qname_id (qname.qname_id) with the value
  -- obtained from your sequence, before inserting
  :new.account_id := v_id;
  :new.insert_user := USER;
  :new.insert_datetime := SYSDATE;
  
END account_bi_trg;
/
ALTER TRIGGER "WVC"."ACCOUNT_BI_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger ACCOUNT_BU_TRG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "WVC"."ACCOUNT_BU_TRG" 
  BEFORE UPDATE 
  ON account
  FOR EACH ROW

BEGIN

  :new.update_user := USER;
  :new.update_datetime := SYSDATE;
  
END account_bu_trg;
/
ALTER TRIGGER "WVC"."ACCOUNT_BU_TRG" ENABLE;

