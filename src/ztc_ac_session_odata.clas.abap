"!@testing SRVB:ZUI_AC_SESSION_O2
CLASS ztc_ac_session_odata DEFINITION
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PRIVATE SECTION.

    CLASS-DATA: o_client_proxy       TYPE REF TO /iwbep/if_cp_client_proxy,
                o_filter_factory     TYPE REF TO /iwbep/if_cp_filter_factory,
                o_filter_node        TYPE REF TO /iwbep/if_cp_filter_node,
                cds_test_environment TYPE REF TO if_cds_test_environment,
                sql_test_environment TYPE REF TO if_osql_test_environment,
                session_mock_data    TYPE TABLE OF zzt_ac_session.

    CLASS-METHODS :
      class_setup RAISING cx_static_check,
      class_teardown,

      create_local_client_proxy
        IMPORTING
          service_key         TYPE /iwbep/if_cp_client_proxy=>ty_s_service_key_v2
        RETURNING
          VALUE(client_proxy) TYPE REF TO /iwbep/if_cp_client_proxy .

    METHODS:
      setup,
      teardown,
      "! <p class="shorttext synchronized" lang="en"></p>
      "! read request with filter for duration
      read_sessions_with_filter FOR TESTING,
      "! <p class="shorttext synchronized" lang="en"></p>
      "! create a session with false mail adress
      create_session_with_false_mail FOR TESTING.
ENDCLASS.



CLASS ztc_ac_session_odata IMPLEMENTATION.

  METHOD class_setup.

    o_client_proxy = create_local_client_proxy( VALUE #(
                                                          service_id      = 'ZUI_AC_SESSION_O2'
                                                          service_version = '0001' )  ).

    cds_test_environment = cl_cds_test_environment=>create_for_multiple_cds(
        i_for_entities = VALUE #( ( i_for_entity = 'ZC_AC_SESSIONTP' i_select_base_dependencies = abap_true  )
                                  ( i_for_entity = 'ZC_AC_SPEAKERTP' i_select_base_dependencies = abap_true ) )
                                ).

    DATA(session_uuid1) = cl_system_uuid=>if_system_uuid_static~create_uuid_x16( ).
    DATA(session_uuid2) = cl_system_uuid=>if_system_uuid_static~create_uuid_x16( ).

    session_mock_data     = VALUE #( ( session_uuid = session_uuid1 title = 'Session Test 1' mail = 'dummy@gmail.com' abstract = 'Test' language ='German'
                                       duration = '30' session_level = 'Basics' focus_area = 'Classic ABAP' )
                                     ( session_uuid = session_uuid2 title = 'Session Test 2' mail = 'dummy@gmail.com' abstract = 'Test' language ='English'
                                       duration = '30' session_level = 'Basics' focus_area = 'S/4HANA' )

     ) .

  ENDMETHOD.


  METHOD setup.
    cds_test_environment->clear_doubles( ).
  ENDMETHOD.


  METHOD teardown.
    ROLLBACK ENTITIES.
  ENDMETHOD.


  METHOD class_teardown.
    cds_test_environment->destroy(  ).
  ENDMETHOD.


  METHOD create_local_client_proxy.

    TRY.
        " the Cloud version
        DATA(class1) = 'CL_WEB_ODATA_CLIENT_FACTORY'.
        CALL METHOD (class1)=>create_v2_local_proxy
          EXPORTING
            is_service_key  = service_key
          RECEIVING
            ro_client_proxy = client_proxy.
      CATCH cx_root.
    ENDTRY.


    IF client_proxy IS NOT BOUND.
      TRY.
          " the onPrem version
          DATA(class2) = '/IWBEP/CL_CP_CLIENT_PROXY_FACT'.
          CALL METHOD (class2)=>create_v2_local_proxy
            EXPORTING
              is_service_key  = service_key
            RECEIVING
              ro_client_proxy = client_proxy.
        CATCH cx_root.
      ENDTRY.
    ENDIF.

    cl_abap_unit_assert=>assert_bound( msg = 'cannot get client proxy factory or service binding not active' act = client_proxy ).

  ENDMETHOD.

  METHOD read_sessions_with_filter.
    TYPES duration_range TYPE RANGE OF ze_abapconf_duration.

    cds_test_environment->insert_test_data( session_mock_data ).

    DATA(o_session) = o_client_proxy->create_resource_for_entity_set( 'Session' ).

    DATA(o_request) = o_session->create_request_for_read( ).

    DATA(duration_range) = VALUE duration_range( ( sign = 'I' option = 'EQ' low = '30' ) ).

    DATA(o_filter_factory) = o_request->create_filter_factory( ).
    DATA(o_filter_node) = o_filter_factory->create_by_range( iv_property_path = 'DURATION'
                                                             it_range         = duration_range ).

    o_request->set_filter( o_filter_node ).

    DATA(o_response) = o_request->execute( ).

    cl_abap_unit_assert=>assert_not_initial( o_response ).

    DATA response_data TYPE STANDARD TABLE OF zc_ac_sessiontp.
    o_response->get_business_data( IMPORTING et_business_data = response_data ).

    cl_abap_unit_assert=>assert_equals( exp =  '2' act = lines( response_data ) ).
    cl_abap_unit_assert=>assert_equals( exp =  'Session Test 1' act = response_data[ 1 ]-Title ).
    cl_abap_unit_assert=>assert_equals( exp =  'Session Test 2' act = response_data[ 2 ]-title ).
  ENDMETHOD.

  METHOD create_session_with_false_mail.
    TYPES duration_range TYPE RANGE OF ze_abapconf_duration.

    DATA(o_session) = o_client_proxy->create_resource_for_entity_set( 'Session' ).

    DATA(o_request) = o_session->create_request_for_create( ).

    DATA(session_data) = VALUE zc_ac_sessiontp( sessionuuid = cl_system_uuid=>if_system_uuid_static~create_uuid_x16( ) title = 'Corrupted Session' mail = 'falseMail' abstract = 'Test' language ='German'
                                      duration = '30' sessionlevel = 'Basics' focusarea = 'Classic ABAP' ).
    o_request->set_business_data( session_data ).

    try.
        data(o_response) = o_request->execute( ).
      catch  /iwbep/cx_gateway.
        "get error messages
        DATA(o_msg_cont) = /iwbep/cl_mgw_msg_container=>get_mgw_msg_container( ).
        DATA(messages) = o_msg_cont->get_messages( ).
    endtry.

    "check request errors -> multiple RAP validations
    cl_abap_unit_assert=>assert_equals( exp =  'E-Mail adress invalid endig (not known provider)' act =  messages[ 1 ]-message ).
    cl_abap_unit_assert=>assert_equals( exp =  'E-Mail adress invalid format' act = messages[ 2 ]-message ).
  ENDMETHOD.

ENDCLASS.
