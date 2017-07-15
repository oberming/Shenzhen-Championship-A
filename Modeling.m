function [InitialDataAmong, PauseTotal, InitialDelay, PauseCount] = Modeling(E2ERTT, PlayAvgSpeed, InitialSpeedPeak, CodeSpeed, RndCS, RndPAS, TotalAvgSpeed)
    global DataSize
    DataSize                                            = max(size(CodeSpeed));
    InitialPreDelay                                     = InitialPrepare(E2ERTT, TotalAvgSpeed, InitialSpeedPeak);
    [InitialDataAmong ,InitialDelay, DownloadTempPool]  = ModelI(E2ERTT, InitialSpeedPeak, CodeSpeed, TotalAvgSpeed);
    InitialDelay                                        = InitialDelay + InitialPreDelay;
    [PauseTotal, PauseCount]                            = ModelP(DownloadTempPool, PlayAvgSpeed, CodeSpeed, E2ERTT, RndCS, RndPAS);
end

function InitialPreDelay = InitialPrepare(E2ERTT, TotalAvgSpeed, InitialSpeedPeak)
    InitialPreDelay = 2 .* E2ERTT;
    adPack          = 5050000;
    InitialPreDelay = InitialPreDelay + adPack ./ (0.5 * unifrnd(InitialSpeedPeak - 500,InitialSpeedPeak + 500)) .* (TotalAvgSpeed >= 380);
    %
end

function [InitialDataAmong, InitialDelay, DownloadTempPool] = ModelI(E2ERTT, InitialSpeedPeak, CodeSpeed, TotalAvgSpeed)
    global DataSize    
    InitialDelay        = zeros(DataSize, 1);
    StartSymbol         = false(DataSize, 1);
    DownloadTempPool    = zeros(DataSize, 1);
    MaxCwnd             = fix(InitialSpeedPeak .* E2ERTT);
    CurrentCwnd         = 10720;                                            %cwnd1 = 21440
    while sum(StartSymbol) < DataSize
        InitialDelay        = InitialDelay + (~StartSymbol) .* E2ERTT;
        CurrentCwnd         = 2 * CurrentCwnd .* (CurrentCwnd < 0.5 * MaxCwnd) + ...
                              0.75 * MaxCwnd .* (CurrentCwnd >= 0.5 * MaxCwnd);        %本来为0.5maxcwnd，上面也是
        CurrentSpeed        = (~StartSymbol) .* CurrentCwnd;
        DownloadTempPool    = DownloadTempPool + CurrentSpeed;
        StartSymbol         = logical((DownloadTempPool > CodeSpeed .* 4192)  + ...
                                      (TotalAvgSpeed < 380) .* (DownloadTempPool > 200 * CodeSpeed));
    end
    InitialDataAmong = DownloadTempPool / 8;
end

function [PauseTotal, PauseCount] = ModelP(DownloadTempPool, PlayAvgSpeed, CodeSpeed, E2ERTT, RndCS, RndPAS)
    global DataSize
    time                = 0;
    PauseTotal          = zeros(DataSize, 1);
    StartSymbol         = true (DataSize, 1);
    PauseCount          = zeros(DataSize, 1);
    if PlayAvgSpeed < 5200
        while time < 30000
            time                = time + 1;
            PlayTime            = time - PauseTotal;                                                                                %播放时间
            DownloadTempPool    = DownloadTempPool - 1.2 .* StartSymbol .* CodeSpeed .* RndCS(PlayTime) + ...                              %减去播放量
                             0.7 .* StartSymbol .* PlayAvgSpeed .* RndPAS(time) .* E2ERTT .* (mod(time, E2ERTT) == 0) .* (DownloadTempPool < 2700 .* CodeSpeed) + ...
                           +  1.75 .* (~StartSymbol)  .* PlayAvgSpeed .* RndPAS(time) .* E2ERTT .* (mod(time, E2ERTT) == 0);      %播放时存货大于0.5秒就不下载，小于0.5秒就按0.75倍下载，停止时按1.3倍高速下载，每个rtt结算一次
            PauseCount          = PauseCount + (DownloadTempPool < CodeSpeed .* RndCS(PlayTime)) .* StartSymbol;                    %卡段时间
            StartSymbol         = StartSymbol - (DownloadTempPool < CodeSpeed .* RndCS(PlayTime)) .* StartSymbol + ...              %刚刚开始卡顿的数目
                              (~StartSymbol) .* (DownloadTempPool > 2400 * CodeSpeed);                                          %卡顿还没有开始的数目
            PauseTotal          = PauseTotal + (~StartSymbol);
        end
    else
        while time < 30000
            time                = time + 1;
            PlayTime            = time - PauseTotal;                                                                                %播放时间
            DownloadTempPool    = DownloadTempPool - 1.2 .* StartSymbol .* CodeSpeed .* RndCS(PlayTime) + ...                              %减去播放量
                             0.65 .* StartSymbol .*  PlayAvgSpeed .* RndPAS(time) .* E2ERTT .* (mod(time, E2ERTT) == 0) .* (DownloadTempPool < 1400 .* CodeSpeed) + ...
                           +  1.85 .* (~StartSymbol) .*  PlayAvgSpeed .* RndPAS(time) .* E2ERTT .* (mod(time, E2ERTT) == 0);      %播放时存货大于0.5秒就不下载，小于0.5秒就按0.75倍下载，停止时按1.3倍高速下载，每个rtt结算一次
            PauseCount          = PauseCount + (DownloadTempPool < CodeSpeed .* RndCS(PlayTime)) .* StartSymbol;                    %卡段时间
            StartSymbol         = StartSymbol - (DownloadTempPool < CodeSpeed .* RndCS(PlayTime)) .* StartSymbol + ...              %刚刚开始卡顿的数目
                              (~StartSymbol) .* (DownloadTempPool > 1400 * CodeSpeed);                                          %卡顿还没有开始的数目
            PauseTotal          = PauseTotal + (~StartSymbol);
        end
    end
end