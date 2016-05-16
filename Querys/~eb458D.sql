
select * from GRC_SERVICOS_PRESTADOS where DATA_INSERCAO > sysdate -4

REM.TCOE.T061389.S01.D130914.H084346.NC.BRT.dafoqhj.GO

select nome_arquivo from GRC_ARQS_BMP where data_carga > sysdate -11 and nome_arquivo not like '%.GN'

select count (*) from GRC_ARQS_BMP where data_carga > sysdate -11


GRC_NAOFATURACONJUNTO