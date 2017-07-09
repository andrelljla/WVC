DECLARE
  vLastYear       integer := 2016;

BEGIN  

  -- Count, Total, Average Invoice by month
  insert into SUMRY_INVC_MONTH_HIST_DTL
  select  c.year,
          c.monthofyear,
          count(i.invc_amt) NumberOfInvoices,
          sum(i.invc_amt) TotalInvoiceAmount,
          avg(i.invc_amt) AverageInvoiceAmount
  from invoice_transaction i, calendar_dim c
  where i.date_key = c.datekey
  and c.year between 2002 and vLastYear
  group by c.monthofyear, c.year
  order by c.year, c.monthofyear
  ;
  
  -- Count, Total, Average Invoice by week
  insert into SUMRY_INVC_WEEK_HIST_DTL
  select  c.year,
          c.weekofyear,
          count(i.invc_amt) NumberOfInvoices,
          sum(i.invc_amt) TotalInvoiceAmount,
          avg(i.invc_amt) AverageInvoiceAmount
  from invoice_transaction i, calendar_dim c
  where i.date_key = c.datekey
  and c.year between 2002 and vLastYear
  group by c.weekofyear, c.year
  order by c.year, c.weekofyear
  ;
  
END;


select week_of_year, max(high_amount), max(low_amount), max(average_amount), max(ytd_amount)
from 
(
  select  week_of_year, 
          max(invoice_total_amt) high_amount, 
          min(invoice_total_amt) low_amount, 
          avg(invoice_total_amt) average_amount,
          0 ytd_amount-- YTD results
    from  SUMRY_INVC_WEEK_HIST_DTL
    group by week_of_year
  UNION ALL
  select  c.weekofyear week_of_year, 
          0 high_amount,
          0 low_amount,
          0 average_amount,
          sum(i.invc_amt) ytd_amount
  from  INVOICE_TRANSACTION i, CALENDAR_DIM c
  where i.date_key = c.datekey
    and c.year = 2017
    group by c.weekofyear
  )
group by week_of_year--, high_amount, low_amount, average_amount
order by week_of_year
;

select month_of_year, max(high_amount), max(low_amount), max(average_amount), max(ytd_amount)
from 
(
  select  month_of_year, 
          max(invoice_total_amt) high_amount, 
          min(invoice_total_amt) low_amount, 
          avg(invoice_total_amt) average_amount,
          0 ytd_amount-- YTD results
    from  SUMRY_INVC_MONTH_HIST_DTL
    group by month_of_year
  UNION ALL
  select  c.monthofyear month_of_year, 
          0 high_amount,
          0 low_amount,
          0 average_amount,
          sum(i.invc_amt) ytd_amount
  from  INVOICE_TRANSACTION i, CALENDAR_DIM c
  where i.date_key = c.datekey
    and c.year = 2017
    group by c.monthofyear
  )
group by month_of_year--, high_amount, low_amount, average_amount
order by month_of_year
;  
  