select * from cmf_balance where bill_ref_no in (107914502)


select External_id, account_no, Bill_ref_no, cnpj, valor from gvt_nrc_invalida where status is null and account_no is not null  and account_no in (
select account_no from cmf_balance_detail C where C.OPEN_ITEM_ID in (91,92))
group by (External_id, account_no, Bill_ref_no, cnpj, valor)




select G.EXTERNAL_ID, G.ACCOUNT_NO, G.BILL_REF_NO, G.CNPJ, B.TOTAL_DUE as VALOR
  from GVT_LOTERICA_CONSULTA_CPFCNPJ C,
       gvt_nrc_invalida G,
       cmf_balance_detail D,
       cmf_balance b
 where G.ACCOUNT_NO = C.ACCOUNT_NO
   and G.ACCOUNT_NO = D.ACCOUNT_NO
   and G.BILL_REF_NO = D.BILL_REF_NO
   and G.ACCOUNT_NO = B.ACCOUNT_NO
   and G.BILL_REF_NO = B.BILL_REF_NO
   and D.OPEN_ITEM_ID in (91,92)
   and G.status is null
   and G.account_no is not null
   
   
   
   update gvt_nrc_invalida G set valor = (select Max(GL_AMOUNT) from bmf where account_no = G.ACCOUNT_NO and bill_ref_no = G.BILL_REF_NO)
   
   
   select * from gvt_nrc_invalida
   

  
