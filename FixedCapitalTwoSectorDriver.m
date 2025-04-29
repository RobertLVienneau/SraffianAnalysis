% An illustration of the recurrence of truncation.
clear all
% Consider the simplest multisector model in which circulating and fixed
% capital exist in all sectors. One sector produces a machine which lasts
% for two years. The other sector produces corn, which acts as both circulating
% capital and as the consumption good. Once a machine is used in the
% production of a finished good, it cannot be transferred to the other sector.
%
% This example illustrates the recurrence of truncation, without reswitching.
% This is analogous to the recurrence of a process.
% For a low rate of profits, Alpha is cost-minimizing.
%   The machine is truncated in bith machine and corn production.
% For the next range of the rate of profits, Gamma is cost-minimizing.
%   The machine remains truncated in machine production.
% For the next range of the rate of profits, Delta is cost-minimizing.
%   The machine is run for two-years in both machine and corn production.
% For the highest rate of profits, Beta is cost-minimizing.
%   The machine is again truncated in corn-production.
% The above is true for A(1, 2) = 3/20.
%
% A fluke switch point is at approximately A(1, 2) = 0.0662366658003254
% All four wge curves intersect at this switch point.
%

s1 = 1;
s2 = 1;

% 1, to plot wages; 2, to plot the price of new machines;
% 3, to plot the price of old machines in the machine-producing sector;
% 4, to plot the price of old machines in the corn-producing sector.
plotIndex = 1;

% Direct labor coefficients:
a0 = [ 1/10, 8, 43/40, 1 ];

% Input matrix:
A =[[ 1/16, 3/20, 1/8, 53/200 ]; ...
    [ 1,      0,    1,   0 ]; ...
    [ 0,      1,    0,   0 ]; ...
    [ 0,      0,    0,   1]];

% Output matrix:
B = [[ 0, 0,   1, 14/25 ]; ...
     [ 2, 5/2, 0, 0 ]; ...
     [ 1,  0,  0, 0 ]; ...
     [ 0,  0,  1, 0 ]];

% Numeraire (This should really be different sizes for the different techniques):
d = [1; 0; 0; 0];

% Number of increments to use when plotting wage curves.
rIncrements = 200;
% Start with -1? Then 1. Start with 0? Then 0;
negativeOne = 0;

% Define Alpha, Beta, Gamma, Delta
[a0Alpha, AAlpha, BAlpha, SAlpha] = ...
    get_technique_parameters( [1, 3], a0, A, B, [s1, s1, s2, s2] );
[a0Beta, ABeta, BBeta, SBeta] = ...
    get_technique_parameters( [1, 2, 3], a0, A, B, [s1, s1, s2, s2] );
 % The last row of input and output matrices for Gamma are not correct after the following:
[a0Gamma, AGamma, BGamma, SGamma] = ...
    get_technique_parameters( [1, 3, 4], a0, A, B, [s1, s1, s2, s2] );
AGamma(3,:) = A(4, [1, 3, 4] );
BGamma(3,:) = B(4, [1, 3, 4] );

[a0Delta, ADelta, BDelta, SDelta] = ...
    get_technique_parameters( [1, 2, 3, 4], a0, A, B, [s1, s1, s2, s2] );

% Find polynomials for rational functions for each  feasible technique.
[fAlpha, gAlpha, numerAlpha] = get_rational_functionsN(a0Alpha, AAlpha, BAlpha, d(1:2, :), SAlpha);
% [fAlpha, gAlpha, numerAlpha] = get_rational_functions( a0Alpha, AAlpha, BAlpha, d(1:2, :), SAlpha);

[fBeta, gBeta, numerBeta] = get_rational_functionsN(a0Beta, ABeta, BBeta, d(1:3, :), SBeta);
[fGamma, gGamma, numerGamma] = get_rational_functionsN(a0Gamma, AGamma, BGamma, d(1:3, :), SGamma);
[fDelta, gDelta, numerDelta] = get_rational_functionsN(a0Delta, ADelta, BDelta, d, SDelta);

% Find the maximum rate of profits and wagde for the four techniques.
rMaxAlpha = get_r_max2( fAlpha );
rMaxBeta = get_r_max2( fBeta );
rMaxGamma = get_r_max2( fGamma );
rMaxDelta = get_r_max2( fDelta );

rMax = max( [ rMaxAlpha, rMaxBeta, rMaxGamma, rMaxDelta ] );

% These are the wage when r = 0. In models of pure fixed capital, wage curves
% can slope up off the frontier.
wMaxAlpha = get_maximum_wage( fAlpha, gAlpha );
wMaxBeta = get_maximum_wage( fBeta, gBeta );
wMaxGamma = get_maximum_wage( fGamma, gGamma );
wMaxDelta = get_maximum_wage( fDelta, gDelta );

