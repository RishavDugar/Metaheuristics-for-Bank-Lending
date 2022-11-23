%************************************************%
%RISHAV DUGAR 19IM3FP30
%************************************************%
clear all 
close all
clc

%Bank Params
D = 60;
K = 0.15;

%Data
loan = [10,9,15,17,3,18,11,4,25,10];
interest = [0.022,0.028,0.021,0.023,0.026,0.025,0.027,0.021,0.022,0.021];
rating = ["A","A","AAA","BB","AAA","BBB","AA","A","BB","AAA"];
loss = [0.001,0.001,0.0002,0.0058,0.0002,0.0024,0.0003,0.0001,0.0058,0.0002];

%Range of Values
N = length(loan);
x_max = 2^(N)-1;
x_min = 1;

%Initial Temperature 
c = 0;
s = 0;
h = 10;
while c<h
    x_tmp = round(rand*(x_max-x_min)+x_min);
    bin = int2bit(x_tmp,N,true)';
    if feasible(bin,loan,D,K) == 1
        s = s + fitness(bin,loan,interest,loss,D,K);
        c = c + 1;
    end
end

%SA Params
T_init = s/h;
max_run = 60;
boltzmann = 1;
T_min = 0.0001;
alpha = 0.9;
initial_search = 60;
max_reject = 20;

fits = [];
T = [];
gbest = 0;
gbest_sol = [];
for m = 1:50
    tic
    %Variables & Lists to be used during the code
    opt = [];
    eval = [];
    best_sol = [];
    temp = [];

    %Initialisations
    T = T_init;
    E_init = 0; 
    E_old = E_init; 
    E_new= E_old;
    best = 0;
    count = 1;
    i = 0;
    rejects = 0;
    
    while T>T_min && rejects < max_reject
        i = i + 1;

        %Initial Search
        while count < initial_search+1
	        x_tmp = round(rand*(x_max-x_min)+x_min);
            bin = int2bit(x_tmp,N,true)';
            if feasible(bin,loan,D,K) == 1
	            if fitness(bin,loan,interest,loss,D,K)>best
	                best_sol = x_tmp;
                    best = fitness(bin,loan,interest,loss,D,K);
                end
                count = count + 1;
            end
        end
        
        if i>=max_run
            T = T*alpha;
            i = 0;
            reject = 0;
        end

        %Generating new solutions
        bin = int2bit(best_sol,N,true)';
        [bin1,bin2] = gen(bin,loan,D,x_max,x_min,N,K);

        obj1 = fitness(bin1,loan,interest,loss,D,K);
        obj2 = fitness(bin2,loan,interest,loss,D,K);

        if obj1>obj2
            obj = obj1;
            x_tmp = bit2int(bin1',N,true);
        else
            obj = obj2;
            x_tmp = bit2int(bin2',N,true);
        end

        if obj>best
            best = obj;
            best_sol = x_tmp;
            reject = 0;
        else
            if exp((obj-best)/(boltzmann*T))>rand
                best = obj;
                best_sol = x_tmp;
                reject = 0;
            else
                rejects = rejects + 1;
            end
        end


    end
    fits(m) = best;
    T(m) = toc;

    if best>gbest
        gbest = best;
        gbest_sol = best_sol;
    end
end
Chromosome = int2bit(gbest_sol,10,true)'
Capital_Used = sum(Chromosome.*loan)
Profit = gbest
%Plotting

%Ploting results generation wise
figure(1);
plot(1:50,fits, 'bo');
xlabel('Iteration Number');
ylabel('Fitness');
title('Result');


