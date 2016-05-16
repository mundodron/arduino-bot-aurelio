-- Selecionar clientes com faturas em em aberto
select ci.EXTERNAL_ID, c.ACCOUNT_NO, c.BILL_REF_NO, c.TOTAL_DUE from cmf cm, cmf_balance c, customer_id_acct_map ci 
where c.CLOSED_DATE is null
and c.bill_ref_no <> 0
and c.ACCOUNT_NO = ci.ACCOUNT_NO
and c.ACCOUNT_NO = cm.ACCOUNT_NO
and ci.EXTERNAL_ID_TYPE = 1
and cm.ACCOUNT_CATEGORY = 10
and cm.ACCOUNT_NO = cm.HIERARCHY_ID
order by c.BILL_REF_NO desc

-- Visualizar tipos de uso
select u.TYPE_ID_USG, d.DESCRIPTION_TEXT, d.SHORT_DESCRIPTION_TEXT 
from USAGE_TYPES u, DESCRIPTIONS d 
where u.DESCRIPTION_CODE = d.DESCRIPTION_CODE
--and u.TYPE_ID_USG in (401, 402, 403)
and d.LANGUAGE_CODE = 2
order by u.TYPE_ID_USG

-- Visualizar jurisdições
select j.JURISDICTION, d.DESCRIPTION_TEXT 
from JURISDICTIONS j, DESCRIPTIONS d 
where j.DESCRIPTION_CODE = d.DESCRIPTION_CODE
and d.LANGUAGE_CODE = 2
--and j.JURISDICTION in (0,9,10)
ORDER BY J.JURISDICTION

-- Visualizar Categorias de clientes
select a.ACCOUNT_CATEGORY, a.DISPLAY_VALUE
from account_category_values a
where a.LANGUAGE_CODE = 2
order by a.ACCOUNT_CATEGORY

--Lista de Instâncias Corporate/Retail/SME
select DISTINCT c.ACCOUNT_NO, a.DISPLAY_VALUE, equip.EXTERNAL_ID
from cmf c, account_category_values a, 
CUSTOMER_ID_EQUIP_MAP equip, service s
where c.ACCOUNT_CATEGORY = a.ACCOUNT_CATEGORY
and s.PARENT_ACCOUNT_NO = c.ACCOUNT_NO
and s.SUBSCR_NO = equip.SUBSCR_NO
and equip.EXTERNAL_ID_TYPE = 1
and equip.INACTIVE_DATE is null
and s.DISPLAY_EXTERNAL_ID_TYPE = 6
and c.ACCOUNT_CATEGORY = 11

-- Visualizar Corridors de clientes (Sem o Favoritos GVT)
select e.EXTERNAL_ID, c.CONTACT1_PHONE, cr.CORRIDOR_PLAN_ID, cpiv.DISPLAY_VALUE
from cmf c, customer_corridors cr, customer_id_acct_map e, corridor_plan_id_values cpiv
where c.ACCOUNT_NO = e.ACCOUNT_NO
and c.ACCOUNT_NO = cr.ACCOUNT_NO
and cr.ACCOUNT_NO = e.ACCOUNT_NO
and c.ACCOUNT_NO = c.HIERARCHY_ID
and cr.CORRIDOR_PLAN_ID <> 28475
and cr.CORRIDOR_PLAN_ID = cpiv.CORRIDOR_PLAN_ID
and c.ACCOUNT_CATEGORY = 12
order by cr.CORRIDOR_PLAN_ID desc

-- Visualizar Clientes com Corridors Favoritos GVT
select e.EXTERNAL_ID, c.CONTACT1_PHONE , cr.CORRIDOR_PLAN_ID, cr.POINT_ORIGIN , cr.POINT_TARGET
from cmf c, customer_corridors cr, customer_id_acct_map e
where c.ACCOUNT_NO = e.ACCOUNT_NO
and c.ACCOUNT_NO = cr.ACCOUNT_NO
and cr.ACCOUNT_NO = e.ACCOUNT_NO
and c.ACCOUNT_NO = c.HIERARCHY_ID
and cr.CORRIDOR_PLAN_ID = 28475
and c.ACCOUNT_CATEGORY = 12
and cr.INACTIVE_DT is null

-- Pesquisar cliente pela conta cobrança
select * from customer_id_acct_map c
where c.EXTERNAL_ID = '999999039066'

--Visualizar Planos (Produtos)
select p.ELEMENT_ID, p.LEVEL_CODE as Nivel, d.DESCRIPTION_TEXT 
from PRODUCT_ELEMENTS p, DESCRIPTIONS d 
where p.DESCRIPTION_CODE = d.DESCRIPTION_CODE
and d.LANGUAGE_CODE = 2
and d.DESCRIPTION_TEXT like '%Básico%'  
--and p.ELEMENT_ID in (11569, 11570)

