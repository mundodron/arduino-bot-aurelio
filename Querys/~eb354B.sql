Desconex�es feitas pelas interface e pelo sautorot est�o caindo no seguinte erro:

Unable to update service geocode and franchise tax code in SERVICE_BILLING (...) error during execution of trigger 'ARBOR.SERVICE_ADDRESS_ASSOC_AIUTRIG'

Existem duas causas conhecidas:

1 - Mais de uma linha ativa na service_addess_assoc;
2 - FX_GEOCODE inv�lido na ADR_ADDRESS;

A primeira causa caracteriza inconsist�ncia no Kenan, o erro de trigger � esperado. N�o � o caso da segunda causa.

Segue um exemplo:

select * from gvt_cease_account where serv_inst='MGA-104LZ8I4-003-104LZ8IF';

select * from SERVICE_ADDRESS_ASSOC

Quando a SERVICE_ADDRESS_ASSOC_AIUTRIG executa este trecho:

select * from SERVICE_BILLING

UPDATE SERVICE_BILLING
  SET service_geocode = v_fx_geocode,
      service_franchise_tax_code = v_franchise_tax_code
WHERE subscr_no = service_address_assoc_pkg.trig_tab(idx).subscr_no
  AND subscr_no_resets = service_address_assoc_pkg.trig_tab(idx).subscr_no_resets;

O v_fx_geocode n�o � v�lido e dispara erro em outra trigger na service_billing.

(Se o FX_GEOCODE da ADR_ADDRESS for atualizado para o mesmo valor do SERVICE_GEOCODE (SERVICE_BILLING), o registro vai ser processado corretamente.)

Na desconex�o n�o � necess�rio atualizar a service billing, o problema pode ser contornado adicionando uma verfica��o no update:

if service_address_assoc_pkg.trig_tab(idx).inactive_dt IS NULL THEN
  UPDATE SERVICE_BILLING
    SET service_geocode = v_fx_geocode,
        service_franchise_tax_code = v_franchise_tax_code
  WHERE subscr_no = service_address_assoc_pkg.trig_tab(idx).subscr_no
    AND subscr_no_resets = service_address_assoc_pkg.trig_tab(idx).subscr_no_resets;
END IF;

Por favor, verificar se � poss�vel alterar a trigger.
