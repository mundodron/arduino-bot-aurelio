     SELECT *
       FROM bill_invoice a, contafacil_corp b
      WHERE 1 =1 --a.account_no = v_cliente 
        AND a.prep_status = 1
        AND a.prep_error_code is null
        AND backout_status = '0'
        AND format_error_code IS NULL
        AND a.bill_ref_no = b.bill_ref_no
        AND a.account_no = b.account_no;
        
        
        select * from cmf_balance where bill_ref_no = 143494431
        
        select * from GVT_HISTORY_EIF where account_no = 2826277 and bill_ref_no = 143494431
        
        select * from bmf where account_no = 2826277 and orig_bill_ref_no = 143494431
        
        select * from bill_invoice_detail where bill_ref_no = 143494431