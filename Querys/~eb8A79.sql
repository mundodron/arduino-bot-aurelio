
select * from gvt_invoice_control_detail where prep_status = 1
AND to_date(GVT_DATE,'yyyy/mm/dd') >= TO_DATE('2014/02/01', 'yyyy/mm/dd')
AND to_dateGVT_DATE <= TO_DATE('2014/02/31','yyyy/mm/dd');