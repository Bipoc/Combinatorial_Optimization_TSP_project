reset;

#model classic.mod;
#model sequential.mod;
model flow.mod;

data TSP_instances/burma14.dat;
 
option solver gurobi;
option gurobi_options 'timelim 360';
#option gurobi_options 'presolve 0'; option gurobi_options 'heurfrac 0'; option gurobi_options 'cuts 0'; option gurobi_options 'mipstart 0';

solve;