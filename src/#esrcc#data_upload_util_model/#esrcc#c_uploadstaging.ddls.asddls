@AbapCatalog.viewEnhancementCategory: [ #NONE ]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Upload Staging Projection'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity /ESRCC/C_UploadStaging
  provider contract transactional_query
  as projection on /ESRCC/I_UploadStaging
  //composition of target_data_source_name as _association_name
{

  key Application,
  key SubApplication,
  key CreatedBy,
      DataStream,
      
      CreatedAt,
      
      MimeType,
      
      Filename,
      
      TableName
      //    _association_name // Make association public
}
