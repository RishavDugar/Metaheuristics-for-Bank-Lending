function [f] = fitness(xbin,loan,interest,loss,D,K)

%Params
customer_transaction_cost = 0.01;
avg_deposit_rate = 0.009;

l = (1-K)*D -loan;
f = sum(xbin.*loan.*interest, "all");
f = f + sum(xbin.*l, "all")*customer_transaction_cost;
f = f - avg_deposit_rate*D;
f = f - sum(xbin.*loss, "all");

end