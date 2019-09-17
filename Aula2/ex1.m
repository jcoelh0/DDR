
n= 64*8
prob= 10^-7 %normal
pNormal=1-(1-prob)^n


prob2= 10^-3 %normal
pInterference=1-(1-prob2)^n

p=0.99

pNwError = (pNormal * p)/ ((pNormal*p)+(pInterference)*(1-p))
pIwError = 1-pNwError