% Code for analyzing the choice of technique.
clear all

% For exploring Harrod-neutral technical progress in Alpha and Delta.
theta = 0.8;   % For Alpha
phi = 0.096;     % For Delta
t = 0.36344039;

% Specify relative markups.
% s1 = 0.5;
% s2 = 1 - s1;

s1 = 1;
s2 = 1;

% For graph in my paper:
% s1 = 4/5;
% s2 = 28/25;

S = [[s1, 0]; ...
   [0, s2]];

% Specify technology from which to select techniques.
% The followingextends an example from Bruno, Burmeister & Sheshinski (1966)
a0 = [1*exp(1 - theta*t), (2/5)*exp(1 - phi*t), (33/50)*exp(1 - theta*t), (1/100)*exp(1 - phi*t)];
A = [[ 0, 1/3, 1/50, 71/100] ; ...
      [ 1/10, 1/20, 3/10, 0]];
B =[[1, 1, 0, 0];
     [0, 0, 1, 1]];

% The following is from my ROPE 2024 article:
% a0 = [1*exp(1 - theta*t), 275/464*exp(1 - phi*t), 1*exp(1 - theta*t), 1*exp(1 - phi*t)];
% A = [[ 1/10, 113/232, 2, 1/2] ; ...
%      [ 1/40, 0, 2/5, 3/5]];
% B =[[1, 1, 0, 0];
%    [0, 0, 1, 1]];

% The second commodity is the numeraire.
d = [0;1];

% Define Alpha, Beta, Gamma, Delta

a0Alpha = [a0(1), a0(3)];
AAlpha = [A(:,1), A(:,3)];
BAlpha = [B(:,1), B(:,3)];

a0Beta = [a0(1), a0(4)];
ABeta = [A(:,1), A(:,4)];
BBeta = [B(:,1), B(:,4)];

a0Gamma = [a0(2), a0(3)];
AGamma = [A(:,2), A(:,3)];
BGamma = [B(:,2), B(:,3)];

a0Delta = [a0(2), a0(4)];
ADelta = [A(:,2), A(:,4)];
BDelta = [B(:,2), B(:,4)];

% Number of increments to use when plotting wage curves.
rIncrements = 200;
% Start with -1? Then 1. Start with 0? Then 0;
negativeOne = 0;

% ------------------------

% Find polynomials for rational functions for each echnique.
[fAlpha, gAlpha, uAlpha, vAlpha] = get_rational_functions2( a0Alpha, AAlpha, BAlpha, d, S);
[fBeta, gBeta, uBeta, vBeta] = get_rational_functions2( a0Beta, ABeta, BBeta, d, S);
[fGamma, gGamma, uGamma, vGamma] = get_rational_functions2( a0Gamma, AGamma, BGamma, d, S);
[fDelta, gDelta, uDelta, vDelta] = get_rational_functions2( a0Delta, ADelta, BDelta, d, S);

% Find the maximum rate of profits for the techniques.
rMaxAlpha = get_r_max2( fAlpha );
rMaxBeta = get_r_max2( fBeta );
rMaxGamma = get_r_max2( fGamma );
rMaxDelta = get_r_max2( fDelta );

rMax = max( [rMaxAlpha, rMaxBeta, rMaxGamma, rMaxDelta] );

% Get maximum wages.
wMaxAlpha = get_maximum_wage( fAlpha, gAlpha );
wMaxBeta = get_maximum_wage( fBeta, gBeta );
wMaxGamma = get_maximum_wage( fGamma, gGamma );
wMaxDelta = get_maximum_wage( fDelta, gDelta );

% Check polynomials for prices.
if ~ check_prices2( 0, rMaxAlpha, rIncrements, fAlpha, gAlpha, uAlpha, vAlpha, ...
    a0Alpha, AAlpha, BAlpha, d, S, 10^-4)
    printf( "Error in finding rational functions for Alpha!\n");
    % quit(1);
end

if ~ check_prices2( 0, rMaxBeta, rIncrements, fBeta, gBeta, uBeta, vBeta, ...
    a0Beta, ABeta, BBeta, d, S, 10^-4)
    printf( "Error in finding rational functions for Alpha!\n");
    % quit(1);
