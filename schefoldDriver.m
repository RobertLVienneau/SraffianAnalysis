% Code for analyzing the choice of technique in a triple switching example.

clear all

%
% schefieldDriver.m
%
% TODO: Write subroutines
%    To check Hawkins-Simon conditions.
%    To solve for switch points
%    To find maximum wage
%    To find fluke cases
%    To do all of these for 4-commodity model. Octave seems to be able
%      to find roots for 5th degree polynomial.
%    To find a0, A, B for Corn-Tractor model? To do all of these for this model?


s1 = 1/2;        % Markup in machine industry.
% s1 = 0.495114006515;
% s1 = 0.497971149500;
% s1 = 0.500731966063;
s2 = 1 - s1;   % Markup in corn industry.

% s1 = 1;
% s2 = 1;

% Notes:
%    s1     Number of switch points (Between Alpha and Gamma)
%    0.495     0
%    0.4951140006514   0   The switch point is on the axis for the rate of profits.
%    0.4951141 1
%    0.496     1
%    0.497     1
%    0.497971149499     1   Wage curves tangent at repeated switch point.
%    0.4979711495  3
%    0.498     3
%    0.499     3
%    0.5       3
%    0.500731966063   3    Wage curves tangent at repeated switch point.
%    0.500731966064   1
%    0.501     1
%    0.502     1
%    0.6       1
%    0.7       1
%    0.9       1     I never have a switch point on the wage axis.
%    0.999     1


a0Alpha = [1];
AAlpha = [1/2];
BAlpha = [1];
SAlpha = [s2];

a0Beta = [3/140, 1];
ABeta = [[31/504, 1/4]; ...
     [0, 1]];
BBeta = [[0, 1/2]; ...
   [1, 0]];
SBeta = [[s1, 0]; ...
      [0, s2]];

a0Gamma = [3/140, 1, 1/3];
AGamma = [[31/504, 1/4, 2/315]; ...
      [0, 1, 0]; ...
      [0, 0, 1]];
BGamma = [[0, 1/2, 1/2]; ...
   [1, 0, 0]; ...
   [0, 1, 0]];
SGamma = [[s1, 0, 0]; ...
        [0, s2, 0]; ...
        [0, 0, s2]];

% Numeraire
dAlpha = [1];
dBeta = [1; 0];
dGamma = [1;0; 0];


% Number of increments to use when plotting wage curves.
rIncrements = 200;
% rIncrements = 5;
% Start with -1? Then 1. Start with 0? Then 0;
% negativeOne = 1;
negativeOne = 0;



% Find polynomials for rational functions for each echnique.
[fAlpha, gAlpha, uAlpha] = get_rational_functions1( a0Alpha, AAlpha, BAlpha, dAlpha, SAlpha);
[fBeta, gBeta, uBeta, vBeta] = get_rational_functions2( a0Beta, ABeta, BBeta, dBeta, SBeta);
[fGamma, gGamma, tGamma, uGamma, vGamma] = get_rational_functions3( a0Gamma, AGamma, BGamma, dGamma, SGamma);


% Find the maximum rate of profits for the three techniques.
rMaxAlpha = get_r_max2( fAlpha );
rMaxBeta = get_r_max2( fBeta );
rMaxGamma = get_r_max2( fGamma );

% rMaxAlpha - rMaxBeta;

rMax = max( [rMaxAlpha, rMaxBeta, rMaxGamma] );

% Get maximum wages. TO DO: echo these out.
wMaxAlpha = get_maximum_wage( fAlpha, gAlpha );
wMaxBeta = get_maximum_wage( fBeta, gBeta );
wMaxGamma = get_maximum_wage( fGamma, gGamma );

% Check polynomials for prices.
if ~ check_prices1( 0, rMaxAlpha, rIncrements, fAlpha, gAlpha, uAlpha, ...
    a0Alpha, AAlpha, BAlpha, dAlpha, SAlpha, 10^-4)
    printf( "Error in finding rational functions for Alpha!\n");
    % quit(1);
end

if ~ check_prices2( 0, rMaxBeta, rIncrements, fBeta, gBeta, uBeta, vBeta, ...
    a0Beta, ABeta, BBeta, dBeta, SBeta, 10^-4)
    printf( "Error in finding rational functions for Beta!\n");
    % quit(1);
end

if ~ check_prices3( 0, rMaxGamma, rIncrements, fGamma, gGamma, tGamma, uGamma, vGamma, ...
    a0Gamma, AGamma, BGamma, dGamma, SGamma, 10^-4)
    printf( "Error in finding rational functions for Gamma!\n");
    % quit(1);
