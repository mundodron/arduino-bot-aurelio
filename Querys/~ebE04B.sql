select * from gvt_val_plano where component_id in (30367,30361,30487,30488)

select PLANO from gvt_val_plano where ELEMENTO like ('%Assinatura%')

select * from gvt_val_plano where component_id in (30487,30488,30489,30490) order by 2


select component_id, count(1) from gvt_val_plano group by component_id order by 2 desc 





select rowid, a.* from gvt_val_plano a where A.COMPONEnT_ID IN (30487,30488,30489,30490) ORDER BY component_id