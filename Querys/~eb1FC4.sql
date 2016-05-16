CAMPO='Descrição' ANTIGO='Srs,
- Recebemos o seguinte INC1146785 da equipe de faturamento:
Detectei pela Gauss a conta 999983876212 tem Voz, BL e TV, porem cada um tem sua safra:
A franquia de voz - safra 201505
A TV 201508
A BL CTA-30ZY00P5-013 201505
A BL CTA-8120ETI2L-013 201306.
Todos os produtos deve ter a mesma safra.
Favor realizar levantamento e tratamento.
---------------------------------------------------------------------
- Foi aberta REQ1150708 para equipe de interfaces efetuar as validações aonde obtivemos o seguinte:
Boa tarde,
a análise deverá ser realizada na sp do kenan, pois conforme verificado no código do BillingTransformer todos os componentes devem ser ressafrados.
-
Comentário do código:
// PJ 1096 Contrato unico - A regra de safra(chave de tarifação) é um controle feito direto no kenan para cada produto e a chave é enviada para todos
Nome da sp:
sp.put("StoredProcedureName", "gvt_pro_ressafra_produto");
---------------------------------------------------------------------
- Verificamos no Kenan que existem vários produtos que deveriam estar sendo ressafrados mas que por algum motivo não estão recebendo a nova safra.
Necessitamos que seja validada a Store Procedure gvt_pro_ressafra_produto para entender o motivo deste problema.
Para chegar a listagem de produtos com problema favor efetuar a extração cfme o seguinte (CUST 1):
-- CRIAR TABELA COM TODAS ÚLTIMAS SAFRAS VÁLIDAS PARA TODAS AS CONTAS
create table ressafras_ativas as 
select l.perfilcobranca, c.account_no, max(safra) safra, max(dataressafra) dataressafra
from arborgvt_billing.gvt_log_processo_ressafra l
join customer_id_acct_map c on l.perfilcobranca = c.external_id
and c.external_id_type = 1
group by l.perfilcobranca, c.account_no;
-- A PARTIR DA LISTAGEM DE SAFRAS VÁLIDAS (ressafras_ativas) FAZ A COMPARAÇÃO DA SAFRA DOS PRODUTOS 
-- SUJEITOS A RESSAFRA (gvt_classificacao_tv com ressafrar = 'SIM')
-- COMPARANDO COM A SAFRA DOS PRODUTOS DO CLIENTE ATIVOS NA PRODUCT COM INFORMAÇÃO NA PRODUCT_RATE_KEY (CAMPO UNITS)
-- SE RETIRAR A CONDIÇÃO QUE FILTRA A CONTA DO CLIENTE PODEREMOS VER OUTROS CASOS DE INCONSISTÊNCIA DE SAFRA NA BASE
select ra.*, prk.units, case when prk.units <> ra.safra then 'ERRO' end flg_erro, 
p.element_id, p.billing_active_dt, d.description_text
from g0032485sql.ressafras_ativas ra
join product p on p.parent_account_no = ra.account_no
and p.billing_inactive_dt is null 
join descriptions d on d.description_code = p.element_id
and d.language_code = 2
join gvt_classificacao_tv gct on gct.subtype_code = p.element_id
and gct.ressafrar = 'SIM'
left join product_rate_key prk on prk.tracking_id = p.tracking_id
and prk.tracking_id_serv = p.tracking_id_serv
where ra.perfilcobranca = '999983876212';
---------------------------------------------------------------------' NOVO='Srs,
- Recebemos o seguinte INC1146785 da equipe de faturamento:
Detectei pela Gauss a conta 999983876212 tem Voz, BL e TV, porem cada um tem sua safra:
A franquia de voz - safra 201505
A TV 201508
A BL CTA-30ZY00P5-013 201505
A BL CTA-8120ETI2L-013 201306.
Todos os produtos deve ter a mesma safra.
Favor realizar levantamento e tratamento.
---------------------------------------------------------------------
- Foi aberta REQ1150708 para equipe de interfaces efetuar as validações aonde obtivemos o seguinte:
Boa tarde,
a análise deverá ser realizada na sp do kenan, pois conforme verificado no código do BillingTransformer todos os componentes devem ser ressafrados.
-
Comentário do código:
// PJ 1096 Contrato unico - A regra de safra(chave de tarifação) é um controle feito direto no kena    
 
 Atualização de campo DANTE GALIOTTO 16/11/2015 16:45:16 00:00:08 CAMPO='Descrição' ANTIGO='Srs,
