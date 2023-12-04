class ZCL_AC_MAIL_FRAMEWORK definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR .
  methods SENS_SESSION_ACCEPTED
    importing
      !I_MAIL type ZE_ABAPCONF_MAIL
      !I_TITLE type ZE_ABAPCONF_SESSION_TITLE
    returning
      value(R_SUCCESFUL) type FLAG .
protected section.
private section.
ENDCLASS.



CLASS ZCL_AC_MAIL_FRAMEWORK IMPLEMENTATION.


  method CONSTRUCTOR.
  endmethod.


  method SENS_SESSION_ACCEPTED.
  endmethod.
ENDCLASS.
