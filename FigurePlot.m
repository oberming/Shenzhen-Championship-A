function FigurePlot(PlayAvgSpeed, PauseTotal, OOPauseTotal, InitialSpeedPeak, InitialDelay, OOInitialDelay, InitialDataAmong, OOInitialDataAmong, CodeSpeed, PauseCount, OOPauseCount)
    figure(1);
    plot3(PlayAvgSpeed, PauseTotal, PauseCount, 'r. ')
    hold on
    plot3(PlayAvgSpeed, OOPauseTotal, OOPauseCount, 'b. ')
    hold off
    xlabel playAvgSpeed;
    ylabel pauseTotal;
    zlabel PauseCount;

    figure(2)
    plot(InitialSpeedPeak,InitialDelay,'r. ')
    hold on
    plot(InitialSpeedPeak,OOInitialDelay,'b. ')
    hold off
    xlabel InitialSpeedPeak;
    axis([0 12e4 0 3.5e4])
    ylabel InitialDelay;

    figure(3)
    plot(InitialSpeedPeak, InitialDataAmong / 8 ./ CodeSpeed,'r. ')
    hold on
    plot(InitialSpeedPeak, OOInitialDataAmong / 8 ./ CodeSpeed,'b. ')
    hold off
    xlabel InitialSpeedPeak;
    ylabel InitialDataAmong;

    figure(4)
    plot(InitialDelay, InitialDataAmong / 8 ./ CodeSpeed, 'r. ')
    hold on
    plot(InitialDelay, OOInitialDataAmong / 8 ./ CodeSpeed, 'b. ')
    hold off
    xlabel InitialDelay;
    ylabel InitialDataAmong;    
end
