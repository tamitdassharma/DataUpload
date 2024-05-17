@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Excel Upload Status'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
define view entity /ESRCC/I_UPLOADSTATUS 
as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: '/ESRCC/UPLOAD_STATUS')
{
      @ObjectModel.text.element: ['text']
      @UI.textArrangement: #TEXT_ONLY
      @Search: { defaultSearchElement: true, fuzzinessThreshold: 0.7 }
  key value_low as Status,

      @Semantics.text: true
      @Search: { defaultSearchElement: true, fuzzinessThreshold: 0.7 }
      text
}
where
  language = $session.system_language
