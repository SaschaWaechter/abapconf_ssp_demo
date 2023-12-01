@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'CDS View forSpeaker'
define view entity ZR_AC_SPEAKERTP
  as select from ZZT_AC_SPEAKER
  association to parent ZR_AC_SESSIONTP as _Session on $projection.ParentUUID = _Session.SessionUUID
{
  key SPEAKER_UUID as SpeakerUUID,
  PARENT_UUID as ParentUUID,
  SPEAKER_NAME as SpeakerName,
  SPEAKER_SHORT_BIO as SpeakerShortBio,
  SPEAKER_PROFILE as SpeakerProfile,
  SPEAKER_JOB_DESCR as SpeakerJobDescr,
  SPEAKER_EMPLOYER as SpeakerEmployer,
  SPEAKER_WEBPAGE as SpeakerWebpage,
  SOCIALMED as Socialmed,
  PICTURE as Picture,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  _Session
  
}
