select * from SINCRONISMO_SK

update SINCRONISMO_SK SK set sk.account_no = (select MAP.ACCOUNT_NO from customer_id_acct_map map where MAP.EXTERNAL_ID = SK.CONTA_COBRANCA and external_id_type = 1 and inactive_date is null) 