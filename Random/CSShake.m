function Rnd = CSShake()
    tmp = normrnd(1,0.33,300,1);
    Rnd = zeros(30000,1);
    for ii = 1:30000
        Rnd(ii) = tmp(fix(1 + (ii-1)/100));
    end
end