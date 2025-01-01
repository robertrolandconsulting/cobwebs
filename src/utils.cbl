       >>SOURCE FORMAT IS FREE
*>*******************************************
*> Various helper routines
*>
*> utils
*>
*> Copyright (c) 2024 Robert Roland
*>*******************************************
identification division.
program-id. string-split.

data division.

local-storage section.

01  split-string.
    05  split-string-pieces occurs 10 times.
        10  split-string-piece pic x(80) value spaces.
    05  split-string-count pic s9(04) value 0.

77  counter pic s9(04) comp.
77  ptr     pic s9(04) value 1.

linkage section.

01  split-delimiter pic x(1) value spaces.

01  string-values.
    05  string-value pic x(1024) value spaces.

01  split-string-out.
    05  split-string-pieces-out occurs 10 times.
        10  split-string-piece-out pic x(80) value spaces.
    05  split-string-count-out pic s9(04) value 0.

procedure division
   using split-delimiter string-values split-string-out.

    move 1 to counter.
    move 1 to ptr.

    move 0 to split-string-count.

    perform varying counter from 1 by 1 until counter > 10
       unstring string-value delimited by all split-delimiter
                into split-string-pieces(counter)
                with pointer ptr
                tallying in split-string-count
       end-unstring
    end-perform.

    move split-string to split-string-out.

    goback.

end program string-split.
