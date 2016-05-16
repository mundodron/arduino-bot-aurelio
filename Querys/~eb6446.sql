-- drop table gvt_sempreloc_full;

-- grant all on gvt_sempreloc_full to public

create table gvt_sempreloc_full as
SELECT /*+ parallel (c 30)*/
         a.msg_id,
         a.msg_id2,
         a.msg_id_serv,
         a.account_no,
         a.type_id_usg,
         a.rate_dt,
         a.trans_dt,
         a.point_origin,
         a.point_target,
         a.point_id_target,
         a.element_id,
         a.seqnum_rate_usage,
         a.open_item_id,
         a.no_bill,
         a.annotation,
         b.subscr_no,
         b.bill_ref_no,
         b.billed_amount,
         b.units_credited,
         b.amount_credited,
         b.unit_cr_id,
         b.discount,
         b.discount_id,
         a.equip_class_code,
         a.rate_period,
         a.rated_units,
         a.primary_units,
         c.bill_period,
         A.JURISDICTION
  FROM   cdr_data a,
         cdr_billed b,
         (  SELECT   bill.account_no, bill.bill_ref_no, bill.bill_ref_resets, bill.bill_period
              FROM   bill_invoice bill, cmf_package_component comp
             WHERE   prep_Date BETWEEN TO_DATE ('01/04/2014 00:00:00','dd/mm/yyyy hh24:mi:ss')
                                   AND  TO_DATE ('30/04/2014 23:59:59','dd/mm/yyyy hh24:mi:ss')
                     AND bill.bill_period = 'M15'
                     AND BILL.ACCOUNT_NO = comp.PARENT_ACCOUNT_NO
                     AND comp.component_id IN (30491)
                     AND bill.prep_status = 1
                     AND bill.prep_error_code IS NULL
          GROUP BY   bill.account_no, bill.bill_ref_no, bill.bill_ref_resets, bill.bill_period) c
 WHERE   c.account_no = b.account_no
         AND c.bill_ref_no = b.bill_ref_no
         AND c.bill_ref_resets = b.bill_ref_resets
         AND a.msg_id = b.msg_id
         AND a.msg_id2 = b.msg_id2
         AND a.msg_id_serv = b.msg_id_serv
         AND a.cdr_data_partition_key = b.cdr_data_partition_key
         AND a.split_row_num = b.split_row_num
         AND a.element_id = 10333
         AND b.type_id_usg in (288, 274, 276);

-- select * from gvt_sempreloc_full

-- select jurisdiction, count(1) from gvt_sempreloc_full group by jurisdiction