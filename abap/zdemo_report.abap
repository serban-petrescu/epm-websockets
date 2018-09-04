REPORT zdemo_report.

DATA: gt_products TYPE TABLE OF zdemo_epm_ws_prd,
      gr_alv_ctrl TYPE REF TO cl_gui_alv_grid,
      gv_ok_code  TYPE syst_ucomm,
      gf_arfc     TYPE abap_bool VALUE abap_true,
      gf_load     TYPE abap_bool VALUe abap_true.

CALL SCREEN 1000.

MODULE status_1000 OUTPUT.
  SET PF-STATUS 'MAIN'.

  IF gf_load = abap_true.
    gf_load = abap_false.
    PERFORM load_data.
  ENDIF.

  IF gr_alv_ctrl IS NOT BOUND.
    gr_alv_ctrl = NEW #( i_parent = NEW cl_gui_custom_container( container_name = 'ALV' ) ).
    gr_alv_ctrl->set_table_for_first_display(
      EXPORTING
        i_structure_name              = 'ZDEMO_EPM_WS_PRD'
        is_layout                     = VALUE #( sel_mode = 'D' )
      CHANGING
        it_outtab                     = gt_products
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4
    ).
  ELSE.
    gr_alv_ctrl->refresh_table_display( ).
  ENDIF.
  IF gf_arfc = abap_true.
      gf_arfc = abap_false.
      CALL FUNCTION 'ZDEMO_FM_REFRESH' DESTINATION 'NONE'
        STARTING NEW TASK 'EPM_WS_DEMO' PERFORMING return_form ON END OF TASK.
  ENDIF.
ENDMODULE.

MODULE user_command_1000 INPUT.
  CASE gv_ok_code.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
     WHEN 'ARFC_TIM'.
       gf_arfc = abap_true.
     WHEN 'ARFC_FUL'.
       gf_arfc = abap_true.
       gf_load = abap_true.
     WHEN 'DELETE'.
        gr_alv_ctrl->get_selected_rows(
          IMPORTING
            et_index_rows =  DATA(lt_sel_rows)
        ).

        IF lines( lt_sel_rows ) > 0.
            DATA(ls_product) = gt_products[ lt_sel_rows[ 1 ]-index ].
            DELETE zdemo_epm_ws_prd FROM ls_product.
            COMMIT WORK.
            DELETE gt_products INDEX lt_sel_rows[ 1 ]-index.
            PERFORM send_refresh.
        ELSE.
            MESSAGE 'No line is selected.' TYPE 'W'.
        ENDIF.

  ENDCASE.
ENDMODULE.

FORM return_form USING taskname.
  DATA lf_timeout TYPE abap_bool.
  RECEIVE RESULTS FROM FUNCTION 'ZDEMO_FM_REFRESH'
    IMPORTING
        ef_timeout          = lf_timeout
    EXCEPTIONS
      communication_failure = 1
      system_failure        = 2
      OTHERS                = 3.
  IF sy-subrc = 0.
    IF lf_timeout = abap_false.
      SET USER-COMMAND 'ARFC_FUL'.
    ELSE.
      SET USER-COMMAND 'ARFC_TIM'.
    ENDIF.
  ENDIF.

ENDFORM.

FORM send_refresh.
    DATA: lo_producer TYPE REF TO if_amc_message_producer_text.
    TRY.
        lo_producer ?= cl_amc_channel_manager=>create_message_producer( i_application_id = 'Z<AMC_APP_NAME>' i_channel_id = '/demo' ).
        lo_producer->send( i_message = zcl_zdemo_epm_ws_dpc_ext=>gv_refresh_message ).
      CATCH cx_amc_error INTO DATA(lx_amc_error).
        MESSAGE lx_amc_error->get_text( ) TYPE 'E'.
      CATCH cx_apc_error INTO DATA(lx_apc_error).
        MESSAGE lx_apc_error->get_text( ) TYPE 'E'.
    ENDTRY.
ENDFORM.

FORM load_data.
  CLEAR: gt_products.
  SELECT * FROM zdemo_epm_ws_prd INTO TABLE gt_products.
ENDFORM.