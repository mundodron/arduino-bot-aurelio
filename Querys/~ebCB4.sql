SELECT B.ROW_ID,
       B.ASSET_NUM AS PILOTO
FROM   S_QUOTE_SOLN A, 
       S_QUOTE_SOLN B 
WHERE  1=1 --A.ASSET_NUM = 'NHO-1023JW6I-003-1023JW6M'
  AND  A.STATUS_CD = 'Ativo'
  AND  A.SERV_PROD_ID = '1+1M7L+4706'
  AND  A.X_APONTAMENTO_ID = B.ROW_ID
  and  TRIm(B.ROW_ID) = '1-23JW6L' 

UNION

SELECT A.ROW_ID,
       D.X_TEXTO_LIVRE 
FROM   S_QUOTE_SOLN A, 
       S_QUOTE_ITEM B, 
       S_QTEITEM_PARAM C, 
       S_PARAM D
WHERE  A.ROW_ID = B.QUOTE_SOLN_ID
  AND  B.ROW_ID = C.QUOTE_ITEM_ID (+)
  AND  C.PARAM_ID = D.ROW_ID (+)
 --AND A.ASSET_NUM = ?
  AND  A.STATUS_CD = 'Ativo'
  AND  D.PARAM_NAME_ID IN ('1-BI76', '1-BIBZ', '1-BXLH', '1-BZ8T', '1-CTT6', '1-CTTG', '1-E4KN', '1-N69H', '1-1KTAO', '1-15GCHB', '1-275SQL', '1-8MKK1B')
  AND  TRIm(A.ROW_ID) = '1-23JW6L' 


UNION

SELECT A.ROW_ID,
       G.X_TEXTO_LIVRE
FROM S_QUOTE_SOLN A, 
     S_QUOTE_SOLN B, 
     S_QUOTE_ITEM C, 
     S_QTEITEM_PARAM D, 
     S_PARAM E, 
     S_QTEITEM_PARAM F, 
     S_PARAM G
WHERE A.INV_ACCNT_ID = B.INV_ACCNT_ID
 AND B.ROW_ID = C.QUOTE_SOLN_ID
 AND D.QUOTE_ITEM_ID = C.ROW_ID
 AND E.ROW_ID = D.PARAM_ID
 AND A.ASSET_ID = E.X_SERVICE_ID
 AND F.QUOTE_ITEM_ID = C.ROW_ID
 AND G.ROW_ID = F.PARAM_ID
 AND ''||G.PARAM_NAME_ID in ('1-CTTG', '1-N69H')
 AND B.STATUS_CD = 'Ativo'
 AND ''||E.PARAM_NAME_ID in ('1-BPSH', '1-N69G')
 AND ''||B.SERV_PROD_ID in ('1-ADDP', '1-N69F')
 AND ''||C.PROD_ID in ('1-N69K', '1-N69E')
 --AND A.ASSET_NUM = ? --  instancia
 AND TRIm(A.ROW_ID) = '1-23JW6L' 
 AND ROWNUM <= 1
 
 UNION
 
 SELECT A.ROW_ID,NULL AS PILOTO, A.ASSET_NUM
   FROM S_QUOTE_SOLN A
  WHERE 1 =1 --A.ASSET_NUM = ? -- instancia
    AND A.STATUS_CD = 'Ativo'
    AND A.SERV_PROD_ID in ('1-7JRE','1-BAVZ','1-B4RW')
    AND trim(A.ROW_ID) = '1-23JW6L' 

select * from gvt_febraban_ponta_b_arbor where row_id = '1-23JW6L'