% Start setting up the graph.
if (negativeOne == 1)
   rIncr = (rMax + 1)/(rIncrements - 1);
   rIncrAlpha = (rMaxAlpha + 1)/(rIncrements - 1);
   rIncrBeta = (rMaxBeta + 1)/(rIncrements - 1);
   rIncrGamma = (rMaxGamma + 1)/(rIncrements - 1);
   rIncrDelta = (rMaxDelta + 1)/(rIncrements - 1);
   rStart = -1.0;
else
   rIncr = rMax/(rIncrements - 1);
   rIncrAlpha = rMaxAlpha/(rIncrements - 1);
   rIncrBeta = rMaxBeta/(rIncrements - 1);
   rIncrGamma = rMaxGamma/(rIncrements - 1);
   rIncrDelta = rMaxDelta/(rIncrements - 1);
   rStart = 0.0;
end

% Check polynomials for prices
% Does not work except for specific sizes.
% check_prices( 0, rMaxAlpha, rIncrements, fAlpha, gAlpha, numerAlpha, ...
%       a0Alpha, AAlpha, BAlpha, d(1:2, :), SAlpha, 10^-4, 1, "Alpha");
% [rAlpha, wAlpha, priceAlpha, isok] = get_and_check_wage_curve( 0, rIncr, rIncrements, ...
%      fAlpha, gAlpha, numerAlpha, a0Alpha, AAlpha, BAlpha, ...
%      d(1:2, :), SAlpha, 10^-4, 1, "Alpha");
check_prices( 0, rMaxAlpha, rIncrements, fAlpha, gAlpha, numerAlpha, ...
       a0Alpha, AAlpha, BAlpha, d(1:2, :), SAlpha, 10^-4, 1, "Alpha");
check_prices( 0, rMaxBeta, rIncrements, fBeta, gBeta, numerBeta, ...
       a0Beta, ABeta, BBeta, d(1:3, :), SBeta, 10^-4, 1, "Beta");
check_prices( 0, rMaxGamma, rIncrements, fGamma, gGamma, numerGamma, ...
       a0Gamma, AGamma, BGamma, d(1:3, :), SGamma, 10^-4, 1, "Gamma");
check_prices( 0, rMaxDelta, rIncrements, fDelta, gDelta, numerDelta, ...
       a0Delta, ADelta, BDelta, d(1:3, :), SDelta, 10^-4, 1, "Delta");


% Get wage and price curves.
[rAlpha, wAlpha, priceAlpha] = get_wage_and_price_curves( ...
     rStart, rIncrAlpha, rIncrements, fAlpha, gAlpha, numerAlpha, 1 );
[rBeta, wBeta, priceBeta] = get_wage_and_price_curves( ...
     rStart, rIncrBeta, rIncrements, fBeta, gBeta, numerBeta, 1 );
[rGamma, wGamma, priceGamma] = get_wage_and_price_curves( ...
     rStart, rIncrGamma, rIncrements, fGamma, gGamma, numerGamma, 1 );
[rDelta, wDelta, priceDelta] = get_wage_and_price_curves( ...
     rStart, rIncrDelta, rIncrements, fDelta, gDelta, numerDelta, 1 );

% Echo parameters for each each feasible technique.
print_parameters_wrapper( a0Alpha, AAlpha, BAlpha, d(1:2, :), SAlpha, ...
    fAlpha, gAlpha, numerAlpha, "Alpha" );
print_parameters_wrapper( a0Beta, ABeta, BBeta, d(1:3, :), ...
     SBeta, fBeta, gBeta, numerBeta, "Beta" );
print_parameters_wrapper( a0Gamma, AGamma, BGamma, d(1:3, :), ...
    SGamma, fGamma, gGamma, numerGamma, "Gamma" );
print_parameters_wrapper( a0Delta, ADelta, BDelta, d, ...
    SDelta, fDelta, gDelta, numerDelta, "Delta" );

% Get switch points.
% First, look at intersections of wage curves.
% Alpha vs. Beta differ in that Beta operates the second process:
[nSwitchPoints1, switchPoints1] = get_switch_points( ...
    fAlpha, gAlpha, fBeta, gBeta, 0, min( rMaxAlpha, rMaxBeta ) );
wages1 = get_wages_for_switch_points(switchPoints1, fAlpha, gAlpha, rMaxAlpha, 1, "Alpha vs. Beta");
% Alpha vs. Gamma differ in that Gamma operates the fourth process:
[nSwitchPoints2, switchPoints2] = get_switch_points( ...
    fAlpha, gAlpha, fGamma, gGamma, 0, min( rMaxAlpha, rMaxGamma ) );
