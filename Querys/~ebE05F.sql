SELECT *
 FROM cmf
WHERE no_bill = 0
  AND account_status != -2
  AND account_category IN (9, 10, 11)
  AND contact1_phone IS NOT NULL
  AND cust_zip IS NOT NULL
  -- AND bill_period = UPPER ('&2')
  -- AND UPPER(BILL_PERIOD) in (SELECT BILL_PERIOD FROM GVT_PROCESSAMENTO_CICLO WHERE PROCESSAMENTO = UPPER('&2'))
  AND  next_bill_date >= sysdate
--  AND next_bill_date = TO_DATE ('15/06/2010', 'DD/MM/YYYY')
  AND EXISTS (
         SELECT 1
           FROM service
          WHERE service.parent_account_no = cmf.account_no
            --AND service.service_inactive_dt IS NULL)
            and (service.service_inactive_dt is null or (service.service_inactive_dt + 7) > nvl(cmf.prev_cutoff_date,cmf.date_active)))            
  AND EXISTS (
              SELECT 1
                FROM sin_group_ref SIN
               WHERE SIN.GROUP_ID = cmf.mkt_code
                     AND SIN.inactive_date IS NULL)
  AND cmf.account_no = 10229294
  
  
  select * from gvt_blacklist_faturamento
  
          select * from bill_invoice where bill_ref_no = '283502801,282875286'