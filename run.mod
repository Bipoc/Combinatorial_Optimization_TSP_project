reset;

#model classic.mod;
#model sequential.mod;
#model flow.mod;
#model twoInOne.mod;
model cascade.mod;

data TSP_instances/xqf131.dat;
 
option solver gurobi;
#option gurobi_options 'outlev 1';
#option gurobi_options 'timelim 360 presolve 0 heurfrac 0 cuts 0 mipstart 0';

solve;
display _total_solve_elapsed_time;
