-- 03420926000124 

select contact1_phone from cmf where account_no = 4610803

select * from GVT_LOTERICA_CONSULTA_CPFCNPJ where account_no = 4610803

select * from gvt_layout_faturas_corp where account_no = 4610803 

 
 SELECT A.CNPJ, B.MENSAGEM, C.NUM_CONTRATO
       -- INTO :p_cnpj:i0090, :p_mensagem:i0091, :p_num_contrato:i0092
      FROM (SELECT G1.account_no ACCOUNT_NO, G1.cnpj CNPJ, to_char(NULL) MENSAGEM, to_char(NULL) NUM_CONTRATO
                FROM GVT_LAYOUT_FATURAS_CORP G1
               WHERE G1.account_no = 4610803
                 AND G1.data_exclusao is null
                 AND G1.flag = 1
             ) A,
             (SELECT G2.account_no ACCOUNT_NO, to_char(NULL) CNPJ, G2.mensagem MENSAGEM, to_char(NULL) NUM_CONTRATO
                FROM GVT_LAYOUT_FATURAS_CORP G2
               WHERE G2.account_no = 4610803
                 AND G2.data_exclusao is null
                 AND G2.flag = 2
             ) B,        
             (SELECT G3.account_no ACCOUNT_NO, to_char(NULL) CNPJ, to_char(NULL) MENSAGEM, G3.num_contrato NUM_CONTRATO
                FROM GVT_LAYOUT_FATURAS_CORP G3
               WHERE G3.account_no = 4610803
                 AND G3.data_exclusao is null
                 AND G3.flag = 3
             ) C,
             CMF
      WHERE CMF.account_no = 4610803
        AND A.account_no (+) = CMF.account_no 
        AND B.account_no (+) = CMF.account_no
        AND C.account_no (+) = CMF.account_no;
        
        
        
                select * from cmf where account_no = 4610803