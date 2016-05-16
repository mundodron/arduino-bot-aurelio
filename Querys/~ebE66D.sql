/* Formatted on 09/05/2014 14:46:30 (QP5 v5.115.810.9015) */
SELECT   TO_CHAR (NULL),
         TO_CHAR (NULL),
         package_id,
         TO_NUMBER (NULL),
         type_code,
         subtype_code,
         tracking_id,
         tracking_id_serv,
         prep_sequence,
         prorate_code,
         billing_level,
         billing_category,
         amount,
         b.units,
         tax,
         tax_rate,
         tax_pkg_inst_id,
         discount,
         b.discount_id,
         d.description_code,
         trans_date,
         b.provider_id,
         b.element_id,
         n.product_line_id,
         b.description_code,
         subscr_no,
         subscr_no_resets,
         from_date,
         dateadd ('dd', -1, TO_DATE),
         annotation,
         b.profile_id,
         0,
         b.federal_tax,
         b.state_tax,
         b.county_tax,
         b.city_tax,
         b.secondary_amount,
         b.rated_amount,
         b.rate_currency_code,
         b.open_item_id,
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         TO_CHAR (NULL),
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         DECODE (2,
                 1,
                 tracking_date,
                 2,
                 NULL),
         p.description_code,
         b.tax_type_code,
         b.bill_invoice_row,
         DECODE (2,
                 1,
                 tracking_date,
                 2,
                 NULL),
         TO_NUMBER (NULL),
         TO_CHAR (NULL),
         TO_NUMBER (NULL),
         d.discount_level,
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         TO_CHAR (NULL)
  FROM   BILL_INVOICE_DETAIL b,
         PRODUCT_LINES p,
         DISCOUNT_DEFINITIONS d,
         NRC_TRANS_DESCR n
 WHERE       b.bill_ref_no = :p_bill_ref_no
         AND b.bill_ref_resets = :p_bill_ref_resets
         AND b.subtype_code = n.type_id_nrc
         AND b.billing_level = 0
         AND b.product_line_id = p.product_line_id(+)
         AND b.type_code = 3
         AND d.discount_id(+) = b.discount_id
UNION ALL
SELECT   TO_CHAR (NULL),
         TO_CHAR (NULL),
         package_id,
         component_id,
         type_code,
         subtype_code,
         b.tracking_id,
         b.tracking_id_serv,
         prep_sequence,
         prorate_code,
         billing_level,
         billing_category,
         amount,
         b.units,
         tax,
         tax_rate,
         tax_pkg_inst_id,
         discount,
         b.discount_id,
         d.description_code,
         trans_date,
         b.provider_id,
         b.element_id,
         b.product_line_id,
         b.description_code,
         b.subscr_no,
         b.subscr_no_resets,
         from_date,
         dateadd ('dd', -1, TO_DATE),
         annotation,
         b.profile_id,
         0,
         b.federal_tax,
         b.state_tax,
         b.county_tax,
         b.city_tax,
         b.secondary_amount,
         b.rated_amount,
         b.rate_currency_code,
         b.open_item_id,
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         TO_CHAR (NULL),
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         DECODE (2,
                 1,
                 tracking_date,
                 2,
                 NULL),
         p.description_code,
         b.tax_type_code,
         b.bill_invoice_row,
         DECODE (2,
                 1,
                 tracking_date,
                 2,
                 NULL),
         TO_NUMBER (NULL),
         TO_CHAR (NULL),
         TO_NUMBER (NULL),
         d.discount_level,
         DECODE (b.type_code,
                 5, ct1.DESCRIPTION_CODE,
                 6, ct2.DESCRIPTION_CODE,
                 NULL),
         DECODE (b.type_code,
                 5, cc1.TOTAL_PERIODS,
                 6, cc2.TOTAL_PERIODS,
                 NULL),
         DECODE (b.type_code,
                 5, cck1.AVAIL_PERIODS,
                 6, cck2.AVAIL_PERIODS,
                 NULL),
         TO_CHAR (NULL)
  FROM   BILL_INVOICE_DETAIL b,
         CUSTOMER_CONTRACT cc1,
         CUSTOMER_CONTRACT cc2,
         CUSTOMER_CONTRACT_KEY cck1,
         CUSTOMER_CONTRACT_KEY cck2,
         PRODUCT_LINES p,
         DISCOUNT_DEFINITIONS d,
         CONTRACT_TYPES ct1,
         CONTRACT_TYPES ct2
 WHERE       b.bill_ref_no = :p_bill_ref_no
         AND b.bill_ref_resets = :p_bill_ref_resets
         AND b.billing_level = 0
         AND b.product_line_id = p.product_line_id(+)
         AND b.type_code IN (1, 5, 6)
         AND d.discount_id(+) = b.discount_id
         AND (    cc1.tracking_id(+) = b.units
              AND cc1.parent_account_no(+) = :p_account_no
              AND cck1.tracking_id(+) = cc1.tracking_id
              AND cck1.tracking_id_serv(+) = cc1.tracking_id_serv
              AND ct1.contract_type(+) = cc1.contract_type)
         AND (    cc2.tracking_id(+) = b.tracking_id
              AND cc2.parent_account_no(+) = :p_account_no
              AND cck2.tracking_id(+) = cc2.tracking_id
              AND cck2.tracking_id_serv(+) = cc2.tracking_id_serv
              AND ct2.contract_type(+) = cc2.contract_type)
