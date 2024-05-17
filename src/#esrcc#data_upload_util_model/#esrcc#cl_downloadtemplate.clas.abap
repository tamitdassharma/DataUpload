CLASS /esrcc/cl_downloadtemplate DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read .
    INTERFACES IF_XCO_STRING.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /esrcc/cl_downloadtemplate IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.
   CHECK NOT it_original_data IS INITIAL.

    DATA lt_calculated_data TYPE STANDARD TABLE OF /esrcc/c_uploadstaging WITH DEFAULT KEY.
    MOVE-CORRESPONDING it_original_data TO lt_calculated_data.

     DATA:
      enrichment_exit      TYPE REF TO CL_ABAP_TYPEDESCR,
      structure_descriptor TYPE REF TO cl_abap_typedescr.

    DATA:
      _table_name         TYPE tabname,
      _dynamic_table      TYPE REF TO data,
      _dynamic_table_line TYPE REF TO data,
      _components         TYPE cl_abap_structdescr=>component_table.

    " Form or generate the basic list of components of the provided table
    CALL METHOD cl_abap_structdescr=>describe_by_name
      EXPORTING
        p_name         = '/ESRCC/CB_LI_TMP'
      RECEIVING
        p_descr_ref    = structure_descriptor
      EXCEPTIONS
        type_not_found = 1
        OTHERS         = 2.
    IF sy-subrc <> 0.
*      is_exception_raised = abap_true.
      RETURN.
    ENDIF.

    _components = CAST cl_abap_structdescr( structure_descriptor )->get_components( ).
    DELETE _components WHERE name IS INITIAL.

    DATA(line_handler) = cl_abap_structdescr=>get( _components ).
    CREATE DATA _dynamic_table_line TYPE HANDLE line_handler.
    IF _dynamic_table_line IS INITIAL.
      RAISE EXCEPTION TYPE cx_sy_create_data_error.
    ENDIF.

    DATA(table_handler) = cl_abap_tabledescr=>create( line_handler ).
    CREATE DATA _dynamic_table TYPE HANDLE table_handler.
    IF _dynamic_table IS INITIAL.
      RAISE EXCEPTION TYPE cx_sy_create_data_error.
    ENDIF.

*    DATA(lo_write_access) = xco_cp_xlsx=>document->for_file_contentwrite_access( ).
*    DATA(lo_worksheet) = lo_write_access->get_workbook(
*    )->worksheet->at_position( 1 ).

*    DATA(stream) = cl_svim_excel_download_stream=>get_instance( iv_objectname = '/ESRCC/CB_LI_TMP'
*                                                                    iv_objecttype = 'U' ).


    LOOP AT lt_calculated_data ASSIGNING FIELD-SYMBOL(<ls_calculated_data>).
        <ls_calculated_data>-tmpDataStream = <ls_calculated_data>-DataStream.
        <ls_calculated_data>-tmpFilename = 'DownloadTemplate.xlsx'.
        <ls_calculated_data>-tmpMimeType = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'.
    ENDLOOP.
    MOVE-CORRESPONDING lt_calculated_data TO ct_calculated_data.
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
*  IF iv_entity <> 'ZDEMO_C_SORDERITEM_VF'.
**        RAISE EXCEPTION TYPE zcx_calc_exit EXPORTING textid = zcx_calc_exit=>entity_not_known.
*    ENDIF.
   RETURN.
  ENDMETHOD.

  METHOD if_xco_string~append.

  ENDMETHOD.

  METHOD if_xco_string~as_message.

  ENDMETHOD.

  METHOD if_xco_string~as_xstring.
*  DATA lo_xco_cp_abap_dictionary TYPE REF TO xco_cp_abap_dictionary.
*  Create Object lo_xco_cp_abap_dictionary.

  DATA lv_string type string.
  DATA(lv_original_xstring) = xco_cp=>string( lv_string
  )->as_xstring( xco_cp_binary=>text_encoding->base64
  )->value.

  ENDMETHOD.

  METHOD if_xco_string~decompose.

  ENDMETHOD.

  METHOD if_xco_string~ends_with.

  ENDMETHOD.

  METHOD if_xco_string~from.

  ENDMETHOD.

  METHOD if_xco_string_iterable~get_iterator.

  ENDMETHOD.

  METHOD if_xco_text~get_lines.

  ENDMETHOD.

  METHOD if_xco_news~get_messages.

  ENDMETHOD.

  METHOD if_xco_string~grep.

  ENDMETHOD.

  METHOD if_xco_string~matches.

  ENDMETHOD.

  METHOD if_xco_string~prepend.

  ENDMETHOD.

  METHOD if_xco_string~split.

  ENDMETHOD.

  METHOD if_xco_string~starts_with.

  ENDMETHOD.

  METHOD if_xco_string~to.

  ENDMETHOD.

  METHOD if_xco_string~to_lower_case.

  ENDMETHOD.

  METHOD if_xco_string~to_upper_case.

  ENDMETHOD.

ENDCLASS.
