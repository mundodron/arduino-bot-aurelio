16:18:31] <Thiago Passos - 6592> BBDCO6307.TXT
[16:18:37] <Thiago Passos - 6592> 6308
[16:19:19] <Thiago Passos - 6592> A111015               GVT/CURITIBA-PR     001BANCO DO BRASIL S/A 2012050900632004DEBITO AUTOMATICO

[16:20:03] <Thiago Passos - 6592> select * from BANK_SEQS --interno
where bank_id = 001
[16:20:13] <Thiago Passos - 6592> +- no seq
[16:20:30] <Thiago Passos - 6592> select * from gvt_controle_debito


select * from BANK_SEQS where bank_id = 001