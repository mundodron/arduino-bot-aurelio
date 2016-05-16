SELECT B.BILL_LNAME || B.BILL_FNAME CLIENTE,
       B.bill_period CICLO,
       A.chg_date DATA,
       DECODE(B.no_bill, 1, 'SIM', 0, 'NAO') NO_BILL,
       B.REMARK
  FROM (SELECT account_no, 
               max(trunc(CHG_DATE)) CHG_DATE
          FROM gvt_no_bill_audit
        GROUP BY account_no) a,
       cmf b
  WHERE A.ACCOUNT_NO = B.ACCOUNT_NO
  AND ACCOUNT_CATEGORY IN (9,10,11,12,13,14,15,21,22)
  AND A.CHG_DATE > trunc(sysdate - 15)
  order by A.CHG_DATE desc