% For exploring an example of intensive rent.
clear all
% The example is from Antonio D'Agata (1983). The existence and unicity of
%    cost-minimizing systems in intensive rent theory, Metroeconomica, 35: 147-158.
%
% It is also problem 7.8 in Kurz and Salvadori (1995).
%
% Alpha, Beta, and Gamma are techniques in which only one process is operated
% on the land. The scarcity of land is shown by the possibility of selecting
% the Delta, Epsilon, and Zeta techniques, in which two processes are
% operating on the land, side by side.
%
% For testing or demonstrating, modify plotIndex (line 27) or
%   acres land available (line 47).
%
% Suppose that T = 100 acres of land are available (D'Agata's example).
%  Alpha, Delta, and Epsilon are feasible.
%   Alpha is never cost-minimizing, as shown by extra profits in the 3rd corn-producing process.
%   Delta is cost-minimizing from approximately r = 11.1 percent to r = 46.34 percent. Between
%     r = 46.34 percent and r = 52.31 percent, the third corn-producing process will be adopted.
%   Epsilon is cost-minimizing from r = 0 to approximately r = 46.34 percent. Between
%    r = 46.34 percent and r = 66.7 percent, the second corn-producing process will be adopted.
% The example illustrates an upward-sloping wage curve, for Delta.
% The cost-minimizing technique is not unique for r between 11.1 percent and 46.34 percent. Both
%   Delta and Epsilon are cost-minimizing.
% A cost-minimizing technique does not exist for r between 46.34 and 81 percent, despite the
%   existence of feasible techniques. For r between 46.34 percent and 52.31 percent, there
%   is a cycle, with Epsilon preferred at Delta prices and Delta preferred at Epsilon prices.
%
% Suppose that T = 110 acres of land are available.
%   Alpha, Beta, Epsilon, and Zeta are feasible.
%   Alpha is never cost-minimizing, ss shown by extra profits in the 3rd corn-producing process.
%   Beta is cost-minimizing from approximately r = 60.63 percent to the maximimum rate of profits.
%   Epsilon is cost-minimizing from r = 0 to approximately 46.34 percent.
%   Zeta is approximately cost-minimizing from approximately r = 46.34 percent to 60.63 percent.
% The example illustrates an upward-sloping wage curve, for Zeta.
% The cost-minimizing technique is unique, given the rate of profits.
% It is not unique, given the wage. There is a range of the wage where Beta, Epsilon, and Zeta
%   are all cost-minimizing.
%

s1 = 1;
s2 = 1;
s3 = 1;

% 1, to plot wages; 2, to plot rent per acre against the rate of profits;
% 3, to plot extra profits in the first corn-producing process; 4 to
% plot extra profits in the second corn-producing process; 5, to plot
% extra profits in the third corn-producing pross.
plotIndex = 1;

% Direct labor coefficients:
a0 = [1, 1, 1, 11/5, 1];

% Land coefficients:
c = [0, 0, 1, 1, 1];

% Input matrix:
A = [[0,     0,  1/10, 1/10, 1/10]; ...
     [0,     0,   2/5, 1/10, 1/10]; ...
     [1/10, 3/5, 1/10, 3/10, 2/5]; ...
     [0,    0,   0,    0,    0]];

B = [[1, 0, 0, 0, 0]; ...
     [0, 1, 0, 0, 0]; ...
     [0, 0, 1, 1, 1]; ...
     -c];


 t1 = 101.587301587301;
 t2 = 101.587301587302;
 t3 = (t1 + t2)/2;
 t4 = (t3 + t2)/2;
 t5 = (t3 + t4)/2;


% Acres land available:
T = 100;
% At T = 100, Alpha, Delta, and Epsilon are feasible.
% At T = 110, Alpha, Beta, Epsilon, and Zeta are feasible.
% At T = 125, Alpha, Beta, and Gamma are feasible.

% Numeraire:
% Alpha, Delta, and Epsilon are feasible (D'Agata's example):
d = [90; 60; 19; 0];
% Alpha, Beta, Epsilon, and Zeta are feasible:
% d = [90; 60; 17; 0];
% Alpha, Beta, and Gamma are feasible:
% d = [90; 60; 7; 0];

% The fourth element of the price vector is the rent of land.

% Required net output:
% Alpha, Delta, and Epsilon are feasible (D'Agata's example):
y = [90; 60; 19; -T];
% Alpha, Beta, Epsilon, and Zeta are feasible:
% y = [90; 60; 17; -T];
% Alpha, Beta, and Gamma are feasible:
% y = [90; 60; 7; -T];


% Number of increments to use when plotting wage curves.
rIncrements = 200;
% Start with -1? Then 1. Start with 0? Then 0;
negativeOne = 0;


% Define Alpha, Beta, Gamma, Delta, Epsilon, and Zeta techniques.
[a0Alpha, AAlpha, BAlpha, SAlpha] = ...
    get_technique_parameters( [1, 2, 3], a0, A, B, [s1, s2, s3, s3, s3] );
[a0Beta, ABeta, BBeta, SBeta] = ...
    get_technique_parameters( [1, 2, 4], a0, A, B, [s1, s2, s3, s3, s3] );
[a0Gamma, AGamma, BGamma, SGamma] = ...
    get_technique_parameters( [1, 2, 5], a0, A, B, [s1, s2, s3, s3, s3] );
[a0Delta, ADelta, BDelta, SDelta] = ...
    get_technique_parameters( [1, 2, 3, 4], a0, A, B, [s1, s2, s3, s3, s3] );
[a0Epsilon, AEpsilon, BEpsilon, SEpsilon] = ...
    get_technique_parameters( [1, 2, 3, 5], a0, A, B, [s1, s2, s3, s3, s3] );
[a0Zeta, AZeta, BZeta, SZeta] = ...
    get_technique_parameters( [1, 2, 4, 5], a0, A, B, [s1, s2, s3, s3, s3] );

