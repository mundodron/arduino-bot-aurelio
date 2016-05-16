/*
Em PBct2 houve o seguinte erro. 
Não executado o delete do chamado em pbcat:
ERRO NA FATURA 145414262-ORA-20033: 20007, Failure updating balance
ORA-06512: at "ARBOR.BMF_INSERT", line 522
ORA-20033: ORA-20033: ORA-20033: ORA-20001: 147004, TRIG: UPDATE Failed: balance_due cannot be negative for non-zero invoices.
ORA-06512: at "ARBOR.CMF_BALANCE_RTRIG", line 33
ORA-04088: error during execution of trigger 'ARBOR.CMF_BALANCE_RTRIG'
ORA-06512: at "ARBOR.BMF_DISTRIBUTION_INSERT", line 150
ORA-20001: 147004, TRIG: UPDATE Failed: balance_due cannot be negative for non-zero invoices.
ORA-06512: at "ARBOR.CMF_BA
*/
select * from cmf_balance where bill_ref_no = 145414262

select * from cmf_balance where account_no = 7662073 

select * from bmf where account_no = 7662073 and orig_bill_ref_no = 145414262

              select  account_no, closed_date, bill_ref_no, BILL_REF_RESETS
                 --into v_acct,  v_dt_fechamento, v_bill_ref_no, v_BILL_REF_RESETS
                 from cmf_balance 
                where bill_ref_no = 145414262
                  and NOT EXISTS
                         (SELECT * 
                            FROM bmf
                           WHERE account_no = 7662073
                             and orig_bill_ref_no = 145414262
                             and trunc(chg_date) = trunc(sysdate));