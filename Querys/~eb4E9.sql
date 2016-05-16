SELECT N.BILL_REF_NO      "FAT_PAGA_ATRASO",
         N.PPDD_DATE        "VCTO_FAT_PAGA_ATRASO",
         N.CLOSED_DATE      "DATA_PGTO_FAT_ATRASO",
         N.TOTAL_DUE/100    "VALOR_FAT_ATRASO"
    FROM CMF_BALANCE n
   WHERE n.bill_ref_no in ( select * from 
                              ( SELECT   to_number(trim(substr(annotation,16,9))) as fatura_paga_em_atraso
                                  FROM   nrc, nrc_key nk
                                 WHERE   nk.tracking_id = nrc.tracking_id
                                   AND   nk.tracking_id_serv = nrc.tracking_id_serv
                                   AND   nrc.billing_account_no = acc_no
                                   AND nrc.type_id_nrc IN (12500, 12501)
                                   AND nrc.no_bill = 0
                                   order by 1 desc )
                            where rownum = 1 );
