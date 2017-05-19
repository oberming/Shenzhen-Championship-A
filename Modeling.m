function [InitialDataAmong ,PauseTotal, InitialDelay, PauseCount] = Modeling(E2ERTT, PlayAvgSpeed, InitialSpeedPeak, CodeSpeed)
% The discribetion is in describe.m
%矩阵化编程
    [InitialDataAmong ,InitialDelay, TempPool]  = ModelI(E2ERTT, InitialSpeedPeak, CodeSpeed, PlayAvgSpeed);
    [PauseTotal, PauseCount]                    = ModelP(TempPool, PlayAvgSpeed, CodeSpeed);
end
