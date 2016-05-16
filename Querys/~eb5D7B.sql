select G.External_id, G.account_no, G.Bill_ref_no, G.cnpj, G.valor 
  from gvt_nrc_invalida G, 
       cmf_balance B
 where G.status is null 
   and B.BILL_REF_NO = G.BILL_REF_NO
   and B.CLOSED_DATE is not null
   and G.account_no is not null
   and G.ACCOUNT_NO = B.ACCOUNT_NO
   and G.account_no in (select account_no from cmf_balance_detail C where C.OPEN_ITEM_ID in (91,92))
group by (G.External_id, G.account_no, G.Bill_ref_no, G.cnpj, G.valor);


update gvt_nrc_invalida G set G.account_no = (select account_no from customer_id_acct_map where external_id = G.EXTERNAL_ID);