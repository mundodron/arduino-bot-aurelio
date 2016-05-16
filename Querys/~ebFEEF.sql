    Select bill_period --into AUX_CICLO
    from bill_cycle where bill_period like 'M%' and prep_date = (Select max(prep_date) from bill_cycle where bill_period like 'M%' and prep_date <= sysdate);
    
    Select *
      from bill_cycle a 
     where prep_date >= sysdate;