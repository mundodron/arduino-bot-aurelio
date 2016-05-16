    select external_id CONTA_COBRANCA, ciam.account_no ACCOUNT_NO, bill_ref_no FATURA_ATUAL, b.payment_due_date VCTO_FAT_ATUAL, 
            ( select sum(amount + federal_tax)/100
              from bill_invoice_detail bid
              where bid.bill_ref_no = b.bill_ref_no
              and bid.bill_ref_resets = b.bill_ref_resets
              and bid.type_code in (2,3,7)
            ) VALOR_FAT_ATUAL,
            ( select sum(amount + federal_tax)/100
              from bill_invoice_detail bid
              where bid.bill_ref_no = b.bill_ref_no
              and bid.bill_ref_resets = b.bill_ref_resets
              and bid.type_code = 3
              and subtype_code in (12500, 12501)
            ) VALOR_JUROS_MULTA_FAT_ATUAL 
    from bill_invoice b, customer_id_acct_map ciam
    where b.prep_status = 4
    and b.PREP_DATE > sysdate - 5
    and b.bill_period = 'M02' --- <<< alterar o ciclo >>>
    and b.PREP_ERROR_CODE is null
    and exists ( select 1 from cmf c
                 where c.account_no = b.account_no
                 and c.account_category in (10,11) )
    and ciam.account_no = b.account_no
    and ciam.external_id_type = 1
    and exists ( select 1 from bill_invoice_detail bid
                 where b.bill_ref_no = bid.bill_ref_no
                 and b.bill_ref_resets = bid.bill_ref_resets
                 and subtype_code in (12500, 12501) )
    and external_id = '999985455833';