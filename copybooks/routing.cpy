01  router-config.
    05  num-routes             pic s9(04) comp.
    05  route-table occurs 10 times indexed by route-idx.
*> GET / POST / PUT / PATCH / DELETE / HEAD
        10 route-method        pic x(6).
        10 route-path          pic x(1024).
        10 route-destination   pic x(100).
