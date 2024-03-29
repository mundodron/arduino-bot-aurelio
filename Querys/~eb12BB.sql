
----------------- Todas as Faturas de Mar�o

create table gvt_faturas_marco as
select account_no,bill_ref_no,bill_ref_resets 
from bill_invoice
where prep_Date between to_date('01/03/2014 00:00:00','dd/mm/yyyy hh24:mi:ss') and to_date('31/03/2014 23:59:59','dd/mm/yyyy hh24:mi:ss')
  and prep_status=1
  and prep_error_code is null;  
  
----------------- Separa��o de somente Plano GVT ILIMITADO LOCAL e TOTAL
--select count(1) from gvt_faturas_marco_sempre_temp

create table gvt_faturas_marco_sempre_temp as
select a.*
from gvt_faturas_marco a,cmf_package_component b
where a.account_no=b.parent_account_no
  and b.component_id in (30491,30492); 
  
----------------- Elimina��o de Duplicados 

select count(1) from gvt_faturas_marco_sempre

create table gvt_faturas_marco_sempre as 
select distinct a.* 
from gvt_faturas_marco_sempre_temp a;

----------------- Retorna todos os CDR�S faturados com plano 10333

create table gvt_sempreloc_full as
select /*+ parallel (c 30)*/ a.msg_id,a.msg_id2,a.msg_id_serv,a.account_no,a.type_id_usg,a.rate_dt,a.trans_dt,a.point_origin,a.point_target,a.point_id_target,a.element_id,
a.seqnum_rate_usage,a.open_item_id,a.no_bill,a.annotation,b.subscr_no,b.bill_ref_no,b.billed_amount,b.units_credited,b.amount_credited,b.unit_cr_id,b.discount,b.discount_id,
a.equip_class_code,a.rate_period,a.rated_units,a.primary_units
from cdr_data a,cdr_billed b,gvt_faturas_marco_sempre c
where c.account_no=b.account_no
  and c.bill_ref_no=b.bill_ref_no
  and c.bill_ref_resets=b.bill_ref_resets
  and a.msg_id=b.msg_id
  and a.msg_id2=b.msg_id2
  and a.msg_id_serv=b.msg_id_serv
  and a.cdr_data_partition_key=b.cdr_data_partition_key
  and a.split_row_num=b.split_row_num
  and a.element_id=10333
  and b.type_id_usg=288; 
  
--------------------------- Enriquecimento de CDR�s
--Inser��o da CNL destino
create table gvt_sempreloc_marco_cnl as
select a.*, b.point_class, b.point_city
  from arbor_prod.gvt_sempreloc_full a,
       usage_points b
where a.point_id_target = b.point_id;  

-- CNL�S cidade atendida pela GVT
g0004445sql.willson_sempre_local 


   
alter table gvt_sempreloc_marco_cnl add (type_id_usg_new varchar2(3));

--Separa��o de uso SEMPRE LOCAL ATENDIDA E N�O ATENDIDA      
update gvt_sempreloc_marco_cnl a set type_id_usg_new = '276' where not exists (select 1 from g0004445sql.willson_sempre_local where cnl = a.point_class);   

--Separa��o de uso SEMPRE LOCAL ATENDIDA      
update gvt_sempreloc_marco_cnl a set type_id_usg_new = '288' where exists (select 1 from g0004445sql.willson_sempre_local where cnl = a.point_class);   

alter table gvt_sempreloc_marco_cnl add (seqnum_new number(10));

--Inser��o de SEQNUM do uso sempre local 
update gvt_sempreloc_marco_cnl a set seqnum_new = (select seqnum 
                                                     from rate_usage ru
                                                    where ru.element_id = a.element_id
                                                      and ru.type_id_usg = a.type_id_usg_new
                                                      and ru.equip_class_code = a.equip_class_code
                                                      and ru.jurisdiction=67
                                                      and ru.rate_period = 'N'
                                                      and ru.inactive_dt is null);   

commit;                                                      

--Inser��o da FRANQUIA no per�odo do CDR 


alter table gvt_sempreloc_marco_cnl add (component_id number(10));  

update gvt_sempreloc_marco_cnl a set a.component_id = (select max(cpc.component_id) 
 from cmf_package_component cpc
where cpc.parent_account_no = a.account_no
  and cpc.parent_subscr_no = a.subscr_no
  and a.trans_dt >= cpc.active_dt
  and (a.trans_dt < cpc.inactive_dt or cpc.inactive_dt is null)
  and cpc.component_id in (30491,30492));
    
--Relat�rio FINAL

create table gvt_sempreloc_marco_full as
select a.account_no,
       a.msg_id,
       a.msg_id2,
       a.open_item_id,
       a.no_bill,
       a.annotation,
       a.msg_id_serv,
       a.point_origin,
       a.point_target,
       i.point_city,       
       a.trans_dt data_chamada,
       a.point_class cnl_destino,
       a.equip_class_code codigo_estado_tarifario,
       f.display_value estado_tarifario,
       a.rate_period,
       d.bill_period,
       a.primary_units duracao_real,
       a.rated_units*6 duracao_tarifada,
       a.rated_units unidades_tarifadas, 
       a.units_credited unidades_creditadas,
       g.description_text descricao_franquia,
       a.type_id_usg_new novo_uso,   
       a.component_id,
       h.display_value plano,
       case
         when a.type_id_usg_new=276 then
              'CIDADE DESTINO NAO ATENDIDA'
            else
              'CIDADE DESTINO ATENDIDA'
         end DESC_USO,
       b.ADD_FIXED_AMT/100000000 tarifa_primeiro_minuto_nova,
       c.ADD_FIXED_AMT/100000000 tarifa_primeiro_minuto_antiga,
       b.ADD_UNIT_RATE/100000000 tarifa_unidade_nova,
       c.ADD_UNIT_RATE/100000000 tarifa_unidade_antiga,
       billed_amount/100 valor_antigo,  
       a.amount_credited/100 valor_franquiado,
       case
         when rated_units<10 then
            trunc(NVL(b.ADD_UNIT_RATE/100000000,0)*10,2)
           else
            trunc(((NVL(b.ADD_UNIT_RATE/100000000,0)*(rated_units-10)) + (NVL(b.ADD_FIXED_AMT/1000000000,0)*10)),2)
       end valor_novo
from gvt_sempreloc_marco_cnl a,
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
