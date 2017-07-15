cc;
load exdata                                               %载入数据
OOInitialDataAmong  = zeros(max(size(CodeSpeed)), 1);
OOInitialDelay      = zeros(max(size(CodeSpeed)), 1);
OOPauseTotal        = zeros(max(size(CodeSpeed)), 1);
OOPauseCount        = zeros(max(size(CodeSpeed)), 1);   %创建空矩阵用以存放数据
RndCS               = CSShake();
RndPAS              = PASShake();                       %得到随机数矩阵
tic
    for ii = 1:max(size(CodeSpeed))
        [OOInitialDataAmong(ii), OOPauseTotal(ii), OOInitialDelay(ii), OOPauseCount(ii)] = ...
        Modeling(E2ERTT(ii), PlayAvgSpeed(ii), InitialSpeedPeak(ii), CodeSpeed(ii), RndCS, RndPAS, TotalAvgSpeed(ii));
    end
toc
clear ii RndCS RndPAS;

FigurePlot(PlayAvgSpeed, PauseTotal, OOPauseTotal, InitialSpeedPeak, InitialDelay, OOInitialDelay, InitialDataAmong, OOInitialDataAmong, CodeSpeed, PauseCount, OOPauseCount)
%作图
[ErrPC, ErrID,ErrPT,ErrIDA] = ErrorAnalyse(PauseCount ,InitialDelay, PauseTotal, InitialDataAmong, OOInitialDelay, OOPauseTotal, OOInitialDataAmong, OOPauseCount)
%误差分析