Select def.parceiro||', '||par.nome operadora,
       uf,
       eot,
       decode(data_max_critica,to_date('31/12/2999','dd/mm/yyyy'),'NAO','SIM') POSSUI_DEFERIMENTO
from grc_deferimento_fiscal def, grc_parceiros par
where par.codigo = def.parceiro
order by def.parceiro, def.uf; 