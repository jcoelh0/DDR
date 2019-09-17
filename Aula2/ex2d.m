
%state 3
ps3 = ps0*(((1*5*10)/(195*40*20)));

%state 4
ps4 = ps0*(((1*5*10*10)/(195*40*20*5)));

%media bit error rate
average = (ps3*10^(-3) + ps4*10^(-2))/(ps3+ps4)