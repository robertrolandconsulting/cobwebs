*> this is "based" because the pointer's location
*> comes from the FCGX-Request record below.
01  FCGX-Stream-In based.
    05  filler usage pointer synchronized. *> 8
    05  filler usage pointer synchronized. *> 8
    05  filler usage pointer synchronized. *> 8
    05  filler usage pointer synchronized. *> 8
    05  filler usage binary-long synchronized. *> 4
    05  filler usage binary-long synchronized. *> 4
    05  filler usage binary-long synchronized. *> 4
    05  filler usage binary-long synchronized. *> 4
    05  filler usage pointer synchronized. *> 8
    05  filler usage pointer synchronized. *> 8
    05  filler usage pointer. *> 8

01  FCGX-Stream-Out based.
    05  filler usage pointer synchronized. *> 8
    05  filler usage pointer synchronized. *> 8
    05  filler usage pointer synchronized. *> 8
    05  filler usage pointer synchronized. *> 8
    05  filler usage binary-long synchronized. *> 4
    05  filler usage binary-long synchronized. *> 4
    05  filler usage binary-long synchronized. *> 4
    05  filler usage binary-long synchronized. *> 4
    05  filler usage pointer synchronized. *> 8
    05  filler usage pointer synchronized. *> 8
    05  filler usage pointer. *> 8

01  FCGX-Stream-Err based.
    05  filler usage pointer synchronized. *> 8
    05  filler usage pointer synchronized. *> 8
    05  filler usage pointer synchronized. *> 8
    05  filler usage pointer synchronized. *> 8
    05  filler usage binary-long synchronized. *> 4
    05  filler usage binary-long synchronized. *> 4
    05  filler usage binary-long synchronized. *> 4
    05  filler usage binary-long synchronized. *> 4
    05  filler usage pointer synchronized. *> 8
    05  filler usage pointer synchronized. *> 8
    05  filler usage pointer. *> 8

01  FCGX-Request.
    05  filler  usage binary-long synchronized.
    05  filler  usage binary-long synchronized.
    05  in-ptr  usage pointer synchronized. *> pointer to FCGX-Stream-In
    05  out-ptr usage pointer synchronized. *> pointer to FCGX-Stream-Out
    05  err-ptr usage pointer synchronized. *> pointer to FCGX-Stream-Err
    05  env-ptr usage pointer synchronized.
    05  filler  usage pointer synchronized.
    05  filler  usage binary-long synchronized.
    05  filler  usage binary-long synchronized.
    05  filler  usage binary-long synchronized.
    05  filler  usage binary-long synchronized.
    05  filler  usage binary-long synchronized.
    05  filler  usage binary-long synchronized.
    05  filler  usage binary-long synchronized.
    05  filler  usage binary-long synchronized.
