CLASS /esrcc/cl_data_upload_utility DEFINITION PUBLIC FINAL CREATE PRIVATE .

  PUBLIC SECTION.
    INTERFACES:
      /esrcc/if_data_upload_utility .

    CLASS-METHODS:
      create RETURNING VALUE(instance) TYPE REF TO /esrcc/if_data_upload_utility.
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA:
      _application_logger TYPE REF TO /esrcc/if_application_logs,
      _upload_staging     TYPE /esrcc/upld_stg.

    METHODS:
      _initiate_logging IMPORTING application     TYPE /esrcc/application
                                  sub_application TYPE /esrcc/sub_application,
      _extract_raw_file_from_db IMPORTING application      TYPE /esrcc/application
                                          sub_application  TYPE /esrcc/sub_application
                                          created_by       TYPE abp_creation_user
                                          upload_uiid      TYPE sysuuid_x16
                                RETURNING VALUE(extracted) TYPE abap_boolean,
      _upload_costbase_data_to_model,
      _upload_srvcap_data_to_model,
      _upload_srvcons_data_to_model,
      _upload_allbase_data_to_model.
ENDCLASS.



CLASS /esrcc/cl_data_upload_utility IMPLEMENTATION.


  METHOD /esrcc/if_data_upload_utility~upload_data.
    " Initiate the logging mechanism
    _initiate_logging(
      application     = application
      sub_application = sub_application ).

    _upload_staging-upload_uuid = upload_uiid.
    _upload_staging-data_stream = datastream.
    _upload_staging-created_by  = created_by.
    _upload_staging-application = sub_application.

*    " Extract the raw data from the DB
*    IF _extract_raw_file_from_db(
*         application     = application
*         sub_application = sub_application
*         created_by      = created_by
*         upload_uiid     = upload_uiid ) = abap_false.
*      RETURN.
*    ENDIF.

    CASE _upload_staging-application.
      WHEN 'FLI'.
        _upload_costbase_data_to_model(  ).

      WHEN 'FPD'.
        _upload_srvcap_data_to_model(  ).

      WHEN 'FCP'.
        _upload_srvcons_data_to_model(  ).

      WHEN 'FAB'.
        _upload_allbase_data_to_model(  ).

    ENDCASE.


  ENDMETHOD.

  METHOD create.
    instance = NEW /esrcc/cl_data_upload_utility( ).
  ENDMETHOD.

  METHOD _extract_raw_file_from_db.
    SELECT SINGLE * FROM /esrcc/d_upld AS upload_data_staging WHERE uploaduiid = @upload_uiid INTO CORRESPONDING FIELDS OF @_upload_staging.
    IF sy-subrc = 0.
      extracted = abap_true.
    ELSE.
      " Message: No data found in upload staging.
    ENDIF.
  ENDMETHOD.

  METHOD _initiate_logging.
    _application_logger = /esrcc/cl_application_logs=>create_instance( ).
    _application_logger->set_log_header_info(
      log_header = VALUE #(
          application     = application
          sub_application = sub_application ) ).
  ENDMETHOD.

  METHOD _upload_costbase_data_to_model.

    DATA:
      cost_base_line_item  TYPE /esrcc/cb_li_tmp,
      cost_base_line_items TYPE STANDARD TABLE OF /esrcc/cb_li_tmp WITH EMPTY KEY.

    DATA(raw_data_reader) = xco_cp_xlsx=>document->for_file_content( _upload_staging-data_stream )->read_access( ).

    DATA(first_worksheet_reader) = raw_data_reader->get_workbook( )->worksheet->at_position( 1 ).


