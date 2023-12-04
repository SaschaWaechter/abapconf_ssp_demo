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
  @Search.defaultSearchElement: true
  Title,
  Language,
  Abstract,
  Duration,
  FocusArea,
  SessionLevel,
  Mail,
  @ObjectModel.text.element: ['AcceptedText']
  Accepted,
  _AcceptedStatus.AcceptedText as AcceptedText,
  CriticalityAccepted,
  CreatedAt,
  CreatedBy,
  LastChangedBy,
  LastChangedAt,
  LocalLastChangedAt,
  _Speaker : redirected to composition child ZC_AC_SPEAKERTP
  
}
