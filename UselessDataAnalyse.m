cc
load data
UselessDataRatio =  (CodeSpeed .* (30000-PauseTotal)) ./ (InitialDataAmong .* 8 + PlayAvgSpeed .* 30000);
b = (TotalAvgSpeed .* (InitialDelay + 30000)) ./ (InitialDataAmong .* 8 + PlayAvgSpeed .* 30000);
plot(PlayAvgSpeed,UselessDataRatio,'r. ')
hold on

