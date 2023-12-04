CLASS ltc_session DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CLASS-DATA: class_under_test     TYPE REF TO lhc_session,
                cds_test_environment TYPE REF TO if_cds_test_environment,
                sql_test_environment TYPE REF TO if_osql_test_environment.

    CLASS-METHODS:
      "! Instantiate class under test and setup test double frameworks
      class_setup,

      "! Destroy test environments and test doubles
      class_teardown.

    METHODS:
      "! Reset test doubles
      setup,

      "! Reset transactional buffer
      teardown,

      "! Test Validation of correct mail address
      validateCorrectMail FOR TESTING,

      "! Test Validation of correct mail address
      validateIncorrectMail FOR TESTING,

      "! Test Validation of correct mail address
      validateCorrectMailEnding FOR TESTING,

      "! Test accept a Session Action
      acceptSession for Testing.

ENDCLASS.


CLASS ltc_session IMPLEMENTATION.

  METHOD class_setup.
    CREATE OBJECT class_under_test FOR TESTING.
    cds_test_environment = cl_cds_test_environment=>create( i_for_entity = 'ZR_AC_SESSIONTP' ).
    sql_test_environment = cl_osql_test_environment=>create( i_dependency_list = VALUE #( ( 'ZZT_AC_VALIDMAIL' ) ) ).
  ENDMETHOD.

  METHOD setup.
    cds_test_environment->clear_doubles( ).
    sql_test_environment->clear_doubles( ).
  ENDMETHOD.

  METHOD teardown.
    ROLLBACK ENTITIES.
  ENDMETHOD.

  METHOD class_teardown.
    cds_test_environment->destroy( ).
    sql_test_environment->destroy( ).
  ENDMETHOD.


  METHOD validateCorrectMail.
    " Declare required structures
    DATA failed TYPE RESPONSE FOR FAILED LATE zr_ac_sessiontp.
    DATA reported TYPE RESPONSE FOR REPORTED LATE  zr_ac_sessiontp.

    " Fill in test data
    DATA session_mock_data TYPE STANDARD TABLE OF zzt_ac_session.
    session_mock_data = VALUE #( ( session_uuid = cl_system_uuid=>if_system_uuid_static~create_uuid_x16( ) title = 'Testtitel' Abstract = 'Eine Test Session' Session_Level = 'Basics'
                                   mail = 'mail@test.de' Language = 'English' Focus_Area = 'ABAP Restful Application Programming Model (RAP)' ) ).
    cds_test_environment->insert_test_data( session_mock_data ).

    " Call method to be tested
    class_under_test->validatemail(
      EXPORTING
        keys     = CORRESPONDING #( session_mock_data MAPPING SessionUUID = session_uuid  )
      CHANGING
        failed   = failed
        reported = reported
    ).

    " Check for content in failed and reported
    cl_abap_unit_assert=>assert_initial( msg = 'failed' act = failed ).
    cl_abap_unit_assert=>assert_initial( msg = 'reported' act = reported ).

  ENDMETHOD.

  METHOD validateincorrectmail.

    " Declare required structures
    DATA failed TYPE RESPONSE FOR FAILED LATE zr_ac_sessiontp.
    DATA reported TYPE RESPONSE FOR REPORTED LATE  zr_ac_sessiontp.

    " Fill in test data
    DATA session_mock_data TYPE STANDARD TABLE OF zzt_ac_session.
    session_mock_data = VALUE #( ( session_uuid = cl_system_uuid=>if_system_uuid_static~create_uuid_x16( ) title = 'Testtitel' Abstract = 'Eine Test Session' Session_Level = 'Basics'
                                   mail = 'ichBinKeineMail' Language = 'English' Focus_Area = 'ABAP Restful Application Programming Model (RAP)' ) ).
    cds_test_environment->insert_test_data( session_mock_data ).

    " Call method to be tested
    class_under_test->validatemail(
      EXPORTING
        keys     = CORRESPONDING #( session_mock_data MAPPING SessionUUID = session_uuid )
      CHANGING
        failed   = failed
        reported = reported
    ).

    " Check for content in failed and reported
    cl_abap_unit_assert=>assert_not_initial( msg = 'failed' act = failed ).
    cl_abap_unit_assert=>assert_not_initial( msg = 'reported' act = reported ).


  ENDMETHOD.

  METHOD validatecorrectmailending.

    " Declare required structures
    DATA failed TYPE RESPONSE FOR FAILED LATE zr_ac_sessiontp.
    DATA reported TYPE RESPONSE FOR REPORTED LATE  zr_ac_sessiontp.

    " Fill in test data
    DATA session_mock_data TYPE STANDARD TABLE OF zzt_ac_session.
    session_mock_data = VALUE #( ( session_uuid = cl_system_uuid=>if_system_uuid_static~create_uuid_x16( ) title = 'Testtitel' Abstract = 'Eine Test Session' Session_Level = 'Basics'
                                   mail = 'write@testmail.com' Language = 'English' Focus_Area = 'ABAP Restful Application Programming Model (RAP)' ) ).
    cds_test_environment->insert_test_data( session_mock_data ).

    "Test data for mail ending table
    DATA mail_ending_mock_data TYPE STANDARD TABLE OF zzt_ac_validmail.
    mail_ending_mock_data = VALUE #( ( mail_ending = '@testmail.com' ) ).
    sql_test_environment->insert_test_data( mail_ending_mock_data ).

    " Call method to be tested
    class_under_test->validatemailending(
      EXPORTING
        keys     = CORRESPONDING #( session_mock_data MAPPING SessionUUID = session_uuid )
      CHANGING
        failed   = failed
        reported = reported
    ).

    " Check for content in failed and reported
    cl_abap_unit_assert=>assert_initial( msg = 'failed' act = failed ).
    cl_abap_unit_assert=>assert_initial( msg = 'reported' act = reported ).

  ENDMETHOD.

  METHOD acceptsession.

  ENDMETHOD.

ENDCLASS.
