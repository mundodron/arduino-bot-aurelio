      SELECT C.ACCOUNT_NO, C.BILL_REF_NO, C.PAYMENT_DUE_DATE
      FROM   CDC_PROCESSAR_BACKLOG C
      WHERE  C.account_category not in (9,10,11)
       and   C.processo = 1;
       
       
             SELECT DISTINCT provider_id, 
             decode(open_item_id,2,1,3,1,open_item_id) open_item_id
      FROM   bill_invoice bi, 
             bill_invoice_detail bid
      WHERE  bi.account_no = v_cliente
       AND   bi.bill_ref_no = v_bill_ref_no
       AND   bi.bill_ref_no = bid.bill_ref_no
       AND   bi.bill_ref_resets = bid.bill_ref_resets
       AND   bid.type_code IN (2, 3, 7)
       ORDER BY decode(open_item_id,2,1,3,1,open_item_id);