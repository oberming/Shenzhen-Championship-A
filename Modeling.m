function [InitialDataAmong ,PauseTotal, InitialDelay] = Modeling(E2ERTT, PlayAvgSpeed, InitialSpeedPeak, CodeSpeed)
% The discribetion is in describe.m
%矩阵化编程
    [InitialDataAmong ,InitialDelay, TempPool] = ModelB1I(E2ERTT, InitialSpeedPeak, CodeSpeed, PlayAvgSpeed);
    PauseTotal = ModelB1P(TempPool, PlayAvgSpeed, CodeSpeed);
end
