SELECT    'UPDATE G0023421SQL.GVT_ERRO_SANTANDER SET CONTA_SERV = '''
      || x_acct_id_num
      || ''' WHERE TELEFONE = '''
      || asset_num
      || ''';'
 FROM s_quote_soln sqs, s_org_ext soe
WHERE asset_num IN
         (select telefone from GVT_ERRO_SANTANDER)
  AND status_cd = 'Ativo'
  AND serv_accnt_id = soe.row_id