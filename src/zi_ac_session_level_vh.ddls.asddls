@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help Duration'
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_AC_SESSION_LEVEL_VH as select from zzt_ac_level
{
    key session_level as SessionLevel
}
