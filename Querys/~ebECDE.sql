select * from cmf_balance where bill_ref_no = 231921369

select * from GVT_DET_FATURAMENTO_CD where external_id= '999988297186'

select * from grc_servicos_prestados where lote in ('T401141.S00.D251114.H070003','TCOE.T401141.S00.D251114.H072923','T401141.S00.D271114.H070011','T401141.S00.D271114.H080721','T401141.S00.D021214.H070013','T401141.S00.D021214.H072338','T401141.S00.D041214.H070009','T401141.S00.D041214.H072512','T401141.S00.D091214.H070009','T401141.S00.D091214.H074348','T401141.S00.D111214.H072535','T401141.S00.D161214.H070011','T401141.S00.D161214.H073655','T401141.S00.D181214.H195654','T401141.S00.D181214.H201638','T401141.S00.D231214.H070008','T401141.S00.D231214.H072749','T401141.S00.D251214.H113225','T401141.S00.D251214.H120257','T401141.S00.D301214.H070009','T401141.S00.D301214.H072805','T401141.S00.D010115.H163134','T401141.S00.D010115.H171331','T401141.S00.D060115.H070012','T401141.S00.D060115.H074715','T401141.S00.D080115.H070013','T401141.S00.D080115.H072759','T401141.S00.D160115.H095826','T401141.S00.D160115.H103054','T401141.S00.D200115.H070011','T401141.S00.D200115.H072004','T401141.S00.D220115.H070007','T401141.S00.D220115.H073229','T401141.S00.D270115.H082055','T401141.S00.D270115.H084235','T401141.S00.D290115.H070008','T401141.S00.D290115.H073303','T401141.S00.D030215.H070008','T401141.S00.D030215.H072558','T401141.S00.D050215.H070010','T401141.S00.D050215.H072131','T401141.S00.D100215.H070011','T401141.S00.D100215.H073158','T401141.S00.D120215.H070018','T401141.S00.D120215.H073349','T401141.S00.D170215.H070008','T401141.S00.D170215.H073032','T401141.S00.D190215.H070008','T401141.S00.D190215.H073439','T401141.S00.D240215.H070007','T401141.S00.D240215.H074143','T401141.S00.D260215.H070007','T401141.S00.D260215.H073714','T401141.S00.D030315.H070007','T401141.S00.D030315.H072955','T401141.S00.D050315.H111148','T401141.S00.D050315.H120907','T401141.S00.D100315.H070007','T401141.S00.D100315.H073627','T401141.S00.D120315.H092507')

select * from grc_servicos_prestados where lote = 'TCOR.T401141.S00.D271114.H080721'

select * from grc_servicos_prestados where lote = 'TCOR.T401141.S00.D120315.H092507'


select * from cobilling.retorno_enviados where SUBSTR(DSNAME, 1, 12) = 'TCOR.T401141' AND DT_ENVIO > ('20-NOV-14')


select substr(dsname,1,24), dsname, count(1) from cobilling.remessa_recebidos 
where operadora = 'TIM'
group by substr(dsname,1,24), dsname
having count(1) = 1;

select * from grc_servicos_prestados


select REQUEST_STATUS from adj
group by REQUEST_STATUS