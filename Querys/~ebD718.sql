----------------- Todas as Faturas Sempre Local


drop table g0023421sql.gvt_faturas_sempre_local1;

create table g0023421sql.gvt_faturas_sempre_local1 as
select account_no,bill_ref_no,bill_ref_resets, prep_Date
from bill_invoice
where prep_Date between to_date('01/05/2014 00:00:00','dd/mm/yyyy hh24:mi:ss') and to_date('30/05/2014 23:59:59','dd/mm/yyyy hh24:mi:ss')
  and prep_status=1
  and bill_period = 'M20'
  and prep_error_code is null;
  
----------------- Separação de somente Plano GVT ILIMITADO LOCAL e TOTAL

drop table g0023421sql.gvt_faturas_sempre_temp1;

create table g0023421sql.gvt_faturas_sempre_temp1 as
select a.*
from g0023421sql.gvt_faturas_sempre_local1 a,cmf_package_component b
where a.account_no=b.parent_account_no
  and b.component_id in (30491); 
  
----------------- Eliminação de Duplicados 
drop table g0023421sql.gvt_fat_sempre_temp1;

create table g0023421sql.gvt_fat_sempre_temp1 as 
select distinct a.* 
from gvt_faturas_sempre_temp a;

----------------- Retorna todos os CDR´S faturados com plano 10333

drop table g0023421sql.gvt_sempreloc_full1;

create table g0023421sql.gvt_sempreloc_full1 as
select /*+ parallel (c 30)*/ a.msg_id,a.msg_id2,a.msg_id_serv,a.account_no,a.type_id_usg,a.rate_dt,a.trans_dt,a.point_origin,a.point_target,a.point_id_target,a.element_id,
a.seqnum_rate_usage,a.open_item_id,a.no_bill,a.annotation,b.subscr_no,b.bill_ref_no,b.billed_amount,b.units_credited,b.amount_credited,b.unit_cr_id,b.discount,b.discount_id,
a.equip_class_code,a.rate_period,a.rated_units,a.primary_units,A.JURISDICTION
from cdr_data a,cdr_billed b,g0023421sql.gvt_fat_sempre_temp1 c
where c.account_no=b.account_no
  and c.bill_ref_no=b.bill_ref_no
  and c.bill_ref_resets=b.bill_ref_resets
  and a.msg_id=b.msg_id
  and a.msg_id2=b.msg_id2
  and a.msg_id_serv=b.msg_id_serv
  and a.cdr_data_partition_key=b.cdr_data_partition_key
  and a.split_row_num=b.split_row_num
  and a.element_id=10333
  and b.type_id_usg in (276,288); 
  
   
--------------------------- Enriquecimento de CDR´s
   
alter table g0023421sql.gvt_sempreloc_full1 add (type_id_usg_new varchar2(3));

alter table g0023421sql.gvt_sempreloc_full1 add (jurisdiction_new number(10));


--Update para jurisdição não atendida para cidade atendida      
update g0023421sql.gvt_sempreloc_full1 a set type_id_usg_new = '288',jurisdiction_new=11 where type_id_usg=288 and jurisdiction=67;   

--Separação de uso SEMPRE LOCAL ATENDIDA
update g0023421sql.gvt_sempreloc_full1 a set type_id_usg_new = '288',jurisdiction_new=11 where type_id_usg=276;    

commit; 

alter table g0023421sql.gvt_sempreloc_full1 add (seqnum_new number(10));

--Inserção de SEQNUM do uso sempre local 
update g0023421sql.gvt_sempreloc_full1 a set seqnum_new = (select seqnum 
                                                     from rate_usage ru
                                                    where ru.element_id = a.element_id
                                                      and ru.type_id_usg = a.type_id_usg_new
                                                      and ru.equip_class_code = a.equip_class_code
                                                      and ru.jurisdiction=a.jurisdiction_new
                                                      and ru.rate_period = 'N'
                                                      and ru.inactive_dt is null)