UNION ALL
SELECT   TO_CHAR (NULL),
         TO_CHAR (NULL),
         package_id,
         component_id,
         type_code,
         subtype_code,
         b.tracking_id,
         b.tracking_id_serv,
         prep_sequence,
         prorate_code,
         billing_level,
         billing_category,
         amount,
         b.units,
         tax,
         tax_rate,
         tax_pkg_inst_id,
         discount,
         b.discount_id,
         d.description_code,
         trans_date,
         b.provider_id,
         b.element_id,
         b.product_line_id,
         b.description_code,
         b.subscr_no,
         b.subscr_no_resets,
         from_date,
         dateadd ('dd', -1, TO_DATE),
         annotation,
         b.profile_id,
         0,
         b.federal_tax,
         b.state_tax,
         b.county_tax,
         b.city_tax,
         b.secondary_amount,
         b.rated_amount,
         b.rate_currency_code,
         b.open_item_id,
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         TO_CHAR (NULL),
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         DECODE (2,
                 1,
                 tracking_date,
                 2,
                 NULL),
         p.description_code,
         b.tax_type_code,
         b.bill_invoice_row,
         DECODE (2,
                 1,
                 tracking_date,
                 2,
                 NULL),
         TO_NUMBER (NULL),
         TO_CHAR (NULL),
         TO_NUMBER (NULL),
         d.discount_level,
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         r.region
  FROM   BILL_INVOICE_DETAIL b,
         PRODUCT_LINES p,
         DISCOUNT_DEFINITIONS d,
         GVT_BILL_PRODUCT_RATE_KEY r
 WHERE       b.bill_ref_no = :p_bill_ref_no
         AND b.bill_ref_resets = :p_bill_ref_resets
         AND b.billing_level = 0
         AND b.product_line_id = p.product_line_id(+)
         AND b.type_code = 2
         AND d.discount_id(+) = b.discount_id
         AND b.bill_ref_no = r.bill_ref_no(+)
         AND b.bill_ref_resets = r.bill_ref_resets(+)
         AND b.tracking_id = r.tracking_id(+)
         AND b.tracking_id_serv = r.tracking_id_serv(+)
