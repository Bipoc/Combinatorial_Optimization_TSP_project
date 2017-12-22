#The sequential model
param n;

set CITIES ordered := 1..n;
set TIME ordered := CITIES;
set LINKS := {i in CITIES, j in CITIES: ord(i) != ord(j)};

param COST{LINKS} >= 0;

var x {TIME, LINKS} binary;

minimize TravelCost:
	sum {t in TIME, (i,j) in LINKS} COST[i,j]*x[t,i,j]; 

subject to OneOutForTheFirst:
	sum {j in CITIES: (1,j) in LINKS} x[1,1,j] = 1;

subject to RestToZero {i in {CITIES diff {1}}, j in CITIES: (i,j) in LINKS}:
	x[1,i,j] = 0;

subject to OutEqualIn {t in {TIME diff {1}}, i in CITIES}:
	sum {j in CITIES: (i,j) in LINKS} x[t-1,j,i] = sum {j in CITIES: (i,j) in LINKS} x[t,i,j];

subject to OutEqualInFirstRow:
	sum {j in CITIES: (j,1) in LINKS} x[n,j,1] = 1;

subject to OnlyOnce {i in CITIES}:
	sum {t in TIME, j in CITIES: (i,j) in LINKS} x[t,i,j] = 1;
