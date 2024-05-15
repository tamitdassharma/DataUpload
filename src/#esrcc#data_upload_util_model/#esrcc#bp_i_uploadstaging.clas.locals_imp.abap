CLASS lhc_uploadstaging DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR uploadstaging RESULT result.

    METHODS uploadexceldata FOR MODIFY
      IMPORTING keys FOR ACTION uploadstaging~uploadexceldata RESULT result.

ENDCLASS.

CLASS lhc_uploadstaging IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD uploadexceldata.
  ENDMETHOD.

ENDCLASS.
