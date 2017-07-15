function [CodeSpeed1] = randming(CodeSpeed)
global DataSize
CodeSpeed1   = zeros(max(size(CodeSpeed), 1));
time         = 0;
    while time < 30000
        time         = time + 1;
        CodeSpeed1(time,1) = normrnd(CodeSpeed,0.35)
    end
end