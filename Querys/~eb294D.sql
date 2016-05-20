select cmf.account_no,
j.JURISDICTION,
cmf.BILL_LNAME NOME, 
        bi.bill_ref_no FATURA,
        bi.FROM_DATE PERÍODOINICIAL,
        bi.to_date PERÍODOFINAL,
        bi.STATEMENT_DATE DATAEMISSÃO,
        up.point_city CIDADE,
        UP.POINT_STATE_ABBR UF,
        c.POINT_ORIGIN POINT_ORIGIN,
        c.POINT_TARGET POINT_TARGET, 
        c.external_id EXTERNAL_ID,
        C.TYPE_ID_USG CÓDIGO, 
        c.ORIG_TYPE_ID_USG,
        e.DESCRIPTION_TEXT SERVICO,
        f.description_text PlanoTarifas,
        c.element_id,
         cb.UNIT_CR_ID ID_FRAQUIA,
        d.DESCRIPTION_TEXT FRANQUIA,        
        to_char( cb.TRANS_DT, 'dd/mm/yyyy') data, to_char( cb.TRANS_DT, 'hh24:mi:ss') hora,
        case when (c.PRIMARY_UNITS/60)<1 then 1
                 else ROUND (c.PRIMARY_UNITS/60) end DURAçãO,
        c.PRIMARY_UNITS,
        cb.amount_credited/100 DescontoR$,
        (c.amount-cb.amount_credited)/100 ValorCobradoR$,
        c.AMOUNT/100 as ValorOriginalR$,
        c.RATE_PERIOD AS horario,
        (CBL.NEW_CHARGES/100)TOTAL_FATURA_R$,
        c.RATED_UNITS,
        cb.UNITS_CREDITED, C.Orig_Type_Id_Usg
 FROM   cdr_billed cb,
      cdr_data c,
      descriptions d, 
      descriptions e,
      descriptions f,
      jurisdictions j,
      descriptions g,
      usage_points up,
      cmf,
      bill_invoice bi,
      CMF_BALANCE CBL
where  cb.MSG_ID=c.MSG_ID
  and cb.MSG_ID_SERV=c.MSG_ID_SERV
  and cb.MSG_ID2=c.MSG_ID2
  and cb.split_row_num=c.split_row_num
  and c.point_id_target=up.point_id(+)
  -- and bi.BILL_REF_NO = 175811811    ---NUMERO DA FATURA  
  -- and cb.POINT_TARGET='3133982870'
  and cmf.account_no = 9855857
  and cb.UNIT_CR_ID =d.DESCRIPTION_CODE (+)
  and '16'||cb.TYPE_ID_USG=e.DESCRIPTION_CODE (+)
  and j.description_code=g.description_code(+)
  and j.jurisdiction=c.jurisdiction
  and c.element_id=f.description_code (+)
  and f.language_code (+)=2
  and d.LANGUAGE_CODE (+)=2 
  and e.LANGUAGE_CODE (+)=2
  and g.language_code (+)=2
  and c.ACCOUNT_NO=cmf.ACCOUNT_NO
  and cb.bill_ref_no=bi.bill_ref_no
  AND CBL.BILL_REF_NO=BI.BILL_REF_NO
 ORDER BY c.TRANS_DT;