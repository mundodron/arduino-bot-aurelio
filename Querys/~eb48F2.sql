
select C.EXTERNAL_ID, L.CONTACT1_PHONE CPF
  from gvt_caixa c,
       GVT_LOTERICA_CONSULTA_CPFCNPJ l
 where C.ACCOUNT_NO = L.ACCOUNT_NO
   and C.EXTERNAL_ID = L.EXTERNAL_ID;
   
   
   select * from gvt_caixa