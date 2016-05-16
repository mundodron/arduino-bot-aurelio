/*

BANCO: 399;HSBC                ;                                                  ;DEBITO AUTOMATICO   ;                     ;               ;          ;                                                  ;;                    
IDENT CLIENT;IDENT FATURA;IDENT BAIXA;   VALOR DEBITO;     VALOR PAGO;DT PAGTO  ;MENSAGEM                                          ;   SEQ-NSA;                 
999983995971;0103863851;0009067547;         133,05;       279648;15/02/2012;Débito efetuado                                    ;  4664;                        
QTDE :000001;TOTAL : ;         133,05;       2.796,48;DIFERENCA : ;      -2.663,43;;                                                  ;;                         
            ;          ;          ;               ;               ;          ;                                                  ;      ;                        

 */

select * from customer_id_acct_map where external_id = '999983995971'--'999984850086'

select * from bmf where account_no = 4224513 and bill_ref_no = 103863851

select * from cmf_balance where account_no = 4224513

select * from cmf_balance where account_no = 4224513 and bill_ref_no = 103863851

