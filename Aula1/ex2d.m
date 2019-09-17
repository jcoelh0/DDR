
timegap = 10*10^(-6);
fcs = 4;
header = 36;

p = logspace(-8,-3,100);
n1= 100*8;
n2= 200*8;
n3= 1000*8;

f1 = (1-p).^n1
f2 = (1-p).^n2
f3 = (1-p).^n3

semilogx(p,f1,p,f2,p,f3)


legend('100 Bytes','200 Bytes','1000 Bytes')
xlabel('Bit Error Rate')
grid on
title('Probability of packet reception without errors (%)')