end

if ~ check_prices2( 0, rMaxGamma, rIncrements, fGamma, gGamma, uGamma, vGamma, ...
    a0Gamma, AGamma, BGamma, d, S, 10^-4)
    printf( "Error in finding rational functions for Gamma!\n");
    % quit(1);
end

if ~ check_prices2( 0, rMaxDelta, rIncrements, fDelta, gDelta, uDelta, vDelta, ...
    a0Delta, ADelta, BDelta, d, S, 10^-4)
    printf( "Error in finding rational functions for Delta!\n");
    % quit(1);
end

% Echo parameters to standard out.
printf( "\n\nParameters for Alpha price system:\n" );
print_price_parameters( 2, a0Alpha, AAlpha, BAlpha, d, S );
printf( "\nRational functions for Alpha:\n" );
print_price_functions(2, fAlpha, gAlpha, [uAlpha', vAlpha' ] );

printf( "\n\nParameters for Beta price system:\n" );
print_price_parameters( 2, a0Beta, ABeta, BBeta, d, S );
printf( "\nRational functions for Beta:\n" );
print_price_functions(2, fBeta, gBeta, [uBeta', vBeta' ] );

printf( "\n\nParameters for Gamma price system:\n" );
print_price_parameters( 2, a0Gamma, AGamma, BGamma, d, S );
printf( "\nRational functions for Gamma:\n" );
print_price_functions(2, fGamma, gGamma, [uGamma', vGamma' ] );

printf( "\n\nParameters for Delta price system:\n" );
print_price_parameters( 2, a0Delta, ADelta, BDelta, d, S );
printf( "\nRational functions for Delta:\n" );
print_price_functions(2, fDelta, gDelta, [uDelta', vDelta' ] );

% Get switch points
% Only pairs of techniques that differ in one process are considered:
% Alpha and Beta, Alpha and Gamma, Beta and Delta, Gamma and Delta.
[nSwitchPoints1, switchPoints1] = get_switch_points( ...
    fAlpha, gAlpha, fBeta, gBeta, 0, min( rMaxAlpha, rMaxBeta ) );

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


[nSwitchPoints2, switchPoints2] = get_switch_points( ...
    fAlpha, gAlpha, fGamma, gGamma, 0, min( rMaxAlpha, rMaxGamma ) );

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


[nSwitchPoints3, switchPoints3] = get_switch_points( ...
    fBeta, gBeta, fDelta, gDelta, 0, min( rMaxBeta, rMaxDelta ) );

wagesForSwitchPoint3 = zeros(1, nSwitchPoints3 );
if ( nSwitchPoints3 == 0)
     printf( "No Switch Points Exist for Beta and Delta\n" );
else
     printf( "\nSwitch Points for Beta and Delta\n" );
     for idx = 1:1:nSwitchPoints3
         wagesForSwitchPoint3( idx ) = get_wage_rational( ...
             switchPoints3( idx ), fBeta, gBeta, rMaxBeta );

         printf( "  Rate of profits: %f,  Wage: %f\n", ...
            switchPoints3(idx), wagesForSwitchPoint3(idx) );
      endfor
endif


[nSwitchPoints4, switchPoints4] = get_switch_points( ...
    fGamma, gGamma, fDelta, gDelta, 0, min( rMaxGamma, rMaxDelta ) );

wagesForSwitchPoint4 = zeros(1, nSwitchPoints4 );
if ( nSwitchPoints4 == 0)
     printf( "No Switch Points Exist for Gamma and Delta\n" );
