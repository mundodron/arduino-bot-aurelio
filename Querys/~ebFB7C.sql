select * from cmf_balance where bill_ref_no = 142907225 -- 135351122

select OPEN_ITEM_ID from CMF_BALANCE_DETAIL  where bill_ref_no = 135351122

select OPEN_ITEM_ID from SIN_SEQ_NO where bill_ref_no = 135351122

/* 
Comparar o campo OPEN_ITEM_ID (nota fiscal) da fatura se está igual na CMF_BALANCE_DETAIL e na SIN_SEQ_NO. A CMF_BALANCE_DETAIL 
contém todas as notas fiscais da fatura, mas existem OPEN_ITEM_IDs que não vão para a SIN_SEQ_NO.
A nota PadrãoGVT, na CMF_BALANCE_DETAIL, tem o campo OPEN_ITEM_ID = 1 e na SIN_SEQ_NO tem o campo OPEN_ITEM_ID = 0;
*/

select * from BILL_INVOICE where bill_ref_no = 135351122

select OPEN_ITEM_ID from cmf_balance_detail where bill_ref_no = 135351122

select * from GVT_SINSEQNO_SERIES where MKT_CODE = 22 

select MKT_CODE  from CMF where account_no = 6956282


