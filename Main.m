cc;
load data
OOInitialDataAmong  = zeros(1, max(size(CodeSpeed)));
OOInitialDelay      = zeros(1, max(size(CodeSpeed)));
OOPauseTotal        = zeros(1, max(size(CodeSpeed)));
OOPauseCount        = zeros(1, max(size(CodeSpeed)));
tic
    for i = 1:max(size(CodeSpeed))
        [OOInitialDataAmong(i), OOPauseTotal(i), OOInitialDelay(i), OOPauseCount(i)] = ...
        Modeling(E2ERTT(i), PlayAvgSpeed(i), InitialSpeedPeak(i), CodeSpeed(i));
    end
toc
clear i;
OOInitialDelay      = OOInitialDelay';
OOPauseTotal        = OOPauseTotal';
OOInitialDataAmong  = OOInitialDataAmong';
OOPauseCount        = OOPauseCount';


FigurePlot(PlayAvgSpeed, PauseTotal, OOPauseTotal, InitialSpeedPeak, InitialDelay, OOInitialDelay, InitialDataAmong, OOInitialDataAmong, CodeSpeed, PauseCount, OOPauseCount)
%作图
[ErrPC, ErrID,ErrPT,ErrIDA] = ...
ErrorAnalyse(PauseCount ,InitialDelay, PauseTotal, InitialDataAmong, OOInitialDelay, OOPauseTotal, OOInitialDataAmong, OOPauseCount)
%误差分析