UNION ALL
SELECT   TO_CHAR (NULL),
         TO_CHAR (NULL),
         b.package_id,
         b.component_id,
         b.type_code,
         b.subtype_code,
         b.tracking_id,
         b.tracking_id_serv,
         b.prep_sequence,
         b.prorate_code,
         b.billing_level,
         b.billing_category,
         b.amount,
         b.units,
         b.tax,
         b.tax_rate,
         b.tax_pkg_inst_id,
         b.discount,
         b.discount_id,
         d.description_code,
         b.trans_date,
         b.provider_id,
         b.element_id,
         b.product_line_id,
         b.description_code,
         b.subscr_no,
         b.subscr_no_resets,
         b.from_date,
         dateadd ('dd', -1, b.TO_DATE),
         b.annotation,
         b.profile_id,
         0,
         b.federal_tax,
         b.state_tax,
         b.county_tax,
         b.city_tax,
         b.secondary_amount,
         b.rated_amount,
         b.rate_currency_code,
         b.open_item_id,
         a.adj_trans_code,
         a.request_status,
         arcv.display_value,
         atd.trans_target_type,
         atd.trans_target_id,
         atd.adj_trans_category,
         a.orig_bill_ref_no,
         a.orig_bill_ref_resets,
         bi.statement_date,
         p.description_code,
         b.tax_type_code,
         b.bill_invoice_row,
         DECODE (2,
                 1,
                 tracking_date,
                 2,
                 NULL),
         a.adj_reason_code,
         a.annotation,
         TO_NUMBER (NULL),
         d.discount_level,
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         TO_CHAR (NULL)
  FROM   BILL_INVOICE_DETAIL b,
         PRODUCT_LINES p,
         ADJ a,
         ADJ_REASON_CODE_VALUES arcv,
         ADJ_TRANS_DESCR atd,
         BILL_INVOICE bi,
         DISCOUNT_DEFINITIONS d
 WHERE       b.bill_ref_no = :p_bill_ref_no
         AND b.bill_ref_resets = :p_bill_ref_resets
         AND b.billing_level = 0
         AND b.product_line_id = p.product_line_id(+)
         AND b.type_code = 4
         AND a.no_bill = 0
         AND b.tracking_id = a.tracking_id
         AND b.tracking_id_serv = a.tracking_id_serv
         AND a.adj_reason_code = arcv.adj_reason_code
         AND arcv.language_code = :p_language_code
         AND a.adj_trans_code = atd.adj_trans_code
         AND bi.bill_ref_no = a.orig_bill_ref_no
         AND bi.bill_ref_resets = a.orig_bill_ref_resets
         AND d.discount_id(+) = b.discount_id
UNION ALL
SELECT   c.external_id,
         m.external_id,
         package_id,
         component_id,
         type_code,
         subtype_code,
         b.tracking_id,
         b.tracking_id_serv,
         prep_sequence,
         prorate_code,
         billing_level,
         billing_category,
         b.amount,
         b.units,
         tax,
         tax_rate,
         tax_pkg_inst_id,
         discount,
         b.discount_id,
         d.description_code,
         trans_date,
         b.provider_id,
         b.element_id,
         b.product_line_id,
         b.description_code,
         b.subscr_no,
         b.subscr_no_resets,
         from_date,
         dateadd ('dd', -1, TO_DATE),
         b.annotation,
         b.profile_id,
         0,
         b.federal_tax,
         b.state_tax,
         b.county_tax,
         b.city_tax,
         b.secondary_amount,
         b.rated_amount,
         b.rate_currency_code,
         b.open_item_id,
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         TO_CHAR (NULL),
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         DECODE (2,
                 1,
                 tracking_date,
                 2,
                 NULL),
         p.description_code,
         b.tax_type_code,
         b.bill_invoice_row,
         bed.trans_dt,
         TO_NUMBER (NULL),
         TO_CHAR (NULL),
         s.parent_account_no,
         d.discount_level,
         DECODE (b.type_code,
                 5, ct1.DESCRIPTION_CODE,
                 6, ct2.DESCRIPTION_CODE,
                 NULL),
         DECODE (b.type_code,
                 5, cc1.TOTAL_PERIODS,
                 6, cc2.TOTAL_PERIODS,
                 NULL),
         DECODE (b.type_code,
                 5, cck1.AVAIL_PERIODS,
                 6, cck2.AVAIL_PERIODS,
                 NULL),
         TO_CHAR (NULL)
  FROM   BILL_INVOICE_DETAIL b,
         CUSTOMER_CONTRACT cc1,
         CUSTOMER_CONTRACT cc2,
         CUSTOMER_CONTRACT_KEY cck1,
         CUSTOMER_CONTRACT_KEY cck2,
         CUSTOMER_ID_ACCT_MAP c,
         SERVICE s,
         CUSTOMER_ID_EQUIP_MAP m,
         PRODUCT_LINES p,
         DISCOUNT_DEFINITIONS d,
         CONTRACT_TYPES ct1,
         CONTRACT_TYPES ct2,
         (  SELECT   bill_invoice_row, MAX (trans_dt) trans_dt
              FROM   CDR_BILLED
             WHERE   bill_ref_no = :p_bill_ref_no
                     AND bill_ref_resets = :p_bill_ref_resets
          GROUP BY   bill_invoice_row) bed
 WHERE       bed.bill_invoice_row(+) = b.bill_invoice_row
         AND b.bill_ref_no = :p_bill_ref_no
         AND b.bill_ref_resets = :p_bill_ref_resets
         AND b.billing_level = 1
         AND b.type_code IN (1, 3, 5, 6, 7)
         AND s.subscr_no = b.subscr_no
         AND s.subscr_no_resets = b.subscr_no_resets
         AND c.account_no = s.parent_account_no
         AND c.external_id_type = :p_EIF_external_id_type
         AND c.is_current = 1
         AND m.subscr_no = b.subscr_no
         AND m.subscr_no_resets = b.subscr_no_resets
         AND m.external_id_type = s.display_external_id_type
         AND m.is_current = 1
         AND b.product_line_id = p.product_line_id(+)
         AND d.discount_id(+) = b.discount_id
         AND (    cc1.tracking_id(+) = b.units
              AND cc1.parent_account_no(+) = :p_account_no
              AND cck1.tracking_id(+) = cc1.tracking_id
              AND cck1.tracking_id_serv(+) = cc1.tracking_id_serv
              AND ct1.contract_type(+) = cc1.contract_type)
         AND (    cc2.tracking_id(+) = b.tracking_id
              AND cc2.parent_account_no(+) = :p_account_no
              AND cck2.tracking_id(+) = cc2.tracking_id
              AND cck2.tracking_id_serv(+) = cc2.tracking_id_serv
              AND ct2.contract_type(+) = cc2.contract_type)