-- Selecionar instâncias que possuem os produtos
select pr.BILLING_ACCOUNT_NO , c.EXTERNAL_ID from product pr, CUSTOMER_ID_EQUIP_MAP c 
where pr.BILLING_INACTIVE_DT is null
and c.INACTIVE_DATE is null 
and c.EXTERNAL_ID_TYPE = 1
and pr.ELEMENT_ID in (
    select p.ELEMENT_ID 
    from PRODUCT_ELEMENTS p, DESCRIPTIONS d 
    where p.DESCRIPTION_CODE = d.DESCRIPTION_CODE
    and d.LANGUAGE_CODE = 2
    and d.DESCRIPTION_TEXT like '%Economix%Flex%')
and pr.PARENT_SUBSCR_NO = c.SUBSCR_NO

-- Selecionar instâncias que possuem os produtos Economix Flex
select pr.BILLING_ACCOUNT_NO , c.EXTERNAL_ID from product pr, CUSTOMER_ID_EQUIP_MAP c 
where pr.BILLING_INACTIVE_DT is null
and c.INACTIVE_DATE is null 
and c.EXTERNAL_ID_TYPE = 1
and pr.ELEMENT_ID in (
    select p.ELEMENT_ID 
    from PRODUCT_ELEMENTS p, DESCRIPTIONS d 
    where p.DESCRIPTION_CODE = d.DESCRIPTION_CODE
    and d.LANGUAGE_CODE = 2
    and d.DESCRIPTION_TEXT like '%Economix%Flex%')
and pr.PARENT_SUBSCR_NO = c.SUBSCR_NO

-- Selecionar clientes com Corridor Local 30
select account_no, next_bill_date from cmf
where cmf.DATE_INACTIVE is null
and cmf.ACCOUNT_NO in (
    select cc.ACCOUNT_NO from customer_corridors cc
    where cc.INACTIVE_DT is null 
    and cc.CORRIDOR_PLAN_ID in (select corridor_plan_id from corridor_plan_id_values c 
        where c.DISPLAY_VALUE like 'Corridor Lo30'
        and c.SHORT_DISPLAY like 'LO') 
)

-- Selecionar clientes com Francia VC1 e LDN
select p.ELEMENT_ID, p.BILLING_ACCOUNT_NO, c.EXTERNAL_ID
from PRODUCT p, CUSTOMER_ID_EQUIP_MAP c
WHERE p.BILLING_INACTIVE_DT is null 
and p.BILLING_ACTIVE_DT is not null
and c.SUBSCR_NO = p.PARENT_SUBSCR_NO
and p.ELEMENT_ID in (11411, 11398)
order by p.ELEMENT_ID, p.BILLING_ACCOUNT_NO, c.SUBSCR_NO

-- Selecionar provedores
-- 13 - Provedor não GVT 
-- 9 - Procedor GVT
select DISTINCT uj.POINT_TARGET, uj.JURISDICTION, uj.ACTIVE_DT
from usage_jurisdiction uj
where jurisdiction in (9)
and uj.INACTIVE_DT is null
and uj.POINT_TARGET like '41%' 
order by uj.ACTIVE_DT

-- Tipos de Uso - Rede Economix
select u.TYPE_ID_USG, d.DESCRIPTION_TEXT from usage_types u, descriptions d
where u.DESCRIPTION_CODE = d.DESCRIPTION_CODE
and u.TYPE_ID_USG in (404,405)
and d.LANGUAGE_CODE = 2

-- Visualizar Descontos
select dis.DISCOUNT_ID, dis.ELEMENT_ID, des.DESCRIPTION_TEXT from discount_definitions dis, descriptions des
where dis.DESCRIPTION_CODE = des.DESCRIPTION_CODE
and des.DESCRIPTION_TEXT like '%Plano de Desconto Digital X%'
and des.LANGUAGE_CODE = 2
order by dis.DISCOUNT_ID desc

-- Visualizar Instâncias com Contratos (Cenário 26)
    select cc.PARENT_ACCOUNT_NO, cc.PARENT_SUBSCR_NO, ce.EXTERNAL_ID from customer_contract cc, CUSTOMER_ID_EQUIP_MAP ce
    where cc.CONTRACT_TYPE in (
        -- Visulizar contratos com descontos
        select ct.CONTRACT_TYPE from CONTRACT_TYPES ct, discount_definitions dd
        where ct.PLAN_ID_DISCOUNT = dd.DISCOUNT_ID 
        and dd.DISCOUNT_ID in (14852))
    and cc.PARENT_SUBSCR_NO = ce.SUBSCR_NO
    and ce.EXTERNAL_ID_TYPE = 1
    and ce.INACTIVE_DATE is null