% Only Alpha, Delta, and Epsilon are feasible. Show this.
[qAlpha, isAlphaFeasible] = get_quantity_flows(y(1:3), 0, a0Alpha, AAlpha, BAlpha, 0);
isAlphaFeasible = isAlphaFeasible && ( c(3)*qAlpha(3) <= T );
if (isAlphaFeasible)
  printf( "Alpha is feasible.\n" );
else
  printf( "Alpha is NOT feasible.\n" );
endif

[qBeta, isBetaFeasible] = get_quantity_flows(y(1:3), 0, a0Beta, ABeta, BBeta, 0);
isBetaFeasible = isAlphaFeasible && ( c(4)*qBeta(3) <= T );
if (isBetaFeasible)
  printf( "Beta is feasible.\n" );
else
  printf( "Beta is NOT feasible.\n" );
endif

[qGamma, isGammaFeasible] = get_quantity_flows(y(1:3), 0, a0Gamma, AGamma, BGamma, 0);
isGammaFeasible = isGammaFeasible && ( c(5)*qGamma(3) <= T );
if (isGammaFeasible)
  printf( "Gamma is feasible.\n" );
else
  printf( "Gamma is NOT feasible.\n" );
endif

[qDelta, isDeltaFeasible] = get_quantity_flows(y, 0, a0Delta, ADelta, BDelta, 0);
if (isDeltaFeasible)
  printf( "Delta is feasible.\n" );
else
  printf( "Delta is NOT feasible.\n" );
endif

[qEpsilon, isEpsilonFeasible] = get_quantity_flows(y, 0, a0Epsilon, AEpsilon, BEpsilon, 0);
if (isEpsilonFeasible)
  printf( "Epsilon is feasible.\n" );
else
  printf( "Epsilon is NOT feasible.\n" );
endif

[qZeta, isZetaFeasible] = get_quantity_flows(y, 0, a0Zeta, AZeta, BZeta, 0);
if (isZetaFeasible)
  printf( "Zeta is feasible.\n\n" );
else
  printf( "Zeta is NOT feasible.\n\n" );
endif

% Find polynomials for rational functions for each  feasible technique.
if (isAlphaFeasible)
   [fAlpha, gAlpha, numerAlpha] = get_rational_functions( a0Alpha, AAlpha, BAlpha, d(1:3, :), SAlpha);
endif
if (isBetaFeasible)
   [fBeta, gBeta, numerBeta] = get_rational_functions( a0Beta, ABeta, BBeta, d, SBeta);
endif
if (isGammaFeasible)
   [fGamma, gGamma, numerGamma] = get_rational_functions( a0Gamma, AGamma, BGamma, d, SGamma);
endif
if (isDeltaFeasible)
   [fDelta, gDelta, numerDelta] = get_rational_functions( a0Delta, ADelta, BDelta, d, SDelta);
endif
if (isEpsilonFeasible)
   [fEpsilon, gEpsilon, numerEpsilon] = get_rational_functions( a0Epsilon, AEpsilon, BEpsilon, d, SEpsilon);
endif
if (isZetaFeasible)
   [fZeta, gZeta, numerZeta] = get_rational_functions( a0Zeta, AZeta, BZeta, d, SZeta);
endif


% Find the maximum rate of profits and wagde for the six techniques.
rMax = 0;
if (isAlphaFeasible)
  rMaxAlpha = get_r_max2( fAlpha );
  rMax = max( [rMax, rMaxAlpha] );
  wMaxAlpha = get_maximum_wage( fAlpha, gAlpha );
endif
if (isBetaFeasible)
  rMaxBeta = get_r_max2( fBeta );
  rMax = max( [rMax, rMaxBeta] );
  wMaxBeta = get_maximum_wage( fBeta, gBeta );
endif
if (isGammaFeasible)
  rMaxGamma = get_r_max2( fGamma );
  rMax = max( [rMax, rMaxGamma] );
  wMaxGamma = get_maximum_wage( fGamma, gGamma );
endif
if (isDeltaFeasible)
  rMaxDelta = get_r_max2( fDelta );
  rMax = max( [rMax, rMaxDelta] );
  wMaxDelta = get_maximum_wage( fDelta, gDelta );
endif
if (isEpsilonFeasible)
  rMaxEpsilon = get_r_max2( fEpsilon );
  rMax = max( [rMax, rMaxEpsilon] );
  wMaxEpsilon = get_maximum_wage( fEpsilon, gEpsilon );
endif
if (isZetaFeasible)
  rMaxZeta = get_r_max2( fZeta );
  rMax = max( [rMax, rMaxZeta] );
  wMaxZeta = get_maximum_wage( fZeta, gZeta );
endif


% Start setting up the graph.
if (negativeOne == 1)
   rIncr = (rMax + 1)/(rIncrements - 1);
   rStart = -1.0;
else
   rIncr = rMax/(rIncrements - 1);
   rStart = 0.0;
end


% Check polynomials for prices
if (isAlphaFeasible)
   check_prices( 0, rMaxAlpha, rIncrements, fAlpha, gAlpha, numerAlpha, ...
       a0Alpha, AAlpha, BAlpha, d, SAlpha, 10^-4, 1, "Alpha");
endif
if (isBetaFeasible)
   check_prices( 0, rMaxBeta, rIncrements, fBeta, gBeta, numerBeta, ...
       a0Beta, ABeta, BBeta, d, SBeta, 10^-4, 1, "Beta");
endif
if (isGammaFeasible)
   check_prices( 0, rMaxGamma, rIncrements, fGamma, gGamma, numerGamma, ...
       a0Gamma, AGamma, BGamma, d, SGamma, 10^-4, 1, "Gamma");
