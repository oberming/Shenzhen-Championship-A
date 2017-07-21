function final = cpmodel(ISPN1,E2EN1,PASN1)

InitialSpeedPeakcp = (ISPN1 - 10002) ./ 149223;
E2ERTTcp = (149 - E2EN1) ./ 134;
PlayAvgSpeedcp = (PASN1 - 538) ./ 28794;     %综合评价变量的分量,cp为综合变量的缩写

InitialSpeedPeakwc  = 0.3117;
E2ERTTwc            = 0.2987;
PlayAvgSpeedwc      = 0.3896;
final               = InitialSpeedPeakwc .* InitialSpeedPeakcp + E2ERTTwc .*E2ERTTcp + PlayAvgSpeedwc .* PlayAvgSpeedcp;
end