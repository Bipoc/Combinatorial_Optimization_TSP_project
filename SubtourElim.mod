param n;
set CITIES ordered := 1..n;

set S := 0 .. (2**n - 1);

set POW {k in S} := {i in CITIES: (k div 2**(ord(i)-1)) mod 2 = 1};

set LINKS := {i in CITIES, j in CITIES: ord(i) != ord(j)};

param COST{LINKS} >= 0;
var x {LINKS} binary;

subject to SubtourElim{k in S diff {0,2**n-1}}:
   sum {i in POW[k], j in CITIES diff POW[k]: (i,j) in LINKS} x[i,j] >= 1;


