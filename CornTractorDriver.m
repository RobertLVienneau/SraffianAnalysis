% An example of Steedman's Corn-Tractor model.

clear all;

% I HAVE POLYNOMIALS FOR BETA HARD_CODED BELOW. SWITCH POINTS,TOO.
% TODO: Fix. Is it a matter of roundoff error, numerical instability?

% For Alpha, the type of tractor lasts one year.

a21Alpha = 0.306225775;
a01Alpha = 233.6967046;

a22Alpha = 1;
a02Alpha = 763.1516477;


% For Beta, the type of tractor lasts two years.

a21Beta = 0.4;      % New tractors per new tractors.
a01Beta = 20;       % Person-yrs per new tractors.

a23Beta = 20;       % New tractor per bushel.
a03Beta = 850;      % Person-year per bushel.

% Let 50 machines = 1 new tractor

% a21Beta = 0.4;      % New machines per new machines.
% a01Beta = 20/50;    % Person-yrs per new machines.

% a23Beta = 20*50;    % New machines per bushel.
% a03Beta = 850;      % Person-year per bushel.

% Switch points at (r, w) =
%  (0, 0.000909091)
%  (0.447472539, 0.000729536)
%  (2.265564437, 0)

% TODO: Fix and remove hardcoding:
% switchPoints = [0, 0.447472539, 2.265564437];

fBeta = [0,0,-0.4, 0.2, 1.6];
gBeta = [0,60,970,1760];
numerBeta = [[0;60;970;1760],[0;0;20;40],[0;20;40;20],[0;20;40;20]];

% For specifying competitive markets.
s1 = 1;
s2 = 1;

a0Alpha = [a01Alpha, a02Alpha];

AAlpha = [[0,        0]; ...
          [a21Alpha, a22Alpha]];

BAlpha = [[0,         1]; ...
          [1,         0]];

SAlpha = [[s1, 0]; ...
          [0, s2]];



a0Beta = [a01Beta, a01Beta, a03Beta, a03Beta];

ABeta = [[0,       0,       0,       0]; ...
         [a21Beta, 0,       a23Beta, 0]; ...
         [0,       a21Beta, 0,       0]; ...
         [0,       0,       0,       a23Beta]];

BBeta = [[0,       0, 1,       1]; ...
         [1,       1, 0,       0]; ...
         [a21Beta, 0, 0,       0]; ...
         [0,       0, a23Beta, 0]];

SBeta = [[s1, 0, 0, 0]; ...
         [0, s1, 0, 0]; ...
         [0, 0, s2, 0]; ...
         [0, 0, 0, s2]];


d = [1;0;0;0];


% Number of increments to use when plotting wage curves.
rIncrements = 200;
% Start with -1? Then 1. Start with 0? Then 0;
negativeOne = 0;

% Find polynomials for rational functions for each technique.
[fAlpha, gAlpha, numerAlpha] = get_rational_functions( a0Alpha, AAlpha, BAlpha, d, SAlpha);
% [fBeta, gBeta, numerBeta] = get_rational_functions( a0Beta, ABeta, BBeta, d, SBeta);

% Find the maximum rate of profits for the techniques.
rMaxAlpha = get_r_max2( fAlpha );
rMaxBeta = get_r_max2( fBeta );

rMax = max( [rMaxAlpha, rMaxBeta] );

% Get maximum wages.
wMaxAlpha = get_maximum_wage( fAlpha, gAlpha );
wMaxBeta = get_maximum_wage( fBeta, gBeta );

% Check polynomials for prices
check_prices( 0, rMaxAlpha, rIncrements, fAlpha, gAlpha, numerAlpha, ...
    a0Alpha, AAlpha, BAlpha, d, SAlpha, 10^-4, 1, "Alpha");
% check_prices( 0, rMaxBeta, rIncrements, fBeta, gBeta, numerBeta, ...
%    a0Beta, ABeta, BBeta, d, SBeta, 10^-4, 1, "Beta");
check_prices( 0, rMaxBeta, rIncrements, fBeta, gBeta, numerBeta, ...
    a0Beta, ABeta, BBeta, d, SBeta, 3, 1, "Beta");

% Echo parameters for each technique.
print_parameters_wrapper( a0Alpha, AAlpha, BAlpha, d, SAlpha, fAlpha, gAlpha, numerAlpha, "Alpha" );
print_parameters_wrapper( a0Beta, ABeta, BBeta, d, SBeta, fBeta, gBeta, numerBeta, "Beta" );

% Get switch points..
% Alpha and Beta differ in the third process.
% switchPoints1 = get_switch_points_from_prices( fAlpha, gAlpha, numerAlpha, d, S(3,3), ......
%     a0Beta(3), ABeta(:,3), BBeta(:,3), 0, min( rMaxAlpha, rMaxBeta ) );

[nSwitchPoints, switchPoints] = get_switch_points( fAlpha, gAlpha, fBeta, gBeta, ...
    0, rMax);
% TODO: I happen to know that this example yields a just barely negative switch point.
switchPoints = [0, switchPoints];

wagesForSwitchPoints = get_wages_for_switch_points(switchPoints, ...
      fAlpha, gAlpha, rMaxAlpha, 1, "Alpha vs. Beta");

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

% Plot wage curves.
axes( 'FontSize', 15, 'Box', 'on', 'NextPlot', 'add' );
hold on
plot( 100*rAlpha, wAlpha, '-', 'color', 'black', 'LineWidth', 2 );
plot( 100*rBeta, wBeta, '--', 'color', 'black', 'LineWidth', 2 );

if ( size(switchPoints, 2) > 0 )
     plot( 100*switchPoints, wagesForSwitchPoints, "oblack", 'MarkerFaceColor', 'black');
endif

xlabel( 'Rate of Profits (Percent)', 'FontWeight', 'bold', ...
    'FontSize', 20, 'FontName', 'Times New Roman');
ylabel( 'Wage (Busheles per Person-Year)', 'FontWeight', 'bold', ...
    'FontSize', 20, 'FontName', 'Times New Roman');

hold off
