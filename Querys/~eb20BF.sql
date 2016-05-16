select * from bank_seqs --interno
where bank_id = 001


update BANK_SEQS set SEQ_NUMB = SEQ_NUMB + 2 where bank_id = 001;