select count(*) from GVT_FEBRABAN_PONTA_B_ARBOR_Bk

select count(*) from GVT_FEBRABAN_PONTA_B_ARBOR

select * from gvt_febraban_ponta_b_arbor_bk where EMF_EXT_ID not in (select EMF_EXT_ID from gvt_febraban_ponta_b_arbor)

select * from customer_id_acct_map where external_id = '899999452150'

select * from GVT_EIF_TERMO_FIDELIDADE where conta_cobranca = '899999452150'

select * from GVT_EIF_TERMO_FIDELIDADE where nome_termo = 'MODEM' order by 11 desc

        SELECT max(SEQUENCIAL) SEQUENCIAL, SUM(ID_TERMO) id_termo, min(nome_termo) nome_termo, MIN(VALOR) VALOR, MIN(PRAZO) PRAZO from (
SELECT max(sequencial) SEQUENCIAL, to_number(ID_TERMO) id_termo, min(nome_termo) nome_termo, VALOR, PRAZO
                    FROM GVT_EIF_TERMO_FIDELIDADE 
                     WHERE CONTA_COBRANCA = 899999452150
                         AND (NVL(BILL_REF_NO,0) = 0 OR
                                 BILL_REF_NO = 150477387)
      group by CONTA_COBRANCA, ID_TERMO, nome_termo, VALOR, PRAZO)