%a false positive is when a station decides wrongly that the link is in interference 
%state (i.e.,it receives n consecutive control frames with error and the link is in 
%the normal state)

n2= 64*8
prob= 10^-7 %normal
pNormal=1-(1-prob)^n2


prob2= 10^-3 %normal
pInterference=1-(1-prob2)^n2

p=0.99
n=2

pfalsePositive = (pNormal^n * p)/ ((pNormal^n*p)+(pInterference^n)*(1-p))