else
     printf( "\nSwitch Points for Gamma and Delta\n" );
     for idx = 1:1:nSwitchPoints4
         wagesForSwitchPoint4( idx ) = get_wage_rational( ...
             switchPoints4( idx ), fGamma, gGamma, rMaxGamma );

         printf( "  Rate of profits: %f,  Wage: %f\n", ...
            switchPoints4(idx), wagesForSwitchPoint4(idx) );
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
wagesDelta = zeros(1, rIncrements);
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
  % wagesAlpha( idx ) = get_wage( r, a0Alpha, AAlpha, BAlpha, S, d, rMaxAlpha );
  wagesAlpha( idx ) = get_wage_rational( r, fAlpha, gAlpha, rMaxAlpha );

  % Find corresponding wage for Beta for the rate of profits.
  % wagesBeta( idx ) = get_wage( r, a0Beta, ABeta, BBeta, S, d, rMaxBeta );
  wagesBeta( idx ) = get_wage_rational( r, fBeta, gBeta, rMaxBeta );

  % Find corresponding wage for Gamma for the rate of profits.
  % wagesGamma( idx ) = get_wage( r, a0Gamma, AGamma, BGamma, S, d, rMaxGamma );
  wagesGamma( idx ) = get_wage_rational( r, fGamma, gGamma, rMaxGamma );

  % Find corresponding wage for Delta for the rate of profits.
  % wagesDelta( idx ) = get_wage( r, a0Delta, ADelta, BDelta, S, d, rMaxDelta );
  wagesDelta( idx ) = get_wage_rational( r, fDelta, gDelta, rMaxDelta );
endfor

% Get rid of trailing zeros for each each curve to plot.
idx = 1;
while ( wagesAlpha(idx) > 0 )
  idx = idx + 1;
endwhile
rAlpha = rr( 1:idx );
wagesAlpha = wagesAlpha(1:idx);

idx = 1;
while ( wagesBeta(idx) > 0 )
  idx = idx + 1;
endwhile
rBeta = rr( 1:idx );
wagesBeta = wagesBeta(1:idx);

idx = 1;
while ( wagesGamma(idx) > 0 )
  idx = idx + 1;
endwhile
rGamma = rr( 1:idx );
wagesGamma = wagesGamma(1:idx);

idx = 1;
while ( wagesDelta(idx) > 0 )
  idx = idx + 1;
endwhile
rDelta = rr( 1:idx );
wagesDelta = wagesDelta(1:idx);

% Plot wage curves.
axes( 'FontSize', 15, 'Box', 'on', 'NextPlot', 'add' );
hold on
% plot( rr, wagesAlpha, 'blue', 'LineWidth', 2 );
% plot( rr, wagesBeta, 'red', 'LineWidth', 2 );
% plot( rr, wagesGamma, 'green', 'LineWidth', 2 );
% plot( rr, wagesDelta, 'cyan', 'LineWidth', 2 );
plot( 100*rAlpha, wagesAlpha, '-', 'color', 'black', 'LineWidth', 2 );
plot( 100*rBeta, wagesBeta, '--', 'color', 'black', 'LineWidth', 2 );
plot( 100*rGamma, wagesGamma, ':', 'color', 'black', 'LineWidth', 2 );
plot( 100*rDelta, wagesDelta, '-.', 'color', 'black', 'LineWidth', 2 );
if (nSwitchPoints1 > 0)
    plot( 100*switchPoints1, wagesForSwitchPoint1, "oblack", 'MarkerFaceColor', 'black');
endif
if (nSwitchPoints2 > 0)
    plot( 100*switchPoints2, wagesForSwitchPoint2, "oblack", 'MarkerFaceColor', 'black');
endif
if (nSwitchPoints3 > 0)
    plot( 100*switchPoints3, wagesForSwitchPoint3, "oblack", 'MarkerFaceColor', 'black');
endif
if (nSwitchPoints4 > 0)
    plot( 100*switchPoints4, wagesForSwitchPoint4, "oblack", 'MarkerFaceColor', 'black');
endif
xlabel( 'Rate of Profits (Percent)', 'FontWeight', 'bold', ...
   'FontSize', 20, 'FontName', 'Times New Roman');
% xlabel( 'Scale Factor for the Rate of Profits (Percent)', 'FontWeight', 'bold', ...
%   'FontSize', 20, 'FontName', 'Times New Roman');
ylabel( 'Wage (Busheles per Person-Year)', 'FontWeight', 'bold', ...
    'FontSize', 20, 'FontName', 'Times New Roman');

legendArray = [ 'Alpha'; 'Beta'; 'Gamma'; 'Delta' ];
legend( legendArray, 'location', 'northeast' );

hold off

% printf( "%3.12f,   %3.12f,   %3.12f\n", switchPoints1(1), switchPoints4(1), switchPoints4(1) - switchPoints1(1) );








