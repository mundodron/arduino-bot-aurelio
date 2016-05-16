--update BANK_SEQS set SEQ_NUMB = SEQ_NUMB + 2 where bank_id = 001;

select * from BANK_SEQS where bank_id = 001;

select max(arquivo) from gvt_controle_debito where banco = 'BANCO_DO_BRASIL'