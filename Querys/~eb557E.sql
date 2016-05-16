SELECT MIN(CUTOFF_DATE)
                                    FROM   BILL_CYCLE
                                    WHERE    PPDD_DATE = sysdate --TO_DATE ('sysdate','dd/mm/yyyy')
                                    AND bill_period like 'M%'
                                    
   SELECT MIN(CUTOFF_DATE) 
    from BILL_CYCLE
    where PPDD_DATE > sysdate -3
    and bill_period like 'M%'
    
    select * from all_tables where table_name like '%JNL%' 
    
    select max(JNL_END_DT) from JNL_CYCLE
    
    
    select bill_period
      from bill_invoice
     where bill_ref_no = (select max(bill_ref_no) from bill_invoice where PREP_STATUS = 4 and prep_date > trunc(sysdate -2))