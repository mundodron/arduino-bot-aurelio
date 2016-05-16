* Suspensão temporária de TV a Pedido para "Suspensão temporária de IPTV a Pedido"
* Suspens%otempor%ria de TV a Pedido para "Suspensão temporária de TV a Pedido"

select * from descriptions where DESCRIPTION_TEXT like '%TV a pedido%'

select * from descriptions where DESCRIPTION_CODE 

select * from COMPONENT_DEFINITION_VALUES where component_id in (31233,29642)

select * from descriptions 

select * from COMPONENT_DEFINITION_VALUES where DISPLAY_VALUE

select * from all_tables where table_name like '%VALUES%'


EXTERNAL_ID_TYPE (Instância)    COMPONENT_ID    ELEMENT_ID    DISPLAY_VALUE
10    29642    10222    Suspens?Tempor?a TV a pedido
11    31233    10619    Suspensão Temporária TV a pedido

select cdv.display_value, d.description_text, PCM.MEMBER_ID, PCM.COMPONENT_ID
from package_component_members pcm, descriptions d, component_definition_values cdv
where pcm.component_id in  (31233,29642)
and cdv.language_Code = 2
and d.language_code = 2
and cdv.component_id = pcm.component_id
and d.description_code = pcm.member_id

-- update COMPONENT_DEFINITION_VALUES set DISPLAY_VALUE = 'Suspensão Temporária TV a pedido' where COMPONENT_ID = 29642;

-- update COMPONENT_DEFINITION_VALUES set DISPLAY_VALUE = 'Suspensão Temporária IPTV a pedido' where COMPONENT_ID = 31233;

-- update DESCRIPTIONS set DESCRIPTION_TEXT = 'Suspensão Temporária IPTV a pedido' where DESCRIPTION_CODE = 10619;

select * from DESCRIPTIONS where description_code = 10619