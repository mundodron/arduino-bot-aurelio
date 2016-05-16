select * from customer_id_acct_map where external_id = '899998500563'

select cmf.cust_state, cmf.bill_state from cmf where account_no = 8551415

select rowid, a.* from cmf a where account_no = 8551415

select SB.PARENT_ACCOUNT_NO, vl.* 
  from service_billing sb, equip_class_code_values vl
 where sb.parent_account_no = 8551415
   and VL.EQUIP_CLASS_CODE = SB.EQUIP_CLASS_CODE
   and VL.LANGUAGE_CODE = 2
   
select * from local_address

select * from service_address_assoc


