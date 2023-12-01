@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help Focus Area'
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_AC_FOCUS_AREA_VH as select from zzt_ac_focusarea
{
    key focus_area as FocusArea
}
