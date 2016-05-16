declare
    conta  integer; -- cmf_balance.account_no%type;
    last_bill integer;
    ttal_due integer;
    cmfb_due  integer;
    cmptd_blnc  integer;
    valor_calc integer;

begin
    conta := 2279425;
    cmfb_due := 11072;
    cmptd_blnc := 11072;
    
    last_bill := null;
    ttal_due := null;
    valor_calc := null;

    select max(bill_ref_no)
    into last_bill
    from cmf_balance
    where account_no = conta;

    select total_due
    into ttal_due
    from cmf_balance
    where account_no = conta
    and bill_ref_no = last_bill;

    valor_calc := (cmfb_due - cmptd_blnc) + ttal_due;

    if (valor_calc is not null)
    then
        DBMS_OUTPUT.PUT_LINE('update cmf_balance set total_due = ' || valor_calc || ' where account_no = ' || conta || ' and bill_ref_no = ' || last_bill || ';'); 
        DBMS_OUTPUT.PUT_LINE('update cmf_balance_detail set total_due = ' || valor_calc || ' where account_no = ' || conta || ' and bill_ref_no = ' || last_bill || ' and open_item_id = 1;');
    else
        DBMS_OUTPUT.PUT_LINE('Dados insuficientes');
    end if;
end;

/
