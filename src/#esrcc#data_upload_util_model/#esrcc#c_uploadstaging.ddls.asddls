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
       @Semantics.largeObject: {          
              mimeType: 'tmpMimeType',
              fileName: 'tmpFilename',
              contentDispositionPreference: #INLINE
          }   
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:/ESRCC/CL_DOWNLOADTEMPLATE'
      virtual tmpDataStream : abap.rawstring( 0 ),           
      @Semantics.mimeType: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:/ESRCC/CL_DOWNLOADTEMPLATE'
      virtual tmpMimeType : abap.char(128),  
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:/ESRCC/CL_DOWNLOADTEMPLATE'    
      virtual tmpFilename : abap.char(128),      
      TableName,
      @ObjectModel.text.element: [ 'uploadstatustext' ]
      Status,
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
      statuscriticallity,
      _UploadScenarios.text as applicationtext,
      _UploadStatus.text as uploadstatustext
}
