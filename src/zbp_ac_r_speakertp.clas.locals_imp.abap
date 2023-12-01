CLASS LHC_SPEAKER DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      CALCULATESPEAKERUUID FOR DETERMINE ON SAVE
        IMPORTING
          KEYS FOR  Speaker~CalculateSpeakerUUID .
ENDCLASS.

CLASS LHC_SPEAKER IMPLEMENTATION.
  METHOD CALCULATESPEAKERUUID.
  ENDMETHOD.
ENDCLASS.