end

printf( "\n\nParameters for Alpha price system:\n" );
print_price_parameters( 1, a0Alpha, AAlpha, BAlpha, dAlpha, SAlpha );
printf( "\nRational functions for Alpha:\n" );
print_price_functions(1, fAlpha, gAlpha, [uAlpha'] );

printf( "\n\nParameters for Beta price system:\n" );
print_price_parameters( 2, a0Beta, ABeta, BBeta, dBeta, SBeta );
printf( "\nRational functions for Beta:\n" );
print_price_functions(2, fBeta, gBeta, [uBeta', vBeta' ] );

printf( "\n\nParameters for Gamma price system:\n" );
print_price_parameters( 3, a0Gamma, AGamma, BGamma, dGamma, SGamma );
printf( "\nRational functions for Gamma:\n" );
print_price_functions(3, fGamma, gGamma, [tGamma', uGamma', vGamma' ] );

% Get switch points.
[nSwitchPoints1, switchPoints1] = get_switch_points( ...
    fAlpha, gAlpha, fBeta, gBeta, 0, min( rMaxAlpha, rMaxBeta ) );
[nSwitchPoints2, switchPoints2] = get_switch_points( ...
    fAlpha, gAlpha, fGamma, gGamma, 0, min( rMaxAlpha, rMaxGamma ) );
[nSwitchPoints3, switchPoints3] = get_switch_points( ...
    fBeta, gBeta, fGamma, gGamma, 0, min( rMaxBeta, rMaxGamma ) );

wagesForSwitchPoint1 = zeros(1, nSwitchPoints1 );
if ( nSwitchPoints1 == 0)
     printf( "No Switch Points Exist for Alpha and Beta\n" );
else
     printf( "\nSwitch Points for Alpha and Beta\n" );
     for idx = 1:1:nSwitchPoints1
         wagesForSwitchPoint1( idx ) = get_wage_rational( ...
             switchPoints1( idx ), fAlpha, gAlpha, rMaxAlpha );

         printf( "  Rate of profits: %f,  Wage: %f\n", ...
            switchPoints1(idx), wagesForSwitchPoint1(idx) );
      endfor
endif

wagesForSwitchPoint2 = zeros(1, nSwitchPoints2 );
if ( nSwitchPoints2 == 0)
     printf( "No Switch Points Exist for Alpha and Gamma\n" );
else
     printf( "\nSwitch Points for Alpha and Gamma\n" );
     for idx = 1:1:nSwitchPoints2
         wagesForSwitchPoint2( idx ) = get_wage_rational( ...
             switchPoints2( idx ), fAlpha, gAlpha, rMaxAlpha );

         printf( "  Rate of profits: %f,  Wage: %f\n", ...
            switchPoints2(idx), wagesForSwitchPoint2(idx) );
      endfor
endif

wagesForSwitchPoint3 = zeros(1, nSwitchPoints3 );
if ( nSwitchPoints3 == 0)
     printf( "No Switch Points Exist for Beta and Gamma\n" );
else
     printf( "\nSwitch Points for Beta and Gamma\n" );
     for idx = 1:1:nSwitchPoints3
         wagesForSwitchPoint3( idx ) = get_wage_rational( ...
             switchPoints3( idx ), fBeta, gBeta, rMaxBeta );

         printf( "  Rate of profits: %f,  Wage: %f\n", ...
            switchPoints3(idx), wagesForSwitchPoint3(idx) );
      endfor
endif

%
if (negativeOne == 1)
   rIncr = (rMax + 1)/(rIncrements - 1);
else
   rIncr = rMax/(rIncrements - 1);
end

% Find vector of wages for plotting.
rr = zeros(1, rIncrements );
wagesAlpha = zeros(1, rIncrements);
wagesBeta = zeros(1, rIncrements);
wagesGamma = zeros(1, rIncrements);

% Can I replace for loop with some sort of vector operation?
for idx=1:1:rIncrements
  % Find rate of profits.
  if (negativeOne == 1)
       r = -1 + rIncr*(idx - 1);
    else
       r = rIncr*(idx - 1);
  endif
  rr( idx ) = r;
  % Find corresponding wage for Alpha for the rate of profits.
  % wagesAlpha( idx ) = get_wage( r, a0Alpha, AAlpha, BAlpha, SAlpha, dAlpha, rMaxAlpha );
  wagesAlpha( idx ) = get_wage_rational( r, fAlpha, gAlpha, rMaxAlpha );

  % Find corresponding wage for ABeta for the rate of profits.
  % wagesBeta( idx ) = get_wage( r, a0Beta, ABeta, BBeta, SBeta, dBeta, rMaxBeta );
  wagesBeta( idx ) = get_wage_rational( r, fBeta, gBeta, rMaxBeta );

  % Find corresponding wage for Gamma for the rate of profits.
  % wagesGamma( idx ) = get_wage( r, a0Gamma, AGamma, BGamma, SGamma, dGamma, rMaxGamma );
  wagesGamma( idx ) = get_wage_rational( r, fGamma, gGamma, rMaxGamma );
endfor


% Get rid of trailing zeros for each each curve to plot.
idx = 1;
while ( ( wagesAlpha(idx) > 0 ) && ( idx < size( wagesAlpha,2 ) ) )
  idx = idx + 1;
endwhile
rAlpha = rr( 1:idx );
wagesAlpha = wagesAlpha(1:idx);

idx = 1;
while ( ( wagesBeta(idx) > 0 ) && ( idx < size( wagesBeta,2 ) ) )
  idx = idx + 1;
endwhile
rBeta = rr( 1:idx );
wagesBeta = wagesBeta(1:idx);

idx = 1;
while ( ( wagesGamma(idx) > 0 ) && ( idx < size( wagesGamma,2 ) ) )
  idx = idx + 1;
endwhile
rGamma = rr( 1:idx );
wagesGamma = wagesGamma(1:idx);


% Plot wage curves.
axes( 'FontSize', 15, 'Box', 'on', 'NextPlot', 'add' );
hold on
plot( 100*rAlpha, wagesAlpha, 'blue', 'LineWidth', 2 );
plot( 100*rBeta, wagesBeta, 'red', 'LineWidth', 2 );
plot( 100*rGamma, wagesGamma, 'green', 'LineWidth', 2 );
if (nSwitchPoints1 > 0)
    plot( 100*switchPoints1, wagesForSwitchPoint1, "oblack", 'MarkerFaceColor', 'black');
endif
if (nSwitchPoints2 > 0)
    plot( 100*switchPoints2, wagesForSwitchPoint2, "oblack", 'MarkerFaceColor', 'black');
endif
if (nSwitchPoints3 > 0)
    plot( 100*switchPoints3, wagesForSwitchPoint3, "oblack", 'MarkerFaceColor', 'black');
endif
xlabel( 'Rate of Profits (Percent)', 'FontWeight', 'bold', ...
   'FontSize', 20, 'FontName', 'Times New Roman');
ylabel( 'Wage (Busheles per Person-Year)', 'FontWeight', 'bold', ...
    'FontSize', 20, 'FontName', 'Times New Roman');

legendArray = [ 'Alpha'; 'Beta'; 'Gamma'; ];
legend( legendArray, 'location', 'northeast' );
hold off

% % Plot difference between wage curves
% plot( rr, wagesBeta - wagesAlpha, 'blue' );
% hold on
% xlabel( 'Rate of Profits (Percent)' );
% ylabel( 'Difference in Wage (Busheles per Person-Year)' );
% hold off

printf( "\n" );
printf( "s1,max r Alpha (percent),max r Gamma (percent), r (percent), r (percent), r (percent), max w Alpha, max w Gamma, w1, w2, w3\n");

   if ( nSwitchPoints2 == 0 )
      printf( "%1.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f\n", ...
         s1, 100*rMaxAlpha, 100*rMaxGamma, 1/0, 1/0, 1/0, wMaxAlpha, wMaxGamma, ...
            1/0, 1/0, 1/0);
   elseif ( nSwitchPoints2 == 1 )
      printf( "%1.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f\n", ...
         s1, 100*rMaxAlpha, 100*rMaxGamma, 100*switchPoints2(1), 1/0, 1/0, wMaxAlpha, wMaxGamma, ...
            wagesForSwitchPoint2(1), 1/0, 1/0);
   elseif ( nSwitchPoints2 == 2 )
      printf( "%1.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f\n", ...
         s1, 100*rMaxAlpha, 100*rMaxGamma, 100*switchPoints2(1), 100*switchPoints2(2), 1/0, wMaxAlpha, wMaxGamma, ...
            wagesForSwitchPoint2(1), wagesForSwitchPoint2(2), 1/0);
   elseif ( nSwitchPoints2 == 3 )
      printf( "%1.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f\n", ...
         s1, 100*rMaxAlpha, 100*rMaxGamma, 100*switchPoints2(1), 100*switchPoints2(2), 100*switchPoints2(3), ...
           wMaxAlpha, wMaxGamma, wagesForSwitchPoint2(1), wagesForSwitchPoint2(2), wagesForSwitchPoint2(3));
   endif



