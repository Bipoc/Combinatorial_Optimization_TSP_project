reset; 

#model classic.mod;
#model sequential.mod; 
#model flow.mod; 
model twoInOne.mod

data TSP_instances/xqf131.dat;
#data TSP_instances/dantzig42.dat;
#data TSP_instances/eil51.dat;


# TSP heuristic

param curr_node default 1;
param next_city default 1;
param min_cost default 1000000;
param heuristic = 1;

if heuristic then {
    
    for {i in 1..n-1} {
        let min_cost := 10000000;
        for {j in CITIES : ord(j) != curr_node and sum {k in CITIES : ord(k) != ord(j) } x[j, k] == 0 and (curr_node, j) in LINKS} {
            if COST[curr_node, j] < min_cost then {
                let min_cost := COST[curr_node, j];
                let next_city := j;
            } 
        }
        let x[curr_node, next_city] := 1;
        let curr_node := next_city;
    }
    let x[curr_node, 1] := 1;
} 

 
option solver gurobi;

# option classic model
#option gurobi_options 'timelim 60 cuts -1 mipstart 1';

# option sequential model
#option gurobi_options 'timelim 360 cuts -1 mipstart 1 intstart 1';

# option flow model

# option gurobi_options 'timelim 109 presolve 0 heurfrac 0 cuts 0';
option gurobi_options 'timelim 360 outlev 1 flowcover -1 flowpath 2 cuts 3 mipstart 1';


solve;
display _total_solve_elapsed_time;
