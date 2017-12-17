reset;

param n;

set CITIES ordered := 1..n;
set LINKS := {i in CITIES, j in CITIES: ord(i) != ord(j)};

param COST{LINKS} >= 0;

var x {LINKS} binary;
var u {CITIES diff {1}} integer, >=2, <=n;

minimize TravelCost:
	sum {(i,j) in LINKS} COST[i,j]*x[i,j]; 

subject to OneOut{i in CITIES}:
	sum {j in CITIES: (i,j) in LINKS} x[i,j] = 1;

subject to OneIn{j in CITIES}:
	sum {i in CITIES: (i,j) in LINKS} x[i,j] = 1;

subject to Order {i in CITIES, j in CITIES: (i,j) in LINKS and ord(i)!=1 and ord(j)!=1}:
	u[i] <= u[j] - (n-1)*x[i,j] + n-2;

data TSP_instances/burma14.dat;
 
option solver gurobi;
 
solve;