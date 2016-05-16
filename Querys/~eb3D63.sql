select * from gvt_sempreloc_full

grant all on gvt_sempreloc_full to public


select point_class_target
from usage_jurisdiction
where element_id=10333
  and jurisdiction = 11
  and inactive_dt is null;