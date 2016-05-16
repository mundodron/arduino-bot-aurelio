select account_no from customer_id_acct_map where external_id in ('999979684777','999979684778','999979684781','999979684779','999979684783','999979684776','999979684775','999979684782','999991426191','999986524242','999983519547')

select account_no, bill_ref_no, file_name from bill_invoice where account_no in (4330340) order by bill_ref_no

select * from gvt_product_velocity where tracking_id in (
select tracking_id from gvt_product_velocity group by tracking_id having count(1) > 1) and end_dt is not null


