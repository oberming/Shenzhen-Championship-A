function Rnd = MaxwellRnd(xmean, nn)
    Rnd = zeros(1,nn);
    for ii = 1:nn
        tmpx = 0;
        tmpy = 1;
        while tmpy > 32/pi/pi*exp(-4*tmpx^2/pi/xmean^2)*tmpx^2
            tmpy = rand();
            tmpx = 5*xmean*rand();
        end
    Rnd(ii) = tmpx;
    end
end