- Recebemos o seguinte INC1146785 da equipe de faturamento:
Detectei pela Gauss a conta ... CAMPO='Descrição' ANTIGO='Srs,
- Recebemos o seguinte INC1146785 da equipe de faturamento:
Detectei pela Gauss a conta 999983876212 tem Voz, BL e TV, porem cada um tem sua safra:
A franquia de voz - safra 201505
A TV 201508
A BL CTA-30ZY00P5-013 201505
A BL CTA-8120ETI2L-013 201306.
Todos os produtos deve ter a mesma safra.
Favor realizar levantamento e tratamento.
---------------------------------------------------------------------
- Foi aberta REQ1150708 para equipe de interfaces efetuar as validações aonde obtivemos o seguinte:
Boa tarde,
a análise deverá ser realizada na sp do kenan, pois conforme verificado no código do BillingTransformer todos os componentes devem ser ressafrados.
-
Comentário do código:
// PJ 1096 Contrato unico - A regra de safra(chave de tarifação) é um controle feito direto no kenan para cada produto e a chave é enviada para todos
Nome da sp:
sp.put("StoredProcedureName", "gvt_pro_ressafra_produto");
---------------------------------------------------------------------
Verificamos no Kenan que existem vários produtos que deveriam estar sendo ressafrados mas que por algum motivo não estão recebendo a nova safra.
Necessitamos que seja validada a Store Procedure gvt_pro_ressafra_produto para entender o motivo deste problema.
Para chegar a listagem de produtos com problema favor efetuar a extração cfme o seguinte (CUST 1):
-- CRIAR TABELA COM TODAS ÚLTIMAS SAFRAS VÁLIDAS PARA TODAS AS CONTAS
create table ressafras_ativas as 
select l.perfilcobranca, c.account_no, max(safra) safra, max(dataressafra) dataressafra
from arborgvt_billing.gvt_log_processo_ressafra l
join customer_id_acct_map c on l.perfilcobranca = c.external_id
and c.external_id_type = 1
group by l.perfilcobranca, c.account_no;
-- A PARTIR DA LISTAGEM DE SAFRAS VÁLIDAS (ressafras_ativas) FAZ A COMPARAÇÃO DA SAFRA DOS PRODUTOS 
-- SUJEITOS A RESSAFRA (gvt_classificacao_tv com ressafrar = 'SIM')
-- COMPARANDO COM A SAFRA DOS PRODUTOS DO CLIENTE ATIVOS NA PRODUCT COM INFORMAÇÃO NA PRODUCT_RATE_KEY (CAMPO UNITS)
-- SE RETIRAR A CONDIÇÃO QUE FILTRA A CONTA DO CLIENTE PODEREMOS VER OUTROS CASOS DE INCONSISTÊNCIA DE SAFRA NA BASE
select ra.*, prk.units, case when prk.units <> ra.safra then 'ERRO' end flg_erro, 
p.element_id, p.billing_active_dt, d.description_text
from g0032485sql.ressafras_ativas ra
join product p on p.parent_account_no = ra.account_no
and p.billing_inactive_dt is null 
join descriptions d on d.description_code = p.element_id
and d.language_code = 2
join gvt_classificacao_tv gct on gct.subtype_code = p.element_id
and gct.ressafrar = 'SIM'
left join product_rate_key prk on prk.tracking_id = p.tracking_id
and prk.tracking_id_serv = p.tracking_id_serv
where ra.perfilcobranca = '999983876212';
---------------------------------------------------------------------' NOVO='Srs,
- Recebemos o seguinte INC1146785 da equipe de faturamento:
Detectei pela Gauss a conta 999983876212 tem Voz, BL e TV, porem cada um tem sua safra:
A franquia de voz - safra 201505
A TV 201508
A BL CTA-30ZY00P5-013 201505
A BL CTA-8120ETI2L-013 201306.
Todos os produtos deve ter a mesma safra.
Favor realizar levantamento e tratamento.
---------------------------------------------------------------------
- Foi aberta REQ1150708 para equipe de interfaces efetuar as validações aonde obtivemos o seguinte:
Boa tarde,
a análise deverá ser realizada na sp do kenan, pois conforme verificado no código do BillingTransformer todos os componentes devem ser ressafrados.
-
Comentário do código:
// PJ 1096 Contrato unico - A regra de safra(chave de tarifação) é um controle feito direto no kenan  
 CAMPO='Descrição' ANTIGO='Srs,
