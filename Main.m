cc;
<<<<<<< HEAD
load exdata                                               %载入数据
=======
load exdata
>>>>>>> acc8ced90a659ca76d44f0702414298c087214bb
OOInitialDataAmong  = zeros(max(size(CodeSpeed)), 1);
OOInitialDelay      = zeros(max(size(CodeSpeed)), 1);
OOPauseTotal        = zeros(max(size(CodeSpeed)), 1);
OOPauseCount        = zeros(max(size(CodeSpeed)), 1);   %创建空矩阵用以存放数据
RndCS               = CSShake();
<<<<<<< HEAD
RndPAS              = PASShake();                       %得到随机数矩阵
=======
>>>>>>> acc8ced90a659ca76d44f0702414298c087214bb
tic
    for ii = 1:max(size(CodeSpeed))
        [OOInitialDataAmong(ii), OOPauseTotal(ii), OOInitialDelay(ii), OOPauseCount(ii)] = ...
        Modeling(E2ERTT(ii), PlayAvgSpeed(ii), InitialSpeedPeak(ii), CodeSpeed(ii), RndCS, TotalAvgSpeed(ii));
        ii
    end
toc
clear ii RndCS RndPAS;

FigurePlot(PlayAvgSpeed, PauseTotal, OOPauseTotal, InitialSpeedPeak, InitialDelay, OOInitialDelay, InitialDataAmong, OOInitialDataAmong, CodeSpeed, PauseCount, OOPauseCount)
%作图
[ErrPC, ErrID,ErrPT,ErrIDA] = ErrorAnalyse(PauseCount ,InitialDelay, PauseTotal, InitialDataAmong, OOInitialDelay, OOPauseTotal, OOInitialDataAmong, OOPauseCount)
%误差分析