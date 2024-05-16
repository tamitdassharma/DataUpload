@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Upload Staging Interface'

define root view entity /ESRCC/I_UploadStaging
  as select from /esrcc/upld_stg as upld_stg
  
  association [0..1] to /ESRCC/I_UPLOADSCENARIOS as _UploadScenarios
    on _UploadScenarios.Application = $projection.Application
  //composition of target_data_source_name as _association_name
{
  key upload_uuid as UploadUIID,
  application     as Application,
   @Semantics.largeObject: {          
              mimeType: 'MimeType',
              fileName: 'Filename',
//              acceptableMimeTypes: [ 'text/csv' ],
              contentDispositionPreference: #INLINE
          }     
      data_stream     as DataStream,
      
      @Semantics.mimeType: true
      mime_type       as MimeType,
      filename        as Filename,
      table_name      as TableName,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      
      //asccosiations
      _UploadScenarios
}
