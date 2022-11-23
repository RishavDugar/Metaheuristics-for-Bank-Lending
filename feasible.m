function [y] = feasible(xbin,loan,D,K)

    s = sum(xbin.*loan);
    if s<=(1-K)*D 
       y = 1;
    else
       y = 0;
    end

end
