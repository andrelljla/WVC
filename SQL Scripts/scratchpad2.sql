select new_accounts_in_daterange(20160101,20161231) as newAccounts from dual;
select new_accounts_last_n_days(554) as newAccounts from dual;

select sysdate-10 from dual;

select sysdate-554 from dual;
select datekey, year_ago_datekey, to_number(year-1 ||'0101') /*into today_datekey, lastYear_datekey, lastYearStart_datekey*/ from calendar_dim where datevalue = to_char(sysdate,'mm/dd/yyyy');
select new_accounts_yoytd from dual;

create table stg_txn_journal_2000_2016 as select * from stg_txn_journal;
truncate table stg_txn_journal;

CREATE TYPE customer_typ_demo AS OBJECT
    ( customer_id        NUMBER(6)
    , cust_first_name    VARCHAR2(20)
    , cust_last_name     VARCHAR2(20)
    , cust_address       CUST_ADDRESS_TYP
    , phone_numbers      PHONE_LIST_TYP
    , nls_language       VARCHAR2(3)
    , nls_territory      VARCHAR2(30)
    , credit_limit       NUMBER(9,2)
    , cust_email         VARCHAR2(30)
    , cust_orders        ORDER_LIST_TYP
    ) ;
    
Create or replace type TYP_New_Accounts_YOYTD as object
(
    newAccountsThisYearToDate   integer
  , newAccountsPriorYearToDate  integer
  , newAccountsDelta            integer
  , today_datekey               integer
  , lastYear_datekey            integer
  , thisYearStart_datekey       integer
  , lastYearStart_datekey       integer
);

CREATE TYPE address_t AS OBJECT
  EXTERNAL NAME 'Examples.Address' LANGUAGE JAVA 
  USING SQLData(
    street_attr varchar(250) EXTERNAL NAME 'street',
    city_attr varchar(50) EXTERNAL NAME 'city',
    state varchar(50) EXTERNAL NAME 'state',
    zip_code_attr number EXTERNAL NAME 'zipCode',
    STATIC FUNCTION recom_width RETURN NUMBER
      EXTERNAL VARIABLE NAME 'recommendedWidth',
    STATIC FUNCTION create_address RETURN address_t
      EXTERNAL NAME 'create() return Examples.Address',
    STATIC FUNCTION construct RETURN address_t
      EXTERNAL NAME 'create() return Examples.Address',
    STATIC FUNCTION create_address (street VARCHAR, city VARCHAR, 
        state VARCHAR, zip NUMBER) RETURN address_t
      EXTERNAL NAME 'create (java.lang.String, java.lang.String, java.lang.String, int) return Examples.Address',
    STATIC FUNCTION construct (street VARCHAR, city VARCHAR, 
        state VARCHAR, zip NUMBER) RETURN address_t
      EXTERNAL NAME 
        'create (java.lang.String, java.lang.String, java.lang.String, int) return Examples.Address',
    MEMBER FUNCTION to_string RETURN VARCHAR
      EXTERNAL NAME 'tojava.lang.String() return java.lang.String',
    MEMBER FUNCTION strip RETURN SELF AS RESULT 
      EXTERNAL NAME 'removeLeadingBlanks () return Examples.Address'
  ) NOT FINAL;
/

CREATE OR REPLACE TYPE long_address_t
UNDER address_t
EXTERNAL NAME 'Examples.LongAddress' LANGUAGE JAVA 
USING SQLData(
    street2_attr VARCHAR(250) EXTERNAL NAME 'street2',
    country_attr VARCHAR (200) EXTERNAL NAME 'country',
    address_code_attr VARCHAR (50) EXTERNAL NAME 'addrCode',    
    STATIC FUNCTION create_address RETURN long_address_t 
      EXTERNAL NAME 'create() return Examples.LongAddress',
    STATIC FUNCTION  construct (street VARCHAR, city VARCHAR, 
        state VARCHAR, country VARCHAR, addrs_cd VARCHAR) 
      RETURN long_address_t 
      EXTERNAL NAME 
        'create(java.lang.String, java.lang.String,
        java.lang.String, java.lang.String, java.lang.String) 
          return Examples.LongAddress',
    STATIC FUNCTION construct RETURN long_address_t
      EXTERNAL NAME 'Examples.LongAddress() 
        return Examples.LongAddress',
    STATIC FUNCTION create_longaddress (
      street VARCHAR, city VARCHAR, state VARCHAR, country VARCHAR, 
      addrs_cd VARCHAR) return long_address_t
      EXTERNAL NAME 
        'Examples.LongAddress (java.lang.String, java.lang.String,
         java.lang.String, java.lang.String, java.lang.String)
           return Examples.LongAddress',
    MEMBER FUNCTION get_country RETURN VARCHAR
      EXTERNAL NAME 'country_with_code () return java.lang.String'
  );
/