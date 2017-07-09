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
select  cal.year, cal.weekofyear, sum(inv.total_amount) invoice_total, count(visit_id) visit_count, 
        round(avg(inv.total_amount),2) avg_invoice, round(stddev(inv.total_amount),2) invoice_stddev
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

-- Raw Invoice_Visit/Date
select  cal.year, cal.month, cal.monthofyear, cal.dayofmonth, sum(inv.total_amount) invoice_total, count(visit_id) visit_count
  from  invoice inv, calendar_dim cal, visit vst
 where  inv.visit_key = vst.visit_id
  and   vst.visit_date_key = cal.datekey
group by cal.year, cal.month, cal.monthofyear, cal.dayofmonth
;

-- Daily Invoice_Visit/Date
select mv.month, mv.monthofyear, mv.dayofmonth, 
      min(mv.invoice_total) min_day_invoice, max(mv.invoice_total) max_day_invoice, round(avg(mv.invoice_total),2) avg_day_invoice_total, round(stddev(mv.invoice_total),4) sdev_day_invoice_total,
      min(mv.visit_count) min_day_visits, max(mv.visit_count) max_day_visits, round(avg(mv.visit_count),0) avg_day_visits, round(stddev(mv.visit_count),4) sdev_day_visit_count,
      sum(i2.total_amount) total_day_invoice_total, count(v2.visit_id) total_day_visit_count
from mv_raw_invc_visit_dayofyear mv, invoice i2, visit v2, calendar_dim c2
 where  i2.visit_key = v2.visit_id
  and   v2.visit_date_key = c2.datekey
  and   mv.year = c2.year
  and   mv.dayofmonth = c2.dayofmonth
  and   c2.monthofyear = mv.monthofyear
  -- Data for 2000/2001 are sketchy, leave out of MV
  and   c2.year > 2001
group by mv.month, mv.monthofyear, mv.dayofmonth
order by mv.monthofyear, mv.dayofmonth
;

-- Weekly Invoice/Visit
select mv.weekofyear, 
      min(mv.invoice_total) min_week_invoice, max(mv.invoice_total) max_week_invoice, round(avg(mv.invoice_total),2) avg_week_invoice_total, 
      round(median(mv.invoice_total),2) median_week_invoice_total, round(stddev(mv.invoice_total),4) sdev_week_invoice_total,
      round((avg(mv.invoice_total)+stddev(mv.invoice_total)),2) avg_plusSD_week_invoice_total, round((avg(mv.invoice_total)-stddev(mv.invoice_total)),2) avg_lesssSD_week_invoice_total,
      sum(mv.invoice_total) total_week_invoice_total,      
      min(mv.visit_count) min_week_visits, max(mv.visit_count) max_week_visits, round(avg(mv.visit_count),0) avg_week_visits, 
      round(median(mv.visit_count),2) median_week_visits, round(stddev(mv.visit_count),4) sdev_week_visit_count,
      round(avg(mv.visit_count)+stddev(mv.visit_count),0) avg_plussd_week_visits, round(avg(mv.visit_count)-stddev(mv.visit_count),0) avg_lesssd_week_visits, 
      sum(mv.visit_count) total_week_visit_count
from mv_raw_invc_visit_weekofyear mv--, invoice i2, visit v2, calendar_dim c2
-- where  i2.visit_key = v2.visit_id
--  and   v2.visit_date_key = c2.datekey
--  and   c2.weekofyear = mv.weekofyear
  -- Data for 2000/2001 are sketchy, leave out of MV
  where   mv.year > 2001
group by mv.weekofyear
order by mv.weekofyear
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



-- Invoice Statistics by DOW
select  day, dayofweek, min(invoice_total) invoice_min, max(invoice_total) invoice_max, round(avg(invoice_total),2) invoice_avg, 
        (round(avg(invoice_total),2) + round(stddev(invoice_total),4)) mean_plus_stddev,
        (round(avg(invoice_total),2) - round(stddev(invoice_total),4)) mean_less_stddev,                
        median(invoice_total) invoice_median, round(stddev(invoice_total),4) invoice_stddev
from mv_invoice_visit_dayofweek 
group by day, dayofweek
order by dayofweek;

-- Invoice Statistics by Week
select  weekofyear, min(invoice_total) invoice_min, max(invoice_total) invoice_max, round(avg(invoice_total),2) invoice_avg, 
        (round(avg(invoice_total),2) + round(stddev(invoice_total),4)) mean_plus_stddev,
        (round(avg(invoice_total),2) - round(stddev(invoice_total),4)) mean_less_stddev,        
        median(invoice_total) invoice_median, round(stddev(invoice_total),4) invoice_stddev
from mv_raw_invc_visit_weekofyear 
group by weekofyear
order by weekofyear;

-- Invoice Statistics by Month
select  month, monthofyear, min(invoice_total) invoice_min, max(invoice_total) invoice_max, round(avg(invoice_total),2) invoice_avg, 
        (round(avg(invoice_total),2) + round(stddev(invoice_total),4)) mean_plus_stddev,
        (round(avg(invoice_total),2) - round(stddev(invoice_total),4)) mean_less_stddev,        
        median(invoice_total) invoice_median, round(stddev(invoice_total),4) invoice_stddev
from mv_raw_invc_visit_monthofyear 
group by month, monthofyear
order by monthofyear;




