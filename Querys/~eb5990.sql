
select 'Select min(trans_dt)  menor_trans_dt, '||
                    'max(trans_dt)  maior_trans_dt, '||
                    'count(1)       qtde, '||
                    'eot_pagadora, '||
 -- RDM21802   'case '''||APELIDO_OPERADORA||''' when ''TELEFONICA'' then ''011''  when ''EMBRATEL'' then ''001'' else eot_pagadora end  eot_default '||
               'eot_pagadora eot_default'  ||
              'from gvt_chamadas_cb '||
              'where status = ''N'' '||
                     'Parametro_Operadora' ||
                'and substr(annotation,1,3) not in ( ''---'',''   '') '||
                'and trans_dt > sysdate - 45 '||-- conforme prazo contratual
                'and tracking_id not in ( Select tracking_id  from gvt_chamadas_cb_excecao where ativo = ''S'' ) '||
               'group by eot_pagadora, eot_pagadora' 
-- RDM21802 'case '''||APELIDO_OPERADORA||''' when ''TELEFONICA'' then ''011''  when ''EMBRATEL'' then ''001'' else eot_pagadora end';
from dual