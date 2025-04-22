% Code for analyzing the choice of technique.

clear all

% For exploring Harrod-neutral change in Alpha and Theta techniques.
phi = 1/20;       % Rate of growth of productivity for Alpha.
sigma = 1/10;     % Rate of growth of productivity for Theta.
t = 48.37585338;

phi = 3;
sigma = 5.418792669;
t = 1;

% Specify relative markups.
% s1 = 1/4;
% s2 = 1/3;
% s3 = 1 - s1 - s2;

% Competitive markets. Simplifies calculation of switch points.

s1 = 1;
s2 = 1;
s3 = 1;

% A reswitching example from my 2024 ROPE paper?
% s1 = 1;
% s2 = 0.8;
% s3 = 0.3;

% Specify technology from which to select techniques.

% From my ROPE 2024 paper:
% a0 = [1/3, 1/10, 5/2, 7/20, 1, 3/2];

% From some blog post in January 2024:
a0 = [(15/2)*exp(-phi*t), 32*exp(-sigma*t), (13/2)*exp(-phi*t), 60*exp(-sigma*t), (15/2)*exp(-phi*t), 55*exp(-sigma*t)];

A = [[1/6, 2/5, 1/200, 1/100, 1, 0]; ...
     [1/200, 1/400, 1/4, 3/10, 0, 1/4]; ...
     [1/300, 1/300, 1/300, 0, 0, 0]];

B = [[1,1,0,0,0,0]; ...
     [0,0,1,1,0,0]; ...
     [0,0,0,0,1,1]];


% The third commodity is the numeraire.
d = [0;0;1];


% Number of increments to use when plotting wage curves.
rIncrements = 200;
% Start with -1? Then 1. Start with 0? Then 0;
negativeOne = 0;


% Define Alpha, Beta, Gamma, Delta, Epsilon, Zera, Eta, Theta techniques.
[a0Alpha, AAlpha, BAlpha, S] = ...
    get_technique_parameters( [1, 3, 5], a0, A, B, [s1, s1, s2, s2, s3, s3] );
[a0Beta, ABeta, BBeta, S] = ...
    get_technique_parameters( [1, 3, 6], a0, A, B, [s1, s1, s2, s2, s3, s3] );
[a0Gamma, AGamma, BGamma, S] = ...
    get_technique_parameters( [1, 4, 5], a0, A, B, [s1, s1, s2, s2, s3, s3] );
[a0Delta, ADelta, BDelta, S] = ...
    get_technique_parameters( [1, 4, 6], a0, A, B, [s1, s1, s2, s2, s3, s3] );
[a0Epsilon, AEpsilon, BEpsilon, S] = ...
    get_technique_parameters( [2, 3, 5], a0, A, B, [s1, s1, s2, s2, s3, s3] );
[a0Zeta, AZeta, BZeta, S] = ...
    get_technique_parameters( [2, 3, 6], a0, A, B, [s1, s1, s2, s2, s3, s3] );
[a0Eta, AEta, BEta, S] = ...
    get_technique_parameters( [2, 4, 5], a0, A, B, [s1, s1, s2, s2, s3, s3] );
[a0Theta, ATheta, BTheta, S] = ...
    get_technique_parameters( [2, 4, 6], a0, A, B, [s1, s1, s2, s2, s3, s3] );

% Find polynomials for rational functions for each technique.
[fAlpha, gAlpha, numerAlpha] = get_rational_functions( a0Alpha, AAlpha, BAlpha, d, S);
[fBeta, gBeta, numerBeta] = get_rational_functions( a0Beta, ABeta, BBeta, d, S);
[fGamma, gGamma, numerGamma] = get_rational_functions( a0Gamma, AGamma, BGamma, d, S);
[fDelta, gDelta, numerDelta] = get_rational_functions( a0Delta, ADelta, BDelta, d, S);
[fEpsilon, gEpsilon, numerEpsilon] = get_rational_functions( a0Epsilon, AEpsilon, BEpsilon, d, S);
[fZeta, gZeta, numerZeta] = get_rational_functions( a0Zeta, AZeta, BZeta, d, S);
[fEta, gEta, numerEta] = get_rational_functions( a0Eta, AEta, BEta, d, S);
[fTheta, gTheta, numerTheta] = get_rational_functions( a0Theta, ATheta, BTheta, d, S);

% Find the maximum rate of profits for the eight techniques.
rMaxAlpha = get_r_max2( fAlpha );
rMaxBeta = get_r_max2( fBeta );
rMaxGamma = get_r_max2( fGamma );
rMaxDelta = get_r_max2( fDelta );
rMaxEpsilon = get_r_max2( fEpsilon );
rMaxZeta = get_r_max2( fZeta );
rMaxEta = get_r_max2( fEta );
rMaxTheta = get_r_max2( fTheta );

