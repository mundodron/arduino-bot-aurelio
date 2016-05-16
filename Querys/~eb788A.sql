select * 
  from GVT_FERNANDO G,
     GVT_LOTERICA_CONSULTA_CPFCNPJ L,
    gvt_rajadas_bill R
where G.FUCPF = L.CONTACT1_PHONE
--and   R.ACCOUNT_NO = L.ACCOUNT_NO
and   R.EXTERNAL_ID = L.EXTERNAL_ID
and   R.STATUS = 888
and   L.account_no is not null

update gvt_rajadas_bill a set account_no = (select account_no from customer_id_acct_map where external_id = A.EXTERNAL_ID)

select * from cmf_balance_detail