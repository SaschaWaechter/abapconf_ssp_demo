@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help Language'
@ObjectModel.resultSet.sizeCategory: #XS
define root view entity ZI_AC_LANGUAGE_VH as select from zzt_ac_language

{
    key language as Language
}
