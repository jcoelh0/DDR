% calculate the time untill it exits from states 3 and 4

t3 = (1/(20+10))*60
t4 = (1/5)*60

p32 = 20/30;
p34 = 10/30;
p43 = 1;

t=0

for i = 0:10
    t = t + p32*(p34^i) * (t4*i + t3*(i+1))
end