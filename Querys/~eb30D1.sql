select ci.external_id conta,
                            c.account_no,
                            c.bill_ref_no fatura,
                            b.valor,
                            to_date ('22/10/2011','dd/mm/yyyy') dt_baixa
                    from  g0023421sql.gvt_rajadas b, 
                          cmf_balance c, 
                          customer_id_acct_map ci
                    where  b.BILL_REF_NO = c.BILL_REF_NO
                    and    c.account_no = ci.account_no
                    and    ci.external_id_type = 1
                    and    b.external_id in ('999985180922','999985565819','999987077251','999987756342','999988319670','999989393026','999989498156','999989517477','999990535694','999990791857')