where a.type_id_usg=288;   

commit; 

update g0023421sql.gvt_sempreloc_full1 a set seqnum_new = (select seqnum 
                                                     from rate_usage ru
                                                    where ru.element_id = a.element_id
                                                      and ru.type_id_usg = a.type_id_usg_new
                                                      and ru.equip_class_code = a.equip_class_code
                                                      and ru.jurisdiction=a.jurisdiction_new
                                                      and ru.rate_period = 'N'
                                                      and ru.inactive_dt is null)
where a.type_id_usg=276;   



commit;                                                      

--Inserção da FRANQUIA no período do CDR 

alter table g0023421sql.gvt_sempreloc_full1 add (component_id number(10));  

update g0023421sql.gvt_sempreloc_full1 a set a.component_id = (select max(cpc.component_id) 
 from cmf_package_component cpc
where cpc.parent_account_no = a.account_no
  and cpc.parent_subscr_no = a.subscr_no
  and a.trans_dt >= cpc.active_dt
  and (a.trans_dt < cpc.inactive_dt or cpc.inactive_dt is null)
  and cpc.component_id in (30491,30492));

commit; 

--Relatório FINAL

drop table g0023421sql.gvt_sempre_local_full1;

create table g0023421sql.gvt_sempre_local_full1 as
select a.account_no,
       a.msg_id,
       a.msg_id2,
       a.msg_id_serv, 
       a.open_item_id,
       a.jurisdiction,
       a.jurisdiction_new,
       a.no_bill,
       a.annotation,
       a.point_origin,
       a.point_target,
       a.type_id_usg,
       a.type_id_usg_new,
       i.point_city,       
       a.trans_dt data_chamada,
       a.equip_class_code codigo_estado_tarifario,
       f.display_value estado_tarifario,
       a.rate_period,
       d.bill_period,
       a.primary_units duracao_real,
       a.rated_units*6 duracao_tarifada,
       a.rated_units unidades_tarifadas, 
       a.units_credited unidades_creditadas,
       g.description_text descricao_franquia,
       a.component_id,
       h.display_value plano,
            case
         when a.jurisdiction<>11 then
              'CIDADE DESTINO NAO ATENDIDA'
            else
              'CIDADE DESTINO ATENDIDA'
         end DESC_USO,
       b.ADD_FIXED_AMT/100000000 TARIFA_PRIMEIRO_MINUTO_ERRADO,
       c.ADD_FIXED_AMT/100000000 TARIFA_PRIMEIRO_MINUTO_CORRETO,
       b.ADD_UNIT_RATE/100000000 TARIFA_UNIDADE_ERRADO,
       c.ADD_UNIT_RATE/100000000 TARIFA_UNIDADE_CORRETO,
       billed_amount/100 VALOR_CORRETO,  
       a.amount_credited/100 valor_franquiado,
       case
         when rated_units<10 then
            trunc(NVL(b.ADD_UNIT_RATE/100000000,0)*10,2)
           else
            trunc(((NVL(b.ADD_UNIT_RATE/100000000,0)*(rated_units-10)) + (NVL(b.ADD_FIXED_AMT/1000000000,0)*10)),2)
       end VALOR_ERRADO
from g0023421sql.gvt_sempreloc_full1 a,
     rate_usage b,
     rate_usage c,
     cmf d,
     equip_class_code_values f,
     descriptions g,
     component_definition_values h,
     usage_points i
where a.account_no=d.account_no
  and a.equip_class_code=f.equip_class_code
  and f.language_code=2
  and a.seqnum_new=b.seqnum
  and a.seqnum_rate_usage=c.seqnum
  and g.description_code(+)=a.unit_cr_id
  and g.language_code(+)=2
  and a.component_id=h.component_id(+)
  and h.language_code(+)=2
  and a.point_id_target=i.point_id;
  
grant all on gvt_sempre_local_full to public;



--select * from g0023421sql.gvt_sempre_local_full1 where account_no = 1384772

