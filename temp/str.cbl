       IDENTIFICATION DIVISION.
       PROGRAM-ID.   str.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       01  INSTR PIC X(100).

       01  SPLIT-STR PIC X(100) OCCURS 10 TIMES.
       77  TOTAL-ITEMS PIC S9(04).
       77  COUNTER PIC S9(04).
       77  PTR PIC S9(04).

       LINKAGE SECTION.

       PROCEDURE DIVISION.

       MAIN.
           MOVE '/foo/bar/baz' TO INSTR.
           MOVE 0 TO TOTAL-ITEMS.
           MOVE 1 TO PTR.
           MOVE 1 TO COUNTER.

           DISPLAY "Splitting INSTR = " INSTR.

           PERFORM VARYING COUNTER FROM 1 BY 1 UNTIL COUNTER > 10
               DISPLAY "Loop = " COUNTER
               UNSTRING INSTR DELIMITED BY ALL '/'
                   INTO SPLIT-STR(COUNTER)
                   WITH POINTER PTR
                   TALLYING IN TOTAL-ITEMS
               END-UNSTRING
               DISPLAY "PTR = " PTR
               DISPLAY "VAL = " SPLIT-STR(COUNTER)
           END-PERFORM
           DISPLAY "Total items = " TOTAL-ITEMS.
           DISPLAY "Item 1 = " SPLIT-STR(1).

           STOP RUN.
               
