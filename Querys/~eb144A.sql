      SELECT  b.type_code, sum(1), sum(amount)
      FROM   BILL_INVOICE_DETAIL b, PRODUCT_LINES p, DISCOUNT_DEFINITIONS d, NRC_TRANS_DESCR n
      WHERE  b.bill_ref_no           = 153834509
        AND  b.bill_ref_resets       = 0
        AND  b.subtype_code          = n.type_id_nrc
        AND  b.billing_level         = 0
        AND  b.product_line_id       = p.product_line_id (+)
        AND  b.type_code             = 3
        AND  d.discount_id       (+) = b.discount_id
                group by  type_code
        UNION ALL
      SELECT  b.type_code, sum(1), sum(amount)
             FROM   BILL_INVOICE_DETAIL b, CUSTOMER_CONTRACT cc1, CUSTOMER_CONTRACT cc2, CUSTOMER_CONTRACT_KEY cck1, CUSTOMER_CONTRACT_KEY cck2,
              PRODUCT_LINES p, DISCOUNT_DEFINITIONS d, CONTRACT_TYPES ct1, CONTRACT_TYPES ct2
      WHERE  b.bill_ref_no               = 153834509
        AND  b.bill_ref_resets           = 0
        AND  b.billing_level             = 0
        AND  b.product_line_id           = p.product_line_id (+)
        AND  b.type_code                 in ( 1, 5, 6 )
        AND  d.discount_id                  (+) = b.discount_id
                AND  (cc1.tracking_id       (+) = b.units
                AND  cc1.parent_account_no  (+) = 2603309
                AND  cck1.tracking_id       (+) = cc1.tracking_id
                AND  cck1.tracking_id_serv  (+) = cc1.tracking_id_serv    
                AND  ct1.contract_type      (+) = cc1.contract_type)
                AND  (cc2.tracking_id       (+) = b.tracking_id
                AND  cc2.parent_account_no  (+) = 2603309
                AND  cck2.tracking_id       (+) = cc2.tracking_id
                AND  cck2.tracking_id_serv  (+) = cc2.tracking_id_serv    
                AND  ct2.contract_type      (+) = cc2.contract_type)
                        group by  type_code                   
      UNION ALL
      SELECT  b.type_code, sum(1), sum(amount)
      FROM   BILL_INVOICE_DETAIL b, PRODUCT_LINES p, DISCOUNT_DEFINITIONS d, GVT_BILL_PRODUCT_RATE_KEY r
      WHERE  b.bill_ref_no           = 153834509
        AND  b.bill_ref_resets          = 0
        AND  b.billing_level         = 0
        AND  b.product_line_id       = p.product_line_id           (+)
        AND  b.type_code             = 2
        AND  d.discount_id       (+) = b.discount_id
        AND  b.bill_ref_no              = r.bill_ref_no (+)
        AND  b.bill_ref_resets         = r.bill_ref_resets (+)
        AND  b.tracking_id             = r.tracking_id (+)
        AND  b.tracking_id_serv         = r.tracking_id_serv (+)
                        group by  type_code
      UNION ALL
      SELECT  b.type_code, sum(1), sum(amount)
      FROM   BILL_INVOICE_DETAIL b, PRODUCT_LINES p, ADJ a, ADJ_REASON_CODE_VALUES arcv, ADJ_TRANS_DESCR atd,
             BILL_INVOICE bi, DISCOUNT_DEFINITIONS d
      WHERE  b.bill_ref_no           = 153834509
        AND  b.bill_ref_resets       = 0
        AND  b.billing_level         = 0
        AND  b.product_line_id       = p.product_line_id (+)
        AND  b.type_code             = 4
        AND  a.no_bill               = 0
        AND  b.tracking_id           = a.tracking_id
        AND  b.tracking_id_serv      = a.tracking_id_serv
        AND  a.adj_reason_code       = arcv.adj_reason_code
        AND  arcv.language_code      = 2
        AND  a.adj_trans_code        = atd.adj_trans_code
        AND  bi.bill_ref_no          = a.orig_bill_ref_no
        AND  bi.bill_ref_resets      = a.orig_bill_ref_resets
        AND  d.discount_id       (+) = b.discount_id
                        group by  type_code   
      UNION ALL     
      SELECT b.type_code, sum(1), sum(amount)
      FROM   BILL_INVOICE_DETAIL b, CUSTOMER_CONTRACT cc1, CUSTOMER_CONTRACT cc2, 
              CUSTOMER_CONTRACT_KEY cck1, CUSTOMER_CONTRACT_KEY cck2, 
              CUSTOMER_ID_ACCT_MAP c, SERVICE s, CUSTOMER_ID_EQUIP_MAP m, PRODUCT_LINES p, 
              DISCOUNT_DEFINITIONS d, CONTRACT_TYPES ct1, CONTRACT_TYPES ct2,
             ( SELECT bill_invoice_row, MAX(trans_dt) trans_dt
               FROM   CDR_BILLED
               WHERE  bill_ref_no       = 153834509
                 AND  bill_ref_resets     = 0
               GROUP  BY bill_invoice_row ) bed
      WHERE  bed.bill_invoice_row   (+) = b.bill_invoice_row
        AND  b.bill_ref_no              = 153834509
        AND  b.bill_ref_resets          = 0
        AND  b.billing_level            = 1
        AND  b.type_code                in ( 1, 3, 5, 6, 7 )
        AND  s.subscr_no                = b.subscr_no
        AND  s.subscr_no_resets         = b.subscr_no_resets
        AND  c.account_no               = s.parent_account_no
        AND  c.external_id_type         = 1
        AND  c.is_current               = 1
        AND  m.subscr_no                = b.subscr_no
        AND  m.subscr_no_resets         = b.subscr_no_resets
        AND  m.external_id_type         = s.display_external_id_type
        AND  m.is_current               = 1
        AND  b.product_line_id          = p.product_line_id (+)
        AND  d.discount_id          (+) = b.discount_id
                AND  (cc1.tracking_id         (+) = b.units
                AND     cc1.parent_account_no (+) = 2603309
                AND  cck1.tracking_id         (+) = cc1.tracking_id
                AND  cck1.tracking_id_serv    (+) = cc1.tracking_id_serv    
                AND  ct1.contract_type        (+) = cc1.contract_type)
                AND  (cc2.tracking_id         (+) = b.tracking_id
                AND     cc2.parent_account_no (+) = 2603309
                AND  cck2.tracking_id         (+) = cc2.tracking_id
                AND  cck2.tracking_id_serv    (+) = cc2.tracking_id_serv    
                AND  ct2.contract_type        (+) = cc2.contract_type)
                                group by  type_code     
      UNION ALL
      SELECT b.type_code, sum(1), sum(amount)
      FROM   BILL_INVOICE_DETAIL b,  CUSTOMER_ID_ACCT_MAP c, SERVICE s, CUSTOMER_ID_EQUIP_MAP m, PRODUCT_LINES p,
             DISCOUNT_DEFINITIONS d, GVT_BILL_PRODUCT_RATE_KEY r
      WHERE  b.bill_ref_no           = 153834509
        AND  b.bill_ref_resets       = 0
        AND  b.billing_level         = 1
        AND  b.type_code             = 2
        AND  s.subscr_no             = b.subscr_no
        AND  s.subscr_no_resets      = b.subscr_no_resets
        AND  c.account_no            = s.parent_account_no
        AND  c.external_id_type      = 1
        AND  c.is_current            = 1
        AND  m.subscr_no             = b.subscr_no
        AND  m.subscr_no_resets      = b.subscr_no_resets
        AND  m.external_id_type      = s.display_external_id_type
        AND  m.is_current            = 1
        AND  b.product_line_id       = p.product_line_id           (+)
        AND  d.discount_id       (+) = b.discount_id
        AND  b.bill_ref_no              = r.bill_ref_no (+)
        AND  b.bill_ref_resets          = r.bill_ref_resets (+)
        AND  b.tracking_id              = r.tracking_id (+)
        AND  b.tracking_id_serv         = r.tracking_id_serv (+)
                                group by  type_code
      UNION ALL 
      SELECT  b.type_code, sum(1), sum(amount)
      FROM   BILL_INVOICE_DETAIL b,       CUSTOMER_ID_ACCT_MAP c, SERVICE s, CUSTOMER_ID_EQUIP_MAP m, PRODUCT_LINES p, ADJ a,
             ADJ_REASON_CODE_VALUES arcv, ADJ_TRANS_DESCR atd,    BILL_INVOICE bi, DISCOUNT_DEFINITIONS d
      WHERE  b.bill_ref_no           = 153834509
        AND  b.bill_ref_resets       = 0
        AND  b.billing_level         = 1
        AND  b.type_code             = 4
        AND  s.subscr_no             = b.subscr_no
        AND  s.subscr_no_resets      = b.subscr_no_resets
        AND  c.account_no            = s.parent_account_no
        AND  c.external_id_type      = 1
        AND  c.is_current            = 1
        AND  m.subscr_no             = b.subscr_no
        AND  m.subscr_no_resets      = b.subscr_no_resets
        AND  m.external_id_type      = s.display_external_id_type
        AND  m.is_current            = 1
        AND  b.product_line_id       = p.product_line_id (+)
        AND  a.no_bill               = 0
        AND  b.tracking_id           = a.tracking_id
        AND  b.tracking_id_serv      = a.tracking_id_serv
        AND  a.adj_reason_code       = arcv.adj_reason_code
        AND  arcv.language_code      = 2
        AND  a.adj_trans_code        = atd.adj_trans_code
        AND  bi.bill_ref_no      (+) = a.orig_bill_ref_no
        AND  bi.bill_ref_resets  (+) = a.orig_bill_ref_resets
        AND  d.discount_id       (+) = b.discount_id
        group by  type_code
        order by 3