     SELECT a.bill_ref_no,
            TO_CHAR((a.payment_due_date),'YYYYMM')
       FROM bill_invoice a, contafacil_corp b
      WHERE 1 =1 --a.account_no = v_cliente 
        AND a.prep_status = 1
        AND a.prep_error_code is null
        AND backout_status = '0'
        AND format_error_code IS NULL
        AND a.bill_ref_no = b.bill_ref_no
        AND a.account_no = b.account_no;
        
        select * from GVT_CONTA_INTERNET
        
        select * from cmf_balance where account_no in (select account_no from contafacil_corp) order by 3 desc
        
        select * from all_tables where table_name like '%FACIL%' 
        
        select account_no from customer_id_acct_map where external_id in ('999982557227','999982873292','999982591723','999986189562','999979846772','999985051150','999986882638','999986882606','999982557227','999986882637','999986882646','999986882597','999979848510','999986882599','999986882644','999987519858','999986882598','999984833362','999986905041','999986882640','999986882613','999986882601','999986882635','999979848512','999986882641','999979847866','999986882642','999984833362','999986882597','999979846772','999979848514','999982591723','999982873292','999986882641')
        
        select * from GVT_CONTA_INTERNET where account_no in (7543460,7541397,7541408,7541403,7541398,4588106,4578094,4493515,3929019,3865286,3593100,3377652,3377647,3377632,3377645,3377630,3377641,3377638,3377634,3377649,3377631,3377642,3377646,3377644,3377640,3375606,3189456)
        --and bill_ref_no in ()
        and data_processamento > (sysdate - 73)
        
        and external_id = 999986882637
        
        select trunc(PPDD_DATE, 'Month')
          from cmf_balance
         where account_no in (7543460,7541397,7541408,7541403,7541398,4588106,4578094,4493515,3929019,3865286,3593100,3377652,3377647,3377632,3377645,3377630,3377641,3377638,3377634,3377649,3377631,3377642,3377646,3377644,3377640,3375606,3189456)
           --and trunc(PPDD_DATE, 'Month') = 07
        
        
        select * from cmf_balance where bill_ref_no = 147604115
