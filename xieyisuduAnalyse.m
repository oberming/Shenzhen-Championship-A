cc
load data
a = (TotalAvgSpeed .* (InitialDelay + 30000)) ./ (CodeSpeed .* (30000-PauseTotal));
b = (TotalAvgSpeed .* (InitialDelay + 30000)) ./ (InitialDataAmong .* 8 + PlayAvgSpeed .* 30000);