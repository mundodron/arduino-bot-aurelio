-- PBCT1: QTDE: 12850
-- PBCT2: QTDE: 13759

select * from GVT_CONTA_INTERNET where bill_ref_no in (
select distinct bill_ref_no 
  from GVT_CONTA_INTERNET
 where data_processamento between to_date('20151001','yyyymmdd') and to_date('20160401','yyyymmdd')  
   and bill_ref_no is not null
   and exists (select 1 from backlog_cdc
                where nome_arquivo = arq
                  and external_id = extid
                  and bill_ref_no <> refno))


-- A carga da fabr_analise_cdc foi feito assim:

create table backlog_cdc as
      select distinct(account_no), nome_arquivo arq, external_id extid, count(*) qtde, max(bill_ref_no) refno
        from GVT_CONTA_INTERNET
       where data_processamento between to_date('20151001','yyyymmdd') and to_date('20160401','yyyymmdd')
         and bill_ref_no is not null
group by account_no,nome_arquivo, external_id 
having count(*) > 1

--drop table backlog_cdc


select * from GVT_TEMP_CONTAS_PROFORMA