rMax = max( [ rMaxAlpha, rMaxBeta, rMaxGamma, rMaxDelta, ...
   rMaxEpsilon, rMaxZeta, rMaxEta, rMaxTheta ] );

% Get maximum wages. TO DO: echo these out.
wMaxAlpha = get_maximum_wage( fAlpha, gAlpha );
wMaxBeta = get_maximum_wage( fBeta, gBeta );
wMaxGamma = get_maximum_wage( fGamma, gGamma );
wMaxDelta = get_maximum_wage( fDelta, gDelta );
wMaxEpsilon = get_maximum_wage( fEpsilon, gEpsilon );
wMaxZeta = get_maximum_wage( fZeta, gZeta );
wMaxEta = get_maximum_wage( fEta, gEta );
wMaxTheta = get_maximum_wage( fTheta, gTheta );

% Check polynomials for prices
check_prices( 0, rMaxAlpha, rIncrements, fAlpha, gAlpha, numerAlpha, ...
    a0Alpha, AAlpha, BAlpha, d, S, 10^-4, 1, "Alpha");
check_prices( 0, rMaxBeta, rIncrements, fBeta, gBeta, numerBeta, ...
    a0Beta, ABeta, BBeta, d, S, 10^-4, 1, "Beta");
check_prices( 0, rMaxGamma, rIncrements, fGamma, gGamma, numerGamma, ...
    a0Gamma, AGamma, BGamma, d, S, 10^-4, 1, "Gamma");
check_prices( 0, rMaxDelta, rIncrements, fDelta, gDelta, numerDelta, ...
    a0Delta, ADelta, BDelta, d, S, 10^-4, 1, "Delta");
check_prices( 0, rMaxEpsilon, rIncrements, fEpsilon, gEpsilon, numerEpsilon, ...
    a0Epsilon, AEpsilon, BEpsilon, d, S, 10^-4, 1, "Epsilon");
check_prices( 0, rMaxZeta, rIncrements, fZeta, gZeta, numerZeta, ...
    a0Zeta, AZeta, BZeta, d, S, 10^-4, 1, "Zeta");
check_prices( 0, rMaxEta, rIncrements, fEta, gEta, numerEta, ...
    a0Eta, AEta, BEta, d, S, 10^-4, 1, "Eta");
check_prices( 0, rMaxTheta, rIncrements, fTheta, gTheta, numerTheta, ...
    a0Theta, ATheta, BTheta, d, S, 10^-4, 1, "Theta");

% Echo parameters for each technique.
print_parameters_wrapper( a0Alpha, AAlpha, BAlpha, d, S, fAlpha, gAlpha, numerAlpha, "Alpha" );
print_parameters_wrapper( a0Beta, ABeta, BBeta, d, S, fBeta, gBeta, numerBeta, "Beta" );
print_parameters_wrapper( a0Gamma, AGamma, BGamma, d, S, fGamma, gGamma, numerGamma, "Gamma" );
print_parameters_wrapper( a0Delta, ADelta, BDelta, d, S, fDelta, gDelta, numerDelta, "Delta" );
print_parameters_wrapper( a0Epsilon, AEpsilon, BEpsilon, d, S, fEpsilon, gEpsilon, numerEpsilon, "Epsilon" );
print_parameters_wrapper( a0Zeta, AZeta, BZeta, d, S, fZeta, gZeta, numerZeta, "Zeta" );
print_parameters_wrapper( a0Eta, AEta, BEta, d, S, fEta, gEta, numerEta, "Eta" );
print_parameters_wrapper( a0Theta, ATheta, BTheta, d, S, fTheta, gTheta, numerTheta, "Theta" );

% Get switch points.
% I only want to look at pairs of techniques that differ by one process.
% Alpha and Beta differ in the third process.
switchPoints1 = get_switch_points_from_prices( fAlpha, gAlpha, numerAlpha, d, S(3,3), ......
     a0Beta(3), ABeta(:,3), BBeta(:,3), 0, min( rMaxAlpha, rMaxBeta ) );
% Alpha and Gamma differ in the second process.
switchPoints2 = get_switch_points_from_prices( fAlpha, gAlpha, numerAlpha, d, S(2,2), ......
     a0Gamma(2), AGamma(:,2), BGamma(:,2), 0, min( rMaxAlpha, rMaxGamma ) );
% Alpha and Epsilon differ in the first process.
switchPoints3 = get_switch_points_from_prices( fAlpha, gAlpha, numerAlpha, d, S(1,1), ......
     a0Epsilon(1), AEpsilon(:,1), BEpsilon(:,1), 0, min( rMaxAlpha, rMaxEpsilon ) );
