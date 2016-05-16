select 
   'INSERT INTO GVT_HOLD_SYSREC VALUES(' || chr(39) || 'HOLD_CRB' ||chr(39) || ',' || chr(39) ||
   b.CONTACT1_PHONE || chr(39) || ', NULL,' || chr(39) || a.external_id || chr(39) || ',NULL, SYSDATE, NULL, 1, SYSDATE);'
  from GVT_CDBARRAS A,
  GVT_LOTERICA_CONSULTA_CPFCNPJ B
 where A.EXTERNAL_ID = B.EXTERNAL_ID