
Select distinct cod_prestadora from gvt_cobilling_operadora where upper(RAZAO_SOCIAL_OPERADORA) like '%TIM%'

-- 
Select gco.razao_social, 
       id, 
       phone_number, 
       protocol_ea, 
       rn1, 
       cnl, 
       dbo.eot, 
       create_date, 
       activate_date, 
       disconnected_date, 
       fake_number, 
       lnp_type, 
       line_type, 
       serv_prov_id, 
       last_change, 
       schedule_date, 
       status, 
       dbo.uf
from VRC_EOT_ANEXO_5 gco, dbarem.bdo dbo
where gco.eot(+) = dbo.eot
  and phone_number = '4333293720'
    ;

Select * from dbarem.bdo where phone_number = '4330296770'

-- 
Select gco.razao_social_operadora, 
       gco.open_item_id, 
       id, 
       phone_number, 
       protocol_ea, 
       rn1, 
       cnl, 
       eot, 
       create_date, 
       activate_date, 
       disconnected_date, 
       fake_number, 
       lnp_type, 
       line_type, 
       serv_prov_id, 
       last_change, 
       schedule_date, 
       status, 
       dbo.uf
from gvt_cobilling_operadora gco, dbarem.bdo dbo
where gco.cod_eot(+) = dbo.eot
  and gco.uf_eot_agrupador(+) = dbo.uf
    and dbo.phone_number = '1133353340';

-- 
Select --+ full(cad) parallel(cad 4)
       cad.linha_ddd,
             cad.linha_telefone,
             cad.portado,
             id, 
             phone_number, 
             protocol_ea, 
             rn1, 
             cnl, 
             eot, 
             create_date, 
             activate_date, 
             disconnected_date, 
             fake_number, 
             lnp_type, 
             line_type, 
             serv_prov_id, 
             last_change, 
             schedule_date, 
             status, 
             dbo.uf
from dbarem.bdo dbo, gvt_cadastro_cliente cad
where dbo.phone_number(+) = cad.linha_ddd||cad.linha_telefone
  and rownum < 200;



CREATE TABLE VRC_EOT_ANEXO_5
(EOT  NUMBER(10), FANTASIA VARCHAR2(100), RAZAO_SOCIAL VARCHAR2(100), CSP VARCHAR2(10), AREA VARCHAR2(100) );