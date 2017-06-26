-- Raw Invoice_Visit/month
select  cal.year, cal.month, cal.monthofyear, sum(inv.total_amount) invoice_total, count(visit_id) visit_count
  from  invoice inv, calendar_dim cal, visit vst
 where  inv.visit_key = vst.visit_id
  and   vst.visit_date_key = cal.datekey
group by cal.year, cal.month, cal.monthofyear
;

-- YTD Invoice_Visit/MonthOfYear
select mv.year, mv.month, mv.monthofyear, mv.invoice_total, sum(i2.total_amount) ytd_invoice_total, mv.visit_count, count(v2.visit_id) ytd_visit_count
from raw_invoice_visit_monthofyear mv, invoice i2, visit v2, calendar_dim c2
 where  i2.visit_key = v2.visit_id
  and   v2.visit_date_key = c2.datekey
  and   mv.year = c2.year
  and   c2.monthofyear <= mv.monthofyear
  -- Data for 2000/2001 are sketchy, leave out of MV
  and   c2.year > 2001
group by mv.year, mv.month, mv.monthofyear, mv.invoice_total, mv.visit_count
order by mv.year, mv.monthofyear
;

-- Raw Invoice_Visit/WeekOfYear
select  cal.year, cal.weekofyear, sum(inv.total_amount) invoice_total, count(visit_id) visit_count
  from  invoice inv, calendar_dim cal, visit vst
 where  inv.visit_key = vst.visit_id
  and   vst.visit_date_key = cal.datekey
group by cal.year, cal.weekofyear
;

-- YTD Invoice_Visit/WeekofYear
select mv.year, mv.weekofyear, mv.invoice_total, sum(i2.total_amount) ytd_invoice_total, mv.visit_count, count(v2.visit_id) ytd_visit_count
from raw_invoice_visit_weekofyear mv, invoice i2, visit v2, calendar_dim c2
 where  i2.visit_key = v2.visit_id
  and   v2.visit_date_key = c2.datekey
  and   mv.year = c2.year
  and   c2.weekofyear <= mv.weekofyear
  -- Data for 2000/2001 are sketchy, leave out of MV
  and   c2.year > 2001
group by mv.year, mv.weekofyear, mv.invoice_total, mv.visit_count
order by mv.year, mv.weekofyear
;


-- Raw Invoice_visit/DayOfweek
select  cal.year, cal.day, cal.dayofweek, sum(inv.total_amount) invoice_total, count(visit_id) visit_count
  from  invoice inv, calendar_dim cal, visit vst
 where  inv.visit_key = vst.visit_id
  and   vst.visit_date_key = cal.datekey
  -- Data for 2000/2001 are sketchy, leave out of MV
  and   cal.year > 2001
group by cal.year, cal.day, cal.dayofweek
order by cal.year, cal.dayofweek
;


-- DOW Statistics
select day, dayofweek, min(invoice_total), max(invoice_total), avg(invoice_total), median(invoice_total), stddev(invoice_total)
from mv_invoice_visit_dayofweek 
group by day, dayofweek
order by dayofweek;

-- Week Statistics
select weekofyear, min(invoice_total), max(invoice_total), avg(invoice_total), median(invoice_total), stddev(invoice_total)
from mv_raw_invc_visit_weekofyear 
group by weekofyear
order by weekofyear;

-- Month Statistics
select month, monthofyear, min(invoice_total), max(invoice_total), avg(invoice_total), median(invoice_total), stddev(invoice_total)
from mv_raw_invc_visit_monthofyear 
group by month, monthofyear
order by monthofyear;

