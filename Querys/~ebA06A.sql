create table gvt_sempreloc_full as

select /*+ parallel (c 30)*/ a.msg_id,a.msg_id2,a.msg_id_serv,a.account_no,a.type_id_usg,a.rate_dt,a.trans_dt,a.point_origin,a.point_target,a.point_id_target,a.element_id,
a.seqnum_rate_usage,a.open_item_id,a.no_bill,a.annotation,b.subscr_no,b.bill_ref_no,b.billed_amount,b.units_credited,b.amount_credited,b.unit_cr_id,b.discount,b.discount_id,
a.equip_class_code,a.rate_period,a.rated_units,a.primary_units
from cdr_data a,cdr_billed b,g0201723sql.gvt_faturas_marco_sempre c
where c.account_no=b.account_no
  and c.bill_ref_no=b.bill_ref_no
  and c.bill_ref_resets=b.bill_ref_resets
  and a.msg_id=b.msg_id
  and a.msg_id2=b.msg_id2
  and a.msg_id_serv=b.msg_id_serv
  and a.cdr_data_partition_key=b.cdr_data_partition_key
  and a.split_row_num=b.split_row_num
  and a.element_id=10333
  and b.type_id_usg=288; 