wages2 = get_wages_for_switch_points(switchPoints2, fAlpha, gAlpha, rMaxAlpha, 1, "Alpha vs. Gamma");
% A switch point betwee Alpha and Delta is also a switch point for both
% of the above.
% A switch point between Beta and Gamma is also a switch point for both
% of the above.
% Beta and Delta differ in the fourth process:
[nSwitchPoints3, switchPoints3] = get_switch_points( ...
    fBeta, gBeta, fDelta, gDelta, 0, min( rMaxBeta, rMaxDelta ) );
wages3 = get_wages_for_switch_points(switchPoints3, fBeta, gBeta, rMaxBeta, 1, "Beta vs. Delta");
% Gamma and Delta differ in the fourth process (must be the same as Beta vs, Delta):
[nSwitchPoints4, switchPoints4] = get_switch_points( ...
    fGamma, gGamma, fDelta, gDelta, 0, min( rMaxGamma, rMaxDelta ) );
wages4 = get_wages_for_switch_points(switchPoints4, fGamma, gGamma, rMaxGamma, 1, "Gamma vs. Delta");

% Concatenate the vectors for switch points.
% This is fine for graphing, but do not do this for other analyses.
switchPoints = [ switchPoints1, switchPoints2, switchPoints3, switchPoints4 ];
wagesForSwitchPoints = [ wages1, wages2, wages3, wages4 ];


% Graph.
if ( plotIndex == 1)
   % Plot wage curves.
   axes( 'FontSize', 15, 'Box', 'on', 'NextPlot', 'add' );
   hold on
   plot( 100*rAlpha, wAlpha, '-', 'color', 'black', 'LineWidth', 2 );
   plot( 100*rBeta, wBeta, '--', 'color', 'black', 'LineWidth', 2 );
   plot( 100*rGamma, wGamma, ':', 'color', 'black', 'LineWidth', 2 );
   plot( 100*rDelta, wDelta, '-.', 'color', 'black', 'LineWidth', 2 );


   if ( size(switchPoints, 2) > 0 )
     plot( 100*switchPoints, wagesForSwitchPoints, "oblack", 'MarkerFaceColor', 'black');
   endif

   xlabel( 'Rate of Profits (Percent)', 'FontWeight', 'bold', ...
       'FontSize', 20, 'FontName', 'Times New Roman');
   ylabel( 'Wage (Bushels per Person-Year)', 'FontWeight', 'bold', ...
       'FontSize', 20, 'FontName', 'Times New Roman');

   legendArray = [ 'Alpha'; 'Beta'; 'Gamma'; 'Delta' ];
   legend( legendArray, 'location', 'northeast' );

   hold off
elseif ( plotIndex == 2 )
   % Plot price of new machines
   axes( 'FontSize', 15, 'Box', 'on', 'NextPlot', 'add' );
   hold on
   plot( 100*rAlpha, priceAlpha(2, :), '-', 'color', 'black', 'LineWidth', 2 );
   plot( 100*rBeta, priceBeta(2, :), '--', 'color', 'black', 'LineWidth', 2 );
   plot( 100*rGamma, priceGamma(2, :), ':', 'color', 'black', 'LineWidth', 2 );
   plot( 100*rDelta, priceDelta(2, :), '-.', 'color', 'black', 'LineWidth', 2 );

   % TO DO: Think of plotting switch points here.

   % if ( size(switchPoints, 2) > 0 )
   %   plot( 100*switchPoints, wagesForSwitchPoints, "oblack", 'MarkerFaceColor', 'black');
   % endif

   xlabel( 'Rate of Profits (Percent)', 'FontWeight', 'bold', ...
       'FontSize', 20, 'FontName', 'Times New Roman');
   ylabel( 'Price of new machines (Bushels per Machine)', 'FontWeight', 'bold', ...
       'FontSize', 20, 'FontName', 'Times New Roman');

   legendArray = [ 'Alpha'; 'Beta'; 'Gamma'; 'Delta' ];
   legend( legendArray, 'location', 'northeast' );

   hold off
