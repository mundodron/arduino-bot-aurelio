select * from lbx_error where bill_ref_no = 162791313;

 -- commit;
 
 / * Permitir o monitoramento do consumo de energia da bateria ( pensar em mAh)
�������permite definir o valor de alarme na GUI ou via LCD
������Descri��o completa e howto aqui http://www.multiwii.com/wiki/index.php?title=Powermeter
�������Duas op��es:
�������1 - hard : - ( usa sensor de hardware, ap�s a configura��o d� resultados muito bons )
�������2 - moles: - ( bons resultados + -5 % para os CES pel�cia e mist�rio @ 2S e 3S , n�o � bom com SuperSimple ESC ) * /
����/ / # define POWERMETER_SOFT
����/ / # define POWERMETER_HARD
����/ * PLEVELSCALE � o tamanho do passo que voc� pode usar para definir o alarme * /
����# define PLEVELSCALE 50 / / se voc� alterar esse valor para outro granularidade , voc� deve procurar por coment�rios no c�digo para mudar de acordo
����/ * Maior PLEVELDIV vai chegar menor valor para a energia (mAh equivalente) * /
����# define PLEVELDIV 5000 / / (*) padr�o para soft - se menor PLEVELDIV , cuidado com supera��o uint32 pMeter
����# define PLEVELDIVSOFT PLEVELDIV / / para soft sempre igual a PLEVELDIV , pois conjunto dif�cil de 5000
����# define PSENSORNULL 510 / / (*) definido para analogRead () valor para o corrente zero , pois I = 0A meu sensor d� 1/2 Vss , que � de aproximadamente 2.49Volt ;
����# define PINT2mA 13 / / for ( *) exibi��o telemtry : um passo inteiro em anal�gico arduino traduz em mA ( exemplo 4.9 / 37 * 100