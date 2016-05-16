Select --+ index(cdrb CDR_BILLED_XCB_BILL_REF_TRANS)
       cdr.account_no, cdrb.bill_ref_no, replace(val.display_value,'GVT Co-billing ','') empresa, grc.duracao,
       grc.duracao*60 duracao_seg, to_char(trunc(sysdate)+NUMTODSINTERVAL(grc.duracao*60, 'SECOND'),'hh24:mi:ss') duracao_real,
       grc.valor_faturado, grc.valor_bruto/100 valor_bruto, 
       --grc.valor_bruto/100 - valor_faturado difer, round((((valor_bruto/100)/valor_faturado)-1)*100,1) perc, 
       cdr.primary_units, cdr.second_units, cdr.rated_units, cdr.amount/100 amount, cdr.trans_dt, cdr.ext_tracking_id, 
       cdr.msg_id, cdr.msg_id2, cdr.msg_id_serv, cdrb.billed_amount, cdrb.billed_base_amt, 
       cdr.TYPE_ID_USG, cdr.element_id, cdr.jurisdiction, cdr.rate_period, cdr.equip_class_code, cdr.corridor_plan_id --*/
from grc_servicos_prestados grc, cdr_billed cdrb, cdr_data cdr, open_item_id_values val
where grc.status = 'R' 
  and grc.data_emissao_fatura > sysdate-30
  and grc.codigo_arbor in ( 360, 361 ) -- 
  and grc.codigo_arbor in ( 362 )        -- VC2/VC3
  and cdrb.bill_ref_no = grc.sequencial_arrecadacao
  and cdrb.bill_ref_resets = 0
  and cdrb.trans_dt = to_date(to_char(data_servico,'yyyymmdd')||hora_inicio,'yyyymmddhh24:mi:ss')
  and cdr.msg_id = cdrb.msg_id
  and cdr.msg_id2 = cdrb.msg_id2
  and cdr.msg_id_serv = cdrb.msg_id_serv
  and cdr.split_row_num = cdrb.split_row_num
  and val.open_item_id = cdr.open_item_id and val.language_code = 2
  and cdr.ext_tracking_id = grc.sequencial_chave
  and /* NOT */ ( ( cdr.type_id_usg in (360,361) and cdr.element_id in (10330,10331,10332,10333,11005,11006,11016,11027,11124,11448) )      or ( cdr.type_id_usg in (362) ) )
  and rownum < 21
Order by cdrb.bill_ref_no, cdr.trans_dt;
