cc
load exdata
UselessDataRatio =  (CodeSpeed .* (30000-PauseTotal)) ./ (InitialDataAmong .* 8 + PlayAvgSpeed .* 30000);
                        %播放数据量                          %下载数据量
b = (TotalAvgSpeed .* (InitialDelay + 30000)) ./ (InitialDataAmong .* 8 + PlayAvgSpeed .* 30000);
plot(PlayAvgSpeed,1./UselessDataRatio,'r. ')
hold on