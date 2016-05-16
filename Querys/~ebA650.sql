/*
 Escolha: Baixa de pagamento não efetuada / LIU
Descrição: Por gentileza baixar (Loja GVT Pagamento Manual) e retirar o registro do LIU, pois ao realizar a baixa do LIU está apresentando erro.
Conta: 899999616581
Fatura: 145414262
*/

select * from cmf_balance where bill_ref_no = 145414262

select * from gvt_fbb_bill_invoice where bill_ref_no in (147828227,147823982,147828231) 