UNION ALL
SELECT   c.external_id,
         m.external_id,
         package_id,
         component_id,
         type_code,
         subtype_code,
         b.tracking_id,
         b.tracking_id_serv,
         prep_sequence,
         prorate_code,
         billing_level,
         billing_category,
         b.amount,
         b.units,
         tax,
         tax_rate,
         tax_pkg_inst_id,
         discount,
         b.discount_id,
         d.description_code,
         trans_date,
         b.provider_id,
         b.element_id,
         b.product_line_id,
         b.description_code,
         b.subscr_no,
         b.subscr_no_resets,
         from_date,
         dateadd ('dd', -1, TO_DATE),
         b.annotation,
         b.profile_id,
         0,
         b.federal_tax,
         b.state_tax,
         b.county_tax,
         b.city_tax,
         b.secondary_amount,
         b.rated_amount,
         b.rate_currency_code,
         b.open_item_id,
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         TO_CHAR (NULL),
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         DECODE (2,
                 1,
                 tracking_date,
                 2,
                 NULL),
         p.description_code,
         b.tax_type_code,
         b.bill_invoice_row,
         DECODE (2,
                 1,
                 tracking_date,
                 2,
                 NULL),
         TO_NUMBER (NULL),
         TO_CHAR (NULL),
         s.parent_account_no,
         d.discount_level,
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         r.region
  FROM   BILL_INVOICE_DETAIL b,
         CUSTOMER_ID_ACCT_MAP c,
         SERVICE s,
         CUSTOMER_ID_EQUIP_MAP m,
         PRODUCT_LINES p,
         DISCOUNT_DEFINITIONS d,
         GVT_BILL_PRODUCT_RATE_KEY r
 WHERE       b.bill_ref_no = :p_bill_ref_no
         AND b.bill_ref_resets = :p_bill_ref_resets
         AND b.billing_level = 1
         AND b.type_code = 2
         AND s.subscr_no = b.subscr_no
         AND s.subscr_no_resets = b.subscr_no_resets
         AND c.account_no = s.parent_account_no
         AND c.external_id_type = :p_EIF_external_id_type
         AND c.is_current = 1
         AND m.subscr_no = b.subscr_no
         AND m.subscr_no_resets = b.subscr_no_resets
         AND m.external_id_type = s.display_external_id_type
         AND m.is_current = 1
         AND b.product_line_id = p.product_line_id(+)
         AND d.discount_id(+) = b.discount_id
         AND b.bill_ref_no = r.bill_ref_no(+)
         AND b.bill_ref_resets = r.bill_ref_resets(+)
         AND b.tracking_id = r.tracking_id(+)
         AND b.tracking_id_serv = r.tracking_id_serv(+)
