create table baixa_campanha (
   account_no      NUMBER (10),
   bill_ref_no     NUMBER (10), 
   balance_due     NUMBER (18), 
   NEW_CHARGES     NUMBER (18), 
   closed_date     DATE, 
   PPDD_DATE       DATE, 
   BILL_REF_RESETS NUMBER (3)
);

grant all on baixa_campanha to public;