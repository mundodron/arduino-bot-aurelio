select id from PRE_MEDIATION_OWNER.GVT_PMED_CDR where id < (select max(id) from PRE_MEDIATION_OWNER.GVT_PMED_CDR where to_date(SUBSTR(CDR_FILE_NAME,23,8),'YYYYMMDD') < sysdate -190)

delete from PRE_MEDIATION_OWNER.GVT_PMED_CDR where id < 1503



select *  from PRE_MEDIATION_OWNER.GVT_PMED_CDR_FILE_TRACK where to_date(SUBSTR(SOURCE_FILE_NAME,23,8),'YYYYMMDD') < sysdate -190  

commit;

select * from PRE_MEDIATION_OWNER.GVT_PMED_CDR_PARTIAL where PROCESSING_DATE < sysdate - 190 

commit;

select * from PRE_MEDIATION_OWNER.GVT_PMED_CDR_FILE where PROCESSED_DATE < sysdate - 190

commit;