endif
% Wage curves for rent examples can slope up. Need to think
% about maximum rate of profits differently.
% I also construct the wage curves for Delta, Epsilon, and Zeta here.
if (isDeltaFeasible)
  [rDelta, wDelta, priceDelta, isok] = get_and_check_wage_curve( rStart, rIncr, rIncrements, ...
       fDelta, gDelta, numerDelta, a0Delta, ADelta, BDelta, ...
       d, SDelta, 10^-4, 1, "Delta");
  rentDelta = priceDelta(4,:);
endif
if (isEpsilonFeasible)
  [rEpsilon, wEpsilon, priceEpsilon, isok] = get_and_check_wage_curve( rStart, rIncr, rIncrements, ...
       fEpsilon, gEpsilon, numerEpsilon, a0Epsilon, AEpsilon, BEpsilon, ...
       d, SEpsilon, 10^-4, 1, "Epsilon");
  rentEpsilon = priceEpsilon(4,:);
endif
if (isZetaFeasible)
   [rZeta, wZeta, priceZeta, isok] = get_and_check_wage_curve( rStart, rIncr, rIncrements, ...
       fZeta, gZeta, numerZeta, a0Zeta, AZeta, BZeta, ...
       d, SZeta, 10^-4, 1, "Zeta");
  rentZeta = priceZeta(4,:);
endif

% Echo parameters for each each feasible technique.
if (isAlphaFeasible)
   print_parameters_wrapper( a0Alpha, AAlpha, BAlpha, d, SAlpha, fAlpha, gAlpha, numerAlpha, "Alpha" );
endif
if (isBetaFeasible)
   print_parameters_wrapper( a0Beta, ABeta, BBeta, d, SBeta, fBeta, gBeta, numerBeta, "Beta" );
endif
if (isGammaFeasible)
   print_parameters_wrapper( a0Gamma, AGamma, BGamma, d, SGamma, fGamma, gGamma, numerGamma, "Gamma" );
endif
if (isDeltaFeasible)
   print_parameters_wrapper( a0Delta, ADelta, BDelta, d, SDelta, fDelta, gDelta, numerDelta, "Delta" );
endif
if (isEpsilonFeasible)
   print_parameters_wrapper( a0Epsilon, AEpsilon, BEpsilon, d, SEpsilon, fEpsilon, gEpsilon, numerEpsilon, "Epsilon" );
endif
if (isZetaFeasible)
   print_parameters_wrapper( a0Zeta, AZeta, BZeta, d, SZeta, fZeta, gZeta, numerZeta, "Zeta" );
endif
printf("\n");


% Get switch points.
% I only want to look at pairs of techniques that differ by one process.
% I do all possible pairs to find intersections with the abscissa on
% the three graphs of extra profits. Maybe there is some redundancy anyways.
switchPoints = [];
wagesForSwitchPoints = [];
rExtraSwitchPoints1 = [];            % For 1st corn-producing process.
extraProfitsForSwitchPoints1 = [];
rExtraSwitchPoints2 = [];            % For 2nd corn-producing process.
extraProfitsForSwitchPoints2 = [];
rExtraSwitchPoints3 = [];            % For 3rd corn-producing process.
extraProfitsForSwitchPoints3 = [];
rentSwitchPoints = [];               % For rents.
rentsForSwitchPoints = [];

% Start with the Alpha price system.
if (isAlphaFeasible)
   % Find when extra profits are zero in 2nd corn-producing process.
   % These are switch points with Beta and Delta.
   %
   % Can Beta and Delta both be feasible when Alpha is feasible?
   if (isBetaFeasible)
     myrMax = min( rMaxAlpha, rMaxBeta);
     myLabel = "Alpha vs. Beta";
   elseif (isDeltaFeasible)
     myrMax = rMaxAlpha;   % TODO: How do I know this?
     myLabel = "Alpha vs. Delta";
   endif

   switchPoints1 = get_switch_points_from_prices( fAlpha, gAlpha, numerAlpha, d, s3, ......
       a0(4), A(:,4), B(:,4), 0, myrMax );
   wages1 = get_wages_for_switch_points(switchPoints1, fAlpha, gAlpha, ...
       myrMax, 1, myLabel);
   switchPoints = [switchPoints, switchPoints1];
   wagesForSwitchPoints = [wagesForSwitchPoints, wages1];

   extraProfits1 = get_extra_profits_curve(switchPoints1, fAlpha, gAlpha, numerAlpha, ...
       a0(4), A(:,4), B(:,4), s3);
   rExtraSwitchPoints2 = [rExtraSwitchPoints2, switchPoints1];
   extraProfitsForSwitchPoints2 = [extraProfitsForSwitchPoints2, extraProfits1];

   if (isDeltaFeasible)
      % TODO: write a subroutine for the following. Which price is a rent must be
      %   an argument.
      rents1 = [];
      for idx = 1:1:size(switchPoints1, 2)
        prices = get_prices_from_rational_functions(switchPoints1(idx), gDelta, numerDelta);
        rents1 = [rents1, prices(4)];
      endfor
      rentSwitchPoints = [ rentSwitchPoints, switchPoints1];
      rentsForSwitchPoints = [rentsForSwitchPoints, rents1];
   endif

   % Find when extra profits are zero in 3rd corn-producing process.
   % These are switch points with Gamma and Epsilon.
   %
   % Can Gamma and Epsilon both be feasible when Alpha is feasible?
   if ( isGammaFeasible)
     myrMax = min( rMaxAlpha, rMaxGamma);
     myLabel = "Alpha vs. Gamma";
   elseif (isEpsilonFeasible)
     myrMax = rMaxAlpha;   % TODO: How do I know this?
     myLabel = "Alpha vs. Epsilon";
   endif

   switchPoints2 = get_switch_points_from_prices( fAlpha, gAlpha, numerAlpha, d, s3, ......
       a0(5), A(:,5), B(:,5), 0, myrMax );
   wages2 = get_wages_for_switch_points(switchPoints2, fAlpha, gAlpha, ...
       myrMax, 1, myLabel);
   switchPoints = [switchPoints, switchPoints2];
   wagesForSwitchPoints = [wagesForSwitchPoints, wages2];

   extraProfits2 = get_extra_profits_curve(switchPoints2, fAlpha, gAlpha, numerAlpha, ...
       a0(5), A(:,5), B(:,5), s3);
   rExtraSwitchPoints3 = [rExtraSwitchPoints3, switchPoints2];
   extraProfitsForSwitchPoints3 = [extraProfitsForSwitchPoints3, extraProfits2];

   if (isEpsilonFeasible)
      % TODO: write a subroutine for the following. Which price is a rent must be
      %   an argument.
      rents2 = [];
      for idx = 1:1:size(switchPoints2, 2)
        prices = get_prices_from_rational_functions(switchPoints2(idx), gEpsilon, numerEpsilon);
        rents2 = [rents2, prices(4)];
      endfor
      rentSwitchPoints = [ rentSwitchPoints, switchPoints2];
      rentsForSwitchPoints = [rentsForSwitchPoints, rents2];
   endif
