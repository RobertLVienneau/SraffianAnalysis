% An example of fixed capital.

% The eaxmple is from the appendix in:
%   Baldone, Salvatore (1974), Il capitale fisso nello schema teorico di Piero Sraffa, Studi Economici,
%      XXIV(1): 45-106. Trans. in Pasinetti (1980).
%   Pasinetti, Luigi L., (1980) (ed.), Essays on the Theory of Joint Production, New York,
%      Columbia University Press.
%
% 0 < r < 4.0664 %        Alpha cost-minimizing.
% 4.0664 % < r < 55.66%   Gamma cost-minimizing
% 55.66 % < r < 62.73 %   Beta cost-minimiing
% 62.73 %  r < 74.2 %     Alpha cost-minimizing.
%
    s1 = 1;
    s2 = 1;

    % 1, if to plot wages; 2, if to plot prices of new machines;
    %    3 if to plot prices of 1-yr old machines; 4, if to plot prices of 2-yr old machines.
    plotIndex = 2;

    a0 = [2/5, 1/5, 3/5, 2/5];

    A =[[1/10, 2/5, 289/500, 3/5]; ...
        [0, 1, 0, 0]; ...
        [0, 0, 1, 0]; ...
        [0, 0, 0, 1]];

    B = [[0, 1, 1, 1]; ...
         [1, 0, 0, 0]; ...
         [0, 1, 0, 0]; ...
         [0, 0, 1, 0]];

    S = [[s1, 0, 0, 0]; ...
         [0, s2, 0, 0]; ...
         [0, 0, s2, 0]; ...
         [0, 0, 0, s2]];

     d = [1;0;0;0];


% Number of increments to use when plotting wage curves.
rIncrements = 200;
% Start with -1? Then 1. Start with 0? Then 0;
negativeOne = 0;


% Define Alpha, Beta, Gamma techniques.
[a0Alpha, AAlpha, BAlpha, SAlpha] = ...
    get_technique_parameters( [1, 2], a0, A, B, [s1, s2] );
[a0Beta, ABeta, BBeta, SBeta] = ...
    get_technique_parameters( [1, 2, 3], a0, A, B, [s1, s2, s2] );
[a0Gamma, AGamma, BGamma, SGamma] = ...
    get_technique_parameters( [1, 2, 3, 4], a0, A, B, [s1, s2, s2, s2] );

% Find polynomials for rational functions for each technique.
[fAlpha, gAlpha, numerAlpha] = get_rational_functions( a0Alpha, AAlpha, BAlpha, d, SAlpha);
[fBeta, gBeta, numerBeta] = get_rational_functions( a0Beta, ABeta, BBeta, d, SBeta);
[fGamma, gGamma, numerGamma] = get_rational_functions( a0Gamma, AGamma, BGamma, d, SGamma);

% Find the maximum rate of profits for the techniques.
rMaxAlpha = get_r_max2( fAlpha );
rMaxBeta = get_r_max2( fBeta );
rMaxGamma = get_r_max2( fGamma );

rMax = max( [rMaxAlpha, rMaxBeta, rMaxGamma] );

% Get maximum wages.
wMaxAlpha = get_maximum_wage( fAlpha, gAlpha );
wMaxBeta = get_maximum_wage( fBeta, gBeta );
wMaxGamma = get_maximum_wage( fGamma, gGamma );

% Check polynomials for prices
check_prices( 0, rMaxAlpha, rIncrements, fAlpha, gAlpha, numerAlpha, ...
    a0Alpha, AAlpha, BAlpha, d, SAlpha, 10^-4, 1, "Alpha");
check_prices( 0, rMaxBeta, rIncrements, fBeta, gBeta, numerBeta, ...
    a0Beta, ABeta, BBeta, d, SBeta, 10^-4, 1, "Beta");
check_prices( 0, rMaxGamma, rIncrements, fGamma, gGamma, numerGamma, ...
    a0Gamma, AGamma, BGamma, d, SGamma, 10^-4, 1, "Gamma");

% Echo parameters for each technique.
print_parameters_wrapper( a0Alpha, AAlpha, BAlpha, d, SAlpha, fAlpha, gAlpha, numerAlpha, "Alpha" );
print_parameters_wrapper( a0Beta, ABeta, BBeta, d, SBeta, fBeta, gBeta, numerBeta, "Beta" );
print_parameters_wrapper( a0Gamma, AGamma, BGamma, d, SGamma, fGamma, gGamma, numerGamma, "Gamma" );

% Get switch points..
% Alpha and Beta differ in the third process.
switchPoints1 = get_switch_points_from_prices( fAlpha, gAlpha, numerAlpha, d, S(3,3), ......
     a0Beta(3), ABeta(:,3), BBeta(:,3), 0, min( rMaxAlpha, rMaxBeta ) );
% Switch point for Alpha and Gamma is found as intersections of the wage curves.
% Presumably this uses a numeric method built into octave.
% TODO: Find switch points at which price of 1-year old machine is
%  zero in Gamma price system.
[nSwitchPoints2, switchPoints2] = get_switch_points( ...
    fAlpha, gAlpha, fGamma, gGamma, 0, min( rMaxAlpha, rMaxGamma ) );
