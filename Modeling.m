function [InitialDownloadTime, pauseTotal, pausePercentage, InitialDelay] = Modeling(E2ERTT, playAvgSpeed, InitialSpeedPeak, codeSpeed)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MODEL  1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 思    路 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                      %
% codespeed设置为所有用户的平均值                                      %
%                                                                      %
% totaltime 设置为30000                                                %
%                                                                      %
% 假设用户初始下载量为4*codespeed                                      %
%                                                                      %
% 忽略各种延时 仅考虑一开始时的e2e                                     %
%                                                                      %
% 视频开始播放后速率为 playAvgSpeed                                    %
%                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 存在问题 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                      %
% 部分用户仅仅下载0.2s 左右 这类用户全程感知速率大约为400以下          %
%                                                                      %
% 初始等待时间较实际时间差距较大，大约相差一倍产生这种情况的原因是突发 %
% 下载速率与平均下载速率关系与实际差距较大，可以考虑减慢衰减速率       %
%                                                                      %
% 卡顿时间预测与实际符合较好。                                         %
%                                                                      %
% 未考虑视频分包大小                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    InitialDelay = 0;
    pauseTotal = 0;
    time = 0;
    tempPool = 0;
    startSymbol = 0;

    while startSymbol == 0
        InitialDelay = InitialDelay + 1;
        if InitialDelay > E2ERTT
            tempPool = tempPool + (InitialSpeedPeak - playAvgSpeed) ./ ...
                       sqrt(InitialDelay - E2ERTT) + playAvgSpeed;
        end
        if tempPool > codeSpeed * 4000
            startSymbol = 1;
        end
        InitialDownloadTime = tempPool / codeSpeed / 1000;
    end

    while time <= 30000
        while startSymbol == 1
            if time <= 30000
                time = time + 1;
                tempPool = tempPool + playAvgSpeed - codeSpeed;
                if tempPool < 0
                    startSymbol = 0;
                end
            else
                break
            end
        end
        while startSymbol == 0
            if time <= 30000
                time = time + 1;
                pauseTotal = pauseTotal + 1;
                tempPool = tempPool +  playAvgSpeed;
                if tempPool > 2700 * codeSpeed
                    startSymbol = 1;
                end
            else
                break
            end
        end
    end
    pausePercentage = pauseTotal / (30000 - pauseTotal);
end
