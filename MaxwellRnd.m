function Rnd = MaxwellRnd(nn)
    Rnd = zeros(1,nn);
    for ii = 1:nn
        tmpx = 0;
        tmpy = 1;
        while tmpy > 32./pi.^2.*exp(-4.*tmpx.^2./pi)*tmpx^2
            tmpy = rand();
            tmpx = 15*rand();
        end
    Rnd(ii) = tmpx;
    end
end