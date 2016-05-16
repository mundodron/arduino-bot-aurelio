select distinct(B.account_no), L.EXTERNAL_ID, C.BILL_CITY, C.BILL_STATE
  from bmf B,
       GVT_LOTERICA_CONSULTA_CPFCNPJ L,
       cmf C
 where B.bmf_trans_type = -123
   AND B.ACCOUNT_NO = L.ACCOUNT_NO
   AND B.ACCOUNT_NO = C.ACCOUNT_NO
   AND C.NO_BILL = 0
   AND B.TRANS_DATE >= TO_DATE('01/03/2012','DD/MM/RRRR') 
   AND B.TRANS_DATE <TO_DATE('01/05/2012','DD/MM/RRRR')
   and B.NO_BILL = 0
   order by BILL_STATE