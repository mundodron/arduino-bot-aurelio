  SELECT DISTINCT
             s.subscr_no si,        s.subscr_no_resets sir,       service_name_pre,      service_fname,      service_minit,
             service_lname,         m.external_id,                null  ext_id_v  ,      address_1,           address_2,
             address_3,              service_company,              city,                   county,             state,
             postal_code,              ccv.display_value,            s.parent_account_no,  r.description_code, s.service_name_generation,
             sb.service_geocode,     sb.service_franchise_tax_code,cfg.display_value,     c.short_display,    s.service_active_dt,
             s.service_inactive_dt, rec.recurso,                  cfg.short_display,     pb.degrau degrau,   pb.cnla cnla,
             pb.velocidade vel,     pb.unid_velocidade unid_vel,  pb.cnlb cnlb,          pb.address_b addrb, pb.number_b nb,
             pb.compl_b cb,         pb.district_b bairro,         pb.phone_number
      FROM   BILL_INVOICE b, SIN_SEQ_NO ssn, SERVICE s, CUSTOMER_ID_EQUIP_MAP m, COUNTRY_CODE_VALUES ccv, EMF_CONFIG_ID_VALUES cfg, 
             EQUIP_CLASS_CODE_VALUES c, RATE_CLASS_DESCR r, GVT_FEBRABAN_RECURSOS rec, GVT_FEBRABAN_PONTA_B_ARBOR pb, 
             SERVICE_BILLING sb, LOCAL_ADDRESS l, Service_Address_Assoc saa
      WHERE  b.bill_ref_no              = :p_Orig_bill_refno
        AND  b.bill_ref_resets          = :p_Orig_bill_ref_resets
        AND  ssn.bill_ref_no            = b.bill_ref_no
        AND  ssn.bill_ref_resets        = b.bill_ref_resets
        AND  s.parent_account_no        = b.account_no 
        AND  s.parent_account_no        = saa.account_no
        AND  s.subscr_no                = saa.subscr_no
        AND  s.subscr_no_resets         = saa.subscr_no_resets
        AND  l.address_id               = saa.address_id
        AND  DECODE(ssn.open_item_id,0,1,ssn.open_item_id) in 
                     ( SELECT distinct open_item_id 
                                 FROM bill_invoice_detail
                             WHERE bill_ref_no = b.bill_ref_no
                               AND bill_ref_resets = b.bill_ref_resets
                               AND TYPE_CODE != 5
                               AND subscr_no = s.subscr_no
                     )                           
        AND  m.subscr_no                = s.subscr_no
        AND  m.subscr_no_resets         = s.subscr_no_resets
        AND  m.subscr_no                = sb.subscr_no
        AND  m.subscr_no_resets         = sb.subscr_no_resets
        AND  m.external_id_type         = s.display_external_id_type
        AND  m.is_current               = 1
        AND  m.external_id              = pb.emf_ext_id       
        AND  l.country_code             = ccv.country_code     (+)
        AND  ccv.language_code (+)      = :p_language_code
        AND  m.external_id_type         != 6
        AND  s.emf_config_id            = cfg.emf_config_id    (+)
        AND  cfg.language_code (+)      = :p_language_code
        AND  sb.equip_class_code        = c.equip_class_code   (+)
        AND  c.language_code   (+)      = :p_language_code
        AND  s.rate_class               = r.rate_class
        AND  s.emf_config_id            = rec.emf_config_id    (+)
        AND  rec.language_code (+)      = :p_language_code                    
      UNION ALL      
      SELECT DISTINCT
             s.subscr_no si,        s.subscr_no_resets sir,       service_name_pre,      service_fname,      service_minit,
             service_lname,         m.external_id,                null ext_id_v   ,     address_1,           address_2,
             address_3,              service_company,              city,                  county,             state,
             postal_code,                ccv.display_value,            s.parent_account_no,  r.description_code, s.service_name_generation,
             sb.service_geocode,     sb.service_franchise_tax_code,cfg.display_value,     c.short_display,    s.service_active_dt,
             s.service_inactive_dt, rec.recurso,                  cfg.short_display,     NULL degrau,        NULL cnla,
             0 vel,                 NULL unid_vel,                NULL cnlb,             NULL addrb,         NULL nb,
             NULL cb,               NULL bairro,                  NULL phone_number
      FROM   BILL_INVOICE b, SIN_SEQ_NO ssn, SERVICE s, CUSTOMER_ID_EQUIP_MAP m, COUNTRY_CODE_VALUES ccv, EMF_CONFIG_ID_VALUES cfg, 
             EQUIP_CLASS_CODE_VALUES c, RATE_CLASS_DESCR r, GVT_FEBRABAN_RECURSOS rec, SERVICE_BILLING sb, LOCAL_ADDRESS l, Service_Address_Assoc saa
      WHERE  b.bill_ref_no              = :p_Orig_bill_refno
        AND  b.bill_ref_resets          = :p_Orig_bill_ref_resets
        AND  ssn.bill_ref_no            = b.bill_ref_no
        AND  ssn.bill_ref_resets        = b.bill_ref_resets
        AND  s.parent_account_no        = b.account_no 
        AND     s.parent_account_no     = saa.account_no
        AND     s.subscr_no             = saa.subscr_no
        AND  s.subscr_no_resets         = saa.subscr_no_resets
        AND     l.address_id            = saa.address_id
        AND  decode(ssn.open_item_id,0,1,ssn.open_item_id) in 
                     ( SELECT distinct open_item_id 
                                 FROM bill_invoice_detail
                             WHERE bill_ref_no = b.bill_ref_no
                               AND bill_ref_resets = b.bill_ref_resets
                               AND TYPE_CODE != 5
                               AND subscr_no = s.subscr_no
                     )                           
        AND  m.subscr_no                = s.subscr_no
        AND  m.subscr_no_resets         = s.subscr_no_resets
        AND  m.subscr_no                = sb.subscr_no
        AND  m.subscr_no_resets         = sb.subscr_no_resets
        AND  m.external_id_type         = s.display_external_id_type
        AND  m.is_current               = 1
        AND  l.country_code             = ccv.country_code     (+)
        AND  ccv.language_code (+)      = :p_language_code
        AND  s.emf_config_id            = cfg.emf_config_id    (+)
        AND  cfg.language_code (+)      = :p_language_code
        AND  m.external_id_type         in (6,8)
        AND  sb.equip_class_code        = c.equip_class_code   (+)
        AND  c.language_code   (+)      = :p_language_code
        AND  s.rate_class               = r.rate_class
        AND  s.emf_config_id            = rec.emf_config_id    (+)
        AND  rec.language_code (+)      = :p_language_code
      ORDER  BY si, sir;