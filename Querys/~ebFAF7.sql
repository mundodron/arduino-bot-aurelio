select  
    'UPDATE GVT_HOLD_SYSREC SET DATA_REMOCAO = sysdate, STATUS_CLIENTE = 0 WHERE EXTERNAL_ID = '|| chr(39) || a.external_id || chr(39) || ' AND DOCUMENT_NUMB = ' || chr(39) || b.CONTACT1_PHONE || chr(39) || ' and status_cliente = ''1'' AND PROCESSO = ''HOLD_CRB'';'
  from GVT_CDBARRAS A,
  GVT_LOTERICA_CONSULTA_CPFCNPJ B
 where A.EXTERNAL_ID = B.EXTERNAL_ID



UPDATE GVT_HOLD_SYSREC SET DATA_REMOCAO = sysdate, STATUS_CLIENTE = 0 WHERE EXTERNAL_ID = '999983628120' AND DOCUMENT_NUMB = '29136534803' and status_cliente = '1' AND PROCESSO = 'HOLD_CRB';

UPDATE GVT_HOLD_SYSREC SET DATA_REMOCAO = sysdate, STATUS_CLIENTE = 0 WHERE EXTERNAL_ID = '899999773347' AND DOCUMENT_NUMB = '00865735190' and status_cliente = '1' AND PROCESSO = 'HOLD_CRB';


select External_ID, bill_ref_no from GVT_CDBARRAS 