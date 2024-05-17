CLASS lhc_uploadstaging DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR uploadstaging RESULT result.

    METHODS uploadfields FOR DETERMINE ON SAVE
      IMPORTING keys FOR uploadstaging~uploadfields.

    METHODS validate_create FOR VALIDATE ON SAVE
      IMPORTING keys FOR uploadstaging~validate_create.

ENDCLASS.

CLASS lhc_uploadstaging IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD uploadfields.

    READ ENTITIES OF /esrcc/i_uploadstaging IN LOCAL MODE
       ENTITY uploadstaging
       ALL FIELDS WITH CORRESPONDING #( keys )
       RESULT DATA(uploaddata)
       FAILED FINAL(read_failed).

    READ TABLE uploaddata ASSIGNING FIELD-SYMBOL(<uploaddata>) INDEX 1.
    IF sy-subrc = 0 AND <uploaddata>-filename IS NOT INITIAL AND <uploaddata>-datastream IS NOT INITIAL.
      DATA(data_uploader) = /esrcc/cl_data_upload_utility=>create( ).

      data_uploader->upload_data(
        application     = 'FUP'
        sub_application = <uploaddata>-application
        created_by      = <uploaddata>-createdby
        upload_uiid     = <uploaddata>-uploaduiid
        datastream      = <uploaddata>-datastream
      ).
    ENDIF.

    MODIFY ENTITIES OF /esrcc/i_uploadstaging IN LOCAL MODE
       ENTITY UploadStaging
       UPDATE FIELDS ( status )
        WITH VALUE #(
          ( UploadUIID = <uploaddata>-UploadUIID
            Status = 'I' ) ).

  ENDMETHOD.
  .

  METHOD validate_create.

    READ ENTITIES OF /esrcc/i_uploadstaging IN LOCAL MODE
       ENTITY uploadstaging
       ALL FIELDS WITH CORRESPONDING #( keys )
       RESULT DATA(uploaddata)
       FAILED FINAL(read_failed).

    READ TABLE uploaddata ASSIGNING FIELD-SYMBOL(<uploaddata>) INDEX 1.
    IF sy-subrc = 0.
      IF <uploaddata>-filename IS NOT INITIAL.
      select single * from /esrcc/upld_stg where application = @<uploaddata>-Application and status = 'I' into @DATA(_currentuploadeddata).
      if sy-subrc = 0.
        APPEND VALUE #( %tky = <uploadData>-%tky
                        %msg = new_message(
                        id   = '/ESRCC/DATAUPLOAD'
                        number = '000'
                        v1   = <uploadData>-Application
                        v2   = <uploadData>-CreatedBy
                        severity  = if_abap_behv_message=>severity-error )
                       ) TO reported-uploadstaging.
        APPEND VALUE #( %tky = <uploadData>-%tky ) TO
                        failed-uploadstaging.
      ENDIF.
      ELSEIF <uploaddata>-filename IS INITIAL.
        APPEND VALUE #( %tky = <uploaddata>-%tky
                         %msg = new_message(
                         id   = '/ESRCC/DATAUPLOAD'
                         number = '001'
                         severity  = if_abap_behv_message=>severity-error )
                        ) TO reported-uploadstaging.
        APPEND VALUE #( %tky = <uploaddata>-%tky ) TO
                        failed-uploadstaging.
      ELSEIF <uploaddata>-application IS INITIAL.
        APPEND VALUE #( %tky = <uploaddata>-%tky
                         %msg = new_message(
                         id   = '/ESRCC/DATAUPLOAD'
                         number = '002'
                         severity  = if_abap_behv_message=>severity-error )
                        ) TO reported-uploadstaging.
        APPEND VALUE #( %tky = <uploaddata>-%tky ) TO
                        failed-uploadstaging.
      ENDIF.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
