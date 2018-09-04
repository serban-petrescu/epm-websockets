CLASS zcl_apc_handler_class DEFINITION
  PUBLIC
  INHERITING FROM cl_apc_wsp_ext_stateless_base
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: if_apc_wsp_extension~on_message REDEFINITION,
      if_apc_wsp_extension~on_start REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_apc_handler_class IMPLEMENTATION.


  METHOD if_apc_wsp_extension~on_message.
    DATA: lo_producer TYPE REF TO if_amc_message_producer_text.
    TRY.
        DATA(lv_text) = i_message->get_text( ).
        lo_producer ?= cl_amc_channel_manager=>create_message_producer( i_application_id = 'Z<AMC_APP_NAME>' i_channel_id = '/demo' ).
        lo_producer->send( i_message = lv_text ).
      CATCH cx_amc_error INTO DATA(lx_amc_error).
        MESSAGE lx_amc_error->get_text( ) TYPE 'E'.
      CATCH cx_apc_error INTO DATA(lx_apc_error).
        MESSAGE lx_apc_error->get_text( ) TYPE 'E'.
    ENDTRY.
  ENDMETHOD.


  METHOD if_apc_wsp_extension~on_start.
    TRY.
        DATA(lo_binding) = i_context->get_binding_manager( ).
        lo_binding->bind_amc_message_consumer( i_application_id = 'Z<AMC_APP_NAME>' i_channel_id = '/demo' ).
      CATCH cx_apc_error INTO DATA(lx_apc_error).
        DATA(lv_message) = lx_apc_error->get_text( ).
        MESSAGE lx_apc_error->get_text( ) TYPE 'E'.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.