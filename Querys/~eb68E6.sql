
select  external_id,
        account_no,
        data_primeiro_no_bill,
        data_ultimo_no_bill,
        ( select tb4.new_no_bill from gvt_no_bill_audit tb4 where query1.account_no = tb4.account_no and tb4.created = query1.data_ultimo_no_bill) ultimo_no_bill,
        categoria,
        estado,
        ciclo
from    (
select  tb3.external_id         external_id,
        tb2.account_no          account_no,
        min(tb1.created)        data_primeiro_no_bill,
        max(tb1.created)        data_ultimo_no_bill,
        tb2.account_category    categoria,
        tb2.bill_state          estado,
        tb2.bill_period         ciclo
from    gvt_no_bill_audit       tb1,
        cmf                     tb2,
        customer_id_acct_map    tb3
where   tb1.account_no = tb2.account_no
and     tb2.account_no = tb3.account_no
and     tb3.external_id_type = 1        
group by
        tb3.external_id,
        tb2.account_no,
        tb2.account_category,
        tb2.bill_state,
        tb2.bill_period
)  query1    