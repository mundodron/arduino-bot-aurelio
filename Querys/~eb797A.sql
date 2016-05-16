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