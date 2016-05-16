select TELEFONE_ORIGEM,CSP,sysdate from GRC_SERVICOS_PRESTADOS
 where motivo = 218
   and status in ('RI','RA','RP')
   
   
select * from all_tables where upper(table_name) like '%COMPONENT%'

select cp.component_id "COMPONENTE",
       cp.DISPLAY_VALUE "DESCRICAO COMPOENTE",
       MEMBER_ID "ELEMENTO",
       ds.DESCRIPTION_TEXT "DESCRICAO ELEMENTO (FATURA)"
  from COMPONENT_DEFINITION_VALUES cp,
       PACKAGE_COMPONENT_MEMBERS mb,
       descriptions ds
where cp.language_code = 2
  and ds.language_code = 2
  and cp.component_id = mb.component_id
  and mb.member_id = ds.description_code
  and inactive_dt is null
  order by 1



select * from PACKAGE_COMPONENTS

select * from PACKAGE_COMPONENT_MEMBERS

select * from COMPONENT_DEFINITION_REF