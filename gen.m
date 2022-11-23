function [bin1,bin2] = gen(bin,loan,D,x_max,x_min,N,K)

num = length(bin);
bit = randi([1,num]);
neighbors = [];
if bit == 1
    bin1 = [bin(num),bin(2:num-1),bin(1)];
    bin2 = [bin(2),bin(1),bin(3:num)];
    while feasible(bin1,loan,D,K) == 0
        x_tmp = round(rand*(x_max-x_min)+x_min);
        bin1 = int2bit(x_tmp,N,true)';
    end
    while feasible(bin2,loan,D,K) == 0
        x_tmp = round(rand*(x_max-x_min)+x_min);
        bin2 = int2bit(x_tmp,N,true)';
    end
elseif bit == num
    bin1 = [bin(num),bin(2:num-1),bin(1)];
    bin2 = [bin(1:num-2),bin(num),bin(num-1)];
    while feasible(bin1,loan,D,K) == 0
        x_tmp = round(rand*(x_max-x_min)+x_min);
        bin1 = int2bit(x_tmp,N,true)';
    end
    while feasible(bin2,loan,D,K) == 0
        x_tmp = round(rand*(x_max-x_min)+x_min);
        bin2 = int2bit(x_tmp,N,true)';
    end
else
    bin1 = [bin(1:bit-1),bin(bit+1),bin(bit),bin(bit+2:num)];
    bin2 = [bin(1:bit-2),bin(bit),bin(bit-1),bin(bit+1:num)];
    while feasible(bin1,loan,D,K) == 0
        x_tmp = round(rand*(x_max-x_min)+x_min);
        bin1 = int2bit(x_tmp,N,true)';
    end
    while feasible(bin2,loan,D,K) == 0
        x_tmp = round(rand*(x_max-x_min)+x_min);
        bin2 = int2bit(x_tmp,N,true)';
    end
end

end