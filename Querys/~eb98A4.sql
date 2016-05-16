select  --ci.external_id,
        c.account_no
        --c.bill_ref_no fatura
        --c.NEW_CHARGES,
        --to_date ('22/10/2011','dd/mm/yyyy') dt_baixa
 from  cmf_balance c, 
       customer_id_acct_map ci
where  c.account_no = ci.account_no
  and  ci.external_id_type = 1
  and  C.BILL_REF_NO in (101321554,101300908,101323966,101326979,101320566,99888928,101451248,101323171,101323994,101326727,101323182,101326929,101453056)
  and  ci.external_id in ('999988922396','777777759965','999989496783','999989352093','777777768970','999983901744','999992783911','999989333672','999993603997','999986291405','999990509753','999985366561','999993494716')