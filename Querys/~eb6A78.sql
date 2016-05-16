declare 
   v_bill_period             VARCHAR2 (16) := null;
   v_mes                     VARCHAR2 (16) := null;
   v_quant                   NUMBER := null;
   
 cursor c1 (p_dias in number) is 
        select bill_period,
       to_char(sysdate - p_dias, 'mm/yyyy') mes,
       count(1) qtd
          from gvt_no_bill_audit
         where new_no_bill = 1
           and created between trunc((sysdate - 30) - p_dias) and last_day(sysdate - p_dias)
 group by bill_period
 order by bill_period;
    
 begin 
   for i in 1..3 loop
   
         dbms_output.put_line('===== Ultimos '||i*30 ||'  Dias === ');
         
         for j in c1((i-1)*30) loop 
          
          v_bill_period := j.bill_period;
          v_mes := j.mes;
          v_quant := j.qtd;
                  
           dbms_output.put_line(v_bill_period ||'   '|| v_mes || '  ' || v_quant );
           
         end loop; 
         
   end loop;
 end;