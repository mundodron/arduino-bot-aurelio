      SELECT c.external_id,      m.external_id,          package_id,           component_id,                           type_code,
             subtype_code,       b.tracking_id,          b.tracking_id_serv,   prep_sequence,                          prorate_code,
             billing_level,      billing_category,       b.amount,             b.units,                                tax,
             tax_rate,           tax_pkg_inst_id,        discount,             b.discount_id,                          d.description_code,
             trans_date,         b.provider_id,          b.element_id,         b.product_line_id,                      b.description_code,
             b.subscr_no,        b.subscr_no_resets,     from_date,            dateadd('dd',-1,to_date),               b.annotation,
             b.profile_id,       0,                      b.federal_tax,        b.state_tax,
             b.county_tax,       b.city_tax,             b.secondary_amount,   b.rated_amount,                         b.rate_currency_code,
             b.open_item_id,     to_number(NULL),        to_number(NULL),      to_char(NULL),                          to_number(NULL),
             to_number(NULL),    to_number(NULL),        to_number(NULL),      to_number(NULL),                        decode( 2, 1, tracking_date, 2, NULL ),
             p.description_code, b.tax_type_code,        b.bill_invoice_row,   decode( 2, 1, tracking_date, 2, NULL ), to_number(NULL),
             to_char(NULL),      s.parent_account_no,    d.discount_level,     gp.VELOCITY, r.region,
              to_number(NULL),       to_number(NULL),        to_number(NULL), gp.END_DT
      FROM   BILL_INVOICE_DETAIL b,  CUSTOMER_ID_ACCT_MAP c, SERVICE s, CUSTOMER_ID_EQUIP_MAP m, PRODUCT_LINES p, DISCOUNT_DEFINITIONS d, GVT_PRODUCT_VELOCITY gp, GVT_BILL_PRODUCT_RATE_KEY r
      WHERE  b.bill_ref_no           = 228652902 -- :p_bill_ref_no
        AND  b.bill_ref_resets       = 0 --:p_bill_ref_resets
        AND  b.billing_level         = 1
        AND  b.type_code             = 2
        AND  s.subscr_no             = b.subscr_no
        AND  s.subscr_no_resets      = b.subscr_no_resets
        AND  c.account_no            = s.parent_account_no
        AND  c.external_id_type      = 1 --:p_EIF_external_id_type
        AND  c.is_current            = 1
        AND  m.subscr_no             = b.subscr_no
        AND  m.subscr_no_resets      = b.subscr_no_resets
        AND  m.external_id_type      = s.display_external_id_type
        AND  m.is_current            = 1
        AND  b.product_line_id       = p.product_line_id           (+)
        AND  d.discount_id       (+) = b.discount_id
        AND  b.tracking_id           = gp.TRACKING_ID (+)
        AND  b.TRACKING_ID_SERV      = gp.TRACKING_ID_SERV (+)
        --AND  gp.END_DT is null
        AND  b.bill_ref_no              = r.bill_ref_no (+)
        AND     b.bill_ref_resets         = r.bill_ref_resets (+)
        AND     b.tracking_id             = r.tracking_id (+)
        AND  b.tracking_id_serv         = r.tracking_id_serv (+)
