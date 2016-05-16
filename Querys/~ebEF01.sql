/*
Descrição: Por favor, verificar por que as faturas 143494431,142815730,
142815531,141426118 e 141430134, tem minutos faturados e não estão na tabela GVT_HISTORY_EIF.
*/

select * from GVT_HISTORY_EIF where bill_ref_no in (143494431,142815730,142815531,141426118,141430134)

select * from GVT_BILL_INVOICE_NFST where bill_ref_no in (143494431,142815730,142815531,141426118,141430134)




