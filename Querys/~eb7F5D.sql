begin
select sysdate from dual;

update grc_servicos_prestados set tcoe = 'REM.' || lote || '.NC'
where TCOE is null
and data_insercao > to_date ('01/01/2013', 'dd/mm/yyyy')
and status not in ('R','Rj','DE');

select sysdate from dual;
end;

commit;


select * -- 'REM.' || lote || '.NC'
  from grc_servicos_prestados 
 where TCOE is null
   and data_insercao > to_date ('01/01/2013', 'dd/mm/yyyy')
   and status not in ('R','Rj','DE');

select to_date ('01/01/2013', 'dd/mm/yyyy') from dual