% Beta and Delta differ in the second process.
switchPoints4 = get_switch_points_from_prices( fBeta, gBeta, numerBeta, d, S(2,2), ......
     a0Delta(2), ADelta(:,2), BDelta(:,2), 0, min( rMaxBeta, rMaxDelta ) );
% Beta and Zeta differ in the first process.
switchPoints5 = get_switch_points_from_prices( fBeta, gBeta, numerBeta, d, S(1,1), ......
     a0Zeta(1), AZeta(:,1), BZeta(:,1), 0, min( rMaxBeta, rMaxZeta ) );
% Gamma and Delta differ in the third process.
switchPoints6 = get_switch_points_from_prices( fGamma, gGamma, numerGamma, d, S(3,3), ......
     a0Delta(3), ADelta(:,3), BDelta(:,3), 0, min( rMaxGamma, rMaxDelta ) );
% Gamma and Eta differ in the first process.
switchPoints7 = get_switch_points_from_prices( fGamma, gGamma, numerGamma, d, S(1,1), ......
     a0Eta(1), AEta(:,1), BEta(:,1), 0, min( rMaxGamma, rMaxEta ) );
% Delta and Theta differ in the first process.
switchPoints8 = get_switch_points_from_prices( fDelta, gDelta, numerDelta, d, S(1,1), ......
     a0Theta(1), ATheta(:,1), BTheta(:,1), 0, min( rMaxDelta, rMaxTheta ) );
% Epsilon and Zeta differ in the third process.
switchPoints9 = get_switch_points_from_prices( fEpsilon, gEpsilon, numerEpsilon, d, S(3,3), ......
     a0Zeta(3), AZeta(:,3), BZeta(:,3), 0, min( rMaxEpsilon, rMaxZeta ) );
% Epsilon and Eta differ in the second process.
switchPoints10 = get_switch_points_from_prices( fEpsilon, gEpsilon, numerEpsilon, d, S(2,2), ......
     a0Eta(2), AEta(:,2), BEta(:,2), 0, min( rMaxEpsilon, rMaxEta ) );
% Zeta and Theta differ in the second process.
switchPoints11 = get_switch_points_from_prices( fZeta, gZeta, numerZeta, d, S(2,2), ......
     a0Theta(2), ATheta(:,2), BTheta(:,2), 0, min( rMaxZeta, rMaxTheta ) );
% Eta and Theta differ in the third process.
switchPoints12 = get_switch_points_from_prices( fEta, gEta, numerEta, d, S(3,3), ......
     a0Theta(3), ATheta(:,3), BTheta(:,3), 0, min( rMaxEta, rMaxTheta ) );

printf( "\n" );

% Find wages for switch points, echoing switch points to standard out
% as you go.
wages1 = get_wages_for_switch_points(switchPoints1, fAlpha, gAlpha, rMaxAlpha, 1, "Alpha vs. Beta");
wages2 = get_wages_for_switch_points(switchPoints2, fAlpha, gAlpha, rMaxAlpha, 1, "Alpha vs. Gamma");
wages3 = get_wages_for_switch_points(switchPoints3, fAlpha, gAlpha, rMaxAlpha, 1, "Alpha vs. Epsilon");
wages4 = get_wages_for_switch_points(switchPoints4, fBeta, gBeta, rMaxBeta, 1, "Beta vs. Delta");
wages5 = get_wages_for_switch_points(switchPoints5, fBeta, gBeta, rMaxBeta, 1, "Beta vs. Zeta");
wages6 = get_wages_for_switch_points(switchPoints6, fGamma, gGamma, rMaxGamma, 1, "Gamma vs. Delta");
wages7 = get_wages_for_switch_points(switchPoints7, fGamma, gGamma, rMaxGamma, 1, "Gamma vs. Eta");
wages8 = get_wages_for_switch_points(switchPoints8, fDelta, gDelta, rMaxDelta, 1, "Delta vs. Theta");
wages9 = get_wages_for_switch_points(switchPoints9, fEpsilon, gEpsilon, rMaxEpsilon, 1, "Epsilon vs. Zeta");
wages10 = get_wages_for_switch_points(switchPoints10, fEpsilon, gEpsilon, rMaxEpsilon, 1, "Epsilon vs Eta");
wages11 = get_wages_for_switch_points(switchPoints11, fZeta, gZeta, rMaxZeta, 1, "Zeta vs. Theta");
wages12 = get_wages_for_switch_points(switchPoints12, fEta, gEta, rMaxEta, 1, "Eta vs. Theta");

% Concatenate the vectors for switch points.
% This is fine for graphing, but do not do this for other analyses.
switchPoints = [ switchPoints1, switchPoints2, switchPoints3, switchPoints4, ...
     switchPoints5, switchPoints6, switchPoints7, switchPoints8, ...
     switchPoints9, switchPoints10, switchPoints11, switchPoints12 ];
