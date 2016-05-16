            V_FATURA_PAGA_ATRASO := C2.V_FATURA_PAGA_ATRASO;
            V_VENCI_FATURA_PAGA_ATRASO := C2.VENCI_FATURA_PAGA_ATRASO;
            V_DATA_PGTO_FATURA_ATRASADA  := C2.DATA_PGTO_FATURA_ATRASADA;



select * from nrc, nrc_key nk
 where nk.tracking_id=nrc.tracking_id
   and nk.tracking_id_serv=nrc.tracking_id_serv
   and nrc.billing_account_no in (select  account_no
                                     from g0023421sql.GVT_REL_ENCARGOS
                                    where rownum<300)
                                      and nk.bill_ref_no=0
                                      and nrc.type_id_nrc in (12500, 12501)
                                      and nrc.no_bill=0;