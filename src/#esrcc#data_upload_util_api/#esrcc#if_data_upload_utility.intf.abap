INTERFACE /esrcc/if_data_upload_utility
  PUBLIC .
  METHODS:
    upload_data IMPORTING application     TYPE /esrcc/application
                          sub_application TYPE /esrcc/sub_application
                          created_by      TYPE abp_creation_user
                          upload_uiid     TYPE sysuuid_x16
                          datastream      TYPE /ESRCC/DATA_STREAM.

ENDINTERFACE.
