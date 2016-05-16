Existe um shell em produção que valida as contas que possuem o componente conta facil gvt e altera o tipo do formato da fatura para detalhada.

Jobs:
update_conta_detalhada_A_P_R_c1 e c2
update_conta_detalhada_A_P_S_c1 e c2
update_conta_detalhada_F_R_c1 e c2
update_conta_detalhada_P_C_c1 e c2
update_conta_detalhada_P_R_c1 e c2

E esta é a query:
UPDATE CMF
SET BILL_FMT_OPT = 2
WHERE ACCOUNT_NO IN (SELECT /*+ parallel(gvt 10) use_nl(gvt cp pcm) +*/ CP.BILLING_ACCOUNT_NO
FROM PRODUCT CP,
PRODUCT_CHARGE_MAP PCM,
${TABELA} GVT
WHERE CP.BILLING_ACCOUNT_NO = GVT.ACCOUNT_NO
AND CP.ELEMENT_ID IN (11402,11110)
AND CP.PARENT_SUBSCR_NO IS NULL
AND (CP.PRODUCT_INACTIVE_DT is null or (CP.PRODUCT_INACTIVE_DT is not null and PCM.BILLED_THRU_DT < CP.PRODUCT_INACTIVE_DT))
AND CP.TRACKING_ID = PCM.TRACKING_ID 
AND CP.TRACKING_ID_SERV = PCM.TRACKING_ID_SERV 
)
AND BILL_FMT_OPT = 1; 