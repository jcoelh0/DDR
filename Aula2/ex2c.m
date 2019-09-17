% 10^-3 or higher -> estado 3 e 4
% probabilidade do estado estar em interferencia ps3 + ps4

ps0 = 1/(1 + (1/195) + ((1*5)/(195*40)) + ((1*5*10)/(195*40*20)) + ((1*5*10*10)/(195*40*20*5)));

ps3 = ps0*(((1*5*10)/(195*40*20)));
ps4 = ps0*(((1*5*10*10)/(195*40*20*5)));

p_interference = ps3 + ps4