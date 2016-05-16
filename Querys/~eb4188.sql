select bill_in.periodo Periodo,
       sum(bill_in.qt_in) qt_in,
       sum(bill_out.qt_out) qt_out
 from 
(SELECT  to_char(A.created, 'mm/dd') periodo, 
        count(1) qt_in
           FROM  gvt_no_bill_audit A, cmf C
          WHERE  A.new_no_bill = 1
            AND  A.OLD_NO_BILL = 0
            AND  A.ACCOUNT_NO = C.ACCOUNT_NO
            AND ACCOUNT_CATEGORY IN (9,10,11,12,13,14,15,21,22)
            -- AND  trunc(created) between trunc(sysdate - 30, 'month') and last_day(sysdate - 30)
            AND trunc(created) between trunc(sysdate - 30) and trunc(sysdate)
        GROUP BY  to_char(created, 'mm/dd')) bill_in,
(SELECT  to_char(A.created, 'mm/dd') periodo, 
        count(1) qt_out
           FROM  gvt_no_bill_audit A, cmf C
          WHERE  A.NEW_NO_BILL = 0
            AND  A.OLD_NO_BILL = 1
            AND  A.ACCOUNT_NO = C.ACCOUNT_NO
            AND ACCOUNT_CATEGORY IN (9,10,11,12,13,14,15,21,22)
            -- AND  trunc(created) between trunc(sysdate - 30, 'month') and last_day(sysdate - 30)
            AND trunc(created) between trunc(sysdate - 30) and trunc(sysdate)
        GROUP BY  to_char(created, 'mm/dd')) bill_out
where bill_out.periodo = bill_in.periodo
group by bill_in.periodo
order by bill_in.periodo asc