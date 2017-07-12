function [InitialDataAmong ,PauseTotal, InitialDelay, PauseCount] = Modeling(E2ERTT, PlayAvgSpeed, InitialSpeedPeak, CodeSpeed, RndCS, RndPAS)
    global DataSize
    DataSize                                            = max(size(CodeSpeed));
    [InitialDataAmong ,InitialDelay, DownloadTempPool]  = ModelI(E2ERTT, InitialSpeedPeak, CodeSpeed, PlayAvgSpeed);
    [PauseTotal, PauseCount]                            = ModelP(DownloadTempPool, PlayAvgSpeed, CodeSpeed, E2ERTT, RndCS, RndPAS);
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

function [PauseTotal, PauseCount] = ModelP(DownloadTempPool, PlayAvgSpeed, CodeSpeed, E2ERTT, RndCS, RndPAS)
    global DataSize
    time                = 0;
    PauseTotal          = zeros(DataSize, 1);
    StartSymbol         = true (DataSize, 1);
    PauseCount          = zeros(DataSize, 1);
    while time < 30000
        time                = time + 1;
        PlayTime            = time - PauseTotal;                                                                                %播放时间
        DownloadTempPool    = DownloadTempPool - StartSymbol .* CodeSpeed .* RndCS(PlayTime) + ...                              %减去播放量
                              PlayAvgSpeed .* RndPAS(time) .* E2ERTT .* (mod(time, E2ERTT) == 0);                               %每传输轮次增加下载量
        PauseCount          = PauseCount + (DownloadTempPool < CodeSpeed .* RndCS(PlayTime)) .* StartSymbol;                    %卡段时间
        StartSymbol         = StartSymbol - (DownloadTempPool < CodeSpeed .* RndCS(PlayTime)) .* StartSymbol + ...              %刚刚开始卡顿的数目
                              (~StartSymbol) .* (DownloadTempPool > 2700 * CodeSpeed);                                          %卡顿还没有开始的数目
        PauseTotal          = PauseTotal + (~StartSymbol);
    end
end