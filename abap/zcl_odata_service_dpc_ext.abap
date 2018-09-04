CLASS zcl_odata_service_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_odata_service_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS gv_refresh_message TYPE string VALUE `{"action": "refresh"}`.
    CLASS-METHODS populate_db.
  PROTECTED SECTION.

    CLASS-METHODS send_refresh.
    METHODS categorys_get_entity
         REDEFINITION .
    METHODS categorys_get_entityset
         REDEFINITION .
    METHODS currencys_get_entity
         REDEFINITION .
    METHODS currencys_get_entityset
         REDEFINITION .
    METHODS products_create_entity
         REDEFINITION .
    METHODS products_delete_entity
         REDEFINITION .
    METHODS products_get_entity
         REDEFINITION .
    METHODS products_get_entityset
         REDEFINITION .
    METHODS products_update_entity
         REDEFINITION .
    METHODS weightunits_get_entity
         REDEFINITION .
    METHODS weightunits_get_entityset
         REDEFINITION .
  PRIVATE SECTION.


ENDCLASS.



CLASS zcl_odata_service_DPC_EXT IMPLEMENTATION.


  METHOD categorys_get_entity.
    DATA: ls_converted_keys LIKE er_entity,
          ls_source_keys    TYPE zcl_odata_service_mpc=>ts_product.

    IF io_tech_request_context->get_source_entity_set_name( ) = 'Products'.

      io_tech_request_context->get_converted_source_keys(
        IMPORTING
            es_key_values  = ls_source_keys
      ).
      SELECT SINGLE * FROM zdemo_epm_ws_prd AS prd
          INNER JOIN zdemo_epm_ws_cat AS cat ON prd~category = cat~id
          INTO CORRESPONDING FIELDS OF @er_entity WHERE prd~id = @ls_source_keys-id.
    ELSE.
      io_tech_request_context->get_converted_keys(
        IMPORTING
          es_key_values  = ls_converted_keys
      ).

      SELECT SINGLE * FROM zdemo_epm_ws_cat INTO
          CORRESPONDING FIELDS OF @er_entity WHERE
          id = @ls_converted_keys-id.
    ENDIF.
    IF sy-subrc <> 0.
      me->/iwbep/if_sb_dpc_comm_services~rfc_exception_handling(
         EXPORTING
           iv_subrc            = sy-subrc
           iv_exp_message_text = 'Entity not found.'(001) ).
    ENDIF.
  ENDMETHOD.


  METHOD categorys_get_entityset.
    IF line_exists( it_filter_select_options[ property = `NAME` ] ).
      DATA(lt_select_opts) = it_filter_select_options[ property = `NAME` ]-select_options.
      SELECT * FROM zdemo_epm_ws_cat INTO CORRESPONDING FIELDS OF TABLE @et_entityset
          WHERE name IN @lt_select_opts.
    ELSE.
      SELECT * FROM zdemo_epm_ws_cat INTO CORRESPONDING FIELDS OF TABLE @et_entityset.
    ENDIF.
  ENDMETHOD.


  METHOD currencys_get_entity.
    DATA: ls_converted_keys LIKE er_entity,
          ls_source_keys    TYPE zcl_odata_service_mpc=>ts_product.

    IF io_tech_request_context->get_source_entity_set_name( ) = 'Products'.

      io_tech_request_context->get_converted_source_keys(
        IMPORTING
            es_key_values  = ls_source_keys
      ).
      SELECT SINGLE * FROM zdemo_epm_ws_prd AS prd
          INNER JOIN zdemo_epm_ws_crr AS crr ON prd~currency = crr~code
          INTO CORRESPONDING FIELDS OF @er_entity WHERE prd~id = @ls_source_keys-id.
    ELSE.
      io_tech_request_context->get_converted_keys(
        IMPORTING
          es_key_values  = ls_converted_keys
      ).

      SELECT SINGLE * FROM zdemo_epm_ws_crr INTO
          CORRESPONDING FIELDS OF @er_entity WHERE
          code = @ls_converted_keys-code.
    ENDIF.
    IF sy-subrc <> 0.
      me->/iwbep/if_sb_dpc_comm_services~rfc_exception_handling(
         EXPORTING
           iv_subrc            = sy-subrc
           iv_exp_message_text = 'Entity not found.'(001) ).
    ENDIF.
  ENDMETHOD.


  METHOD currencys_get_entityset.
    IF line_exists( it_filter_select_options[ property = `CODE` ] ).
      DATA(lt_select_opts) = it_filter_select_options[ property = `CODE` ]-select_options.
      SELECT * FROM zdemo_epm_ws_crr INTO CORRESPONDING FIELDS OF TABLE @et_entityset
          WHERE code IN @lt_select_opts.
    ELSE.
      SELECT * FROM zdemo_epm_ws_crr INTO CORRESPONDING FIELDS OF TABLE @et_entityset.
    ENDIF.
  ENDMETHOD.


  METHOD populate_db.
    DATA: lt_cat TYPE STANDARD TABLE OF zdemo_epm_ws_cat WITH EMPTY KEY,
          lt_crr TYPE STANDARD TABLE OF zdemo_epm_ws_crr WITH EMPTY KEY,
          lt_wgu TYPE STANDARD TABLE OF zdemo_epm_ws_wgu WITH EMPTY KEY,
          lt_prd TYPE STANDARD TABLE OF zdemo_epm_ws_prd WITH EMPTY KEY.

    lt_crr = VALUE #(
       ( code = 'AED' description = 'United Arab Emirates Dirham'                         )
       ( code = 'AFN' description = 'Afghanistan Afghani'                                 )
       ( code = 'ALL' description = 'Albania Lek'                                         )
       ( code = 'AMD' description = 'Armenia Dram'                                        )
       ( code = 'ANG' description = 'Netherlands Antilles Guilder'                        )
       ( code = 'AOA' description = 'Angola Kwanza'                                       )
       ( code = 'ARS' description = 'Argentina Peso'                                      )
       ( code = 'AUD' description = 'Australia Dollar'                                    )
       ( code = 'AWG' description = 'Aruba Guilder'                                       )
       ( code = 'AZN' description = 'Azerbaijan New Manat'                                )
       ( code = 'BAM' description = 'Bosnia and Herzegovina Convertible Marka'            )
       ( code = 'BBD' description = 'Barbados Dollar'                                     )
       ( code = 'BDT' description = 'Bangladesh Taka'                                     )
       ( code = 'BGN' description = 'Bulgaria Lev'                                        )
       ( code = 'BHD' description = 'Bahrain Dinar'                                       )
       ( code = 'BIF' description = 'Burundi Franc'                                       )
       ( code = 'BMD' description = 'Bermuda Dollar'                                      )
       ( code = 'BND' description = 'Brunei Darussalam Dollar'                            )
       ( code = 'BOB' description = 'Bolivia Boliviano'                                   )
       ( code = 'BRL' description = 'Brazil Real'                                         )
       ( code = 'BSD' description = 'Bahamas Dollar'                                      )
       ( code = 'BTN' description = 'Bhutan Ngultrum'                                     )
       ( code = 'BWP' description = 'Botswana Pula'                                       )
       ( code = 'BYR' description = 'Belarus Ruble'                                       )
       ( code = 'BZD' description = 'Belize Dollar'                                       )
       ( code = 'CAD' description = 'Canada Dollar'                                       )
       ( code = 'CDF' description = 'Congo/Kinshasa Franc'                                )
       ( code = 'CHF' description = 'Switzerland Franc'                                   )
       ( code = 'CLP' description = 'Chile Peso'                                          )
       ( code = 'CNY' description = 'China Yuan Renminbi'                                 )
       ( code = 'COP' description = 'Colombia Peso'                                       )
       ( code = 'CRC' description = 'Costa Rica Colon'                                    )
       ( code = 'CUC' description = 'Cuba Convertible Peso'                               )
       ( code = 'CUP' description = 'Cuba Peso'                                           )
       ( code = 'CVE' description = 'Cape Verde Escudo'                                   )
       ( code = 'CZK' description = 'Czech Republic Koruna'                               )
       ( code = 'DJF' description = 'Djibouti Franc'                                      )
       ( code = 'DKK' description = 'Denmark Krone'                                       )
       ( code = 'DOP' description = 'Dominican Republic Peso'                             )
       ( code = 'DZD' description = 'Algeria Dinar'                                       )
       ( code = 'EGP' description = 'Egypt Pound'                                         )
       ( code = 'ERN' description = 'Eritrea Nakfa'                                       )
       ( code = 'ETB' description = 'Ethiopia Birr'                                       )
       ( code = 'EUR' description = 'Euro Member Countries'                               )
       ( code = 'FJD' description = 'Fiji Dollar'                                         )
       ( code = 'FKP' description = 'Falkland Islands (Malvinas) Pound'                   )
       ( code = 'GBP' description = 'United Kingdom Pound'                                )
       ( code = 'GEL' description = 'Georgia Lari'                                        )
       ( code = 'GGP' description = 'Guernsey Pound'                                      )
       ( code = 'GHS' description = 'Ghana Cedi'                                          )
       ( code = 'GIP' description = 'Gibraltar Pound'                                     )
       ( code = 'GMD' description = 'Gambia Dalasi'                                       )
       ( code = 'GNF' description = 'Guinea Franc'                                        )
       ( code = 'GTQ' description = 'Guatemala Quetzal'                                   )
       ( code = 'GYD' description = 'Guyana Dollar'                                       )
       ( code = 'HKD' description = 'Hong Kong Dollar'                                    )
       ( code = 'HNL' description = 'Honduras Lempira'                                    )
       ( code = 'HRK' description = 'Croatia Kuna'                                        )
       ( code = 'HTG' description = 'Haiti Gourde'                                        )
       ( code = 'HUF' description = 'Hungary Forint'                                      )
       ( code = 'IDR' description = 'Indonesia Rupiah'                                    )
       ( code = 'ILS' description = 'Israel Shekel'                                       )
       ( code = 'IMP' description = 'Isle of Man Pound'                                   )
       ( code = 'INR' description = 'India Rupee'                                         )
       ( code = 'IQD' description = 'Iraq Dinar'                                          )
       ( code = 'IRR' description = 'Iran Rial'                                           )
       ( code = 'ISK' description = 'Iceland Krona'                                       )
       ( code = 'JEP' description = 'Jersey Pound'                                        )
       ( code = 'JMD' description = 'Jamaica Dollar'                                      )
       ( code = 'JOD' description = 'Jordan Dinar'                                        )
       ( code = 'JPY' description = 'Japan Yen'                                           )
       ( code = 'KES' description = 'Kenya Shilling'                                      )
       ( code = 'KGS' description = 'Kyrgyzstan Som'                                      )
       ( code = 'KHR' description = 'Cambodia Riel'                                       )
       ( code = 'KMF' description = 'Comoros Franc'                                       )
       ( code = 'KPW' description = 'Korea (North) Won'                                   )
       ( code = 'KRW' description = 'Korea (South) Won'                                   )
       ( code = 'KWD' description = 'Kuwait Dinar'                                        )
       ( code = 'KYD' description = 'Cayman Islands Dollar'                               )
       ( code = 'KZT' description = 'Kazakhstan Tenge'                                    )
       ( code = 'LAK' description = 'Laos Kip'                                            )
       ( code = 'LBP' description = 'Lebanon Pound'                                       )
       ( code = 'LKR' description = 'Sri Lanka Rupee'                                     )
       ( code = 'LRD' description = 'Liberia Dollar'                                      )
       ( code = 'LSL' description = 'Lesotho Loti'                                        )
       ( code = 'LYD' description = 'Libya Dinar'                                         )
       ( code = 'MAD' description = 'Morocco Dirham'                                      )
       ( code = 'MDL' description = 'Moldova Leu'                                         )
       ( code = 'MGA' description = 'Madagascar Ariary'                                   )
       ( code = 'MKD' description = 'Macedonia Denar'                                     )
       ( code = 'MMK' description = 'Myanmar (Burma) Kyat'                                )
       ( code = 'MNT' description = 'Mongolia Tughrik'                                    )
       ( code = 'MOP' description = 'Macau Pataca'                                        )
       ( code = 'MRO' description = 'Mauritania Ouguiya'                                  )
       ( code = 'MUR' description = 'Mauritius Rupee'                                     )
       ( code = 'MVR' description = 'Maldives (Maldive Islands) Rufiyaa'                  )
       ( code = 'MWK' description = 'Malawi Kwacha'                                       )
       ( code = 'MXN' description = 'Mexico Peso'                                         )
       ( code = 'MYR' description = 'Malaysia Ringgit'                                    )
       ( code = 'MZN' description = 'Mozambique Metical'                                  )
       ( code = 'NAD' description = 'Namibia Dollar'                                      )
       ( code = 'NGN' description = 'Nigeria Naira'                                       )
       ( code = 'NIO' description = 'Nicaragua Cordoba'                                   )
       ( code = 'NOK' description = 'Norway Krone'                                        )
       ( code = 'NPR' description = 'Nepal Rupee'                                         )
       ( code = 'NZD' description = 'New Zealand Dollar'                                  )
       ( code = 'OMR' description = 'Oman Rial'                                           )
       ( code = 'PAB' description = 'Panama Balboa'                                       )
       ( code = 'PEN' description = 'Peru Nuevo Sol'                                      )
       ( code = 'PGK' description = 'Papua New Guinea Kina'                               )
       ( code = 'PHP' description = 'Philippines Peso'                                    )
       ( code = 'PKR' description = 'Pakistan Rupee'                                      )
       ( code = 'PLN' description = 'Poland Zloty'                                        )
       ( code = 'PYG' description = 'Paraguay Guarani'                                    )
       ( code = 'QAR' description = 'Qatar Riyal'                                         )
       ( code = 'RON' description = 'Romania New Leu'                                     )
       ( code = 'RSD' description = 'Serbia Dinar'                                        )
       ( code = 'RUB' description = 'Russia Ruble'                                        )
       ( code = 'RWF' description = 'Rwanda Franc'                                        )
       ( code = 'SAR' description = 'Saudi Arabia Riyal'                                  )
       ( code = 'SBD' description = 'Solomon Islands Dollar'                              )
       ( code = 'SCR' description = 'Seychelles Rupee'                                    )
       ( code = 'SDG' description = 'Sudan Pound'                                         )
       ( code = 'SEK' description = 'Sweden Krona'                                        )
       ( code = 'SGD' description = 'Singapore Dollar'                                    )
       ( code = 'SHP' description = 'Saint Helena Pound'                                  )
       ( code = 'SLL' description = 'Sierra Leone Leone'                                  )
       ( code = 'SOS' description = 'Somalia Shilling'                                    )
       ( code = 'SPL' description = 'Seborga Luigino'                                     )
       ( code = 'SRD' description = 'Suriname Dollar'                                     )
       ( code = 'STD' description = 'São Tomé and Príncipe Dobra'                         )
       ( code = 'SVC' description = 'El Salvador Colon'                                   )
       ( code = 'SYP' description = 'Syria Pound'                                         )
       ( code = 'SZL' description = 'Swaziland Lilangeni'                                 )
       ( code = 'THB' description = 'Thailand Baht'                                       )
       ( code = 'TJS' description = 'Tajikistan Somoni'                                   )
       ( code = 'TMT' description = 'Turkmenistan Manat'                                  )
       ( code = 'TND' description = 'Tunisia Dinar'                                       )
       ( code = 'TOP' description = 'Tonga Pa`anga'                                       )
       ( code = 'TRY' description = 'Turkey Lira'                                         )
       ( code = 'TTD' description = 'Trinidad and Tobago Dollar'                          )
       ( code = 'TVD' description = 'Tuvalu Dollar'                                       )
       ( code = 'TWD' description = 'Taiwan New Dollar'                                   )
       ( code = 'TZS' description = 'Tanzania Shilling'                                   )
       ( code = 'UAH' description = 'Ukraine Hryvnia'                                     )
       ( code = 'UGX' description = 'Uganda Shilling'                                     )
       ( code = 'USD' description = 'United States Dollar'                                )
       ( code = 'UYU' description = 'Uruguay Peso'                                        )
       ( code = 'UZS' description = 'Uzbekistan Som'                                      )
       ( code = 'VEF' description = 'Venezuela Bolivar'                                   )
       ( code = 'VND' description = 'Viet Nam Dong'                                       )
       ( code = 'VUV' description = 'Vanuatu Vatu'                                        )
       ( code = 'WST' description = 'Samoa Tala'                                          )
       ( code = 'XAF' description = 'CFA Franc BEAC'                                      )
       ( code = 'XCD' description = 'East Caribbean Dollar'                               )
       ( code = 'XDR' description = 'International Monetary Fund Special Drawing Rights'  )
       ( code = 'XOF' description = 'BCEAO Franc'                                         )
       ( code = 'XPF' description = 'CFP Franc'                                           )
       ( code = 'YER' description = 'Yemen Rial'                                          )
       ( code = 'ZAR' description = 'South Africa Rand'                                   )
       ( code = 'ZMW' description = 'Zambia Kwacha'                                       )
       ( code = 'ZWD' description = 'Zimbabwe Dollar'                                     )
    ).

    DELETE FROM zdemo_epm_ws_crr.
    INSERT zdemo_epm_ws_crr FROM TABLE lt_crr.

    lt_wgu = VALUE #(
      ( symbol = 't'       description = 'tonne'     )
      ( symbol = 'kg'      description = 'kilogram'  )
      ( symbol = 'hg'      description = 'hectogram' )
      ( symbol = 'g '      description = 'gram'      )
      ( symbol = 'dg'      description = 'decigram'  )
      ( symbol = 'cg'      description = 'centigram' )
      ( symbol = 'mg'      description = 'milligram' )
      ( symbol = 'µg'      description = 'microgram' )
      ( symbol = 'carat'   description = 'carat'     )
      ( symbol = 'grain'   description = 'grain'     )
      ( symbol = 'oz'      description = 'ounce'     )
      ( symbol = 'lb'      description = 'pound'     )
    ).

    DELETE FROM zdemo_epm_ws_wgu.
    INSERT zdemo_epm_ws_wgu FROM TABLE lt_wgu.

    lt_cat = VALUE #(
      ( id = 1 name = 'Projector'     )
      ( id = 2 name = 'Graphics Card' )
      ( id = 3 name = 'Accessory'     )
      ( id = 4 name = 'Printer'       )
      ( id = 5 name = 'Monitor'       )
      ( id = 6 name = 'Laptop'        )
      ( id = 7 name = 'Keyboard '     )
    ).

    DELETE FROM zdemo_epm_ws_cat.
    INSERT zdemo_epm_ws_cat FROM TABLE lt_cat.

    lt_prd = VALUE #(
        ( id = 1 name = 'Power Projector 4713' category = 1 description = 'A very powerful projector with special features for Internet usability, USB 1467'
          weight = '1467' price = '856.49' pictureurl = 'HT-6100.jpg' currency = 'USD' weightunit = 'g' )
        ( id = 2 name = 'Gladiator MX' category = 2 description = 'Gladiator MX: DDR2 RoHS 128MB Supporting 512MB Clock rate: 350 MHz Memory Clock: 533 MHz, Bus Type: PCI-Express, Memory Type: DDR2 Memory Bus: 32-bit'
          weight = '4234' price = '343.39' pictureurl = 'HT-6100.jpg' currency = 'USD' weightunit = 'g' )
        ( id = 3 name = 'Hurricane GX' category = 2 description = 'Hurricane GX: DDR2 RoHS 512MB Supporting 1024MB Clock rate: 550 MHz Memory Clock: 933 MHz, Bus Type: PCI-Express, Memory Type: DDR2 Memory Bus: 64-bit'
        weight = '35' price = '645.49' pictureurl = 'HT-6100.jpg' currency = 'EUR' weightunit = 'g' )
        ( id = 4 name = 'Webcam' category = 3 description = 'Web camera, color, High-Speed USB'
        weight = '464' price = '756.49' pictureurl = 'HT-6100.jpg' currency = 'USD' weightunit = 'cg' )
        ( id = 5 name = 'Monitor Locking Cable' category = 3 description = 'Lock for Monitor'
        weight = '567' price = '86.49' pictureurl = 'HT-6100.jpg' currency = 'USD' weightunit = 'kg' )
        ( id = 6 name = 'Laptop Case' category = 3 description = 'Laptop Case with room for pencils and other items'
        weight = '686' price = '55.49' pictureurl = 'HT-6100.jpg' currency = 'USD' weightunit = 'g' )
        ( id = 7 name = 'USB Stick 16 GByte' category = 3 description = 'USB 2.0 HighSpeed 16GB'
        weight = '353' price = '46.99' pictureurl = 'HT-6100.jpg' currency = 'EUR' weightunit = 'g' )
        ( id = 8 name = 'Deskjet Super Highspeed' category = 4 description = '1200 dpi x 1200 dpi - up to 25 ppm (mono) / up to 24 ppm (colour)'
        weight = '234' price = '46.49' pictureurl = 'HT-6100.jpg' currency = 'USD' weightunit = 'g' )
        ( id = 9 name = 'Laser Allround Pro' category = 4 description = ' up to 25 ppm letter and 24 ppm A4 color or monochrome, with a first-page-out-time of less than 13 seconds for monochrome and less than 15 seconds for color'
        weight = '131' price = '26.49' pictureurl = 'HT-6100.jpg' currency = 'USD' weightunit = 'kg' )

    ).

    DELETE FROM zdemo_epm_ws_prd.
    INSERT zdemo_epm_ws_prd FROM TABLE lt_prd.

    COMMIT WORK.
    send_refresh( ).
  ENDMETHOD.


  METHOD products_create_entity.
    DATA ls_data   LIKE er_entity.

    io_data_provider->read_entry_data(
      IMPORTING
        es_data   = ls_data
    ).
    DATA(ls_record) = CORRESPONDING zdemo_epm_ws_prd( ls_data ).
    SELECT MAX( id ) FROM zdemo_epm_ws_prd INTO @ls_record-id.
    ADD 1 TO ls_record-id.

    INSERT INTO zdemo_epm_ws_prd VALUES @ls_record.
  ENDMETHOD.


  METHOD products_delete_entity.
    DATA ls_converted_keys TYPE zcl_odata_service_mpc=>ts_product.

    io_tech_request_context->get_converted_keys(
      IMPORTING
        es_key_values  = ls_converted_keys
    ).

    DELETE FROM zdemo_epm_ws_prd WHERE id = @ls_converted_keys-id.
    IF sy-subrc <> 0.
      me->/iwbep/if_sb_dpc_comm_services~rfc_exception_handling(
         EXPORTING
           iv_subrc            = sy-subrc
           iv_exp_message_text = 'Entity not found.'(001) ).
    ELSE.
      COMMIT WORK.
      send_refresh( ).
    ENDIF.

  ENDMETHOD.


  METHOD products_get_entity.
    DATA ls_converted_keys LIKE er_entity.

    io_tech_request_context->get_converted_keys(
      IMPORTING
        es_key_values  = ls_converted_keys
    ).

    SELECT SINGLE * FROM zdemo_epm_ws_prd INTO
        CORRESPONDING FIELDS OF @er_entity WHERE
        id = @ls_converted_keys-id.
    IF sy-subrc <> 0.
      me->/iwbep/if_sb_dpc_comm_services~rfc_exception_handling(
         EXPORTING
           iv_subrc            = sy-subrc
           iv_exp_message_text = 'Entity not found.'(001) ).
    ENDIF.
  ENDMETHOD.


  METHOD products_get_entityset.
    IF line_exists( it_filter_select_options[ property = `NAME` ] ).
      DATA(lt_select_opts) = it_filter_select_options[ property = `NAME` ]-select_options.
      SELECT * FROM zdemo_epm_ws_prd INTO CORRESPONDING FIELDS OF TABLE @et_entityset
          WHERE name IN @lt_select_opts.
    ELSE.
      SELECT * FROM zdemo_epm_ws_prd INTO CORRESPONDING FIELDS OF TABLE @et_entityset.
    ENDIF.
  ENDMETHOD.


  METHOD products_update_entity.
    DATA: ls_converted_keys LIKE er_entity,
          ls_data           LIKE er_entity.

    io_tech_request_context->get_converted_keys(
      IMPORTING
        es_key_values  = ls_converted_keys
    ).
    io_data_provider->read_entry_data(
      IMPORTING
        es_data   = ls_data
    ).

    UPDATE zdemo_epm_ws_prd SET
      description = @ls_data-description,
      price = @ls_data-price,
      pictureurl = @ls_data-pictureurl,
      weight = @ls_data-weight
      WHERE id = @ls_converted_keys-id.

    IF sy-subrc <> 0.
      me->/iwbep/if_sb_dpc_comm_services~rfc_exception_handling(
         EXPORTING
           iv_subrc            = sy-subrc
           iv_exp_message_text = 'Entity not found.'(001) ).
    ENDIF.
  ENDMETHOD.


  METHOD send_refresh.
    DATA: lo_producer TYPE REF TO if_amc_message_producer_text.
    TRY.
        lo_producer ?= cl_amc_channel_manager=>create_message_producer( i_application_id = 'Zdemo_EPM_WS_MC' i_channel_id = '/epm' ).
        lo_producer->send( i_message = gv_refresh_message ).
      CATCH cx_amc_error INTO DATA(lx_amc_error).
        MESSAGE lx_amc_error->get_text( ) TYPE 'E'.
      CATCH cx_apc_error INTO DATA(lx_apc_error).
        MESSAGE lx_apc_error->get_text( ) TYPE 'E'.
    ENDTRY.
  ENDMETHOD.


  METHOD weightunits_get_entity.
    DATA: ls_converted_keys LIKE er_entity,
          ls_source_keys    TYPE zcl_odata_service_mpc=>ts_product.

    IF io_tech_request_context->get_source_entity_set_name( ) = 'Products'.

      io_tech_request_context->get_converted_source_keys(
        IMPORTING
            es_key_values  = ls_source_keys
      ).
      SELECT SINGLE * FROM zdemo_epm_ws_prd AS prd
          INNER JOIN zdemo_epm_ws_wgu AS wgu ON prd~weightunit = wgu~symbol
          INTO CORRESPONDING FIELDS OF @er_entity WHERE prd~id = @ls_source_keys-id.
    ELSE.
      io_tech_request_context->get_converted_keys(
        IMPORTING
          es_key_values  = ls_converted_keys
      ).

      SELECT SINGLE * FROM zdemo_epm_ws_wgu INTO
          CORRESPONDING FIELDS OF @er_entity WHERE
          symbol = @ls_converted_keys-symbol.
    ENDIF.
    IF sy-subrc <> 0.
      me->/iwbep/if_sb_dpc_comm_services~rfc_exception_handling(
         EXPORTING
           iv_subrc            = sy-subrc
           iv_exp_message_text = 'Entity not found.'(001) ).
    ENDIF.
  ENDMETHOD.


  METHOD weightunits_get_entityset.
    IF line_exists( it_filter_select_options[ property = `SYMBOL` ] ).
      DATA(lt_select_opts) = it_filter_select_options[ property = `SYMBOL` ]-select_options.
      SELECT * FROM zdemo_epm_ws_wgu INTO CORRESPONDING FIELDS OF TABLE @et_entityset
          WHERE symbol IN @lt_select_opts.
    ELSE.
      SELECT * FROM zdemo_epm_ws_wgu INTO CORRESPONDING FIELDS OF TABLE @et_entityset.
    ENDIF.
  ENDMETHOD.
ENDCLASS.