- Recebemos o seguinte INC1146785 da equipe de faturamento:
Detectei pela Gauss a conta 999983876212 tem Voz, BL e TV, porem cada um tem sua safra:
A franquia de voz - safra 201505
A TV 201508
A BL CTA-30ZY00P5-013 201505
A BL CTA-8120ETI2L-013 201306.
Todos os produtos deve ter a mesma safra.
Favor realizar levantamento e tratamento.
---------------------------------------------------------------------
- Foi aberta REQ1150708 para equipe de interfaces efetuar as validações aonde obtivemos o seguinte:
Boa tarde,
a análise deverá ser realizada na sp do kenan, pois conforme verificado no código do BillingTransformer todos os componentes devem ser ressafrados.
-
Comentário do código:
// PJ 1096 Contrato unico - A regra de safra(chave de tarifação) é um controle feito direto no kenan para cada produto e a chave é enviada para todos
Nome da sp:
sp.put("StoredProcedureName", "gvt_pro_ressafra_produto");
---------------------------------------------------------------------
Verificamos no Kenan que existem vários produtos que deveriam estar sendo ressafrados mas que por algum motivo não estão recebendo a nova safra.
Necessitamos que seja validada a Store Procedure gvt_pro_ressafra_produto para entender o motivo deste problema.
Para chegar a listagem de produtos com problema favor efetuar a extração cfme o seguinte (CUST 1):
-- CRIAR TABELA COM TODAS ÚLTIMAS SAFRAS VÁLIDAS PARA TODAS AS CONTAS
create table ressafras_ativas as 
select l.perfilcobranca, c.account_no, max(safra) safra, max(dataressafra) dataressafra
from arborgvt_billing.gvt_log_processo_ressafra l
join customer_id_acct_map c on l.perfilcobranca = c.external_id
and c.external_id_type = 1
group by l.perfilcobranca, c.account_no;
-- A PARTIR DA LISTAGEM DE SAFRAS VÁLIDAS (ressafras_ativas) FAZ A COMPARAÇÃO DA SAFRA DOS PRODUTOS 
-- SUJEITOS A RESSAFRA (gvt_classificacao_tv com ressafrar = 'SIM')
-- COMPARANDO COM A SAFRA DOS PRODUTOS DO CLIENTE ATIVOS NA PRODUCT COM INFORMAÇÃO NA PRODUCT_RATE_KEY (CAMPO UNITS)
-- SE RETIRAR A CONDIÇÃO QUE FILTRA A CONTA DO CLIENTE PODEREMOS VER OUTROS CASOS DE INCONSISTÊNCIA DE SAFRA NA BASE
select ra.*, prk.units, case when prk.units <> ra.safra then 'ERRO' end flg_erro, 
p.element_id, p.billing_active_dt, d.description_text
from g0032485sql.ressafras_ativas ra
join product p on p.parent_account_no = ra.account_no
and p.billing_inactive_dt is null 
join descriptions d on d.description_code = p.element_id
and d.language_code = 2
join gvt_classificacao_tv gct on gct.subtype_code = p.element_id
and gct.ressafrar = 'SIM'
left join product_rate_key prk on prk.tracking_id = p.tracking_id
and prk.tracking_id_serv = p.tracking_id_serv
where ra.perfilcobranca = '999983876212';
---------------------------------------------------------------------' NOVO='Srs,
- Recebemos o seguinte INC1146785 da equipe de faturamento:
Detectei pela Gauss a conta 999983876212 tem Voz, BL e TV, porem cada um tem sua safra:
A franquia de voz - safra 201505
A TV 201508
A BL CTA-30ZY00P5-013 201505
A BL CTA-8120ETI2L-013 201306.
Todos os produtos deve ter a mesma safra.
Favor realizar levantamento e tratamento.
---------------------------------------------------------------------
- Foi aberta REQ1150708 para equipe de interfaces efetuar as validações aonde obtivemos o seguinte:
Boa tarde,
a análise deverá ser realizada na sp do kenan, pois conforme verificado no código do BillingTransformer todos os componentes devem ser ressafrados.
-
Comentário do código:
// PJ 1096 Contrato unico - A regra de safra(chave de tarifação) é um controle feito direto no kenan  
 
