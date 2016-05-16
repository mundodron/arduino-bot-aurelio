select * from GVT_NRC_INVALIDA where status in (select account_no from customer_id_acct_map)

select * from cmf_balance where bill_ref_no in (select fatura from GVT_NRC_INVALIDA where fatura not in ('3963180','3908520','3831038','3845330','3750814','3750215','2859136','3308069','3142439','2917240','3360442','2291382','2530360','2461816','2575966','3380088')) and closed_date is null

