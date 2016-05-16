create table chamados_boleto as (
SELECT           t1.account_no,
                       t1.orig_bill_ref_no,
                       max(t1.transact_date) as data
                 FROM service t3,
                      adj_trans_descr t2,
                      adj t1
                WHERE t1.account_no = t3.parent_account_no
                  AND t1.adj_trans_code = t2.adj_trans_code
                  AND t1.transact_date >= trunc(sysdate - 30) -- RFC 272848
                  AND t1.transact_date < trunc(sysdate - 2) -- RFC 272848
                  AND t1.adj_reason_code >= 900
                  AND t1.adj_reason_code <= 999
                  AND t1.request_status = 1
                  AND t2.billing_category = 2
                  AND NOT EXISTS (select 'X'
                         from   gvt_bankslip bol
                         where  bol.bill_ref_no = t1.orig_bill_ref_no
                         and    bol.bill_ref_resets = t1.orig_bill_ref_resets
                         and    BOL.ACCOUNT_NO = T1.ACCOUNT_NO)
                  group by  t1.account_no,t1.orig_bill_ref_no)
              


select * from chamados_boleto where orig_bill_ref_no = 131664353 order by 3 desc