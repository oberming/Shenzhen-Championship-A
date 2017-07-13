function [InitialDataAmong ,PauseTotal, InitialDelay, PauseCount] = Modeling(E2ERTT, PlayAvgSpeed, InitialSpeedPeak, CodeSpeed)
% The discribetion is in describe.m
% 引入 Download Temp Pool
    global DataSize
    DataSize        = max(size(CodeSpeed));
    %global PreID
    [PreID]         = preid(E2ERTT, PlayAvgSpeed, InitialSpeedPeak, CodeSpeed);
    [InitialDataAmong ,InitialDelay, DownloadTempPool]  = ModelI(E2ERTT, InitialSpeedPeak, CodeSpeed, PlayAvgSpeed);
    InitialDelay = InitialDelay + PreID;
    [PauseTotal, PauseCount]                            = ModelP(DownloadTempPool, PlayAvgSpeed, CodeSpeed, E2ERTT);
    %CodeSpeed1          = randming(CodeSpeed);
end

function [InitialDataAmong, InitialDelay, DownloadTempPool] = ModelI(E2ERTT, InitialSpeedPeak, CodeSpeed, PlayAvgSpeed)
    global DataSize    
    InitialDelay        = (2.*E2ERTT + zeros(DataSize, 1));     %初始时延基本值为5.5个端到端时间
    StartSymbol         = false(DataSize, 1);                       %开始播放的判断
    DownloadTempPool    = (zeros(DataSize, 1));                     %引入下载池
    MaxCwnd             = fix(InitialSpeedPeak .* E2ERTT);          %fix为向0取整，最大窗口大小为一单位时间内的下载量
    CurrentCwnd         = 1072;                                            %cwnd1 = 2144
    while sum(StartSymbol) < DataSize
        InitialDelay        = + InitialDelay + (~StartSymbol) .* E2ERTT;%每次若没达到开始播放的条件，增加一个单位的时间。
        CurrentCwnd         = 2 * CurrentCwnd .* (CurrentCwnd < 0.5 * MaxCwnd) + ...
                              0.75 * MaxCwnd .* (CurrentCwnd >= 0.5 * MaxCwnd);%瞬时窗口大小的变化
        CurrentSpeed        = (~StartSymbol) .* CurrentCwnd;            %瞬时速度即为瞬时窗口的大小
        DownloadTempPool    = DownloadTempPool + CurrentSpeed;          %缓冲池
        StartSymbol         = logical((DownloadTempPool > CodeSpeed .* 4192)  + ...             %原来是4192
                                      (InitialSpeedPeak < 7000) .* (PlayAvgSpeed < 362) ... 
                                      .* (DownloadTempPool > 200 * CodeSpeed));%播放开始的判断条件，即下载池达到4秒或（初始峰速小于7000且播放速率小玉362且下载池大于200毫秒
    end
    InitialDataAmong = DownloadTempPool / 8;
end

function [PauseTotal, PauseCount] = ModelP(DownloadTempPool, PlayAvgSpeed, CodeSpeed, E2ERTT,CodeSpeed1)
    global DataSize    
    k = (3.46e-4 .* PlayAvgSpeed + 0.1);
    k = (k > 1.2) .* k + (k <= 1.2) .* 1.2;
    time                = 0;
    PauseTotal          = zeros(DataSize, 1);
    StartSymbol         = true (DataSize, 1);
    PauseCount          = zeros(DataSize, 1);
    DownloadTempPool    = DownloadTempPool ./ k;
    while time < 30000
        time                = time + 1;
        DownloadTempPool    = DownloadTempPool - StartSymbol .* CodeSpeed + PlayAvgSpeed  ./ k;
        PauseCount          = PauseCount + (DownloadTempPool < CodeSpeed) .* StartSymbol;% + (CodeSpeed1 > limitation) + (CodeSpeed1(time,1)>4000);
        StartSymbol         = StartSymbol - (DownloadTempPool < CodeSpeed) .* StartSymbol + ...                 %刚刚开始卡顿的数目
                            (~StartSymbol) .* (DownloadTempPool > 2700 * CodeSpeed ./ k);                       %卡顿还没有开始的数目
        PauseTotal          = PauseTotal + (~StartSymbol);
    end
end