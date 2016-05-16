select * from gvt_no_bill_audit

select count(1)
  from cmf
 where no_bill=1
   and ACCOUNT_CATEGORY IN (9,10,11,12,13,14,15,21,22)
   and exists (select 1 from service where service.parent_account_no = cmf.
      account_no
      and service_inactive_dt is null)
   and not exists (select 1 from gvt_no_bill_audit a where cmf.account_no = a.
      account_no)
  
  -----------------------------------------------------------------
  

/* Formatted on 04/12/2013 18:00:03 (QP5 v5.115.810.9015) */
select count(1)
  from cmf
 where ACCOUNT_CATEGORY IN (9,10,11,12,13,14,15,21,22)
   and exists (select 1 from service where service.parent_account_no = cmf.
      account_no
      and service_inactive_dt is null)
   and (( no_bill = 1 and not exists (select 1 from gvt_no_bill_audit a where
      cmf.account_no = a.account_no) ) or
    exists ( select 1 from gvt_no_bill_audit a
             where a.account_no = cmf.account_no
             and old_no_bill = 1
             and chg_date = ( select min(chg_date) from gvt_no_bill_audit a2
      where a.account_no = a2.account_no )
           )
)


---------------------------------------------
select count(1)
from cmf
where ACCOUNT_CATEGORY IN (9,10,11,12,13,14,15,21,22) and exists (select 1 from service where service.parent_account_no = cmf.account_no and service_inactive_dt is null) and no_bill = 1 and not exists ( select 1 from gvt_no_bill_audit a where cmf.account_no = a.account_no )

select count(1)
from cmf
where ACCOUNT_CATEGORY IN (9,10,11,12,13,14,15,21,22) and exists (select 1 from service where service.parent_account_no = cmf.account_no and service_inactive_dt is null) and exists ( select 1 from gvt_no_bill_audit a
             where a.account_no = cmf.account_no
             and old_no_bill = 1
             and chg_date = ( select min(chg_date) from gvt_no_bill_audit a2 where a.account_no = a2.account_no )
           )

select 41033 + 10597 from dual

---------------------------------------------------


  -- 51630
  -- 51653
  -- 51761
  -- 51761 antes de tudo.
  -- 46516 dia 18 de manhã
  -- 46470 dia 18 a tarde
  -- 46384 dia 18 a noite
  -- 46251 dia 19 de manhã
  -- 45479 dia 20 de manhã
  -- 44354 dia 22 a tarde
  -- 43868 dia 25 a tarde
  -- 43564 dia 26 de manhã
  -- 43138 dia 26 a tarde
  -- 43135 dia 26 a noite
  -- 41204 dia 04 a tarde
  -- 41951
  -- 34300 dia 07/01/2014 a tarde
  select account_no, chg_date
        from cmf
       where no_bill=1
       AND ACCOUNT_CATEGORY IN (9,10,11,12,13,14,15,21,22)
  and exists (select 1 from service where service.parent_account_no = cmf.
      account_no
      and service_inactive_dt is null)
  and not exists (select 1 from gvt_no_bill_audit a where cmf.account_no = a.
      account_no)
  order by 2 desc


select * from gvt_no_bill_audit where account_no = 4044963

select account_no,quem, quando, old_no_bill, new_no_bill, old_remark,
      new_remark
      from gvt_log_cmf
      where account_no = 7868168
      order by 3

select * from gvt_log_cmf where account_no = 4929515 order by 2

7364067 ex: varios no_bill

71781

SELECT  -- to_char(A.created, 'mm/dd') periodo,
        count(1) qt_in
           FROM  gvt_no_bill_audit A, cmf C
          WHERE  c.no_bill = 1
            --AND  A.OLD_NO_BILL = 0
            AND  A.ACCOUNT_NO = C.ACCOUNT_NO
            AND ACCOUNT_CATEGORY IN (9,10,11,12,13,14,15,21,22)
            -- AND  trunc(created) between trunc(sysdate - 30, 'month') and last_day(sysdate - 30)
            -- AND trunc(created) between trunc(sysdate - 30) and trunc(sysdate)


        GROUP BY  to_char(created, 'mm/dd')

        select * from customer_id_acct_map where account_no = 3850934

        select * from gvt_no_bill_audit