*    first_worksheet_reader->select(
*        xco_cp_xlsx_selection=>pattern_builder->simple_from_to( )->get_pattern( ) )->row_stream( )->operation->write_to(
*            REF #( cost_base_line_items ) )->if_xco_xlsx_ra_operation~execute( ).



    DATA(cursor) = first_worksheet_reader->cursor(
      io_column = xco_cp_xlsx=>coordinate->for_alphabetic_value( 'A' )
      io_row    = xco_cp_xlsx=>coordinate->for_numeric_value( 2 ) ).

    DATA(position) = 2.

    WHILE cursor->has_cell( ) EQ abap_true
        AND cursor->get_cell( )->has_value( ) EQ abap_true.
      DATA(lo_cell) = cursor->get_cell( ).

      ASSIGN COMPONENT position OF STRUCTURE cost_base_line_item TO FIELD-SYMBOL(<field_value>).

      DATA(string_value) = ``.
      lo_cell->get_value(
        )->set_transformation( xco_cp_xlsx_read_access=>value_transformation->string_value
        )->write_to( REF #( string_value ) ).

      <field_value> = string_value.

      cursor->move_right( ).
      position = position + 1.
      " At this point LV_STRING_VALUE contains the string value of the cell
      " at the current position of the cursor.

      " Move the cursor down one row.
*      cursor->move_down( ).
    ENDWHILE.

    APPEND cost_base_line_item TO cost_base_line_items.

    IF lines( cost_base_line_items ) = 0.
      " Message: File content is empty.
      RETURN.
    ENDIF.

*    MODIFY (_upload_staging-table_name) FROM TABLE @cost_base_line_items.
*    MODIFY /esrcc/cb_li_tmp FROM TABLE @cost_base_line_items.
    IF sy-subrc = 0.
      " Message: Number of records updated.
    ENDIF.
  ENDMETHOD.

  METHOD _upload_srvcap_data_to_model.
    DATA:
      cost_base_line_item  TYPE /esrcc/dirplan,
      cost_base_line_items TYPE STANDARD TABLE OF /esrcc/dirplan WITH EMPTY KEY.

    DATA(raw_data_reader) = xco_cp_xlsx=>document->for_file_content( _upload_staging-data_stream )->read_access( ).

    DATA(first_worksheet_reader) = raw_data_reader->get_workbook( )->worksheet->at_position( 1 ).


*    first_worksheet_reader->select(
*        xco_cp_xlsx_selection=>pattern_builder->simple_from_to( )->get_pattern( ) )->row_stream( )->operation->write_to(
*            REF #( cost_base_line_items ) )->if_xco_xlsx_ra_operation~execute( ).



    DATA(cursor) = first_worksheet_reader->cursor(
      io_column = xco_cp_xlsx=>coordinate->for_alphabetic_value( 'A' )
      io_row    = xco_cp_xlsx=>coordinate->for_numeric_value( 2 ) ).

    DATA(position) = 2.

    WHILE cursor->has_cell( ) EQ abap_true
        AND cursor->get_cell( )->has_value( ) EQ abap_true.
      DATA(lo_cell) = cursor->get_cell( ).

      ASSIGN COMPONENT position OF STRUCTURE cost_base_line_item TO FIELD-SYMBOL(<field_value>).

      DATA(string_value) = ``.
      lo_cell->get_value(
        )->set_transformation( xco_cp_xlsx_read_access=>value_transformation->string_value
        )->write_to( REF #( string_value ) ).

      <field_value> = string_value.

      cursor->move_right( ).
      position = position + 1.
      " At this point LV_STRING_VALUE contains the string value of the cell
      " at the current position of the cursor.

      " Move the cursor down one row.
*      cursor->move_down( ).
    ENDWHILE.

    APPEND cost_base_line_item TO cost_base_line_items.

    IF lines( cost_base_line_items ) = 0.
      " Message: File content is empty.
      RETURN.
    ENDIF.

*    MODIFY (_upload_staging-table_name) FROM TABLE @cost_base_line_items.
*    MODIFY /esrcc/cb_li_tmp FROM TABLE @cost_base_line_items.
    IF sy-subrc = 0.
      " Message: Number of records updated.
    ENDIF.

  ENDMETHOD.

  METHOD _upload_srvcons_data_to_model.

    DATA:
      cost_base_line_item  TYPE /esrcc/diralloc,
      cost_base_line_items TYPE STANDARD TABLE OF /esrcc/diralloc WITH EMPTY KEY.

    DATA(raw_data_reader) = xco_cp_xlsx=>document->for_file_content( _upload_staging-data_stream )->read_access( ).

    DATA(first_worksheet_reader) = raw_data_reader->get_workbook( )->worksheet->at_position( 1 ).


*    first_worksheet_reader->select(
*        xco_cp_xlsx_selection=>pattern_builder->simple_from_to( )->get_pattern( ) )->row_stream( )->operation->write_to(
*            REF #( cost_base_line_items ) )->if_xco_xlsx_ra_operation~execute( ).



    DATA(cursor) = first_worksheet_reader->cursor(
      io_column = xco_cp_xlsx=>coordinate->for_alphabetic_value( 'A' )
      io_row    = xco_cp_xlsx=>coordinate->for_numeric_value( 2 ) ).

    DATA(position) = 2.

    WHILE cursor->has_cell( ) EQ abap_true
        AND cursor->get_cell( )->has_value( ) EQ abap_true.
      DATA(lo_cell) = cursor->get_cell( ).

      ASSIGN COMPONENT position OF STRUCTURE cost_base_line_item TO FIELD-SYMBOL(<field_value>).

      DATA(string_value) = ``.
      lo_cell->get_value(
        )->set_transformation( xco_cp_xlsx_read_access=>value_transformation->string_value
        )->write_to( REF #( string_value ) ).

      <field_value> = string_value.

      cursor->move_right( ).
      position = position + 1.
      " At this point LV_STRING_VALUE contains the string value of the cell
      " at the current position of the cursor.

      " Move the cursor down one row.
*      cursor->move_down( ).
    ENDWHILE.

    APPEND cost_base_line_item TO cost_base_line_items.

    IF lines( cost_base_line_items ) = 0.
      " Message: File content is empty.
      RETURN.
    ENDIF.

*    MODIFY (_upload_staging-table_name) FROM TABLE @cost_base_line_items.
*    MODIFY /esrcc/cb_li_tmp FROM TABLE @cost_base_line_items.
    IF sy-subrc = 0.
      " Message: Number of records updated.
    ENDIF.

  ENDMETHOD.

  METHOD _upload_allbase_data_to_model.

    DATA:
      cost_base_line_item  TYPE /esrcc/indalloc,
      cost_base_line_items TYPE STANDARD TABLE OF /esrcc/indalloc WITH EMPTY KEY.

    DATA(raw_data_reader) = xco_cp_xlsx=>document->for_file_content( _upload_staging-data_stream )->read_access( ).

    DATA(first_worksheet_reader) = raw_data_reader->get_workbook( )->worksheet->at_position( 1 ).


*    first_worksheet_reader->select(
*        xco_cp_xlsx_selection=>pattern_builder->simple_from_to( )->get_pattern( ) )->row_stream( )->operation->write_to(
*            REF #( cost_base_line_items ) )->if_xco_xlsx_ra_operation~execute( ).



    DATA(cursor) = first_worksheet_reader->cursor(
      io_column = xco_cp_xlsx=>coordinate->for_alphabetic_value( 'A' )
      io_row    = xco_cp_xlsx=>coordinate->for_numeric_value( 2 ) ).

    DATA(position) = 2.

    WHILE cursor->has_cell( ) EQ abap_true
        AND cursor->get_cell( )->has_value( ) EQ abap_true.
      DATA(lo_cell) = cursor->get_cell( ).

      ASSIGN COMPONENT position OF STRUCTURE cost_base_line_item TO FIELD-SYMBOL(<field_value>).

      DATA(string_value) = ``.
      lo_cell->get_value(
        )->set_transformation( xco_cp_xlsx_read_access=>value_transformation->string_value
        )->write_to( REF #( string_value ) ).

      <field_value> = string_value.

      cursor->move_right( ).
      position = position + 1.
      " At this point LV_STRING_VALUE contains the string value of the cell
      " at the current position of the cursor.

      " Move the cursor down one row.
*      cursor->move_down( ).
    ENDWHILE.

    APPEND cost_base_line_item TO cost_base_line_items.

    IF lines( cost_base_line_items ) = 0.
      " Message: File content is empty.
      RETURN.
    ENDIF.

*    MODIFY (_upload_staging-table_name) FROM TABLE @cost_base_line_items.
*    MODIFY /esrcc/cb_li_tmp FROM TABLE @cost_base_line_items.
    IF sy-subrc = 0.
      " Message: Number of records updated.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
