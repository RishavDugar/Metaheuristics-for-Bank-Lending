%************************************************%
%RISHAV DUGAR 19IM3FP30
%************************************************%
clear all 
close all
clc

%GA Params
pop_size = 60;
mutation_probability = 0.006;
crossover_probability = 0.8;
number_of_generations = 60;
reproduction_probability = 0.194;

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

fits = [];
T = [];
for m = 1:1
    tic
    %Variables & Lists to be used during the code
    gen_1_xvalues = [];
    gen_1_fvalues = [];
    generations_x = [];
    generations_f = [];
    
    %Size of the string in bit
    x_size = length(dec2bin(x_max));
    
    %Initial Population
    count = 1;
    while count < pop_size+1
	    x_tmp = round(rand*(x_max-x_min)+x_min);
        bin = int2bit(x_tmp,N,true)';
        if feasible(bin,loan,D,K) == 1
	        gen_1_xvalues(count) = x_tmp;
	        gen_1_fvalues(count) = fitness(bin,loan,interest,loss,D,K);
            count = count + 1;
        end
    
    end
        
    %Getting maximum value for initial population
    max_f = 0;
    for j=1:pop_size
	    if gen_1_fvalues(j) >= max_f
		    max_f = gen_1_fvalues(j);
		    max_x = gen_1_xvalues(j);
        end
    end
    
    %Starting GA loop
    for q=1:number_of_generations
        generations_x(q) = max_x;
        generations_f(q) = max_f;
    
        %Reseting list for 2nd generation
	    gen_2_xvalues = [];
	    gen_2_fvalues = [];
        mating_pop = [];
    
        %Selecting best individuals based on Reproduction Criteria
        [gen_1_fvalues,sortIdx] = sort(gen_1_fvalues,'descend');
        gen_1_xvalues = gen_1_xvalues(sortIdx);
        gen_1_fvalues = gen_1_fvalues/sum(gen_1_fvalues);
        C = cumsum(gen_1_fvalues);
        index = find(reproduction_probability <= C,1,"first");
        steps = round(pop_size * gen_1_fvalues);
        
        for i = 1:index
            for j = 1:steps(i)
                gen_2_xvalues = [gen_2_xvalues, gen_1_xvalues(i)];
                gen_2_fvalues = [gen_2_fvalues, fitness(int2bit(gen_1_xvalues(i),N,true)',loan,interest,loss,D,K)];
            end
        end
    
        %Mating Population Selection
        f = gen_2_fvalues/sum(gen_2_fvalues);
        C_mate = cumsum(f);
        for i = 1:6
            r = rand();
            site = find(r <= C_mate,1,"first");
            mating_pop = [mating_pop, gen_2_xvalues(site)];
        end
    
        %Selecting Parents for Mutation and Crossover
        while length(gen_2_xvalues)<pop_size
            bit1 = randi([1,length(mating_pop)]);
            bit2 = randi([1,length(mating_pop)]);
            while bit1==bit2
                bit2 = randi([1,length(mating_pop)]);
            end
            flag = 0;
            if rand()<=crossover_probability
                point = randi([2,N-1]);
                arr1 = int2bit(mating_pop(bit1),N,true);
                arr2 = int2bit(mating_pop(bit2),N,true);
                child_1 = [arr1(1:point)',arr2(point+1:N)'];
                child_1 = reshape(child_1,[1,N]);
                child_2 = [arr1(point+1:N)',arr2(1:point)'];
                child_2 = reshape(child_2,[1,N]);
                
                if rand()<=mutation_probability
                    point = randi([1,N]);
                    if child_1(point) == 0
                        child_1(point) = 1;
                    else
                        child_1(point) = 0;
                    end
                end
    
                if rand()<=mutation_probability
                    point = randi([1,N]);
                    if child_2(point) == 0
                        child_2(point) = 1;
                    else
                        child_2(point) = 0;
                    end
                end
    
                if feasible(child_1,loan,D,K) == 0
                    x_tmp = round(rand*(x_max-x_min)+x_min);
                    bin = int2bit(x_tmp,N,true);
                    while feasible(bin,loan,D,K) == 0
	                    x_tmp = round(rand*(x_max-x_min)+x_min);
                        bin = int2bit(x_tmp,N,true);
                    end
                    child_1 = bin';
                end
    
                if feasible(child_2,loan,D,K) == 0
                    x_tmp = round(rand*(x_max-x_min)+x_min);
                    bin = int2bit(x_tmp,N,true);
                    while feasible(bin,loan,D,K) == 0
	                    x_tmp = round(rand*(x_max-x_min)+x_min);
                        bin = int2bit(x_tmp,N,true);
                    end
                    child_2 = bin';
                end
    
                flag = 1;
            end
            
            if flag==1
                gen_2_xvalues = [gen_2_xvalues, bit2int(child_1',N,true), bit2int(child_2',N,true)];
                gen_2_fvalues = [gen_2_fvalues, fitness(child_1,loan,interest,loss, D,K),fitness(child_2,loan,interest,loss, D,K)];
            else
                gen_2_xvalues = [gen_2_xvalues, mating_pop(bit1), mating_pop(bit2)];
                gen_2_fvalues = [gen_2_fvalues, fitness(int2bit(mating_pop(bit1),N,true)',loan,interest,loss, D,K),fitness(int2bit(mating_pop(bit2),N,true)',loan,interest,loss, D,K)];
            end
        end
    
        gen_2_xvalues = gen_2_xvalues(1:pop_size);
        gen_2_fvalues = gen_2_fvalues(1:pop_size);
    
        %Getting maximum value for Future Generation
        for j=1:pop_size
		    if gen_2_fvalues(j) >= max_f
			    max_f = gen_2_fvalues(j);
			    max_x = gen_2_xvalues(j);
            end
        end
     
	    %Transform gen2 into gen1
        gen_1_xvalues = gen_2_xvalues;
        gen_1_fvalues = gen_2_fvalues;
            
    end

    fits(m) = max_f;
    T(m) = toc;
end
Chromosome = int2bit(max_x,10,true)'
Capital_Used = sum(int2bit(max_x,10,true)'.*loan)
Profit = max_f
%Plotting

%Ploting results generation wise
figure(1);
plot(1:60,generations_f, 'bo');
xlabel('Iteration Number');
ylabel('Fitness');
title('Result');


