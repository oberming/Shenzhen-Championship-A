function [InitialDataAmong ,PauseTotal, InitialDelay, PauseCount] = Modeling(E2ERTT, PlayAvgSpeed, InitialSpeedPeak, CodeSpeed)
% The discribetion is in describe.m
% 引入 Download Temp Pool
    global DataSize
    DataSize        = max(size(CodeSpeed));
    [InitialDataAmong ,InitialDelay, DownloadTempPool]  = ModelI(E2ERTT, InitialSpeedPeak, CodeSpeed, PlayAvgSpeed);
    [PauseTotal, PauseCount]                            = ModelP(DownloadTempPool, PlayAvgSpeed, CodeSpeed, E2ERTT);
end

function [InitialDataAmong, InitialDelay, DownloadTempPool] = ModelI(E2ERTT, InitialSpeedPeak, CodeSpeed, PlayAvgSpeed)
    global DataSize    
    InitialDelay        = (7 * E2ERTT .* ones(DataSize, 1));
    StartSymbol         = false(DataSize, 1);
    DownloadTempPool    = (zeros(DataSize, 1));
    MSS                 = 2144;
    MaxCwnd             = InitialSpeedPeak .* E2ERTT ./ MSS;
    CurrentCwnd         = 5;                                            %cwnd1 = 10
    TransRotate         = 0;
    while sum(StartSymbol) < DataSize
        TransRotate         = TransRotate + 1;
        InitialDelay        = InitialDelay + (~StartSymbol) .* E2ERTT;
        CurrentCwnd         = 2 * CurrentCwnd .* (CurrentCwnd < 0.5 * MaxCwnd) + ...
                              0.75 * MaxCwnd .* (CurrentCwnd >= 0.5 * MaxCwnd);
        CurrentSpeed        = (~StartSymbol) .* CurrentCwnd .* MSS;
        DownloadTempPool    = DownloadTempPool + CurrentSpeed;
        StartSymbol         = logical((DownloadTempPool > CodeSpeed .* 4096)  + ...
                                      (InitialSpeedPeak < 7000) .* (PlayAvgSpeed < 362) .* (DownloadTempPool > 200 * CodeSpeed));
    end
    InitialDataAmong = DownloadTempPool / 8;
end

function [PauseTotal, PauseCount] = ModelP(DownloadTempPool, PlayAvgSpeed, CodeSpeed, E2ERTT)
    global DataSize    
    k                   = 2.1282;                             % 协议速度的倍数
    time                = 0;
    PauseTotal          = zeros(DataSize,1);
    StartSymbol         = true (DataSize,1);
    PauseCount          = zeros(DataSize,1);
    E2ECount            = zeros(DataSize,1);                            % 传输轮次计数
    DataPerE2E          = PlayAvgSpeed .* E2ERTT;                       % Data Downloaded Per E2ERTT
    PlayPool            = DownloadTempPool ./ k;
    DownloadTempPool    = zeros(DataSize,1);
    VideoPackageTime    = 900;                                           %单包视频的播放时间
    VideoPackageDataSiz = VideoPackageTime .* CodeSpeed .* k;           %单包视频的下载数据量
    while time < 30000
        time                = time + 1;
        CountJudge          = (fix(time ./ E2ERTT) > E2ECount);
        MovedDataSize       = fix(DownloadTempPool ./ VideoPackageDataSiz) .* VideoPackageDataSiz;
        E2ECount            = CountJudge + E2ECount;
        DownloadTempPool    = DownloadTempPool + CountJudge .* DataPerE2E - MovedDataSize;
        PlayPool            = PlayPool - StartSymbol .* CodeSpeed + MovedDataSize ./ k;
        PauseCount          = PauseCount + (PlayPool < CodeSpeed) .* StartSymbol;
        StartSymbol         = StartSymbol - (PlayPool < CodeSpeed) .* StartSymbol + ...          %刚刚开始卡顿的数目
                              (~StartSymbol) .* (PlayPool > 2700  .*  CodeSpeed ./ k);
        PauseTotal          = PauseTotal + (~StartSymbol);
    end
end
