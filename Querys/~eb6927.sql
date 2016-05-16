       SELECT B.account_no, B.bill_ref_no, B.bill_ref_resets, 
              B.image_done, B.prep_status, 0 , B.file_name, B.start_offset, B.end_offset, B.page_count,
              B.prep_error_code, B.format_error_code, B.backout_status, B.orig_bill_refno,
              B.orig_bill_ref_resets, B.language_code
         FROM BILL_INVOICE B
        WHERE B.account_no IN (SELECT G1.account_no FROM GVT_FEBRABAN_ACCOUNTS G1
                                WHERE B.account_no = G1.account_no
                                  AND G1.version_feed IN (1, 3)
                                  AND G1.inactive_date IS NULL)
          AND NOT EXISTS (SELECT 1 FROM GVT_FEBRABAN_BILL_INVOICE G2
                           WHERE B.bill_ref_no = G2.bill_ref_no
                             AND B.bill_ref_resets = G2.bill_ref_resets)
          AND B.prep_status = 1 AND b.file_name IS NOT NULL;