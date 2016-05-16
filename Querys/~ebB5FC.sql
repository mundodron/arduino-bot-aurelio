select * from GVT_INVOICE_CONTROL where gvt_file_name = 'gvt_bankslip_c1_140615.tar.gz'


           VALUES( 1, NULL, 'BOLETO', TO_CHAR(SYSDATE,'ddmmyy'), 1, 'BOLETO', 'gvt_bankslip_c1_140615.tar.gz', 0);

select * from GVT_INVOICE_CONTROL where gvt_account_type = 'BOLETO' and GVT_date = '140615'

INSERT INTO GVT_INVOICE_CONTROL (PREP_STATUS, BILL_PERIOD, GVT_ACCOUNT_TYPE, GVT_DATE, GVT_SEQ_NUM, GVT_MODE, GVT_FILE_NAME, TOT_CONTAS_ABNC) 
           VALUES( 1, NULL, 'BOLETO', TO_CHAR(SYSDATE,'ddmmyy'), 1, 'BOLETO', 'gvt_bankslip_c1_140615.tar.gz', 0);


select PREP_STATUS, BILL_PERIOD, GVT_ACCOUNT_TYPE, GVT_DATE, GVT_SEQ_NUM, GVT_MODE, GVT_FILE_NAME, TOT_CONTAS_ABNC from GVT_INVOICE_CONTROL
where gvt_account_type = 'BOLETO' and GVT_date = '140615' 