elseif ( plotIndex == 3 )
   % Plot price of old machines in machine production.
   axes( 'FontSize', 15, 'Box', 'on', 'NextPlot', 'add' );
   hold on
   plot( 100*rBeta, priceBeta(3, :), '--', 'color', 'black', 'LineWidth', 2 );
   plot( 100*rDelta, priceDelta(3, :), '-.', 'color', 'black', 'LineWidth', 2 );

   % Truncation of Beta results in Alpha. Recall that switchPoints1 is for Alpha vs. Beta.
   if ( size(switchPoints1, 2) > 0 )
     priceSwitchPoints1 = get_price_curve( switchPoints1, numerBeta(:, 3), gBeta, rMaxBeta);
     plot( 100*switchPoints1, priceSwitchPoints1, "oblack", 'MarkerFaceColor', 'black');
   endif

   % Truncation of Delta in machine production results in Gamma. Recall that switchPoints4
   % is for Gamma vs. Delta.
   if ( size(switchPoints4, 2) > 0 )
     priceSwitchPoints4 = get_price_curve( switchPoints4, numerDelta(:, 3), gDelta, rMaxDelta);
     plot( 100*switchPoints4, priceSwitchPoints4, "oblack", 'MarkerFaceColor', 'black');
   endif

   xlabel( 'Rate of Profits (Percent)', 'FontWeight', 'bold', ...
       'FontSize', 20, 'FontName', 'Times New Roman');
   % ylabel( 'Price of one-year old machines in machine-production (Bushels per Machine)', 'FontWeight', 'bold', ...
   %    'FontSize', 20, 'FontName', 'Times New Roman');
   ylabel( 'Price of machines in machine-production', 'FontWeight', 'bold', ...
       'FontSize', 20, 'FontName', 'Times New Roman');

   legendArray = [ 'Beta'; 'Delta' ];
   legend( legendArray, 'location', 'northeast' );

   hold off
elseif ( plotIndex == 4 )
   % Plot price of old machines in corn production.
   axes( 'FontSize', 15, 'Box', 'on', 'NextPlot', 'add' );
   hold on
   plot( 100*rGamma, priceGamma(3, :), ':', 'color', 'black', 'LineWidth', 2 );
   plot( 100*rDelta, priceDelta(4, :), '-.', 'color', 'black', 'LineWidth', 2 );

   % Truncation of Gamma results in Alpha. Recall that switchPoints2 is for Alpha vs. Gamma.
   if ( size(switchPoints2, 2) > 0 )
     priceSwitchPoints2 = get_price_curve( switchPoints2, numerGamma(:, 3), gGamma, rMaxGamma);
     plot( 100*switchPoints2, priceSwitchPoints2, "oblack", 'MarkerFaceColor', 'black');
   endif

   % Truncation of Delta in corn production results in Beta. Recall that switchPoints3
   % is for Gamma vs. Delta.
   if ( size(switchPoints3, 2) > 0 )
     priceSwitchPoints3 = get_price_curve( switchPoints3, numerDelta(:, 4), gDelta, rMaxDelta);
     plot( 100*switchPoints3, priceSwitchPoints3, "oblack", 'MarkerFaceColor', 'black');
   endif

   xlabel( 'Rate of Profits (Percent)', 'FontWeight', 'bold', ...
       'FontSize', 20, 'FontName', 'Times New Roman');
   % ylabel( 'Price of one-year old machines in corn-production (Bushels per Machine)', 'FontWeight', 'bold', ...
   %    'FontSize', 20, 'FontName', 'Times New Roman');
   ylabel( 'Price of old machines in corn-production', 'FontWeight', 'bold', ...
       'FontSize', 20, 'FontName', 'Times New Roman');

   legendArray = [ 'Gamma'; 'Delta' ];
   legend( legendArray, 'location', 'northeast' );

   hold off
endif

printf("\n");
printf( "Maximum rate of profits: Alpha: %3.8f, Beta: %3.8f, Gamma: %3.8f, Delta: %3.8f\n", ...
  100*rMaxAlpha, 100*rMaxBeta, 100*rMaxGamma, 100*rMaxDelta );
printf( "Maximum wage: Alpha: %3.8f, Beta: %3.8f, Gamma: %3.8f, Delta: %3.8f\n", ...
   wMaxAlpha, wMaxBeta, wMaxGamma, wMaxDelta );
printf("\n");
printf( "A(1, 2): %3.12f, Alpha vs Beta: %3.12f, Alpha vs Gamma: %3.12f, Difference: %3.12f\n", ...
   A(1,2), 100*switchPoints1(1), 100*switchPoints2(1),  100*(switchPoints1(1) - switchPoints2(1)) );
% slope = ( (100*(switchPoints1(1) - switchPoints2(1))) - oldY)/(A(1,2) - oldX )
% intercept = oldY - slope*oldX
% next = -intercept/slope
% printf( "%3.16f\n", next );

[qAlpha, isAlphaFeasible] = get_quantity_flows([1;0], 0, a0Alpha, AAlpha, BAlpha, 1);
[qBeta, isBetaFeasible] = get_quantity_flows([1;0;0], 0, a0Beta, ABeta, BBeta, 1);
[qGamma, isGammaFeasible] = get_quantity_flows([1;0;0], 0, a0Gamma, AGamma, BGamma, 1);
[qDelta, isDeltaFeasible] = get_quantity_flows([1;0;0;0], 0, a0Delta, ADelta, BDelta, 1);





