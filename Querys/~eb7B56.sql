
      SELECT gp.*
      FROM   BILL_INVOICE_DETAIL b, PRODUCT_LINES p, DISCOUNT_DEFINITIONS d, GVT_PRODUCT_VELOCITY gp, GVT_BILL_PRODUCT_RATE_KEY r
      WHERE  b.bill_ref_no           = 295112703 --:p_bill_ref_no
        AND  b.bill_ref_resets          = 0 --:p_bill_ref_resets
        AND  b.billing_level         = 0
        AND  b.product_line_id       = p.product_line_id (+)
        AND  b.type_code             = 2
        AND  d.discount_id       (+) = b.discount_id
        AND  b.tracking_id           = gp.TRACKING_ID (+)
        AND  b.TRACKING_ID_SERV         = gp.TRACKING_ID_SERV (+)
        AND  gp.END_DT is null
        AND  b.bill_ref_no              = r.bill_ref_no (+)
        AND     b.bill_ref_resets         = r.bill_ref_resets (+)
        AND     b.tracking_id             = r.tracking_id (+)
        AND  b.tracking_id_serv         = r.tracking_id_serv (+)