select to_char(sysdate,'YYYYMM') from dual


    SELECT
      substr( CONVERT( replace(replace(DECODE(TRIM(bill_lname) , NULL,' ', SUBSTR(TRIM(bill_lname), 1,54 )) ,CHR(13),''),CHR(10),''), 'US7ASCII', 'WE8ISO8859P1'),1,54)  NOME_ASSINANTE
   FROM CMF
