function Rnd = PASShake()
    tmp = twoGaussRnd(600);
    Rnd = zeros(30000,1);
    for ii = 1:30000
        Rnd(ii) = tmp(fix(1 + (ii-1)/50));
    end
end