      ********************************************
      * Various helper routines
      *
      * utils
      *
      * Copyright (c) 2024 Robert Roland
      ********************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. string-split.

       DATA DIVISION.

       LOCAL-STORAGE SECTION.

       01  split-string.
           05  split-string-pieces OCCURS 10 TIMES.
               10  split-string-piece PIC X(80) VALUE SPACES.
           05  split-string-count PIC S9(04) VALUE 0.

       77  counter PIC S9(04) COMP.
       77  ptr     PIC S9(04) VALUE 1.

       LINKAGE SECTION.

       01  string-values.
           05  string-value PIC X(1024) VALUE SPACES.

       01  split-string-out.
           05  split-string-pieces-out OCCURS 10 TIMES.
               10  split-string-piece-out PIC X(80) VALUE SPACES.
           05  split-string-count-out PIC S9(04) VALUE 0.

       PROCEDURE DIVISION USING string-values split-string-out.

       MOVE 1 TO counter.
       MOVE 1 TO ptr.

       MOVE 0 TO split-string-count.

       PERFORM VARYING counter FROM 1 BY 1 UNTIL counter > 10
           UNSTRING string-value DELIMITED BY ALL '/'
               INTO split-string-pieces(counter)
               WITH POINTER ptr
               TALLYING IN split-string-count
           END-UNSTRING
       END-PERFORM.

       MOVE split-string TO split-string-out.

       DISPLAY 'Done = ' split-string-count.
       DISPLAY 'Out  = ' split-string-count-out.
       GOBACK.

       END PROGRAM string-split.
