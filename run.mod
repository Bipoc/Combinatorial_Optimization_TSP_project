reset;

#model classic.mod;
#model sequential.mod;
#model flow.mod;
model twoInOne.mod;

data TSP_instances/eil51.dat;
 
option solver gurobi;
#option gurobi_options 'timelim 360 presolve 0 heurfrac 0 cuts 0 mipstart 0';

solve;
display _total_solve_elapsed_time;
