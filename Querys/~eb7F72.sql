select * from customer_id_acct_map where account_no = 1942775

select * from customer_id_equip_map where SUBSCR_NO in (3268673,3268674,4148609) and inactive_date is not null

select * from service where parent_account_no = 1942775

select * from gvt_bill_invoice_nfst where bill_ref_no = 284704319;

select * from cmf_balance where bill_ref_no = 284704319

select account_category from cmf where account_no = 1942775

SELECT SUM(AMOUNT+DISCOUNT)
    FROM BILL_INVOICE_DETAIL BID
    WHERE BID.bill_ref_no = 284704319
      AND BID.bill_ref_resets = 0
      AND decode(BID.open_item_id,90,90,91,90,92,90,93,93,94,93,95,93,BID.open_item_id) = 1      
      AND ( BID.type_code IN (2,3,7) )
      AND BID.SUBTYPE_CODE not IN ( SELECT CHARGE_ID FROM GVT_COBILLING_PROD_FAT
                                    WHERE OPEN_ITEM_ID = 1);
                                    
 SELECT * FROM GVT_COBILLING_PROD_FAT WHERE OPEN_ITEM_ID = 0
 
 select * FROM GVT_COBILLING_PROD_FAT where charge_id = 12034
 
 select * from GVT_BILL_INVOICE_NFST where bill_ref_no = 284704319
 
 select * from customer_id_equip_map where SUBSCR_NO in (3268673,3268674,4148609)
 
 