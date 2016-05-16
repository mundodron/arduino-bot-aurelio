select * from customer_id_acct_map where external_id = '999979750763'

select account_no,bill_ref_no  from bill_invoice where bill_ref_no = 199330702

           select p.*,
           (select tira_acento(description_text) from descriptions dt where dt.description_code = P.ELEMENT_ID and dt.language_code = 2) "PRODUTO"                  
             from product p
            where p.billing_account_no = 