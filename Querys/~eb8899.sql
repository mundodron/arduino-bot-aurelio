select cdv.display_value, d.description_text, pcm.*
from package_component_members pcm, descriptions d, component_definition_values cdv
where pcm.component_id in  (31233,29642)
and cdv.language_Code = 2
and d.language_code = 2
and cdv.component_id = pcm.component_id
and d.description_code = pcm.member_id