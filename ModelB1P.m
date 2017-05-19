function PauseTotal = ModelB1P(TempPool, PlayAvgSpeed, CodeSpeed)
    DataSize    = max(size(CodeSpeed));
    time        = 0;
    PauseTotal  = zeros(DataSize,1);
    StartSymbol = true(DataSize,1);
    while time < 30000
        time        = time + 1;
        TempPool    = TempPool - StartSymbol .* CodeSpeed + PlayAvgSpeed;
        StartSymbol = StartSymbol - (TempPool < 1) .* StartSymbol + ...     %刚刚开始卡顿的数目
                      (~StartSymbol) .* (TempPool > 2700 * CodeSpeed);      %卡顿还没有开始的数目
        PauseTotal  = PauseTotal + (~StartSymbol);
    end
end