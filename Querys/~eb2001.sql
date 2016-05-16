-- Separação de uso SEMPRE LOCAL NÃO ATENDIDA 
-- set type_id_usg_new = '276'
select * from g0023421sql.gvt_sempreloc_full a where not exists (select 1 from usage_jurisdiction where element_id=10333 and jurisdiction = 11 and inactive_dt is null and point_class_target = a.point_id_target);   

-- Separação de uso SEMPRE LOCAL ATENDIDA
-- set type_id_usg_new = '288'
select * from g0023421sql.gvt_sempreloc_full a where exists (select 1 from usage_jurisdiction where element_id=10333 and jurisdiction = 11 and inactive_dt is null and point_class_target = a.point_id_target);   

select point_class_target
from usage_jurisdiction
where element_id=10333
  and jurisdiction = 11
  and inactive_dt is null;
  
select point_id_target from cdr_data

select point_id from usage_points