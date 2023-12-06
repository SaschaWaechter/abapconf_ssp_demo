"! Local Test Class for Speaker entity
CLASS ltc_speaker DEFINITION DEFERRED FOR TESTING.
CLASS lhc_speaker DEFINITION INHERITING FROM cl_abap_behavior_handler FRIENDS ltc_speaker.
  PRIVATE SECTION.
    METHODS calculatespeakeruuid FOR DETERMINE ON SAVE
      IMPORTING
        keys FOR  Speaker~CalculateSpeakerUUID.

    METHODS autoTwitterHandle FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Speaker~autoTwitterHandle.
ENDCLASS.


CLASS lhc_speaker IMPLEMENTATION.
  METHOD calculatespeakeruuid.
  ENDMETHOD.

  METHOD autoTwitterHandle.
    DATA twitter_handle TYPE ze_abapconf_speaker_socialmed.

    " Read travel instances of the transferred keys
    READ ENTITIES OF zr_ac_sessiontp IN LOCAL MODE
         ENTITY Speaker
         FIELDS ( speakerwebpage socialmed )
         WITH CORRESPONDING #( keys )
         RESULT DATA(speakers)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED DATA(read_failed).

    " Check if Social Media Handle is already set
    DELETE speakers WHERE Socialmed IS NOT INITIAL.
    IF speakers IS INITIAL.
      RETURN.
    ENDIF.

    LOOP AT speakers INTO DATA(speaker).

      " Check if Webpage is a Twitter Profile
      IF speaker-SpeakerWebpage CA 'twitter.com/'.

        twitter_handle = |@{ match( val   = speaker-SpeakerWebpage
                                    regex = '([^\/]+$)' ) }|.
        MODIFY ENTITIES OF zr_ac_sessiontp IN LOCAL MODE
               ENTITY Speaker
               UPDATE SET FIELDS
               WITH VALUE #( (  %tky = speaker-%tky Socialmed = twitter_handle ) )
               REPORTED DATA(update_reported).

        " Set the changing parameter
        reported = CORRESPONDING #( DEEP update_reported ).

      ENDIF.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