endif

% Consider the Beta price system.
if (isBetaFeasible)
   % Find when extra profits are zero in 1st corn-producing process.
   % These are switch points with Alpha and Delta.
   %
   % Can Alpha and Delta both be feasible when Beta is feasible?
   if (isAlphaFeasible)
     myrMax = min( rMaxAlpha, rMaxBeta);
     myLabel = "Alpha vs. Beta";
   elseif (isDeltaFeasible)
     myrMax = rMaxBeta;   % TODO: How do I know this?
     myLabel = "Beta vs. Delta";
   endif

   switchPoints3 = get_switch_points_from_prices( fBeta, gBeta, numerBeta, d, s3, ......
       a0(3), A(:,3), B(:,3), 0, myrMax );
   % I have alreqdy found switch points between Alpha and Beta.
   if (isDeltaFeasible)
      wages3 = get_wages_for_switch_points(switchPoints3, fBeta, gBeta, ...
          myrMax, 1, myLabel);
      switchPoints = [switchPoints, switchPoints3];
      wagesForSwitchPoints = [wagesForSwitchPoints, wages3];
   endif

   extraProfits3 = get_extra_profits_curve(switchPoints3, fBeta, gBeta, numerBeta, ...
       a0(3), A(:,3), B(:,3), s3);
   rExtraSwitchPoints1 = [rExtraSwitchPoints1, switchPoints3];
   extraProfitsForSwitchPoints1 = [extraProfitsForSwitchPoints1, extraProfits3];

   if (isDeltaFeasible)
      % TODO: write a subroutine for the following. Which price is a rent must be
      %   an argument.
      rents3 = [];
      for idx = 1:1:size(switchPoints3, 2)
        prices = get_prices_from_rational_functions(switchPoints3(idx), gDelta, numerDelta);
        rentss = [rents3, prices(4)];
      endfor
      rentSwitchPoints = [ rentSwitchPoints, switchPoints3];
      rentsForSwitchPoints = [rentsForSwitchPoints, rents3];
   endif


   % Find when extra profits are zero in 3rd corn-producing process.
   % These are switch points with Gamma and Zeta.
   %
   % Can Gamma and Zeta both be feasible when Beta is feasible?
   if (isGammaFeasible)
     myrMax = min( rMaxBeta, rMaxGamma);
     myLabel = "Beta vs. Gamma";
   elseif (isZetaFeasible)
     myrMax = rMaxBeta;   % TODO: How do I know this?
     myLabel = "Beta vs. Zeta";
   endif

   switchPoints4 = get_switch_points_from_prices( fBeta, gBeta, numerBeta, d, s3, ......
       a0(5), A(:,5), B(:,5), 0, myrMax );
   wages4 = get_wages_for_switch_points(switchPoints4, fBeta, gBeta, ...
          myrMax, 1, myLabel);
   switchPoints = [switchPoints, switchPoints4];
   wagesForSwitchPoints = [wagesForSwitchPoints, wages4];

   extraProfits4 = get_extra_profits_curve(switchPoints4, fBeta, gBeta, numerBeta, ...
       a0(5), A(:,5), B(:,5), s3);
   rExtraSwitchPoints3 = [rExtraSwitchPoints3, switchPoints4];
   extraProfitsForSwitchPoints3 = [extraProfitsForSwitchPoints3, extraProfits4];

   if (isZetaFeasible)
      % TODO: write a subroutine for the following. Which price is a rent must be
      %   an argument.
      rents4 = [];
      for idx = 1:1:size(switchPoints4, 2)
        prices = get_prices_from_rational_functions(switchPoints4(idx), gZeta, numerZeta);
        rents4 = [rents4, prices(4)];
      endfor
      rentSwitchPoints = [ rentSwitchPoints, switchPoints4];
      rentsForSwitchPoints = [rentsForSwitchPoints, rents4];
   endif
endif

