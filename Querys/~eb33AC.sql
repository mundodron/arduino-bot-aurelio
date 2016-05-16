 select count(1), B.DISPLAY_VALUE
   from cmf C,
        bill_disp_meth_values b
 where c.BILL_DISP_METH = B.BILL_DISP_METH
   and B.LANGUAGE_CODE = 2
   group by B.DISPLAY_VALUE
   
   
   
   select * from ARBORGVT_BILLING.GVT_DET_FATURAMENTO_CD
   
   
   select * from bill_disp_meth_values
   