wagesForSwitchPoints = [ wages1, wages2, wages3, wages4, ...
    wages5, wages6, wages7, wages8, ...
    wages9, wages10, wages11, wages12 ];

% Start setting up the graph.
if (negativeOne == 1)
   rIncr = (rMax + 1)/(rIncrements - 1);
   rStart = -1.0;
else
   rIncr = rMax/(rIncrements - 1);
   rStart = 0.0;
end

% Find vector of wages for plotting.
[ rAlpha, wAlpha ] = get_wage_curve( rStart, rIncr, rIncrements, fAlpha, gAlpha, rMaxAlpha );
[ rBeta, wBeta ] = get_wage_curve( rStart, rIncr, rIncrements, fBeta, gBeta, rMaxBeta );
[ rGamma, wGamma ] = get_wage_curve( rStart, rIncr, rIncrements, fGamma, gGamma, rMaxGamma );
[ rDelta, wDelta ] = get_wage_curve( rStart, rIncr, rIncrements, fDelta, gDelta, rMaxDelta );
[ rEpsilon, wEpsilon ] = get_wage_curve( rStart, rIncr, rIncrements, fEpsilon, gEpsilon, rMaxEpsilon );
[ rZeta, wZeta ] = get_wage_curve( rStart, rIncr, rIncrements, fZeta, gZeta, rMaxZeta );
[ rEta, wEta ] = get_wage_curve( rStart, rIncr, rIncrements, fEta, gEta, rMaxEta );
[ rTheta, wTheta ] = get_wage_curve( rStart, rIncr, rIncrements, fTheta, gTheta, rMaxTheta );

% Plot wage curves.
axes( 'FontSize', 15, 'Box', 'on', 'NextPlot', 'add' );
hold on
plot( 100*rAlpha, wAlpha, '-', 'color', 'black', 'LineWidth', 2 );
plot( 100*rBeta, wBeta, '--', 'color', 'black', 'LineWidth', 2 );
plot( 100*rGamma, wGamma, ':', 'color', 'black', 'LineWidth', 2 );
plot( 100*rDelta, wDelta, '-.', 'color', 'black', 'LineWidth', 2 );

grayColor = [.7 .7 .7];
plot( 100*rEpsilon, wEpsilon, '-', 'color', grayColor, 'LineWidth', 2 );
plot( 100*rZeta, wZeta, '--', 'color', grayColor, 'LineWidth', 2 );
plot( 100*rEta, wEta, ':', 'color', grayColor, 'LineWidth', 2 );
plot( 100*rTheta, wTheta, '-.', 'color', grayColor, 'LineWidth', 2 );

if ( size(switchPoints, 2) > 0 )
  plot( 100*switchPoints, wagesForSwitchPoints, "oblack", 'MarkerFaceColor', 'black');
endif

xlabel( 'Rate of Profits (Percent)', 'FontWeight', 'bold', ...
   'FontSize', 20, 'FontName', 'Times New Roman');
ylabel( 'Wage (Busheles per Person-Year)', 'FontWeight', 'bold', ...
    'FontSize', 20, 'FontName', 'Times New Roman');

hold off

% printf( "%3.15f\n", (switchPoints1(1) + switchPoints1(2))/2 );

% Only run with t = 0. Experimentation for four-techique pattern
% r1 = 0.827576126;
% a0Beta
% a0Theta
% CBeta = inv( eye(3) - (1 + r1)*ABeta );
% CDelta = inv( eye(3) - (1 + r1)*ADelta );
% CZeta = inv( eye(3) - (1 + r1)*AZeta );
% CTheta = inv( eye(3) - (1 + r1)*ATheta );
% numer = a0Alpha(1)*CBeta(1,3) + a0Alpha(2)*CBeta(2,3);
% printf( "numerator: %3.14f\n", numer );
% denom = a0Theta*CTheta*d - a0Theta(3)*CBeta(3,3);
% printf( "denominator: %3.14f\n", denom );
% printf( "intercept: %3.14f]n", -log(numer/denom) );

% Only run with t = 0. Experimentation for Alpha vs Beta reswitching pattern
% r1 = 2.224895252;
% a0Alpha
% a0Beta
% CAlpha = inv( eye(3) - (1 + r1)*AAlpha );
% CBeta = inv( eye(3) - (1 + r1)*ABeta );
% numer = a0Alpha*CAlpha*d - a0Alpha(1)*CBeta(1,3) - a0Alpha(2)*CBeta(2,3);
% printf( "numerator: %3.14f\n", numer );
% denom = a0Theta(3)*CBeta(3,3);
% printf( "denominator: %3.14f\n", denom );


