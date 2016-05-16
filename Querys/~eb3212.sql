select count(*) from GVT_CDBARRAS where status = '1' and bill_ref_no in (select bill_ref_no from cmf_balance where closed_date is not null)

select count(*)
 from GVT_CDBARRAS A, 
      cmf_balance B
 where A.status = '1'
  and A.bill_ref_no = B.bill_ref_no
  and B.closed_date is not null;
  

select 
   'INSERT INTO GVT_HOLD_SYSREC VALUES(' || chr(39) || 'HOLD_CRB' ||chr(39) || ',' || chr(39) ||
   b.CONTACT1_PHONE || chr(39) || ', NULL,' || chr(39) || a.external_id || chr(39) || ',NULL, SYSDATE, NULL, 1, SYSDATE);'
  from GVT_CDBARRAS A,
  GVT_LOTERICA_CONSULTA_CPFCNPJ B
 where A.EXTERNAL_ID = B.EXTERNAL_ID

select * from GVT_LOTERICA_CONSULTA_CPFCNPJ


INSERT INTO GVT_HOLD_SYSREC VALUES('HOLD_CRB', '40221024115', NULL, '999985795368', NULL, SYSDATE, NULL, 1, SYSDATE);

INSERT INTO GVT_HOLD_SYSREC VALUES('HOLD_CRB', '40297373900', NULL,'899999913826',NULL, SYSDATE, NULL, 1, SYSDATE);

