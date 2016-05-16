SELECT bit.bill_invoice_row, bit.tax_pkg_inst_id, bit.geocode,   bit.federal_tax,       bit.state_tax,
             bit.county_tax,       bit.city_tax,        bit.other_tax, bit.tax_type_code ttc, bit.tax_rate r,
             bid.amount,           bid.discount,        bid.tax,       bid.type_code,         bid.billing_category,
             decode(bid.type_code, 4, a.adj_reason_code, NULL), decode(bid.type_code, 4, a.orig_bill_ref_no, NULL),
             bid.provider_id,             GVT_REDBC_ICMS(bit.bill_ref_no, bit.bill_ref_resets, bit.bill_invoice_row,bit.tax_pkg_inst_id)
      FROM   BILL_INVOICE_TAX bit, BILL_INVOICE_DETAIL bid, ADJ a
      WHERE  bid.bill_ref_no           = &p_bill_ref_no
        AND  bid.bill_ref_resets       = &p_bill_ref_resets
        AND  bid.type_code             != 5
        AND  bid.tracking_id           = a.tracking_id      (+)
        AND  a.no_bill             (+) = 0
        AND  bit.bill_ref_no           = bid.bill_ref_no
        AND  bit.bill_ref_resets       = bid.bill_ref_resets
        AND  bit.bill_invoice_row      = bid.bill_invoice_row
      UNION ALL
      SELECT bid.bill_invoice_row, bid.tax_pkg_inst_id, bid.geocode,   bid.federal_tax,       bid.state_tax,
             bid.county_tax,       bid.city_tax,        bid.other_tax, bid.tax_type_code ttc, bid.tax_rate r,
             bid.amount,           bid.discount,        bid.tax,       bid.type_code,         bid.billing_category,
             decode(bid.type_code, 4, a.adj_reason_code, NULL), decode(bid.type_code, 4, a.orig_bill_ref_no, NULL),
             bid.provider_id,             0
      FROM   BILL_INVOICE_DETAIL bid, ADJ a
      WHERE  bid.bill_ref_no           = &p_bill_ref_no
        AND  bid.bill_ref_resets       = &p_bill_ref_resets
        AND  bid.tax_pkg_inst_id       > 0
        AND  bid.type_code             != 5
        AND  bid.tracking_id           = a.tracking_id      (+)
        AND  a.no_bill             (+) = 0
      ORDER  BY r, ttc