UNION ALL
SELECT   c.external_id,
         m.external_id,
         b.package_id,
         b.component_id,
         b.type_code,
         b.subtype_code,
         b.tracking_id,
         b.tracking_id_serv,
         b.prep_sequence,
         b.prorate_code,
         b.billing_level,
         b.billing_category,
         b.amount,
         b.units,
         b.tax,
         b.tax_rate,
         b.tax_pkg_inst_id,
         b.discount,
         b.discount_id,
         d.description_code,
         b.trans_date,
         b.provider_id,
         b.element_id,
         b.product_line_id,
         b.description_code,
         b.subscr_no,
         b.subscr_no_resets,
         b.from_date,
         dateadd ('dd', -1, b.TO_DATE),
         b.annotation,
         b.profile_id,
         0,
         b.federal_tax,
         b.state_tax,
         b.county_tax,
         b.city_tax,
         b.secondary_amount,
         b.rated_amount,
         b.rate_currency_code,
         b.open_item_id,
         a.adj_trans_code,
         a.request_status,
         arcv.display_value,
         atd.trans_target_type,
         atd.trans_target_id,
         atd.adj_trans_category,
         a.orig_bill_ref_no,
         a.orig_bill_ref_resets,
         bi.statement_date,
         p.description_code,
         b.tax_type_code,
         b.bill_invoice_row,
         DECODE (2,
                 1,
                 tracking_date,
                 2,
                 NULL),
         a.adj_reason_code,
         a.annotation,
         s.parent_account_no,
         d.discount_level,
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         TO_NUMBER (NULL),
         TO_CHAR (NULL)
  FROM   BILL_INVOICE_DETAIL b,
         CUSTOMER_ID_ACCT_MAP c,
         SERVICE s,
         CUSTOMER_ID_EQUIP_MAP m,
         PRODUCT_LINES p,
         ADJ a,
         ADJ_REASON_CODE_VALUES arcv,
         ADJ_TRANS_DESCR atd,
         BILL_INVOICE bi,
         DISCOUNT_DEFINITIONS d
 WHERE       b.bill_ref_no = :p_bill_ref_no
         AND b.bill_ref_resets = :p_bill_ref_resets
         AND b.billing_level = 1
         AND b.type_code = 4
         AND s.subscr_no = b.subscr_no
         AND s.subscr_no_resets = b.subscr_no_resets
         AND c.account_no = s.parent_account_no
         AND c.external_id_type = :p_EIF_external_id_type
         AND c.is_current = 1
         AND m.subscr_no = b.subscr_no
         AND m.subscr_no_resets = b.subscr_no_resets
         AND m.external_id_type = s.display_external_id_type
         AND m.is_current = 1
         AND b.product_line_id = p.product_line_id(+)
         AND a.no_bill = 0
         AND b.tracking_id = a.tracking_id
         AND b.tracking_id_serv = a.tracking_id_serv
         AND a.adj_reason_code = arcv.adj_reason_code
         AND arcv.language_code = :p_language_code
         AND a.adj_trans_code = atd.adj_trans_code
         AND bi.bill_ref_no(+) = a.orig_bill_ref_no
         AND bi.bill_ref_resets(+) = a.orig_bill_ref_resets
          AND d.discount_id(+) = b.discount_id;
          
          
          
          select * from GVT_PRODUCT_VELOCITY where  TRACKING_ID in (98648622,36427726,36427727,36427728,37255953,36427725,36264760,36427850,36427819,36427843,36428069,40944538,36427828,36427824,36428068,36427752,36427762,37255986,77548708,77548670,77548750,77548625,77548686,77548658,77549011,36427761,36427751,37255985,77786370,77548669,77548687,77548749)
          
          and END_DT is not null;
          
          delete GVT_PRODUCT_VELOCITY where TRACKING_ID in (37255986,37255985) and END_DT is not null;