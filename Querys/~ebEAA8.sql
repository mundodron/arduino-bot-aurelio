
  SELECT   ser.service_inactive_dt,
           CASE
              WHEN LENGTH (
                      TRIM (TRANSLATE (equ.external_id, '0123456789', ' '))
                   ) IS NULL
              THEN
                 CASE
                    WHEN equ.external_id_type = 6
                    THEN
                       CASE
                          WHEN SUBSTR (equ.external_id, 3, 3) NOT IN
                                     ('000', '100')
                          THEN
                             1
                          ELSE
                             2
                       END
                    WHEN equ.external_id LIKE '0800%'
                         OR equ.external_id LIKE '800%'
                    THEN
                       4
                    ELSE
                       3
                 END
              WHEN equ.external_id_type = 6
              THEN
                 5
              WHEN equ.external_id_type = 1
              THEN
                 6
              WHEN equ.external_id_type <> 10
              THEN
                 8
              ELSE
                 7
           END
              ORDEM,
           DECODE (equ.external_id_type,
                   6, ' 6, TELEFONE',
                   7, ' 7, Circ.Dados',
                   1, ' 1, Ident.Fatura',
                   9, ' 9, Internet',
                   10, '10, TV',
                   equ.external_id_type)
              TIPO,
           equ.external_id EQUIP_EXTERNAL_ID,
           UPPER(REPLACE (
                    REPLACE (
                       REPLACE (
                          REPLACE (
                             REPLACE (
                                TRIM(CASE
                                        WHEN address_1 LIKE '%(GVT%'
                                        THEN
                                           SUBSTR (
                                              address_1,
                                              1,
                                              INSTR (address_1, '(GVT') - 1
                                           )
                                        WHEN LENGTH(TRIM(TRANSLATE (
                                                            SUBSTR (
                                                               TRIM (address_1),
                                                               INSTR (
                                                                  TRIM (
                                                                     address_1
                                                                  ),
                                                                  ' ',
                                                                  -1,
                                                                  1
                                                               )
                                                               + 1
                                                            ),
                                                            '0123456789',
                                                            ' '
                                                         ))) IS NULL
                                             AND SUBSTR (address_1,
                                                         INSTR (address_1,
                                                                ' ',
                                                                -1,
                                                                2),
                                                         INSTR (address_1,
                                                                ' ',
                                                                -1,
                                                                1)
                                                         - INSTR (address_1,
                                                                  ' ',
                                                                  -1,
                                                                  2)) NOT LIKE
                                                   '% AP%'
                                        THEN
                                           SUBSTR (address_1,
                                                   1,
                                                   INSTR (TRIM (address_1),
                                                          ' ',
                                                          -1,
                                                          1))
                                        WHEN SUBSTR (address_1,
                                                     INSTR (address_1,
                                                            ' ',
                                                            -1,
                                                            1)) IN
                                                   (' S/N', ' SN')
                                        THEN
                                           SUBSTR (address_1,
                                                   1,
                                                   INSTR (address_1,
                                                          ' ',
                                                          -1,
                                                          1)
                                                   - 1)
                                        ELSE
                                           address_1
                                     END),
                                '        ',
                                ' '
                             ),
                             '  ',
                             ' '
                          ),
                          'null ',
                          ''
                       ),
                       ' .',
                       ''
                    ),
                    ',',
                    ' '
                 ))
              SERVICE_LOGRADOURO,
           CASE
              WHEN LENGTH(TRIM(TRANSLATE (
                                  SUBSTR (TRIM (address_1),
                                          INSTR (TRIM (address_1),
                                                 ' ',
                                                 -1,
                                                 1)
                                          + 1),
                                  '0123456789',
                                  ' '
                               ))) IS NULL
                   AND SUBSTR (address_1, INSTR (address_1,
                                                 ' ',
                                                 -1,
                                                 2), INSTR (address_1,
                                                            ' ',
                                                            -1,
                                                            1)
                                                     - INSTR (address_1,
                                                              ' ',
                                                              -1,
                                                              2)) NOT LIKE
                         '% AP%'
              THEN
                 SUBSTR (TRIM (address_1), INSTR (TRIM (address_1),
                                                  ' ',
                                                  -1,
                                                  1)
                                           + 1)
              /*local_address*/
              ELSE
                 '0'
           END
              SERVICE_NUMERO,
           lad.address_2,
           SUBSTR (UPPER (TRIM (REPLACE (lad.address_2, '; ;', ''))), 1, 60)
              SERVICE_COMPLEMENTO,
           SUBSTR (UPPER (TRIM (lad.address_3)), 1, 60) SERVICE_BAIRRO,
           SUBSTR (UPPER (TRIM (lad.city)), 1, 50) SERVICE_CIDADE,
           SUBSTR (UPPER (TRIM (lad.state)), 1, 2) SERVICE_UF,
           LPAD (
              NVL (
                 TRIM(SUBSTR (
                         TRANSLATE (
                            UPPER (lad.postal_code),
                            '''@()=+,:;.?/\цуг-*ABCDEFGHIJKLMNOPQRSTUVXYWZ',
                            ' '
                         ),
                         1,
                         8
                      )),
                 '0'
              ),
              8,
              '0'
           )
              SERVICE_CEP
    FROM   service ser,
           customer_id_equip_map equ,
           Local_address lad,
           service_address_assoc saa
   WHERE       ser.subscr_no = equ.subscr_no
           AND ser.subscr_no_resets = equ.subscr_no_resets
           AND ser.subscr_no = equ.subscr_no
           AND equ.external_id_type IN (1, 6, 7)
           AND lad.address_id = saa.address_id
           AND saa.account_no = ser.parent_account_no
           AND saa.subscr_no = ser.subscr_no
           AND saa.subscr_no_resets = ser.subscr_no_resets
           AND saa.association_status = 2                              /*###*/
           AND ser.parent_account_no in (SELECT account_no from customer_id_acct_map where external_id = '999979656398')
ORDER BY   2, ser.service_inactive_dt DESC;

select * from customer_id_equip_map where external_id ='CAS-301KPODAF-012'

select * from customer_id_equip_map where external_id ='CAS-301KPODAF-012'

select * from bill_invoice where bill_ref_no = 272953307

proc_carga_erros_bmp