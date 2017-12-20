#Sequantial + flow model in one
param n;

set CITIES ordered := 1..n;
set LINKS := {i in CITIES, j in CITIES: ord(i) != ord(j)};

param COST{LINKS} >= 0;

var x {LINKS} binary;
var y {LINKS} integer,>=0, <=n-1;
var u {CITIES diff {1}} integer, >=2, <=n;

minimize TravelCost:
	sum {(i,j) in LINKS} COST[i,j]*x[i,j]; 

subject to OneOut{i in CITIES}:
	sum {j in CITIES: (i,j) in LINKS} x[i,j] = 1;

subject to OneIn{j in CITIES}:
	sum {i in CITIES: (i,j) in LINKS} x[i,j] = 1;

subject to FlowIffActive {(i,j) in LINKS}:
	y[i,j] <= (n-1)*x[i,j];

subject to FlowEquations{i in {CITIES diff {1}}}:
	sum {j in CITIES: (j,i) in LINKS} y[j,i]
	= 1 + sum {j in CITIES: (i,j) in LINKS} y[i,j];

subject to FlowInput:
	n-1 + sum {j in CITIES: (j,1) in LINKS} y[j,1]
	= sum {j in CITIES: (1,j) in LINKS} y[1,j];

	
subject to Order {i in CITIES, j in CITIES: (i,j) in LINKS and ord(i)!=1 and ord(j)!=1}:
	u[i] <= u[j] - (n-1)*x[i,j] + n-2;