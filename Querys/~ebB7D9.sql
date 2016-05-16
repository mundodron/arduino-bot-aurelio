
select * 
  from GVT_FERNANDO G,
     GVT_LOTERICA_CONSULTA_CPFCNPJ L,
    gvt_rajadas_bill R
where G.FUCPF = L.CONTACT1_PHONE
--and   R.ACCOUNT_NO = L.ACCOUNT_NO
and   R.EXTERNAL_ID = L.EXTERNAL_ID
and   R.STATUS = 888


select * from gvt_rajadas_bill where external_id = 999990042929