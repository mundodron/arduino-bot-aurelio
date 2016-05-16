select v.* from gvt_duration_usg_variable V,
              DESCRIPTIONS D
         where V.ELEMENT_ID = D.DESCRIPTION_CODE
         and type_id_usg = 360 