% Beta and Gamma differ in the fourth porcess.
switchPoints3 = get_switch_points_from_prices( fBeta, gBeta, numerBeta, d, S(4,4), ......
     a0Gamma(4), AGamma(:,4), BGamma(:,4), 0, min( rMaxBeta, rMaxGamma ) );

wages1 = get_wages_for_switch_points(switchPoints1, fAlpha, gAlpha, rMaxAlpha, 1, "Alpha vs. Beta");
wages2 = get_wages_for_switch_points(switchPoints2, fAlpha, gAlpha, rMaxAlpha, 1, "Alpha vs. Gamma");
wages3 = get_wages_for_switch_points(switchPoints3, fBeta, gBeta, rMaxBeta, 1, "Beta vs. Gamma");

% Concatenate the vectors for switch points.
% This is fine for graphing, but do not do this for other analyses.
switchPoints = [ switchPoints1, switchPoints2, switchPoints3 ];
wagesForSwitchPoints = [ wages1, wages2, wages3 ];


% Start setting up the graph.
if (negativeOne == 1)
   rIncr = (rMax + 1)/(rIncrements - 1);
   rStart = -1.0;
else
   rIncr = rMax/(rIncrements - 1);
   rStart = 0.0;
end


[ rAlpha, wAlpha ] = get_wage_curve( rStart, rIncr, rIncrements, fAlpha, gAlpha, rMaxAlpha );
[ rBeta, wBeta ] = get_wage_curve( rStart, rIncr, rIncrements, fBeta, gBeta, rMaxBeta );
[ rGamma, wGamma ] = get_wage_curve( rStart, rIncr, rIncrements, fGamma, gGamma, rMaxGamma );


if ( plotIndex == 1)
   % Plot wage curves.
   axes( 'FontSize', 15, 'Box', 'on', 'NextPlot', 'add' );
   hold on
   % TODO: Remove hard-coding of indices for positive(?) elements.
   plot( 100*rAlpha, wAlpha, '-', 'color', 'black', 'LineWidth', 2 );
   plot( 100*rBeta(1:rIncrements - 1), wBeta(1:rIncrements - 1), ...
      '--', 'color', 'black', 'LineWidth', 2 );
   plot( 100*rGamma(1:rIncrements - 4), wGamma(1:rIncrements - 4), ...
       ':', 'color', 'black', 'LineWidth', 2 );

   if ( size(switchPoints, 2) > 0 )
     plot( 100*switchPoints, wagesForSwitchPoints, "oblack", 'MarkerFaceColor', 'black');
   endif

   xlabel( 'Rate of Profits (Percent)', 'FontWeight', 'bold', ...
       'FontSize', 20, 'FontName', 'Times New Roman');
   ylabel( 'Wage (Busheles per Person-Year)', 'FontWeight', 'bold', ...
       'FontSize', 20, 'FontName', 'Times New Roman');

   legendArray = [ 'Alpha'; 'Beta'; 'Gamma' ];
   legend( legendArray, 'location', 'northeast' );

   hold off
elseif ( plotIndex == 2)
   % Plot prices of new machines.
   priceAlpha = get_price_curve( rAlpha, numerAlpha(:, 2), gAlpha, rMaxAlpha);
   priceBeta = get_price_curve( rBeta, numerBeta(:, 2), gBeta, rMaxBeta);
   priceGamma = get_price_curve( rGamma, numerGamma(:, 2), gGamma, rMaxGamma);

   priceSwitchPoints1 = get_price_curve( switchPoints1, numerBeta(:, 2), gBeta, rMaxBeta);
   priceSwitchPoints2 = get_price_curve( switchPoints2, numerGamma(:, 2), gGamma, rMaxGamma);

   % Plot price curves.
   axes( 'FontSize', 15, 'Box', 'on', 'NextPlot', 'add' );
   hold on
   % ylim( [0.0, max([priceAlpha(1,1), priceBeta(1,1), priceGamma(1,1)])] );
   ylim( [0.0, 0.5] );
   % TODO: Remove hard-coding of indices for positive elements.
   plot( 100*rAlpha(1:rIncrements - 1), priceAlpha(1:rIncrements - 1), ...
     '-', 'color', 'black', 'LineWidth', 2 );
   plot( 100*rBeta(1:rIncrements - 1), priceBeta(1:rIncrements - 1), '--', 'color', 'black', 'LineWidth', 2 );
   plot( 100*rGamma(1:rIncrements - 4), priceGamma(1:rIncrements - 4), ':', 'color', 'black', 'LineWidth', 2 );

   if ( size(switchPoints1, 2) > 0 )
     plot( 100*switchPoints1, priceSwitchPoints1, "oblack", 'MarkerFaceColor', 'black');
   endif
   if ( size(switchPoints2, 2) > 0 )
     plot( 100*switchPoints2, priceSwitchPoints2, "oblack", 'MarkerFaceColor', 'black');
   endif

   legendArray = [legendArray; 'Zeta' ];

   xlabel( 'Rate of Profits (Percent)', 'FontWeight', 'bold', ...
       'FontSize', 20, 'FontName', 'Times New Roman');
   ylabel( 'Price of new machines (Busheles per Machine)', 'FontWeight', 'bold', ...
       'FontSize', 20, 'FontName', 'Times New Roman');

   legendArray = [ 'Alpha'; 'Beta'; 'Gamma' ];
   legend( legendArray, 'location', 'northeast' );

   hold off

