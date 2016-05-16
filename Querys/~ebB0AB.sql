select * from lbx_error where bill_ref_no = 162791313;

 -- commit;
 
 / * Permitir o monitoramento do consumo de energia da bateria ( pensar em mAh)
       permite definir o valor de alarme na GUI ou via LCD
      Descrição completa e howto aqui http://www.multiwii.com/wiki/index.php?title=Powermeter
       Duas opções:
       1 - hard : - ( usa sensor de hardware, após a configuração dá resultados muito bons )
       2 - moles: - ( bons resultados + -5 % para os CES pelúcia e mistério @ 2S e 3S , não é bom com SuperSimple ESC ) * /
    / / # define POWERMETER_SOFT
    / / # define POWERMETER_HARD
    / * PLEVELSCALE é o tamanho do passo que você pode usar para definir o alarme * /
    # define PLEVELSCALE 50 / / se você alterar esse valor para outro granularidade , você deve procurar por comentários no código para mudar de acordo
    / * Maior PLEVELDIV vai chegar menor valor para a energia (mAh equivalente) * /
    # define PLEVELDIV 5000 / / (*) padrão para soft - se menor PLEVELDIV , cuidado com superação uint32 pMeter
    # define PLEVELDIVSOFT PLEVELDIV / / para soft sempre igual a PLEVELDIV , pois conjunto difícil de 5000
    # define PSENSORNULL 510 / / (*) definido para analogRead () valor para o corrente zero , pois I = 0A meu sensor dá 1/2 Vss , que é de aproximadamente 2.49Volt ;
    # define PINT2mA 13 / / for ( *) exibição telemtry : um passo inteiro em analógico arduino traduz em mA ( exemplo 4.9 / 37 * 100