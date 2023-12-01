@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View forSession'
@ObjectModel.semanticKey: [ 'SessionUUID' ]
@Search.searchable: true
define root view entity ZC_AC_SESSIONTP
  provider contract transactional_query
  as projection on ZR_AC_SESSIONTP
{
  key SessionUUID,
  Title,
  Language,
  Abstract,
  Duration,
  FocusArea,
  SessionLevel,
  Mail,
  Accepted,
  CreatedAt,
  CreatedBy,
  LastChangedBy,
  LastChangedAt,
  LocalLastChangedAt,
  _Speaker : redirected to composition child ZC_AC_SPEAKERTP
  
}
