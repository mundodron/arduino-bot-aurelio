      SELECT 
             p.product_line_id,      p.type_group_usg,    d.provider_id,      b.type_id_usg,     a.external_id,
             m.external_id,          t.description_code,  b.trans_dt,         b.point_target,    u.point_city,
             b.point_origin,         u1.point_city,       d.amount,           d.base_amt,        b.subscr_no,
             d.primary_units,        pl.description_code, rpv.display_value,  d.jurisdiction,    d.bill_class,
             d.external_id,          d.corridor_plan_id,  d.amount_reduction, b.amount_credited, d.trans_id,
             d.second_units,         d.annotation,        j.description_code, d.rate_period,     d.billing_units_type,
             d.rated_units,          d.rate_class,        b.bill_invoice_row, d.element_id,      b.units_credited,
             c.description_febraban, d.open_item_id,      rpad(spr.amex_descriptor,19, ' '),     c.COD_CATEGORIA, c.SHORT_DESCRIPTION_TEXT
      FROM   CDR_BILLED b, CDR_DATA d, PRODUCT_ELEMENTS p, CUSTOMER_ID_EQUIP_MAP m, SERVICE S, CUSTOMER_ID_ACCT_MAP a, USAGE_TYPES t,
             USAGE_POINTS u, USAGE_POINTS u1,    RATE_PERIOD_VALUES rpv,  PRODUCT_LINES pl, JURISDICTIONS j, GVT_FEBRABAN_CATEGORIA c,
             SERVICE_PROVIDERS_REF spr
      WHERE  b.bill_ref_no            = :p_bill_ref_no
        AND  b.bill_ref_resets        = :p_bill_ref_resets
        AND  d.amount                != 0
        AND  b.msg_id                = d.msg_id
        AND  b.msg_id2               = d.msg_id2
        AND  b.msg_id_serv           = d.msg_id_serv
        AND  b.split_row_num         = d.split_row_num
        AND  b.cdr_data_partition_key= d.cdr_data_partition_key
        AND  d.provider_id           = spr.provider_id
        AND  p.element_id            = d.element_id
        AND  t.type_id_usg           = b.type_id_usg
        AND  d.point_id_target       = u.point_id (+)
        AND  d.point_id_origin       = u1.point_id (+)
        AND  s.subscr_no             = b.subscr_no
        AND  s.subscr_no_resets      = b.subscr_no_resets
        AND  m.subscr_no             = b.subscr_no
        AND  m.subscr_no_resets      = b.subscr_no_resets
        AND  m.external_id_type      = :p_EIF_external_id_type_subscr
        AND  m.is_current            = 1
        AND  s.parent_account_no     = a.account_no
        AND  a.external_id_type      = :p_EIF_external_id_type
        AND  a.is_current            = 1
        AND  d.rate_period           = rpv.rate_period    (+)
        AND  rpv.language_code   (+) = :p_language_code
        AND  p.product_line_id       = pl.product_line_id (+)
        AND  d.jurisdiction          = j.jurisdiction     (+)
        AND  c.description_code (+)  = t.description_code
      ORDER  BY b.subscr_no, b.subscr_no_resets, p.product_line_id;

select * from bill_invoice where bill_ref_no = 244013133

select * from gvt_febraban_accounts where external_id = '999983221995'

