cc
t = 0.35;
 x = 50:100:1150;
 x = (x)/600;
 y = [0,2,7,15,14,17,8,11,3,4,0,1];
plot(x,y);
hold on
plot(-1:0.01:1, 17 * gaussmf(-1:0.01:1,[t,0]));
hold off

for t = 1:30000
    a(t) = abs(mean(normrnd(0,0.35,t,1)));
end
plot(1:30000,a);

tmpx = 0:0.01:5;
xmean = 1;
tmpy = 32./pi.^2./xmean.^3.*exp(-4.*tmpx.^2./pi./xmean.^2).*tmpx.^2;