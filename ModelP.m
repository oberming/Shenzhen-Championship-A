function [PauseTotal, PauseCount] = ModelP(TempPool, PlayAvgSpeed, CodeSpeed)
    DataSize    = max(size(CodeSpeed));
    time        = 0;
    ll          = 0;
    PauseTotal  = zeros(DataSize,1);
    StartSymbol = true(DataSize,1);
    PauseCount  = zeros(DataSize,1);
    CodeSpeed1  = normrnd(CodeSpeed,0.35);
    while time < 29990
        while ll < 9
            TempPool    = TempPool - StartSymbol .* CodeSpeed1 + PlayAvgSpeed;
            PauseCount  = PauseCount + (TempPool < CodeSpeed1) .* StartSymbol;
            StartSymbol = StartSymbol - (TempPool < CodeSpeed1) .* StartSymbol + ...     %刚刚开始卡顿的数目
                      (~StartSymbol) .* (TempPool > 2700 * CodeSpeed1);      %卡顿还没有开始的数目
            PauseTotal  = PauseTotal + (~StartSymbol);
            time        = time + 1;
            ll          = ll+1;
        end
        ll              = 0;
        CodeSpeed1      = normrnd(CodeSpeed,0.35);
    end
end