% Consider the Gamma price system.
if (isGammaFeasible)
   % Find when extra profits are zero in 1st corn-producing process.
   % These are switch points with Alpha and Epsilon.
   %
   % Can Alpha and Epsilon both be feasible when Gamma is feasible?
   if (isAlphaFeasible)
     myrMax = min( rMaxAlpha, rMaxGamma);
     myLabel = "Alpha vs. Gamma";
   elseif (isEpsilonFeasible)
     myrMax = rMaxGamma;   % TODO: How do I know this?
     myLabel = "Gamma vs. Epsilon";
   endif

   switchPoints5 = get_switch_points_from_prices( fGamma, gGamma, numerGamma, d, s3, ......
       a0(3), A(:,3), B(:,3), 0, myrMax );
   % I have alreqdy found switch points between Alpha and Gamma.
   if ( isEpsilonFeasible)
      wages5 = get_wages_for_switch_points(switchPoints5, fGamma, gGamma, ...
          myrMax, 1, myLabel);
      switchPoints = [switchPoints, switchPoints5];
      wagesForSwitchPoints = [wagesForSwitchPoints, wages5];
   endif

   extraProfits5 = get_extra_profits_curve(switchPoints5, fGamma, gGamma, numerGamma, ...
       a0(3), A(:,3), B(:,3), s3);
   rExtraSwitchPoints1 = [rExtraSwitchPoints1, switchPoints5];
   extraProfitsForSwitchPoints1 = [extraProfitsForSwitchPoints1, extraProfits5];

   if ( isEpsilonFeasible)
      % TODO: write a subroutine for the following. Which price is a rent must be
      %   an argument.
      rents5 = [];
      for idx = 1:1:size(switchPoints5, 2)
        prices = get_prices_from_rational_functions(switchPoints5(idx), gEpsilon, numerEpsilon);
        rents5 = [rents5, prices(4)];
      endfor
      rentSwitchPoints = [ rentSwitchPoints, switchPoints5];
      rentsForSwitchPoints = [rentsForSwitchPoints, rents5];
   endif

   % Find when extra profits are zero in 2nd corn-producing process.
   % These are switch points with Beta and Zeta.
   %
   % Can Beta and Zeta both be feasible when Gamma is feasible?
   if (isBetaFeasible)
     myrMax = min( rMaxBeta, rMaxGamma);
     myLabel = "Beta vs. Gamma";
   elseif (isZetaFeasible)
     myrMax = rMaxGamma;   % TODO: How do I know this?
     myLabel = "Gamma vs. Zeta";
   endif

   switchPoints6 = get_switch_points_from_prices( fGamma, gGamma, numerGamma, d, s3, ......
       a0(4), A(:,4), B(:,4), 0, myrMax );
   % I have alreqdy found switch points between Beta and Gamma.
   if (isZetaFeasible)
      wages6 = get_wages_for_switch_points(switchPoints6, fGamma, gGamma, ...
          myrMax, 1, myLabel);
      switchPoints = [switchPoints, switchPoints6];
      wagesForSwitchPoints = [wagesForSwitchPoints, wages6];
   endif

   extraProfits6 = get_extra_profits_curve(switchPoints6, fGamma, gGamma, numerGamma, ...
       a0(4), A(:,4), B(:,4), s3);
   rExtraSwitchPoints2 = [rExtraSwitchPoints2, switchPoints6];
   extraProfitsForSwitchPoints2 = [extraProfitsForSwitchPoints2, extraProfits6];

   if (isZetaFeasible)
      % TODO: write a subroutine for the following. Which price is a rent must be
      %   an argument.
      rents6 = [];
      for idx = 1:1:size(switchPoints6, 2)
        prices = get_prices_from_rational_functions(switchPoints6(idx), gZeta, numerZeta);
        rents5 = [rents5, prices(4)];
      endfor
      rentSwitchPoints = [ rentSwitchPoints, switchPoints6];
      rentsForSwitchPoints = [rentsForSwitchPoints, rents6];
   endif
endif

% Consider the Delta price system.
if (isDeltaFeasible)
   % Find when extra profits are zero in 3rd corn-producing process.
   % These are switch points with Epsilon and Zeta.
   %
   % Can Epsilon and Zeta both be feasible when Delta is feasible?
   if (isEpsilonFeasible)
     myrMax = rMax;    % TODO: How do I know this?
     myLabel = "Delta vs. Epsilon";
   elseif (isZetaFeasible)
     myrMax = rMax;   % TODO: How do I know this?
     myLabel = "Delta vs. Zeta";
   endif

   switchPoints7 = get_switch_points_from_prices( fDelta, gDelta, numerDelta, d, s3, ......
       a0(5), A(:,5), B(:,5), 0, myrMax );
   wages7 = get_wages_for_switch_points(switchPoints7, fDelta, gDelta, ...
          myrMax, 1, myLabel);
   switchPoints = [switchPoints, switchPoints7];
   wagesForSwitchPoints = [wagesForSwitchPoints, wages7];

   extraProfits7 = get_extra_profits_curve(switchPoints7, fDelta, gDelta, numerDelta, ...
       a0(5), A(:,5), B(:,5), s3);
   rExtraSwitchPoints3 = [rExtraSwitchPoints3, switchPoints7];
   extraProfitsForSwitchPoints3 = [extraProfitsForSwitchPoints3, extraProfits7];

   rents7 = [];
   for idx = 1:1:size(switchPoints7, 2)
      prices = get_prices_from_rational_functions(switchPoints7(idx), gDelta, numerDelta);
      rents7 = [rents7, prices(4)];
   endfor
   rentSwitchPoints = [ rentSwitchPoints, switchPoints7];
   rentsForSwitchPoints = [rentsForSwitchPoints, rents7];
endif


