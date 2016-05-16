SET LINESIZE 3000;
SET PAGESIZE 0;
set heading off echo off feedback off;
SET colsep    " ; ";

SPOOL C:\REC_COUNT.SQL

select * from all_tables;

spool off;