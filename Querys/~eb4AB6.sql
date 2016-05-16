
select C.EXTERNAL_ID, L.CONTACT1_PHONE CPF
  from gvt_caixa c,
       GVT_LOTERICA_CONSULTA_CPFCNPJ l
 where C.ACCOUNT_NO = L.ACCOUNT_NO
   and C.EXTERNAL_ID = L.EXTERNAL_ID;
   
   select NSA, SUM(valor) from E9502359SQL.CANCEL_CEF group by nsa