  Select apelido_operadora,
         crd.arquivo, crd.linha, crd.registro, crd.item, crd.cod_erro, crd.nota_fiscal, crd.esperado, crd.recebido, crd.descricao, crd.posicao, crd.qtde_caracteres, 
         crd.rowid crd_rowid,
         nvl(crd.arquivo ,         ' ')||';'||
         nvl(crd.linha,            '0')||';'||
         nvl(crd.registro,         '0')||';'||
         nvl(crd.item,             ' ')||';'||
         nvl(crd.cod_erro,         ' ')||';'||
         nvl(crd.nota_fiscal,      ' ')||';'||
         nvl(crd.descricao,        ' ')||';'||
         nvl(crd.esperado,         ' ')||';'||
         nvl(crd.recebido,         ' ')||';'||
         nvl(crd.posicao,          '0')||';'||
         nvl(crd.qtde_caracteres,  '0')||';'  concatenado --*/
    from cobilling.GVT_COBILLING_REMESSA_DETALHE crd,
         cobilling.GVT_COBILLING_REMESSA cre,
         (select distinct cod_prestadora, apelido_operadora from cobilling.gvt_cobilling_operadora) x
   where cre.cod_prestadora = x.cod_prestadora
     --and cre.situacao_remessa = 'E'
     and cre.nome_arquivo = crd.arquivo
     and cre.data_atualizacao = crd.data_validacao
     and nvl(crd.arquivo_de_erro,'N') = 'N'
  Order by arquivo, ordem;
