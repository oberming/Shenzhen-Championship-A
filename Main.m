cc;
load exdata
OOInitialDataAmong  = zeros(1, max(size(CodeSpeed)));
OOInitialDelay      = zeros(1, max(size(CodeSpeed)));
OOPauseTotal        = zeros(1, max(size(CodeSpeed)));
OOPauseCount        = zeros(1, max(size(CodeSpeed)));
RndCS               = CSShake();
RndPAS              = MaxwellRnd(30000);
tic
    for ii = 1:max(size(CodeSpeed))
        [OOInitialDataAmong(ii), OOPauseTotal(ii), OOInitialDelay(ii), OOPauseCount(ii)] = ...
        Modeling(E2ERTT(ii), PlayAvgSpeed(ii), InitialSpeedPeak(ii), CodeSpeed(ii), RndCS, RndPAS, TotalAvgSpeed(ii));
    end
toc
clear ii;
clear RndCS;
clear RndPAS;
OOInitialDelay      = OOInitialDelay';
OOPauseTotal        = OOPauseTotal';
OOInitialDataAmong  = OOInitialDataAmong';
OOPauseCount        = OOPauseCount';


FigurePlot(PlayAvgSpeed, PauseTotal, OOPauseTotal, InitialSpeedPeak, InitialDelay, OOInitialDelay, InitialDataAmong, OOInitialDataAmong, CodeSpeed, PauseCount, OOPauseCount)
%作图
[ErrPC, ErrID,ErrPT,ErrIDA] = ErrorAnalyse(PauseCount ,InitialDelay, PauseTotal, InitialDataAmong, OOInitialDelay, OOPauseTotal, OOInitialDataAmong, OOPauseCount)
%误差分析