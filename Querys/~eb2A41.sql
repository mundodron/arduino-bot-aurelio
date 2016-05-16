select * from cmf_balance_detail cb
where bill_ref_no = 170567955
 --fatura exemplo
and open_item_id in (91,92)
and not exists (select 1 from sin_seq_no s
where cb.bill_ref_no = s.bill_ref_no
and s.open_item_id=90);

select * from bill_invoice --_detail
where bill_ref_no= 173903103
and type_code in (2,3,7)
and open_item_id not in (0,1,2,3,90,91,92) 

and amount=0;


select * from cmf_balance_detail cb
where bill_ref_no = 169345957


select * from GVT_DETALHAMENTO_CICLO