% Consider the Epsilon price system.
if (isEpsilonFeasible)
   % Find when extra profits are zero in 2nd corn-producing process.
   % These are switch points with Delta and Zeta.
   %
   % Can Delta and Zeta both be feasible when Epsilon is feasible?
   if (isDeltaFeasible)
     myrMax = rMax;    % TODO: How do I know this?
     myLabel = "Delta vs. Epsilon";
   elseif (isZetaFeasible)
     myrMax = rMax;   % TODO: How do I know this?
     myLabel = "Epsilon vs. Zeta";
   endif

   switchPoints8 = get_switch_points_from_prices( fEpsilon, gEpsilon, numerEpsilon, d, s3, ......
       a0(4), A(:,4), B(:,4), 0, myrMax );
   % I have already found switch points between Delta and Epsilon.
   if (isZetaFeasible)
       wages8 = get_wages_for_switch_points(switchPoints8, fEpsilon, gEpsilon, ...
            myrMax, 1, myLabel);
       switchPoints = [switchPoints, switchPoints8];
       wagesForSwitchPoints = [wagesForSwitchPoints, wages8];
   endif

   extraProfits8 = get_extra_profits_curve(switchPoints8, fEpsilon, gEpsilon, numerEpsilon, ...
       a0(4), A(:,4), B(:,4), s3);
   rExtraSwitchPoints2 = [rExtraSwitchPoints2, switchPoints8];
   extraProfitsForSwitchPoints2 = [extraProfitsForSwitchPoints2, extraProfits8];

   % I have already found switch points between Delta and Epsilon.
   if (isZetaFeasible)
      rents8 = [];
      for idx = 1:1:size(switchPoints8, 2)
         prices = get_prices_from_rational_functions(switchPoints8(idx), gEpsilon, numerEpsilon);
         rents8 = [rents8, prices(4)];
      endfor
      rentSwitchPoints = [ rentSwitchPoints, switchPoints8];
      rentsForSwitchPoints = [rentsForSwitchPoints, rents8];
   endif
endif

% Consider the Zeta price system.
if (isZetaFeasible)
   % Find when extra profits are zero in 1st corn-producing process.
   % These are switch points with Delta and Epsilon.
   %
   % Can Delta and Epsilon both be feasible when Zeta is feasible?
   if (isDeltaFeasible)
     myrMax = rMax;    % TODO: How do I know this?
     myLabel = "Delta vs. Zeta";
   elseif (isEpsilonFeasible)
     myrMax = rMax;   % TODO: How do I know this?
     myLabel = "Epsilon vs. Zeta";
   endif

   switchPoints9 = get_switch_points_from_prices( fZeta, gZeta, numerZeta, d, s3, ......
       a0(3), A(:,3), B(:,3), 0, myrMax );
   % I have already found switch points between Delta and Zeta or Epsilon and Zeta.

   extraProfits9 = get_extra_profits_curve(switchPoints9, fZeta, gZeta, numerZeta, ...
       a0(3), A(:,3), B(:,3), s3);
   rExtraSwitchPoints1 = [rExtraSwitchPoints1, switchPoints9];
   extraProfitsForSwitchPoints1 = [extraProfitsForSwitchPoints1, extraProfits9];

endif


% Find vector of wages, for the first three techniques, for plotting.
if (isAlphaFeasible)
  [ rAlpha, wAlpha ] = get_wage_curve( rStart, rIncr, rIncrements, fAlpha, gAlpha, rMaxAlpha );
endif
if (isBetaFeasible)
  [ rBeta, wBeta ] = get_wage_curve( rStart, rIncr, rIncrements, fBeta, gBeta, rMaxBeta );
endif
if (isGammaFeasible)
  [ rGamma, wGamma ] = get_wage_curve( rStart, rIncr, rIncrements, fGamma, gGamma, rMaxGamma );
endif

% Calculate curves for extra profits.
if (isAlphaFeasible)
  extraProfitsAlpha1 = get_extra_profits_curve( rAlpha, fAlpha, gAlpha, numerAlpha, ...
      a0(3), A(:,3), B(:,3), s3);
  extraProfitsAlpha2 = get_extra_profits_curve( rAlpha, fAlpha, gAlpha, numerAlpha, ...
      a0(4), A(:,4), B(:,4), s3);
  extraProfitsAlpha3 = get_extra_profits_curve( rAlpha, fAlpha, gAlpha, numerAlpha, ...
      a0(5), A(:,5), B(:,5), s3);
endif
if (isBetaFeasible)
  extraProfitsBeta1 = get_extra_profits_curve( rBeta, fBeta, gBeta, numerBeta, ...
      a0(3), A(:,3), B(:,3), s3);
  extraProfitsBeta2 = get_extra_profits_curve( rBeta, fBeta, gBeta, numerBeta, ...
      a0(4), A(:,4), B(:,4), s3);
  extraProfitsBeta3 = get_extra_profits_curve( rBeta, fBeta, gBeta, numerBeta, ...
      a0(5), A(:,5), B(:,5), s3);
endif
if (isGammaFeasible)
  extraProfitsGamma1 = get_extra_profits_curve( rGamma, fGamma, gGamma, numerGamma, ...
      a0(3), A(:,3), B(:,3), s3);
  extraProfitsGamma2 = get_extra_profits_curve( rGamma, fGamma, gGamma, numerGamma, ...
      a0(4), A(:,4), B(:,4), s3);
  extraProfitsGamma3 = get_extra_profits_curve( rGamma, fGamma, gGamma, numerGamma, ...
      a0(5), A(:,5), B(:,5), s3);
endif
if (isDeltaFeasible)
  extraProfitsDelta1 = get_extra_profits_curve( rDelta, fDelta, gDelta, numerDelta, ...
      a0(3), A(:,3), B(:,3), s3);
  extraProfitsDelta2 = get_extra_profits_curve( rDelta, fDelta, gDelta, numerDelta, ...
      a0(4), A(:,4), B(:,4), s3);
  extraProfitsDelta3 = get_extra_profits_curve( rDelta, fDelta, gDelta, numerDelta, ...
      a0(5), A(:,5), B(:,5), s3);
endif
if (isEpsilonFeasible)
  extraProfitsEpsilon1 = get_extra_profits_curve( rEpsilon, fEpsilon, gEpsilon, numerEpsilon, ...
      a0(3), A(:,3), B(:,3), s3);
  extraProfitsEpsilon2 = get_extra_profits_curve( rEpsilon, fEpsilon, gEpsilon, numerEpsilon, ...
      a0(4), A(:,4), B(:,4), s3);
  extraProfitsEpsilon3 = get_extra_profits_curve( rEpsilon, fEpsilon, gEpsilon, numerEpsilon, ...
      a0(5), A(:,5), B(:,5), s3);