elseif (plotIndex == 3)
   % Plot prices of 1-yr old machines for Beta and Gamma
   priceBeta = get_price_curve( rBeta, numerBeta(:, 3), gBeta, rMaxBeta);
   priceGamma = get_price_curve( rGamma, numerGamma(:, 3), gGamma, rMaxGamma);

   priceSwitchPoints1 = get_price_curve( switchPoints1, numerBeta(:, 3), gBeta, rMaxBeta);
   priceSwitchPoints2 = get_price_curve( switchPoints2, numerGamma(:, 3), gAlpha, rMaxAlpha);
   % priceSwitchPoints3 = get_price_curve( switchPoints3, numerGamma(:, 3), gGamma, rMaxGamma);

   % Plot price curves.
   axes( 'FontSize', 15, 'Box', 'on', 'NextPlot', 'add' );
   hold on
   % TODO: Remove hard-coding of indices for positive(?) elements.
   plot( 100*rBeta(1:rIncrements - 1), priceBeta(1:rIncrements - 1), ...
       '--', 'color', 'black', 'LineWidth', 2 );
   plot( 100*rGamma(1:rIncrements - 4), priceGamma(1:rIncrements - 4), ...
      ':', 'color', 'black', 'LineWidth', 2 );

   if ( size(switchPoints1, 2) > 0 )
     plot( 100*switchPoints1, priceSwitchPoints1, "oblack", 'MarkerFaceColor', 'black');
   endif
   if ( size(switchPoints2, 2) > 0 )
     plot( 100*switchPoints2, priceSwitchPoints2, "oblack", 'MarkerFaceColor', 'black');
   endif
   % if ( size(switchPoints3, 2) > 0 )
   %   plot( 100*switchPoints3, priceSwitchPoints3, "oblack", 'MarkerFaceColor', 'black');
   % endif

   xlabel( 'Rate of Profits (Percent)', 'FontWeight', 'bold', ...
       'FontSize', 20, 'FontName', 'Times New Roman');
   ylabel( 'Price of one-year old machines (Busheles per Machine)', 'FontWeight', 'bold', ...
       'FontSize', 20, 'FontName', 'Times New Roman');

   legendArray = [ 'Beta'; 'Gamma' ];
   legend( legendArray, 'location', 'northeast' );

   hold off

elseif (plotIndex == 4)
   % Plot prices of 2-yr old machines for Gamma
   priceGamma = get_price_curve( rGamma, numerGamma(:, 4), gGamma, rMaxGamma);

   % priceSwitchPoints2 = get_price_curve( switchPoints2, numerGamma(:, 4), gGamma, rMaxGamma);
   priceSwitchPoints3 = get_price_curve( switchPoints3, numerGamma(:, 4), gGamma, rMaxGamma);

   % Plot price curves.
   axes( 'FontSize', 15, 'Box', 'on', 'NextPlot', 'add' );
   hold on
   % TODO: Remove hard-coding of indices for positive(?) elements.
   plot( 100*rGamma(1:rIncrements - 4), priceGamma(1:rIncrements - 4), ...
      ':', 'color', 'black', 'LineWidth', 2 );

   % if ( size(switchPoints2, 2) > 0 )
   %  plot( 100*switchPoints2, priceSwitchPoints2, "oblack", 'MarkerFaceColor', 'black');
   % endif
   if ( size(switchPoints3, 2) > 0 )
     plot( 100*switchPoints3, priceSwitchPoints3, "oblack", 'MarkerFaceColor', 'black');
   endif

   xlabel( 'Rate of Profits (Percent)', 'FontWeight', 'bold', ...
       'FontSize', 20, 'FontName', 'Times New Roman');
   ylabel( 'Price of two-year old machines (Busheles per Machine)', 'FontWeight', 'bold', ...
       'FontSize', 20, 'FontName', 'Times New Roman');

   legendArray = [ 'Gamma' ];
   legend( legendArray, 'location', 'northeast' );

   hold off
endif

printf( "Maximum rate of profits for Alpha: %3.12f percent\n", 100*rMaxAlpha );
printf( "Maximum rate of profits for Beta: %3.12f percent\n", 100*rMaxBeta );
printf( "Maximum rate of profits for Gamma: %3.12f percent\n", 100*rMaxGamma );

printf( "Let net output be 1 bushel corn\n");
printf( "  Employment under Alpha: %3.12f\n", a0Alpha*inv( BAlpha - AAlpha )*[1;0] );
printf( "  Employment under Beta: %3.12f\n", a0Beta*inv( BBeta - ABeta )*[1;0;0] );
printf( "  Employment under Gamma: %3.12f\n", a0Gamma*inv( BGamma - AGamma )*[1;0;0;0] );



