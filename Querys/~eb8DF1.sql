            SELECT /*+ RULE */
                   * --chg_date
              --INTO v_bmf_chg_date
              FROM bmf
             WHERE account_no in (select account_no from cmf_balance where bill_ref_no in (select fatura from chamados))--r_adj.account_no
               AND orig_bill_ref_no in (select fatura from chamados)-- = r_adj.orig_bill_ref_no
               AND orig_bill_ref_resets = 0 --= r_adj.orig_bill_ref_resets
               AND TRUNC (chg_date) <= sysdate
               AND bmf_trans_type not in (SELECT DISTINCT BMF_TRANS_TYPE_PGTO FROM GVT_DEPARA_AJUSTE_MASSIVO WHERE UPPER(DESCRIPTION_PGTO) LIKE 'BOLETO%') --RFC 377831
               AND bmf_trans_type <> -98
               AND bmf_trans_type <> -4;
               
               
               
               select * from gvt_bankslip