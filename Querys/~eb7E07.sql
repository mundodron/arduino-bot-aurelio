select account_no, max(bill_ref_no) faturas from cmf_balance where account_no in (3857503,7374426,4463548,3858364,3857518)
group by account_no

select account_no, bill_ref_no from cmf_balance where bill_ref_no in (156539135,153399339,150574910,147624521,156540115,153410714,150605354,147639921,156522131,153347724,150337122,147425742)

Insert into CONTAFACIL_CORP
   (ACCOUNT_NO, BILL_REF_NO)
 Values
   (4463548, 138833903);