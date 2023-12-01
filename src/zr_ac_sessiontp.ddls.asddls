@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'CDS View forSession'
define root view entity ZR_AC_SESSIONTP
  as select from zzt_ac_session
  composition [0..*] of ZR_AC_SPEAKERTP as _Speaker
{
  key session_uuid as SessionUUID,
  title as Title,
  language as Language,
  abstract as Abstract,
  duration as Duration,
  focus_area as FocusArea,
  session_level as SessionLevel,
  @Semantics.eMail.address: true
  mail as Mail,
  accepted as Accepted,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.user.lastChangedBy: true
  last_changed_by as LastChangedBy,
  last_changed_at as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  _Speaker
  
}
