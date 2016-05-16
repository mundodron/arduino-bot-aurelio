SELECT * FROM GVT_DETALHAMENTO_CICLO
           WHERE DATA_PROCESSO >= TO_DATE ('${DATA_BIP}','YYYYMMDDHH24:MI:SS')
                         AND GVT_DATE = '${DATA}'
                         AND GVT_MODE = '${GVT_MODE}'
                         AND ANOTATION = 'CONTA IGNORADA PELO BIP'
                         AND ACCOUNT_CATEGORY IN (${CATEGORIA});
                         exit
                         EOF

select * from bill_invoice b where B.PREP_STATUS <> 1 and B.FILE_NAME is not null

select * from gvt_invoice_control

select * from gvt_invoice_control_detail

select * from all_tables where table_name like '%ORDER%'

select * from ORD_ORDER