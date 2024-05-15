@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Upload Staging Interface'
define root view entity /ESRCC/I_UploadStaging
  as select from /esrcc/upld_stg
  //composition of target_data_source_name as _association_name
{
  key application     as Application,
  key sub_application as SubApplication,
      @Semantics.user.createdBy: true
  key created_by      as CreatedBy,
      @Semantics: {
          largeObject: {
              mimeType: 'MimeType',
              fileName: 'Filename',
              acceptableMimeTypes: [ 'text/csv' ],
              contentDispositionPreference: #INLINE
//              cacheControl: {
//                  maxAge: 
//              }
          }
//          nullValueIndicatorFor: '',
//          signReversalIndicator: true
      }
      data_stream     as DataStream,
      @Semantics.systemDateTime.createdAt: true
      created_at      as CreatedAt,
      @Semantics.mimeType: true
      mime_type       as MimeType,
      filename        as Filename,
      table_name      as TableName
      //    _association_name // Make association public
}
