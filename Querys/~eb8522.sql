select * from bill_invoice_detail where bill_ref_no = 130859427

select * from customer_id_acct_map where account_no = 6534449

select * from GRC_SERVICOS_PRESTADOS A where account_no = 6534449 --A.CLIENTE = 999981381206

select * from CDR_DATA A where a.account_no = 6534449

select de.description_text,
b.type_id_usg,
       b.point_origin,
       b.point_target,
       b.billed_amount,
       b.billed_base_amt,
       b.amount_credited
  from descriptions de,
       cdr_billed b
 where b.bill_ref_no = 130859427  -- AQUI COLOCAR NR DA FATURA
   and b.bill_ref_resets = 0
   and b.type_id_usg +16000 = de.description_code(+)
   and de.language_code(+) = 2
 order by 2,
          4;