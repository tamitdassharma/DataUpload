@EndUserText.label: 'Excel Upload'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity /ESRCC/C_UPLOADSTAGING 
as projection on /ESRCC/I_UploadStaging
{
    key UploadUIID,
      @ObjectModel.text.element: [ 'applicationtext' ]
      Application,
      @Semantics.largeObject: {          
              mimeType: 'MimeType',
              fileName: 'Filename',
              contentDispositionPreference: #INLINE
          }   
      DataStream,           
      @Semantics.mimeType: true
      MimeType,      
      Filename,      
      TableName,
      @Semantics.user.createdBy: true
      CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      CreatedAt,
      @Semantics.user.lastChangedBy: true
      LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,
      
      _UploadScenarios.text as applicationtext
}
