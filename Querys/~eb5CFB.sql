select * from GRC_NAOFATURACONJUNTO

select * from grc_servicos_prestados where motivo = '218'

Select * from COB_CONTROLE_ERROS WHERE TIME >= '01/08/2015' AND programa = 'proc_carrega_contestados'
and erro like '%INSERE_NAOFATURACONJUNTO%'
 order by time desc

    select 1 from GRC_NAOFATURACONJUNTO where telefone = 7133561651 and operadora = 41 and INACTIVE_DT is null;