        select C.ACCOUNT_NO,
               C.EXTERNAL_ID,
               C.BILL_REF_NO,
               I.DATA_PROCESSAMENTO,
               C.ARQ ARQ_OLD,
               I.NOME_ARQUIVO ARQ_NOVO
          from G0023421SQL.backlog_cdc c,
               gvt_conta_internet i
         where C.ACCOUNT_NO = I.ACCOUNT_NO
           and C.BILL_REF_NO = I.BILL_REF_NO
           and C.ARQ != I.NOME_ARQUIVO
           and C.ARQ_OLD is not null