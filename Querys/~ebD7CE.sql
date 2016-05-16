select bill_ref_no, --fatura
bill_ref_resets, --pegue essa informação da bill_invoice
0 open_item_id, --open_item_id
502 sin_seq_ref_no, --> COLOQUE O NUMERO DA NF
80 sin_seq_ref_resets, --sempre é 80
'502-PR' full_sin_seq, --numero da nota e estado da nota
18 group_id, -->verifique na tabela SIN_GROUPS qual o GROUP_ID para o estado da nota
prep_status, --pegue essa informação da bill_invoice
prep_date,  --pegue essa informação da bill_invoice
statement_date,  --pegue essa informação da bill_invoice
payment_due_date  --pegue essa informação da bill_invoice
from BILL_INVOICE 
where bill_ref_no=138086302

select * from SIN_SEQ_NO where bill_ref_no = 138086302;

select * from customer_id_acct_map where account_no = 6647148