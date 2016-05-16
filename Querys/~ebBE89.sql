declare 
   v_bill_period              VARCHAR2 (16) := null;
   v_mes                      VARCHAR2 (16) := null;
   v_M02_00                   NUMBER := null;
   v_M05_00                   NUMBER := null;
   v_M10_00                   NUMBER := null;
   v_M15_00                   NUMBER := null;
   v_M20_00                   NUMBER := null;
   v_M28_00                   NUMBER := null;
   v_M02_30                   NUMBER := null;
   v_M05_30                   NUMBER := null;
   v_M10_30                   NUMBER := null;
   v_M15_30                   NUMBER := null;
   v_M20_30                   NUMBER := null;
   v_M28_30                   NUMBER := null;
   v_M02_90                   NUMBER := null;
   v_M05_90                   NUMBER := null;
   v_M10_90                   NUMBER := null;
   v_M15_90                   NUMBER := null;
   v_M20_90                   NUMBER := null;
   v_M28_90                   NUMBER := null;
      
 cursor c1 (p_dias in number) is 
        select bill_period,
               to_char(sysdate - p_dias, 'mm/yyyy') mes,
               count(1) qtd
          from    cmf
         where   account_no in (select account_no from gvt_no_bill_audit where new_no_bill = 1 and created between trunc(sysdate, 'mm') and last_day(sysdate) )      
group by bill_period
order by BILL_PERIOD;
    
 begin 
   for i in 1..3 loop
         for j in c1((i-1)*30) loop 
          
          v_bill_period := j.bill_period;
          v_mes := j.mes;
          v_quant := j.qtd;
          
            v_M02_00 := j.qtd;
            v_M05_00 
            v_M10_00 
            v_M15_00 
            v_M20_00 
            v_M28_00 

                  
         end loop; 
       
            dbms_output.put_line('Ciclo' || ' 60 dias ' || ' 30 dias ' || ' Atual ' );
            dbms_output.put_line('M02 '  || v_M02_60    || v_M02_30    || v_M02_00    );
            dbms_output.put_line('M05 '  || v_M05_60    || v_M05_30    || v_M05_00    );
            dbms_output.put_line('M10 '  || v_M10_60    || v_M10_30    || v_M10_00    );
            dbms_output.put_line('M15 '  || v_M15_60    || v_M15_30    || v_M15_00    );
            dbms_output.put_line('M20 '  || v_M20_60    || v_M20_30    || v_M20_00    );
            dbms_output.put_line('M28 '  || v_M28_60    || v_M28_30    || v_M28_00    );
            
   end loop;
 end;