Select type_id_usg, jurisdiction, rate_period, round(add_fixed_amt/100000000,3) valor, b.display_value cadencia
  from rate_usage a, units_type_values b
 where element_id = 10482
   and equip_class_code = 51
   and type_id_usg = 617
   and inactive_dt is null
   and b.units_type = a.rate_units_type and b.language_code = 2