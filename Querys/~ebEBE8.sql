select * from 
grc_motivos_de_para gr
    WHERE gr.motivo_grc = '361'
      and rownum = 1
      and parceiro = 2
      and status_grc = 'RJ'