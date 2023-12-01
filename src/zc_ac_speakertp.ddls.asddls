@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for Speaker'
@ObjectModel.semanticKey: [ 'SpeakerName' ]
@Search.searchable: true
@UI: {
  headerInfo: {
    typeName: 'Speaker',
    typeNamePlural: 'Speakers',
    typeImageUrl: 'sap-icon://person-placeholder',
    title: {
      type: #STANDARD,
      label: 'Speaker',
      value: 'SpeakerName'
    }
  },
  presentationVariant: [ {
    sortOrder: [ {
      by: 'SpeakerUUID',
      direction: #DESC
    } ],
    visualizations: [ {
      type: #AS_LINEITEM
    } ]
  } ]
}
define view entity ZC_AC_SPEAKERTP
  as projection on ZR_AC_SPEAKERTP
{
  key SpeakerUUID,
      ParentUUID,
      @Search.defaultSearchElement: true
      SpeakerName,
      SpeakerShortBio,
      SpeakerProfile,
      SpeakerJobDescr,
      SpeakerEmployer,
      SpeakerWebpage,
      Socialmed,
      Picture,
      LocalLastChangedAt,
      _Session : redirected to parent ZC_AC_SESSIONTP

}
