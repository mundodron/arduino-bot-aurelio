select * from all_tables where table_name like '%FEBRABAN%' 

select * from GVT_FEBRABAN_CATEGORIA where SHORT_DESCRIPTION_TEXT = '500'

select * from descriptions where description_code = 16370

insert into GVT_FEBRABAN_CATEGORIA (DESCRIPTION_CODE,SHORT_DESCRIPTION_TEXT,DESCRIPTION_FEBRABAN,COD_CATEGORIA) values (16370,'300','Chamada 0300',102)


INSERT INTO state
(state_abbrev, state_name)
VALUES
('OR', 'Oregon');


select * from gvt_exec_arg where NOME_PROGRAMA = 'PL0201' order by 1 desc

select * from GVT_FEBRABAN_CATEGORIA where DESCRIPTION_FEBRABAN like '%300%'

select * from GVT_FEBRABAN_CATEGORIA where DESCRIPTION_FEBRABAN like '%300%'

select * from GVT_FEBRABAN_CATEGORIA where description_code = 16370

select * from gvt_bankslip where bill_ref_no = 133164004
 
select * from chamados_boleto where orig_bill_ref_no = 130894714

select * from g0013798sql.DQ_BOLETO_NAO_GERADO

update gvt_bankslip set status = 'T', PPDD_DATE = sysdate + 15 where bill_ref_no =  

select * from gvt_bankslip 
