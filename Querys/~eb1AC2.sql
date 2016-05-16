select * from gvt_bankslip where bill_ref_no in (select bill_ref_no from g0013798sql.DQ_BOLETO_NAO_GERADO where status = 0)
and status = 'D'

select * from gvt_bankslip where status = 'D'


select * from gvt_bankslip where bill_ref_no in (select bill_ref_no from g0013798sql.DQ_BOLETO_NAO_GERADO where status = 0)
and bill_ref_no = 133710179
