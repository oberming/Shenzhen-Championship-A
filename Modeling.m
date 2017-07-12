function [InitialDataAmong ,PauseTotal, InitialDelay, PauseCount] = Modeling(E2ERTT, PlayAvgSpeed, InitialSpeedPeak, CodeSpeed)
% The discribetion is in describe.m
% 引入 Download Temp Pool
    global DataSize
    DataSize        = max(size(CodeSpeed));
    [InitialDataAmong ,InitialDelay, DownloadTempPool]  = ModelI(E2ERTT, InitialSpeedPeak, CodeSpeed, PlayAvgSpeed);
    [PauseTotal, PauseCount]                            = ModelP(DownloadTempPool, PlayAvgSpeed, CodeSpeed);
end

function [InitialDataAmong, InitialDelay, DownloadTempPool] = ModelI(E2ERTT, InitialSpeedPeak, CodeSpeed, PlayAvgSpeed)
    global DataSize    
    InitialDelay        = (5.5 .* E2ERTT .* ones(DataSize, 1));
    StartSymbol         = false(DataSize, 1);
    DownloadTempPool    = (zeros(DataSize, 1));
    MaxCwnd             = fix(InitialSpeedPeak .* E2ERTT);
    CurrentCwnd         = 1072;                                            %cwnd1 = 2144
    while sum(StartSymbol) < DataSize
        InitialDelay        = InitialDelay + (~StartSymbol) .* E2ERTT;
        CurrentCwnd         = 2 * CurrentCwnd .* (CurrentCwnd < 0.5 * MaxCwnd) + ...
                              0.75 * MaxCwnd .* (CurrentCwnd >= 0.5 * MaxCwnd);
        CurrentSpeed        = (~StartSymbol) .* CurrentCwnd;
        DownloadTempPool    = DownloadTempPool + CurrentSpeed;
        StartSymbol         = logical((DownloadTempPool > CodeSpeed .* 4192)  + ...
                                      (InitialSpeedPeak < 7000) .* (PlayAvgSpeed < 362) .* (DownloadTempPool > 200 * CodeSpeed));
    end
    InitialDataAmong = DownloadTempPool / 8;
end

function [PauseTotal, PauseCount] = ModelP(DownloadTempPool, PlayAvgSpeed, CodeSpeed)
    global DataSize    
    time                = 0;
    PauseTotal          = zeros(DataSize, 1);
    StartSymbol         = true (DataSize, 1);
    PauseCount          = zeros(DataSize, 1);
    Rnd                 = CSShake();
    while time < 30000
        time                = time + 1;
        PlayTime            = time - PauseTotal;                                                                                 %播放时间
        
        DownloadTempPool    = DownloadTempPool - StartSymbol .* CodeSpeed .* Rnd(PlayTime) + PlayAvgSpeed;
        PauseCount          = PauseCount + (DownloadTempPool < CodeSpeed .* Rnd(PlayTime)) .* StartSymbol;
        StartSymbol         = StartSymbol - (DownloadTempPool < CodeSpeed .* Rnd(PlayTime)) .* StartSymbol + ...                 %刚刚开始卡顿的数目
                            (~StartSymbol) .* (DownloadTempPool > 2700 * CodeSpeed);                                             %卡顿还没有开始的数目
        PauseTotal          = PauseTotal + (~StartSymbol);
    end
end

function Rnd = CSShake()
    tmp = MaxwellRnd(300);
    Rnd = zeros(30000,1);
    for ii = 1:30000
        Rnd(ii) = tmp(fix(1 + (ii-1)/100));
    end
end