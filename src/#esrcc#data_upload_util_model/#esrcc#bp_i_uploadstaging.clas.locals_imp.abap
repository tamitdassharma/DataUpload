CLASS lhc_uploadstaging DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR uploadstaging RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR uploadstaging RESULT result.

    METHODS uploadexceldata FOR MODIFY
      IMPORTING keys FOR ACTION uploadstaging~uploadexceldata RESULT result.

    METHODS uploadfields FOR DETERMINE ON SAVE
      IMPORTING keys FOR uploadstaging~uploadfields.

ENDCLASS.

CLASS lhc_uploadstaging IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD uploadExcelData.
  ENDMETHOD.

  METHOD uploadfields.

    READ ENTITIES OF /ESRCC/I_UploadStaging IN LOCAL MODE
       ENTITY UploadStaging
       ALL FIELDS WITH CORRESPONDING #( keys )
       RESULT DATA(uploadData)
       FAILED FINAL(read_failed).

    READ TABLE uploadData ASSIGNING FIELD-SYMBOL(<uploadData>) INDEX 1.
    IF sy-subrc = 0 AND <uploadData>-Filename is NOT INITIAL AND <uploadData>-DataStream is NOT INITIAL.
        DATA(data_uploader) = /esrcc/cl_data_upload_utility=>create( ).

        data_uploader->upload_data(
          application     = 'FUP'
          sub_application = <uploadData>-Application
          created_by      = <uploadData>-CreatedBy
          upload_uiid     = <uploadData>-UploadUIID
          datastream      = <uploadData>-DataStream
        ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
