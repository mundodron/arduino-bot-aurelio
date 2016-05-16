      SELECT DISTINCT
             s.subscr_no,           s.subscr_no_resets,               service_name_pre,          service_fname,          service_minit,
             service_lname,         m.external_id,                    ext.display_value,         address_1,                       address_2,
             address_3,                      service_company,                  city,                              county,                         state,
             postal_code,                    ccv.display_value,                s.parent_account_no,  r.description_code,     s.service_name_generation,
             sb.service_geocode,     sb.service_franchise_tax_code,     cfg.display_value,         c.short_display,        s.display_external_id_type,
             billed_serv_inst.subscr_no
      FROM   BILL_INVOICE b, SERVICE s, SERVICE_BILLING sb, CUSTOMER_ID_EQUIP_MAP m, COUNTRY_CODE_VALUES ccv, EXTERNAL_ID_TYPE_VALUES ext,
             EMF_CONFIG_ID_VALUES cfg, EQUIP_CLASS_CODE_VALUES c, RATE_CLASS_DESCR r, LOCAL_ADDRESS la, SERVICE_ADDRESS_ASSOC saa, 
                       ( SELECT DISTINCT subscr_no
                           FROM BILL_INVOICE_DETAIL bid, BILL_INVOICE bi
                             WHERE bi.BILL_REF_NO = 196711949
                                  AND bi.BILL_REF_RESETS = 0
                               AND bid.BILL_REF_NO = bi.BILL_REF_NO
                               AND bid.BILL_REF_RESETS = bi.BILL_REF_RESETS
                               AND bid.TYPE_CODE in (2,3)
                       ) billed_serv_inst      
      WHERE  b.bill_ref_no              = 196711949
        AND  b.bill_ref_resets          = 0
        AND  s.parent_account_no        = b.account_no
        AND  s.parent_account_no        = saa.account_no
        AND     s.subscr_no             = saa.subscr_no
        AND     s.subscr_no_resets      = saa.subscr_no_resets
        AND  s.parent_account_no        = sb.parent_account_no
        AND  m.subscr_no                = saa.subscr_no
        AND  m.subscr_no_resets         = saa.subscr_no_resets
        AND  la.address_id              = saa.address_id
        AND  m.subscr_no                = s.subscr_no
        AND  m.subscr_no_resets         = s.subscr_no_resets
        AND  sb.subscr_no               = s.subscr_no
        AND  sb.subscr_no_resets        = s.subscr_no_resets
        AND  m.external_id_type         = s.display_external_id_type
        AND  m.is_current               = 1
        AND  la.country_code                 = ccv.country_code     (+)
        AND  ccv.language_code (+)      = 2
        AND  s.display_external_id_type = ext.external_id_type (+)
        AND  ext.language_code (+)      = 2
        AND  s.emf_config_id            = cfg.emf_config_id    (+)
        AND  cfg.language_code (+)      = 2
        AND  sb.equip_class_code        = c.equip_class_code   (+)
        AND  c.language_code   (+)      = 2
        AND  s.rate_class                   = r.rate_class
    AND  billed_serv_inst.subscr_no (+)    = s.subscr_no 
      ORDER  BY m.external_id, s.subscr_no, s.subscr_no_resets;
