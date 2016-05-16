declare
AUX_GLOBAL_NAME     VARCHAR(100);
V_PATH              VARCHAR2 (100) := 'BILLING_FAT_LOG'; -- Diretorio onde sera gravado o arquivo ex: (BILLING_FAT_LOG) /app/GVT_DEV2/c2/billing/faturamento/log
V_FILENAME          VARCHAR2(50);
V_FILE              UTL_FILE.FILE_TYPE;

aux_count number := 0;

cursor fat_prof_comjurosmulta is

    select external_id CONTA_COBRANCA, ciam.account_no ACCOUNT_NO, bill_ref_no FATURA_ATUAL, b.payment_due_date VCTO_FAT_ATUAL, 
            ( select sum(amount + federal_tax)/100
              from bill_invoice_detail bid
              where bid.bill_ref_no = b.bill_ref_no
              and bid.bill_ref_resets = b.bill_ref_resets
              and bid.type_code in (2,3,7)
            ) VALOR_FAT_ATUAL,
            ( select sum(amount + federal_tax)/100
              from bill_invoice_detail bid
              where bid.bill_ref_no = b.bill_ref_no
              and bid.bill_ref_resets = b.bill_ref_resets
              and bid.type_code = 3
              and subtype_code in (12500, 12501)
            ) VALOR_JUROS_MULTA_FAT_ATUAL 
    from bill_invoice b, customer_id_acct_map ciam
    where b.prep_status = 4
    and b.PREP_DATE > sysdate - 15
    and b.bill_period = 'M20' --- <<< alterar o ciclo >>>
    and b.PREP_ERROR_CODE is null
    and exists ( select 1 from cmf c
                 where c.account_no = b.account_no
                 and c.account_category in (10,11) )
    and ciam.account_no = b.account_no
    and ciam.external_id_type = 1
    and exists ( select 1 from bill_invoice_detail bid
                 where b.bill_ref_no = bid.bill_ref_no
                 and b.bill_ref_resets = bid.bill_ref_resets
                 and subtype_code in (12500, 12501) );

cursor busca_fatura_prod_anterior(acc_no number) is 

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


begin
    select trim(GLOBAL_NAME) into AUX_GLOBAL_NAME from GLOBAL_NAME;
    V_FILENAME := 'REL_JM_PROFORMA_' || to_char( sysdate ,'yyyymmdd_hh24miss' ) || '_' || AUX_GLOBAL_NAME ||'.csv';
    V_FILE := UTL_FILE.FOPEN(V_PATH, V_FILENAME, 'W');

    UTL_FILE.PUT_LINE( V_FILE, 'Inicio - ' || AUX_GLOBAL_NAME || ' : ' || to_char( sysdate ,'dd/mm/yyyy - hh24:mi:ss'));
    UTL_FILE.PUT_LINE( V_FILE,'ACCOUNT_NO' ||';'|| 'CONTA_COBRANCA' ||';'|| 'FATURA_ATUAL' ||';'|| 'VCTO_FAT_ATUAL' ||';'|| 'VALOR_FAT_ATUAL' ||';'|| 'VALOR_JUROS_MULTA_FAT_ATUAL' ||';'|| 'FAT_PAGA_ATRASO' ||';'|| 'VCTO_FAT_PAGA_ATRASO' ||';'|| 'DATA_PGTO_FAT_ATRASO' ||';'|| 'VALOR_FAT_ATRASO');    

    for c1 in fat_prof_comjurosmulta loop
        for c2 in busca_fatura_prod_anterior(c1.account_no) loop
            UTL_FILE.PUT_LINE( V_FILE, c1.ACCOUNT_NO ||';'|| c1.CONTA_COBRANCA ||';'|| c1.FATURA_ATUAL ||';'|| to_char(c1.VCTO_FAT_ATUAL,'dd/mm/yyyy') ||';'|| c1.VALOR_FAT_ATUAL ||';'|| c1.VALOR_JUROS_MULTA_FAT_ATUAL ||';'|| c2.FAT_PAGA_ATRASO ||';'|| to_char(c2.VCTO_FAT_PAGA_ATRASO,'dd/mm/yyyy') ||';'|| to_char(c2.DATA_PGTO_FAT_ATRASO,'dd/mm/yyyy') ||';'|| c2.VALOR_FAT_ATRASO);
        end loop;        
    end loop;
    -- dbms_output.put_line('*** FIM - '||dbms_reputil.global_name()||' - '||to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'));
        
    UTL_FILE.PUT_LINE( V_FILE, '______________________________________________________________________________________');
    UTL_FILE.PUT_LINE( V_FILE, 'Fim do processo: ' || to_char( sysdate ,'dd/mm/yyyy - hh24:mi:ss'));
    UTL_FILE.FFLUSH (V_FILE);
    UTL_FILE.FCLOSE(V_FILE);

end;
/