endif
if (isZetaFeasible)
  extraProfitsZeta1 = get_extra_profits_curve( rZeta, fZeta, gZeta, numerZeta, ...
      a0(3), A(:,3), B(:,3), s3);
  extraProfitsZeta2 = get_extra_profits_curve( rZeta, fZeta, gZeta, numerZeta, ...
      a0(4), A(:,4), B(:,4), s3);
  extraProfitsZeta3 = get_extra_profits_curve( rZeta, fZeta, gZeta, numerZeta, ...
      a0(5), A(:,5), B(:,5), s3);
endif


if ( plotIndex == 1)

   % legendArray = [];
   % legendArray = strings(0);    % The 'strings' function is not yet implemented in Octave.
   legendArray = char(0);      % Creates an array with a first row.

   % Plot wage curves.
   axes( 'FontSize', 15, 'Box', 'on', 'NextPlot', 'add' );
   hold on
   if (isAlphaFeasible)
      plot( 100*rAlpha, wAlpha, '-', 'color', 'black', 'LineWidth', 2 );
      legendArray = [legendArray; 'Alpha' ];
   endif
   if (isBetaFeasible)
      plot( 100*rBeta, wBeta, '--', 'color', 'black', 'LineWidth', 2 );
      legendArray = [legendArray; 'Beta' ];
   endif
   if (isGammaFeasible)
      plot( 100*rGamma, wGamma, ':', 'color', 'black', 'LineWidth', 2 );
      legendArray = [legendArray; 'Gamma' ];
   endif
   if (isDeltaFeasible)
      plot( 100*rDelta, wDelta, '-.', 'color', 'black', 'LineWidth', 2 );
      legendArray = [legendArray; 'Delta' ];
   endif
   grayColor = [.7 .7 .7];
   if (isEpsilonFeasible)
      plot( 100*rEpsilon, wEpsilon, '-', 'color', grayColor, 'LineWidth', 2 );
      legendArray = [legendArray; 'Epsilon' ];
   endif
   if (isZetaFeasible)
      plot( 100*rZeta, wZeta, '--', 'color', grayColor, 'LineWidth', 2 );
      legendArray = [legendArray; 'Zeta' ];
   endif

   if ( size(switchPoints, 2) > 0 )
     plot( 100*switchPoints, wagesForSwitchPoints, "oblack", 'MarkerFaceColor', 'black');
   endif

   xlabel( 'Rate of Profits (Percent)', 'FontWeight', 'bold', ...
      'FontSize', 20, 'FontName', 'Times New Roman');
   ylabel( 'Wage (Bushels per Person-Year)', 'FontWeight', 'bold', ...
       'FontSize', 20, 'FontName', 'Times New Roman');

   legend( legendArray(2:size(legendArray, 1),:) , 'location', 'northeast' );

   hold off

elseif ( ( plotIndex == 2 ) && ...
         (isDeltaFeasible || isEpsilonFeasible || isZetaFeasible) )

   % legendArray = [];
   % legendArray = strings(0);    % The 'strings' function is not yet implemented in Octave.
   legendArray = char(0);      % Creates an array with a first row.

   % Plot rent curves
   axes( 'FontSize', 15, 'Box', 'on', 'NextPlot', 'add' );
   hold on

   if (isDeltaFeasible)
      plot( 100*rDelta, rentDelta, '-.', 'color', 'black', 'LineWidth', 2 );
      legendArray = [legendArray; 'Delta' ];
   endif
   grayColor = [.7 .7 .7];
   if (isEpsilonFeasible)
      plot( 100*rEpsilon, rentEpsilon, '-', 'color', grayColor, 'LineWidth', 2 );
      legendArray = [legendArray; 'Epsilon' ];
   endif
   if (isZetaFeasible)
      plot( 100*rZeta, rentZeta, '--', 'color', grayColor, 'LineWidth', 2 );
      legendArray = [legendArray; 'Zeta' ];
   endif

   if ( size(rentSwitchPoints, 2) > 0 )
     plot( 100*rentSwitchPoints, rentsForSwitchPoints, "oblack", 'MarkerFaceColor', 'black');
   endif

   xlabel( 'Rate of Profits (Percent)', 'FontWeight', 'bold', ...
      'FontSize', 20, 'FontName', 'Times New Roman');
   ylabel( 'Rent (Bushels per Acre)', 'FontWeight', 'bold', ...
       'FontSize', 20, 'FontName', 'Times New Roman');

   legend( legendArray(2:size(legendArray, 1),:), 'location', 'northeast' );

   hold off

elseif ( plotIndex == 3 )
   % legendArray = [];
   % legendArray = strings(0);    % The 'strings' function is not yet implemented in Octave.
   legendArray = char(0);      % Creates an array with a first row.

   % Plot extra profits in first corn-producing process.
   axes( 'FontSize', 15, 'Box', 'on', 'NextPlot', 'add' );
   hold on
   if (isAlphaFeasible)
      plot( 100*rAlpha, extraProfitsAlpha1, '-', 'color', 'black', 'LineWidth', 2 );
      legendArray = [legendArray; 'Alpha' ];
   endif
   if (isBetaFeasible)
      plot( 100*rBeta, extraProfitsBeta1, '--', 'color', 'black', 'LineWidth', 2 );
      legendArray = [legendArray; 'Beta' ];
   endif
   if (isGammaFeasible)
      plot( 100*rGamma, extraProfitsGamma1, ':', 'color', 'black', 'LineWidth', 2  );
      legendArray = [legendArray; 'Gamma' ];
   endif
   if (isDeltaFeasible)
      plot( 100*rDelta, extraProfitsDelta1, '-.', 'color', 'black', 'LineWidth', 2  );
      legendArray = [legendArray; 'Delta' ];
   endif
   grayColor = [.7 .7 .7];
   if (isEpsilonFeasible)
      plot( 100*rEpsilon, extraProfitsEpsilon1,  '-', 'color', grayColor, 'LineWidth', 2  );
      legendArray = [legendArray; 'Epsilon' ];
   endif
   if (isZetaFeasible)
      plot( 100*rZeta, extraProfitsZeta1, '--', 'color', grayColor, 'LineWidth', 2 );
      legendArray = [legendArray; 'Zeta' ];
   endif

   if ( size(rExtraSwitchPoints1, 2) > 0 )
     plot( 100*rExtraSwitchPoints1, extraProfitsForSwitchPoints1, "oblack", 'MarkerFaceColor', 'black');
   endif

   xlabel( 'Rate of Profits (Percent)', 'FontWeight', 'bold', ...
      'FontSize', 20, 'FontName', 'Times New Roman');
   ylabel( 'Extra Profits in 1st Corn Process (Bushels per Unit Level)', 'FontWeight', 'bold', ...
       'FontSize', 20, 'FontName', 'Times New Roman');

   legend( legendArray(2:size(legendArray, 1),:), 'location', 'northeast' );

   hold off


