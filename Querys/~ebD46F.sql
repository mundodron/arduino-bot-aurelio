-- Relatórios_NO_BILL_Comparativo.xlsx

select bill_in.periodo Periodo,
       sum(bill_in.qt_in) qt_in,
       sum(bill_out.qt_out) qt_out
 from 
(SELECT  to_char(A.created, 'mm/dd') periodo, 
        count(1) qt_in
           FROM  gvt_no_bill_audit A, cmf C
          WHERE  A.new_no_bill = 1
            AND  A.ACCOUNT_NO = C.ACCOUNT_NO
            AND ACCOUNT_CATEGORY IN (9,10,11,12,13,14,15,21,22)
            -- AND  trunc(created) between trunc(sysdate - 30, 'month') and last_day(sysdate - 30)
            AND trunc(created) between trunc(sysdate - 30) and trunc(sysdate)
        GROUP BY  to_char(created, 'mm/dd')) bill_in,
(SELECT  to_char(A.created, 'mm/dd') periodo, 
        count(1) qt_out
           FROM  gvt_no_bill_audit A, cmf C
          WHERE  A.new_no_bill = 0
            AND  A.ACCOUNT_NO = C.ACCOUNT_NO
            AND ACCOUNT_CATEGORY IN (9,10,11,12,13,14,15,21,22)
            -- AND  trunc(created) between trunc(sysdate - 30, 'month') and last_day(sysdate - 30)
            AND trunc(created) between trunc(sysdate - 30) and trunc(sysdate)
        GROUP BY  to_char(created, 'mm/dd')) bill_out
where bill_out.periodo = bill_in.periodo
group by bill_in.periodo
order by bill_in.periodo asc

----------------------------------------------------------
-- Relatórios_NO_BILL_Analitico.xlsx

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
  
----------------------------------------------------------
-- Relatórios_NO_BILL_30_dias.xlsx

SELECT  NO_BILL_IN.bill_period,
        NO_BILL_IN.periodo,
        NO_BILL_IN.qt_in qt_in,
        NO_BILL_OUT.qt_out qt_out
FROM    (SELECT  A.bill_period,
        to_char(A.created, 'mm/yyyy') periodo, 
        count(1)                     qt_in
           FROM  gvt_no_bill_audit A, cmf C
          WHERE  A.new_no_bill = 1
            AND  A.ACCOUNT_NO = C.ACCOUNT_NO
            AND  C.ACCOUNT_CATEGORY IN (9,10,11,12,13,14,15,21,22)
            AND  A.created between trunc(sysdate - 30, 'month') and last_day(sysdate - 30)
       GROUP BY  A.bill_period, to_char(created, 'mm/yyyy')
       ORDER BY  A.bill_period) NO_BILL_IN,
       (SELECT  A.bill_period,
        to_char(A.created, 'mm/yyyy') periodo, 
        count(1)                     qt_out
           FROM  gvt_no_bill_audit A, cmf C
          WHERE  A.new_no_bill = 0
            AND  A.OLD_NO_BILL = 1
            AND  A.ACCOUNT_NO = C.ACCOUNT_NO
            AND  C.ACCOUNT_CATEGORY IN (9,10,11,12,13,14,15,21,22)
            AND  A.created between trunc(sysdate - 30, 'month') and last_day(sysdate - 30)
       GROUP BY  A.bill_period, to_char(created, 'mm/yyyy')
       ORDER BY  A.bill_period) NO_BILL_OUT
  where NO_BILL_IN.bill_period = NO_BILL_OUT.bill_period
  order by bill_period
