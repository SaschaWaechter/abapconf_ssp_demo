@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Projection View forSession'
define root view entity ZI_AC_SESSIONTP
  provider contract transactional_interface
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
  _Speaker : redirected to composition child ZI_AC_SPEAKERTP
  
}
