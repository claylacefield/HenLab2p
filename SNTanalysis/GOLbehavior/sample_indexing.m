
a = zeros(10, 1)

a =

     0
     0
     0
     0
     0
     0
     0
     0
     0
     0

b = [5, 7, 9];
a(b) = 1

a =

     0
     0
     0
     0
     1
     0
     1
     0
     1
     0

c = rand(10, 1)

c =

      0.81472
      0.90579
      0.12699
      0.91338
      0.63236
      0.09754
       0.2785
      0.54688
      0.95751
      0.96489

a

a =

     0
     0
     0
     0
     1
     0
     1
     0
     1
     0

c(a == 1)

ans =

      0.63236
       0.2785
      0.95751