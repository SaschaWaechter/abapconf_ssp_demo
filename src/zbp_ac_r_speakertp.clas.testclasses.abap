CLASS ltc_speaker DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CLASS-DATA: class_under_test     TYPE REF TO lhc_speaker,
                cds_test_environment TYPE REF TO if_cds_test_environment.

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

      "! Test Auto Twitter Handle
      autoTwitterHandle FOR TESTING.

ENDCLASS.

CLASS ltc_speaker IMPLEMENTATION.

  METHOD class_setup.
    CREATE OBJECT class_under_test FOR TESTING.
    cds_test_environment = cl_cds_test_environment=>create_for_multiple_cds(
        i_for_entities = VALUE #( ( i_for_entity = 'ZR_AC_SeSSIONTP' )
                                  ( i_for_entity = 'ZR_AC_SPEAKERTP' ) )
                                ).
  ENDMETHOD.

  METHOD setup.
    cds_test_environment->clear_doubles( ).
  ENDMETHOD.

  METHOD teardown.
    ROLLBACK ENTITIES.
  ENDMETHOD.

  METHOD class_teardown.
    cds_test_environment->destroy( ).
  ENDMETHOD.

  METHOD autotwitterhandle.
    " Fill in test data
    DATA speaker_mock_data TYPE STANDARD TABLE OF zzt_ac_speaker.

    DATA(speaker_uuid) = cl_system_uuid=>if_system_uuid_static~create_uuid_x16( ).
    speaker_mock_data = VALUE #( (  speaker_uuid = speaker_uuid speaker_webpage = 'twitter.com/wachtersascha' ) ).
    cds_test_environment->insert_test_data( speaker_mock_data ).

    " Declare required table and structures
    DATA reported TYPE RESPONSE FOR REPORTED LATE zr_ac_sessiontp.

    " Call the method to be tested
    class_under_test->autotwitterhandle(
      EXPORTING keys     = CORRESPONDING #(  speaker_mock_data MAPPING SpeakerUUID = speaker_uuid )
      CHANGING  reported = reported ).

    " Check for content in  reported
    cl_abap_unit_assert=>assert_initial( msg = 'reported' act = reported ).

    READ ENTITIES OF zr_ac_sessiontp IN LOCAL MODE
         ENTITY Speaker
         FIELDS ( socialmed )
         WITH VALUE #( ( SpeakerUUID = speaker_uuid ) )
         RESULT DATA(speakers)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED DATA(read_failed).

    cl_abap_unit_assert=>assert_equals( msg = 'action result' exp = '@wachtersascha' act = speakers[ 1 ]-Socialmed ).
  ENDMETHOD.

ENDCLASS.
