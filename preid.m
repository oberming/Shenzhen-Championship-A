function [PreID] = preid(E2ERTT, PlayAvgSpeed, InitialSpeedPeak, CodeSpeed)
    global DataSize  
    %t                   = zeros(DataSize,1); 
    PreID               = zeros(DataSize, 1);
    %StartSymbol         = false(DataSize, 1);                       %开始播放的判断
    %DownloadTempPool    = (zeros(DataSize, 1));                     %引入下载池
    %MaxCwnd             = fix(InitialSpeedPeak .* E2ERTT);          %fix为向0取整，最大窗口大小为一单位时间内的下载量
    %CurrentCwnd         = 1072;                                            %cwnd1 = 2144
    %while sum(StartSymbol) < DataSize
     PreID           = CodeSpeed.*2000/PlayAvgSpeed; % (~StartSymbol) .* E2ERTT;%每次若没达到开始播放的条件，增加一个单位的时间。
     %   CurrentCwnd         = 2 * CurrentCwnd .* (CurrentCwnd < 0.5 * MaxCwnd) + ...
      %                        0.75 * MaxCwnd .* (CurrentCwnd >= 0.5 * MaxCwnd);%瞬时窗口大小的变化
       % CurrentSpeed        = (~StartSymbol) .* CurrentCwnd;            %瞬时速度即为瞬时窗口的大小
       % DownloadTempPool    = DownloadTempPool + CurrentSpeed;          %缓冲池
       % StartSymbol         = logical((DownloadTempPool > CodeSpeed .* 2048) % + ...             %原来是4192
                                     % (InitialSpeedPeak < 7000) .* (PlayAvgSpeed < 362) ... 
                                     % .* (DownloadTempPool > 200 * CodeSpeed));%播放开始的判断条件，即下载池达到4秒或（初始峰速小于7000且播放速率小玉362且下载池大于200毫秒
    %end
 end