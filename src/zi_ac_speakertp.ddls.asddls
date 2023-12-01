@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Projection View forSpeaker'
define view entity ZI_AC_SPEAKERTP
  as projection on ZR_AC_SPEAKERTP
{
  key SpeakerUUID,
  ParentUUID,
  SpeakerName,
  SpeakerShortBio,
  SpeakerProfile,
  SpeakerJobDescr,
  SpeakerEmployer,
  SpeakerWebpage,
  Socialmed,
  @Semantics.imageUrl: true
  Picture,
  LocalLastChangedAt,
  _Session : redirected to parent ZI_AC_SESSIONTP
  
}