-- SELECIONAR CLIENTES COM PRODUTOS
SELECT EIAM.EXTERNAL_ID, EIEM.EXTERNAL_ID,S.SERVICE_ACTIVE_DT, S.SERVICE_INACTIVE_DT, 
     S.PARENT_ACCOUNT_NO, S.SUBSCR_NO, P.ELEMENT_ID,DES.DESCRIPTION_TEXT, 
     PCM.BILLED_THRU_DT DT_ULTIMO_FATURAMENTO, PCM.BILLED_THRU_DT DT_INICIO, PCM.BILLED_THRU_DT +29 DT_FIM,
     PCM.BILLED_THRU_DT-90 AS "CDRS CENÁRIO ESPECÍFICO 90", 
     P.PRODUCT_ACTIVE_DT, P.PRODUCT_INACTIVE_DT   
FROM  SERVICE S, PRODUCT P, PRODUCT_CHARGE_MAP PCM, CUSTOMER_ID_ACCT_MAP EIAM, 
     CUSTOMER_ID_EQUIP_MAP EIEM, DESCRIPTIONS DES
WHERE/*  S.PARENT_ACCOUNT_NO in (815018,2133143,2133144,1679981)
AND   */ S.PARENT_ACCOUNT_NO = P.PARENT_ACCOUNT_NO
AND    P.PRODUCT_INACTIVE_DT IS NULL
AND    P.TRACKING_ID = PCM.TRACKING_ID
AND    P.TRACKING_ID_SERV = PCM.TRACKING_ID_SERV
AND    P.PARENT_ACCOUNT_NO = PCM.PARENT_ACCOUNT_NO
AND    EIAM.ACCOUNT_NO = S.PARENT_ACCOUNT_NO
AND    EIEM.SUBSCR_NO = S.SUBSCR_NO
AND    EIEM.SUBSCR_NO_RESETS = S.SUBSCR_NO_RESETS
AND    EIAM.EXTERNAL_ID_TYPE= 1
AND    EIEM.EXTERNAL_ID_TYPE= 1
AND    EIEM.EXTERNAL_ID in ('04196969354')
AND    P.ELEMENT_ID = DES.DESCRIPTION_CODE
AND    DES.LANGUAGE_CODE = 2
AND    S.SERVICE_INACTIVE_DT IS NULL
AND    EXISTS (SELECT 'X' FROM PRODUCT_ELEMENTS PE
             WHERE P.ELEMENT_ID = PE.ELEMENT_ID
             AND TYPE_GROUP_USG <> 0)
             
-- seleciona CDR's a Faturar com data superior a 90 dias ---
select *
from cdr_unbilled
where trans_dt < (sysdate-90);

-- Listar Contas Cobranças vs Instâncias
select c.ACCOUNT_NO, acct.EXTERNAL_ID as CONTA_COBRANCA, equip.EXTERNAL_ID as instancia
from service s, customer_id_equip_map equip, customer_id_acct_map acct, cmf c
where s.PARENT_ACCOUNT_NO = c.ACCOUNT_NO
and s.SUBSCR_NO = equip.SUBSCR_NO
and acct.ACCOUNT_NO = c.ACCOUNT_NO
and acct.EXTERNAL_ID_TYPE = 1
and equip.EXTERNAL_ID_TYPE = 1
and s.SERVICE_INACTIVE_DT is null

--Lista de Instâncias Retail
select DISTINCT c.ACCOUNT_NO
from cmf c, account_category_values a, 
CUSTOMER_ID_EQUIP_MAP equip, service s
where c.ACCOUNT_CATEGORY = a.ACCOUNT_CATEGORY
and s.PARENT_ACCOUNT_NO = c.ACCOUNT_NO
and s.SUBSCR_NO = equip.SUBSCR_NO
and equip.EXTERNAL_ID_TYPE = 1
and equip.INACTIVE_DATE is null
and s.DISPLAY_EXTERNAL_ID_TYPE = 6
and c.ACCOUNT_CATEGORY = 11

-- Cliente NRC de taxa de instalação não faturada
-- campo bill_ref_no = 0 na nrc_key
select N.BILLING_ACCOUNT_NO 
from nrc N, nrc_key K
where N.TRACKING_ID = K.TRACKING_ID
And K.BILL_REF_NO = 0
