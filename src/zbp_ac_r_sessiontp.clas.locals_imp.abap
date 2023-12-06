"! Local Test Class for Session entity
CLASS ltc_session DEFINITION DEFERRED FOR TESTING.
"! Methods are private so you have to define a friendship to your testclass
CLASS lhc_session DEFINITION INHERITING FROM cl_abap_behavior_handler FRIENDS ltc_session.
  PRIVATE SECTION.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING
              REQUEST requested_authorizations FOR Session
              RESULT result.

    METHODS calculatesessionuuid FOR DETERMINE ON SAVE
      IMPORTING
                keys FOR  Session~CalculateSessionUUID.

    "! validate mailaddress if it's correct to prevent false entries or trash proposals
    METHODS validateMail FOR VALIDATE ON SAVE
      IMPORTING keys FOR Session~validateMail.

    "! validate mailaddress if it's correct to prevent false entries or trash proposals
    METHODS validateMailEnding FOR VALIDATE ON SAVE
      IMPORTING keys FOR Session~validateMailEnding.

    "! Check if session accepted works correct
    METHODS SetSessionAccepted FOR MODIFY
      IMPORTING keys FOR ACTION Session~SetSessionAccepted RESULT result.
ENDCLASS.

CLASS lhc_session IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD calculatesessionuuid.
  ENDMETHOD.

  METHOD validateMail.
    "Fetch entered mail address for validation with EML
    READ ENTITIES OF zr_ac_sessiontp IN LOCAL MODE
        ENTITY Session
        FIELDS ( Mail ) WITH CORRESPONDING #( keys )
        RESULT DATA(mailAddresses).

    LOOP AT mailAddresses INTO DATA(mailAddress).

      "Simplest validation to check the format of the mail address
      IF mailaddress-Mail NA '@' OR mailaddress-Mail NA '.'.
        "Return validation error
        APPEND VALUE #( %tky = mailaddress-%tky ) TO failed-session.
        "Report text for user
        APPEND VALUE #( %tky = mailAddress-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'E-Mail adress invalid format'
                               )
                        %element-Mail = if_abap_behv=>mk-on ) TO reported-session.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD validateMailEnding.
    DATA mailCorrect TYPE xsdboolean.

    "Fetch entered mail address for validation with EML
    READ ENTITIES OF zr_ac_sessiontp IN LOCAL MODE
        ENTITY Session
        FIELDS ( Mail ) WITH CORRESPONDING #( keys )
        RESULT DATA(mailAddresses).

    "Reads the customized valid mail endings from database table -> dependency
    SELECT mail_ending FROM zzt_ac_validmail INTO TABLE @DATA(valid_mail_endings).

    LOOP AT mailAddresses INTO DATA(mailAddress).

      LOOP AT valid_mail_endings INTO DATA(valid_mail_ending).

        "check if mail ends with a valid ending from database table
        IF mailaddress-Mail CP |*{ valid_mail_ending-mail_ending }|.
          mailcorrect = abap_true.
        ENDIF.

      ENDLOOP.

      "ends not with a valid mail provider -> error
      IF mailcorrect = abap_false.
        "Return validation error
        APPEND VALUE #( %tky = mailaddress-%tky ) TO failed-session.
        "Report text for user
        APPEND VALUE #( %tky = mailAddress-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'E-Mail adress invalid endig (not known provider)'
                               )
                        %element-Mail = if_abap_behv=>mk-on ) TO reported-session.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD SetSessionAccepted.
    MODIFY ENTITIES OF zr_ac_sessiontp IN LOCAL MODE
             ENTITY Session
                UPDATE FROM VALUE #( FOR key IN keys
                ( SessionUUID = key-sessionuuid
                  Accepted = abap_true
                  %control-accepted = if_abap_behv=>mk-on ) )
                FAILED failed
                REPORTED reported.

    "Read changed data for action result
    READ ENTITIES OF zr_ac_sessiontp IN LOCAL MODE
      ENTITY Session
      ALL FIELDS WITH
      CORRESPONDING #( keys )
      RESULT DATA(sessions).

    "Send Mail to Speaker
    LOOP AT sessions INTO DATA(session).

      result = VALUE #( BASE result
             ( %tky   = session-%tky
               %param = session ) ).

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
