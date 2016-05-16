select * from g0023421sql.gvt_sempreloc_full

drop table g0023421sql.gvt_sempreloc_full;

create table g0023421sql.gvt_sempreloc_full as
SELECT /*+ parallel (c 30)*/
         a.msg_id,
         a.msg_id2,
         a.msg_id_serv,
         a.account_no,
         a.type_id_usg,
         a.rate_dt,
         a.trans_dt,
         a.point_origin,
         a.point_target,
         a.point_id_target,
         a.element_id,
         a.seqnum_rate_usage,
         a.open_item_id,
         a.no_bill,
         a.annotation,
         b.subscr_no,
         b.bill_ref_no,
         b.billed_amount,
         b.units_credited,
         b.amount_credited,
         b.unit_cr_id,
         b.discount,
         b.discount_id,
         a.equip_class_code,
         a.rate_period,
         a.rated_units,
         a.primary_units,
         c.bill_period,
         u.point_class,
         u.point_city,
         a.jurisdiction
  FROM   cdr_data a,
         cdr_billed b,
         usage_points u,
         (  SELECT   bill.account_no, bill.bill_ref_no, bill.bill_ref_resets, bill.bill_period
              FROM   bill_invoice bill, cmf_package_component comp
             WHERE   bill.prep_Date BETWEEN TO_DATE ('01/04/2014 00:00:00','dd/mm/yyyy hh24:mi:ss')
                                        AND TO_DATE ('30/04/2014 23:59:59','dd/mm/yyyy hh24:mi:ss')
                     AND bill.bill_period = 'M15'
                     AND bill.ACCOUNT_NO = comp.PARENT_ACCOUNT_NO
                     AND comp.component_id IN (30491)
                     AND bill.prep_status = 1
                     AND bill.prep_error_code IS NULL
          GROUP BY   bill.account_no, bill.bill_ref_no, bill.bill_ref_resets, bill.bill_period) c
 WHERE   c.account_no = b.account_no
         AND c.bill_ref_no = b.bill_ref_no
         AND c.bill_ref_resets = b.bill_ref_resets
         AND a.msg_id = b.msg_id
         AND a.msg_id2 = b.msg_id2
         AND a.msg_id_serv = b.msg_id_serv
         AND a.point_id_target = u.point_id
         AND a.cdr_data_partition_key = b.cdr_data_partition_key
         AND a.split_row_num = b.split_row_num
         AND a.element_id = 10333
         AND b.type_id_usg in (288, 274, 276);

grant all on g0023421sql.gvt_sempreloc_full to public;

-- CNL´S cidade atendida pela GVT
-- select point_class_target from usage_jurisdiction where element_id=10333 and jurisdiction = 11 and inactive_dt is null;
   
alter table g0023421sql.gvt_sempreloc_full add (type_id_usg_new varchar2(3));

-- Separação de uso SEMPRE LOCAL NÃO ATENDIDA 
-- set type_id_usg_new = '276'
-- select * from g0023421sql.gvt_sempreloc_full a where not exists (select 1 from usage_jurisdiction where element_id=10333 and jurisdiction = 11 and inactive_dt is null and point_class_target = a.point_id_target);   

-- Separação de uso SEMPRE LOCAL ATENDIDA
-- set type_id_usg_new = '288'
-- select * from g0023421sql.gvt_sempreloc_full a where exists (select 1 from usage_jurisdiction where element_id=10333 and jurisdiction = 11 and inactive_dt is null and point_class_target = a.point_id_target);   

-- Separação de uso SEMPRE LOCAL NÃO ATENDIDA      
update g0023421sql.gvt_sempreloc_full a set type_id_usg_new = '276' where not exists (select 1 from usage_jurisdiction where element_id=10333 and jurisdiction = 11 and inactive_dt is null and point_class_target = a.point_id_target);   

-- Separação de uso SEMPRE LOCAL ATENDIDA
update g0023421sql.gvt_sempreloc_full a set type_id_usg_new = '288' where exists (select 1 from usage_jurisdiction where element_id=10333 and jurisdiction = 11 and inactive_dt is null and point_class_target = a.point_id_target);   

commit;


--Inserção de SEQNUM do uso sempre local 
alter table g0023421sql.gvt_sempreloc_full add (seqnum_new number(10));

update g0023421sql.gvt_sempreloc_full a set seqnum_new = (select seqnum 
                                                     from rate_usage ru
                                                    where ru.element_id = a.element_id
                                                      and ru.type_id_usg = a.type_id_usg_new
                                                      and ru.equip_class_code = a.equip_class_code
                                                      and ru.jurisdiction=67
                                                      and ru.rate_period = 'N'
                                                      and ru.inactive_dt is null)
where a.type_id_usg=276;   

update g0023421sql.gvt_sempreloc_full a set seqnum_new = (select seqnum 
                                                     from rate_usage ru
                                                    where ru.element_id = a.element_id
                                                      and ru.type_id_usg = a.type_id_usg_new
                                                      and ru.equip_class_code = a.equip_class_code
                                                      and ru.jurisdiction=11
                                                      and ru.rate_period = 'N'
                                                      and ru.inactive_dt is null)
where a.type_id_usg=288;   

commit;

-- select * from g0023421sql.gvt_sempreloc_full;

--Inserção da FRANQUIA no período do CDR 
alter table g0023421sql.gvt_sempreloc_full add (component_id number(10));  

update g0023421sql.gvt_sempreloc_full a set a.component_id = (select max(cpc.component_id) 
 from cmf_package_component cpc
where cpc.parent_account_no = a.account_no
  and cpc.parent_subscr_no = a.subscr_no
  and a.trans_dt >= cpc.active_dt
  and (a.trans_dt < cpc.inactive_dt or cpc.inactive_dt is null)
  and cpc.component_id = 30491);

commit;


drop table g0023421sql.gvt_sempreloc_final;

create table g0023421sql.gvt_sempreloc_final as
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
from g0023421sql.gvt_sempreloc_full a,
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


grant all on g0023421sql.gvt_sempreloc_final to public;

-- select * from g0023421sql.gvt_sempreloc_full

-- select * from g0023421sql.gvt_sempreloc_final


-- select jurisdiction, count(1) from gvt_sempreloc_full group by jurisdiction

-- select * from customer_id_equip_map where external_id = '4730266868'

-- select * from service where SUBSCR_NO = 1362071

--select * from customer_id_acct_map where account_no = 1362071