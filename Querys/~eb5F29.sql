Select count(*) qt,  decode(status,  'B','Boletos Gerados',
                                                'P','Problemas n�o Corrigidos',
                                                'R','Problemas     Corrigidos',
                                                'T','Tratados',
                                                '5','Boletos iguais ou menores que R$5,00',
                                                'D','Boletos Duplicados',
                                                'V','Data de Vencimento n�o foi Postergada',
                                                'N','Boleto sem Numero de Nota Fiscal',
                                                'Erro desconhecido') descricao
                from gvt_bankslip where sequencial = 703 group by status
                
                select * from gvt_bankslip where sequencial = 703
                
                delete from gvt_bankslip where sequencial = 703