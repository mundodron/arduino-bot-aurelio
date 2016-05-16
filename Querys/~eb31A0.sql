set echo off;
set pagesize 100000 ;
spool C:\DPtt.txt;

select sysdate from dual;

spool off;