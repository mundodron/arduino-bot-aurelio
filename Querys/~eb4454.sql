    INSERT INTO 
    GVT_HISTORY_EIF (ACCOUNT_NO, BILL_REF_NO, BILL_REF_RESETS, BILL_MES, MIN_LOCAIS_UTILIZADOS,
    MIN_LONGA_NACIONAIS, MIN_LOCAIS_VC, MIN_LONGA_NACIONAIS_VC, MIN_INTERNACIONAIS, MIN_LONGA_FAVORITOS,
    MIN_LOCAIS_FAVORITOS, MIN_LOCAIS_FALE_DOBRO, MIN_LOCAIS_EXCEDENTES, MIN_VC1_FAVORITOS, 
    MIN_HORARIO_NORMAL, MIN_HORARIO_REDUZIDO, MIN_ENTRE_PLANO)
     VALUES
       (:p_account_no, :p_bill_ref_no, :p_bill_ref_resets, :p_mesano_atual, :v_locais_utilizados,
     :v_longa_nacionais, :v_locais_vc, :v_longa_nacionais_vc, :v_internacionais, :v_longa_favoritos,
     :v_locais_favoritos, :v_locais_fale_dobro, :v_locais_excedentes, :v_vc1_favoritos, :v_hor_normal, 
     :v_hor_reduzido, :v_entre_plano);