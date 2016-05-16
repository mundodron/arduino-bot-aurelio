select * from cmf_balance where bill_ref_no = 272792763 

4020198

272792763


    SELECT ce.* --TRV.RATE
    --INTO :p_tax_rate:i0090
    FROM CMF_EXEMPT CE, TAX_RATES_VAT TRV
    WHERE CE.ACCOUNT_NO = 4020198
      AND CE.DATE_EXPIRATION IS NULL
      AND CE.TAX_PKG_INST_ID = TRV.TAX_PKG_INST_ID
      AND TRV.INACTIVE_DATE IS NULL;  
      
      
      delete from CMF_EXEMPT where account_no = 4020198 and tracking_id = 1450;
      
      select * from all_tables where table_name like '%AVULSO%' and owner like '%ARBOR%'

select * from CONTA_CORPORATE_HQ_AVULSO