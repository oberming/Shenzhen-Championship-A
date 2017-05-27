TDD         = (InitialDataAmong .* 8 + PlayAvgSpeed .* 30000);
TDP         = (CodeSpeed .* (30000-PauseTotal));
OOTDD       = (OOInitialDataAmong .* 8 + PlayAvgSpeed .* 30000);
OOTDP       = (CodeSpeed .* (30000-OOPauseTotal));
UselessDataRatio = (TDD - TDP) ./ TDP;
OOUselessDataRatio = (OOTDD - OOTDP) ./ OOTDP;
plot(PlayAvgSpeed,UselessDataRatio,'r. ')
hold on
plot(PlayAvgSpeed,OOUselessDataRatio,'b. ')
xlabel PlayAvgSpeed
ylabel UselessDataRatio
axis([0,20000,0,5])

