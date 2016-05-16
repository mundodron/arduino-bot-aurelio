    select id
      from PRE_MEDIATION_OWNER.GVT_PMED_CDR
     where id < (select max(id)
                   from PRE_MEDIATION_OWNER.GVT_PMED_CDR
                  where to_date(SUBSTR(CDR_FILE_NAME,23,8),'YYYYMMDD') < sysdate -190);