@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help Duration'
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_AC_DURATION_VH as select from zzt_ac_duration
{
    key duration as Duration,
    duration_text as DurationText
}
