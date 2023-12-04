@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help Accepted'
@ObjectModel.resultSet.sizeCategory: #XS
define root view entity ZI_AC_ACCEPTED_VH as select from zzt_ac_accepted

{
    key accepted as Accepted,
    accepted_text as AcceptedText
}
