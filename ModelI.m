function [InitialDataAmong, InitialDelay, TempPool] = ModelI(E2ERTT, InitialSpeedPeak, CodeSpeed, PlayAvgSpeed)
    DataSize        = max(size(CodeSpeed));
    InitialDelay    = (zeros(DataSize, 1));
    StartSymbol     = false(DataSize, 1);
    TempPool        = (zeros(DataSize, 1));
    MSS             = 2144-320; %bit 
    MaxCwnd         = fix(InitialSpeedPeak .* E2ERTT ./ MSS);
    CurrentCwnd     = 5; %cwnd1 = 10
    TransRotate     = 0;
    while sum(StartSymbol) < DataSize
        TransRotate         = TransRotate + 1;
        InitialDelay        = InitialDelay + (~StartSymbol) .* E2ERTT;
        CurrentCwnd         = 2 * CurrentCwnd .* (CurrentCwnd < 0.5 * MaxCwnd) + ...
                              0.75 * MaxCwnd .* (CurrentCwnd >= 0.5 * MaxCwnd);
        CurrentSpeed        = (~StartSymbol) .* CurrentCwnd .* MSS;
        TempPool            = TempPool + CurrentSpeed; %E2ERTT
        StartSymbol         = logical((TempPool > CodeSpeed .* 4000)  + ...
                                      (InitialSpeedPeak < 7000) .* (PlayAvgSpeed < 362) .* (TempPool > 200 * CodeSpeed));
    end
    InitialDataAmong = TempPool / 8; %bit -> byte
end