FUNCTION ZDEMO_FM_REFRESH
  EXPORTING
    VALUE(EF_TIMEOUT) TYPE BOOLEAN.


  DATA: lo_receiver_text TYPE REF TO lcl_amc_test_text.
  ef_timeout = abap_true.

  CLEAR gt_message_list.

  TRY.
      DATA(lo_consumer) = cl_amc_channel_manager=>create_message_consumer( i_application_id = 'Z<AMC_APP_NAME>' i_channel_id = '/demo' ).
      CREATE OBJECT lo_receiver_text.

      lo_consumer->start_message_delivery( i_receiver = lo_receiver_text ).
    CATCH cx_amc_error INTO DATA(lx_amc_error).
      MESSAGE lx_amc_error->get_text( ) TYPE 'E'.
  ENDTRY.

  WAIT FOR MESSAGING CHANNELS UNTIL lines( gt_message_list ) >= 1 UP TO 120 SECONDS.

  IF lines( gt_message_list ) > 0.
    ef_timeout = abap_false.
  ENDIF.

ENDFUNCTION.