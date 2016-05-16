

select * from all_tables where table_name like '%CONTROL%'
-- TO_DATE('070903', 'MMDDYY')

select count(1) from GVT_INVOICE_CONTROL_DETAIL where prep_status = 1 
   and to_date(GVT_DATE,'mmddyy') BETWEEN to_date('010114','mmddyy') AND to_date('013014','mmddyy')