elseif ( plotIndex == 4 )
   % legendArray = [];
   % legendArray = strings(0);    % The 'strings' function is not yet implemented in Octave.
   legendArray = char(0);      % Creates an array with a first row.

   % Plot extra profits in second corn-producing process.
   axes( 'FontSize', 15, 'Box', 'on', 'NextPlot', 'add' );
   hold on
   if (isAlphaFeasible)
      plot( 100*rAlpha, extraProfitsAlpha2, '-', 'color', 'black', 'LineWidth', 2 );
      legendArray = [legendArray; 'Alpha' ];
   endif
   if (isBetaFeasible)
      plot( 100*rBeta, extraProfitsBeta2, '--', 'color', 'black', 'LineWidth', 2 );
      legendArray = [legendArray; 'Beta' ];
   endif
   if (isGammaFeasible)
      plot( 100*rGamma, extraProfitsGamma2, ':', 'color', 'black', 'LineWidth', 2  );
      legendArray = [legendArray; 'Gamma' ];
   endif
   if (isDeltaFeasible)
      plot( 100*rDelta, extraProfitsDelta2, '-.', 'color', 'black', 'LineWidth', 2  );
      legendArray = [legendArray; 'Delta' ];
   endif
   grayColor = [.7 .7 .7];
   if (isEpsilonFeasible)
      plot( 100*rEpsilon, extraProfitsEpsilon2, '-', 'color', grayColor, 'LineWidth', 2  );
      legendArray = [legendArray; 'Epsilon' ];
   endif
   if (isZetaFeasible)
      plot( 100*rZeta, extraProfitsZeta2, '--', 'color', grayColor, 'LineWidth', 2 );
      legendArray = [legendArray; 'Zeta' ];
   endif

   if ( size(rExtraSwitchPoints2, 2) > 0 )
     plot( 100*rExtraSwitchPoints2, extraProfitsForSwitchPoints2, "oblack", 'MarkerFaceColor', 'black');
   endif

   xlabel( 'Rate of Profits (Percent)', 'FontWeight', 'bold', ...
      'FontSize', 20, 'FontName', 'Times New Roman');
   ylabel( 'Extra Profits in 2nd Corn Process (Bushels per Unit Level)', 'FontWeight', 'bold', ...
       'FontSize', 20, 'FontName', 'Times New Roman');

   legend( legendArray(2:size(legendArray, 1),:), 'location', 'northeast' );

   hold off

elseif ( plotIndex == 5 )
   % legendArray = [];
   % legendArray = strings(0);    % The 'strings' function is not yet implemented in Octave.
   legendArray = char(0);      % Creates an array with a first row.

   % Plot extra profits in third corn-producing process.
   axes( 'FontSize', 15, 'Box', 'on', 'NextPlot', 'add' );
   hold on
   if (isAlphaFeasible)
      plot( 100*rAlpha, extraProfitsAlpha3, '-', 'color', 'black', 'LineWidth', 2 );
      legendArray = [legendArray; 'Alpha' ];
   endif
   if (isBetaFeasible)
      plot( 100*rBeta, extraProfitsBeta3, '--', 'color', 'black', 'LineWidth', 2 );
      legendArray = [legendArray; 'Beta' ];
   endif
   if (isGammaFeasible)
      plot( 100*rGamma, extraProfitsGamma3, ':', 'color', 'black', 'LineWidth', 2  );
      legendArray = [legendArray; 'Gamma' ];
   endif
   if (isDeltaFeasible)
      plot( 100*rDelta, extraProfitsDelta3, '-.', 'color', 'black', 'LineWidth', 2  );
      legendArray = [legendArray; 'Delta' ];
   endif
   grayColor = [.7 .7 .7];
   if (isEpsilonFeasible)
      plot( 100*rEpsilon, extraProfitsEpsilon3, '-', 'color', grayColor, 'LineWidth', 2  );
      legendArray = [legendArray; 'Epsilon' ];
   endif
   if (isZetaFeasible)
      plot( 100*rZeta, extraProfitsZeta3, '--', 'color', grayColor, 'LineWidth', 2 );
      legendArray = [legendArray; 'Zeta' ];
   endif

   if ( size(rExtraSwitchPoints3, 2) > 0 )
     plot( 100*rExtraSwitchPoints3, extraProfitsForSwitchPoints3, "oblack", 'MarkerFaceColor', 'black');
   endif

   xlabel( 'Rate of Profits (Percent)', 'FontWeight', 'bold', ...
      'FontSize', 20, 'FontName', 'Times New Roman');
   ylabel( 'Extra Profits in 3rd Corn Process (Bushels per Unit Level)', 'FontWeight', 'bold', ...
       'FontSize', 20, 'FontName', 'Times New Roman');

   legend( legendArray(2:size(legendArray, 1),:), 'location', 'northeast' );

   hold off


endif


