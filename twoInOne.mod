#Sequantial + flow model in one
param n;

set CITIES ordered := 1..n;
set LINKS := {i in CITIES, j in CITIES: ord(i) != ord(j)};

param COST{LINKS} >= 0;

var x {LINKS} binary;
var y {LINKS} integer, >=0, <=n-1;
var u {CITIES diff {1}} integer,  >=2, <=n;

minimize TravelCost:
	sum {(i,j) in LINKS} COST[i,j]*x[i,j]; 

subject to OneOut{i in CITIES}:
	sum {j in CITIES: (i,j) in LINKS} x[i,j] = 1;

subject to OneIn{j in CITIES}:
	sum {i in CITIES: (i,j) in LINKS} x[i,j] = 1;

subject to FlowIffActive {i in CITIES diff {1}, j in CITIES diff {1}: (i,j) in LINKS}:
	y[i,j] <= (n-2)*x[i,j];

subject to FlowEquations{i in {CITIES diff {1}}}:
    sum {j in CITIES : (i, j) in LINKS} y[i,j] 
    = -1 + sum {k in CITIES: (k,i) in LINKS} y[k,i];

subject to FlowInput{i in {CITIES diff {1}}}:
	(n-1)*x[1, i]= y[1,i];

subject to FlowOutput{i in {CITIES diff {1}}}:
	y[i, 1] = 0;
	
subject to Order {i in CITIES, j in CITIES: (i,j) in LINKS and ord(i)!=1 and ord(j)!=1}:
	u[i] <= u[j] - (n-1)*x[i,j] + n-2;
