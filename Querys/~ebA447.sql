select * from mkt_code_values

select * from sin_seq_no

-- Mostra que o campo REMESSA n�o est� sendo preenchido.
Select * from GRC_HISTORICOS_SERV_PRESTADOS WHERE status_para in ('RA','RI','RP') and DATA_ALTERACAO > sysdate-10

-- Mostra os nomes dos �ltimos arquivos TCOR de contesta��o gerados pela proc_envia_contestados... 
Select * from GRC_INTERFACES where data_inclusao > sysdate-10 and processo = 'PAR';

select * from bill_invoice where bill_ref_no = 212638740 



