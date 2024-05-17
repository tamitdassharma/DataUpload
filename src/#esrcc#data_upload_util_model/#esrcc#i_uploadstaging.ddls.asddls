@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Upload Staging Interface'

define root view entity /ESRCC/I_UploadStaging
  as select from /esrcc/upld_stg as upld_stg
  
  association [0..1] to /ESRCC/I_UPLOADSCENARIOS as _UploadScenarios
    on _UploadScenarios.Application = $projection.Application
 
  association [0..1] to /ESRCC/I_UPLOADSTATUS as _UploadStatus
    on _UploadStatus.Status = $projection.Status
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
      status          as Status,
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
      
   case upld_stg.status
     when 'I' then 2
     when 'C' then 3
     when 'E' then 1 
     when 'W' then 2 
     else
     0
    end as statuscriticallity,
   
      //asccosiations
      _UploadScenarios,
      _UploadStatus
}
