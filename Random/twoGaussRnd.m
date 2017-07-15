function Rnd = twoGaussRnd(nn)
    Rnd = zeros(nn,1);
    for ii = 1:nn
        tmpx = 0;
        tmpy = 1;
        while tmpy > gaussmf(tmpx, [0.2, 0.6]) + 0.1 * gaussmf(tmpx, [0.2, 5])
            tmpy = rand();
            tmpx = 10*rand();
        end
    Rnd(ii) = tmpx;
    end
end