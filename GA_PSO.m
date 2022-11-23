%************************************************%
%RISHAV DUGAR 19IM3FP30
%************************************************%
clear all 
close all
clc

%GA Params
pop_size = 60;
C2 = 1;
W = 5;
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
max_vel = 100;
T = [];
fits = [];
for m = 1:50

    tic

    %Variables & Lists to be used during the code
    gen_1 = [];
    generations = [];
    
    %Size of the string in bit
    x_size = length(dec2bin(x_max));
    
    %Initial Population
    count = 1;
    while count < pop_size+1
	    x_tmp = round(rand*(x_max-x_min)+x_min);
        bin = int2bit(x_tmp,N,true)';
        if feasible(bin,loan,D,K) == 1
	        gen_1(count,1) = x_tmp;
	        gen_1(count,2) = fitness(bin,loan,interest,loss,D,K);
            gen_1(count,3) = max_vel*(rand()-0.5);
            count = count + 1;
        end
    
    end
        
    %Getting maximum value for initial population
    max_f = 0;
    for j=1:pop_size
	    if gen_1(j,2) >= max_f
		    max_f = gen_1(j,2);
		    max_x = gen_1(j,1);
        end
    end
    
    %Starting PSO loop
    for q=1:number_of_generations
    
        generations(q,:) = [max_x,max_f];
    
        %Reseting list for 2nd generation
	    gen_2 = [];
        mating_pop = [];
    
        %Selecting best individuals based on Reproduction Criteria
        gen_1 = sortrows(gen_1,2,"descend");
        gen_1(:,2) = gen_1(:,2)./sum(gen_1(:,2));
        C = cumsum(gen_1(:,2));
        index = find(reproduction_probability <= C,1,"first");
        for k = 1:length(gen_1)
            num = round(pop_size * gen_1(k,2));
            if num == 0
                steps(k) = 1;
            else
                steps(k) = num;
            end
        end
        
        for i = 1:index
            for j = 1:steps(i)
                gen_2 = [gen_2; [gen_1(i,1), fitness(int2bit(gen_1(i,1),N,true)',loan,interest,loss,D,K), gen_1(i,3)]];
            end
        end
    
        %Mating Population Selection
        f = gen_2(:,2)/sum(gen_2(:,2));
        C_mate = cumsum(f);
        for i = 1:6
            r = rand();
            site = find(r <= C_mate,1,"first");
            mating_pop = [mating_pop; [gen_2(site,:),site]];
        end
    
        %Selecting Parent for Mutation and Crossover
        while length(gen_2)<pop_size
            bit1 = randi([1,length(mating_pop)]);
            c1 = round(mating_pop(bit1,1) + mating_pop(bit1,3));
            if c1<0 || c1 >x_max
                c1 = round(rand*(x_max-x_min)+x_min);
            end
            child = int2bit(c1,N,true)';
    
            if feasible(child,loan,D,K) == 0
                x_tmp = round(rand*(x_max-x_min)+x_min);
                bin = int2bit(x_tmp,N,true);
                while feasible(bin,loan,D,K) == 0
                    x_tmp = round(rand*(x_max-x_min)+x_min);
                    bin = int2bit(x_tmp,N,true);
                end
                child = bin';
            end
            
            gen_2 = [gen_2; [bit2int(child',N,true), fitness(child,loan,interest,loss,D,K),  max_vel*(rand()-0.5)]];
            vel = mating_pop(bit1,3) * W + C2 * rand() * (max_x - mating_pop(bit1,1));
            mating_pop(bit1,3) = vel;
            gen_2(mating_pop(bit1,4),3) = vel;
            
        end
    
        %Getting maximum value for Future Generation
        for j=1:pop_size
		    if gen_2(j,2) >= max_f
			    max_f = gen_2(j,2);
			    max_x = gen_2(j,1);
            end
        end
     
	    %Transform gen2 into gen1
        gen_1 = gen_2;
            
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
plot(1:50,fits, 'bo');
xlabel('Iteration Number');
ylabel('Fitness');
title('Result');


