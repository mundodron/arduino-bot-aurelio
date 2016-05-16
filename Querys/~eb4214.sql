
select * from SIN_SEQ_NO where BILL_REF_NO = '195313955';


select OPEN_ITEM_ID, EXTERNAL_ID from CMF_BALANCE_DETAIL where BILL_REF_NO = '195313955';


select * from sin_seq_no where bill_ref_no = 195313955

select * from cmf_balance_detail cb
where cb.bill_ref_no = '195313955' --fatura exemplo CT1 e CT2
and open_item_id in (91,92)
and not exists (select 1 from sin_seq_no s
where cb.bill_ref_no = s.bill_ref_no
and s.open_item_id=90);


select * from bill_invoice_detail
where bill_ref_no= 195313955 -- ¿ fatura 
and type_code in (2,3,7)
and open_item_id not in (0,1,2,3,90,91,92) 
and amount=0;


      SELECT r.provider_id, v.display_value, r.merchant_city
      FROM   SERVICE_PROVIDERS_REF r, SERVICE_PROVIDERS_VALUES v
      WHERE  r.provider_id   = v.provider_id
        AND  v.language_code = 2
      ORDER  BY r.provider_id;