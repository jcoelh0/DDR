%? a false negative is when a station decides wrongly that the link is in normal state (i.e., at
%least one of the n consecutive control frames is received without errors and the link is in
%the interference state)

n2= 64*8
prob= 10^-7 %normal
pNormal=1-(1-prob)^n2


prob2= 10^-3 %normal
pInterference=1-(1-prob2)^n2 %prob of receiving with 1 or more errors

p=0.99


pfalseNegative2 = (1-pInterference^2)*(1-p)/((1-pNormal^2)*p+(1-pInterference^2)*(1-p))
pfalseNegative3 = (1-pInterference^3)*(1-p)/((1-pNormal^3)*p+(1-pInterference^3)*(1-p))

%3mal
%1- :
%2mal, 1mal ou 0mal
pfalseNegative4 = (1-pInterference^4)*(1-p)/((1-pNormal^4)*p+(1-pInterference^4)*(1-p))
pfalseNegative5 = (1-pInterference^5)*(1-p)/((1-pNormal^5)*p+(1-pInterference^5)*(1-p))