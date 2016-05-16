_________________________________________________________________
*** Inicio - PBCT1 - M15 - 08/10/2014 09:27:12
CENARIO;CONTA_COBRANCA;ACCOUNT;SUBSCR_NO;INSTANCIA;FAT_ATUAL;COMPONENTE_ID;COMPONENTE;COMENTARIO
C4 Produto Faltando;999988338223;3910188;8977545;999988338223;203080027;30487;GVT Na Medida Nacional - Conta
C4 Produto Faltando;999988338223;3910188;8977545;999988338223;203080027;30488;GVT Na Medida Nacional - Instancia
_________________________________________________________________
*** Fim - PBCT1 - M15 - 08/10/2014 09:27:14


SELECT   CPC.COMPONENT_ID,
           (select tira_acento(description_text) from descriptions dt where dt.description_code = CPC.ELEMENT_ID and dt.language_code = 2) "PRODUTO"
                          FROM   bill_invoice_detail CPC,
                                 bill_invoice BB
                         WHERE   BB.ACCOUNT_NO = 3910188
                           AND   CPC.BILL_REF_NO = 203080027
                           AND   CPC.BILL_REF_NO = BB.BILL_REF_NO
                           --AND   CPC.SUBSCR_NO = 8977545
                           AND   CPC.TYPE_CODE = 2
                           AND   CPC.BILL_REF_RESETS = BB.BILL_REF_RESETS
                           AND   CPC.BILL_REF_RESETS = 0
                           --AND   CPC.COMPONENT_ID = 25011 -- 30487 --A.COMPONENT_ID 