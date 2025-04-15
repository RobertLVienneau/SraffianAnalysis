% Code for analyzing the choice of technique.

clear all

% For exploring Harrod-neutral change in Alpha and Theta techniques.
phi = 1/20;       % Rate of growth of productivity for Alpha.
sigma = 1/10;     % Rate of growth of productivity for Theta.
t = 1;   % Not used?

timeStart = 0;
timeEnd = 60;
increments = 200;

% Competitive markets. Simplifies calculation of switch points.

s1 = 1;
s2 = 1;
s3 = 1;


A = [[1/6, 2/5, 1/200, 1/100, 1, 0]; ...
     [1/200, 1/400, 1/4, 3/10, 0, 1/4]; ...
     [1/300, 1/300, 1/300, 0, 0, 0]];

B = [[1,1,0,0,0,0]; ...
     [0,0,1,1,0,0]; ...
     [0,0,0,0,1,1]];

% The third commodity is the numeraire.
d = [0;0;1];




printf( "\n" );
printf( "time,phi,sigma,");

printf( "Maximum r for Alpha (percent),Maximum r for Beta (percent),Maximum r for Gamma (percent),Maximum r for Delta (percent)," );
printf( "Maximum r for Epsilon (percent),Maximum r for Zeta (percent),Maximum r for Eta (percent),Maximum r for Theta (percent)," );

printf( "Alpha vs Beta (percent),Alpha vs Beta (percent),Alpha vs Beta (percent),");
printf( "Alpha vs Gamma (percent),Alpha vs Gamma (percent),Alpha vs Gamma (percent),");
printf( "Alpha vs Epsilon (percent),Alpha vs Epsilon (percent),Alpha vs Epsilon (percent),");
printf( "Beta vs Delta (percent),Beta vs Delta (percent),Beta vs Delta (percent),");
printf( "Beta vs Zeta (percent),Beta vs Zeta (percent),Beta vs Zeta (percent),");
printf( "Gamma vs Delta (percent),Gamma vs Delta (percent),Gamma vs Delta (percent),");
printf( "Gamma vs Eta (percent),Gamma vs Eta (percent),Gamma vs Eta (percent),");
printf( "Delta vs Theta (percent),Delta vs Theta (percent),Delta vs Theta (percent),");
printf( "Epsilon vs Zeta (percent),Epsilon vs Zeta (percent),Epsilon vs Zeta (percent),");
printf( "Epsilon vs Eta (percent),Epsilon vs Eta (percent),Epsilon vs Eta (percent),");
printf( "Zeta vs Theta (percent),Zeta vs Theta (percent),Zeta vs Theta(percent),");
printf( "Eta vs Theta (percent),Eta vs Theta (percent),Eta vs Theta(percent),");

printf( "Maximum w for Alpha,Maximum w for Beta,Maximum w for Gamma,Maximum w for Delta," );
printf( "Maximum w for Epsilon,Maximum w for Zeta,Maximum w for Eta,Maximum w for Theta," );

printf( "Alpha vs Beta,Alpha vs Beta,Alpha vs Beta,");
printf( "Alpha vs Gamma,Alpha vs Gamma,Alpha vs Gamma,");
printf( "Alpha vs Epsilon,Alpha vs Epsilon,Alpha vs Epsilon,");
printf( "Beta vs Delta,Beta vs Delta,Beta vs Delta,");
printf( "Beta vs Zeta,Beta vs Zeta,Beta vs Zeta,");
printf( "Gamma vs Delta,Gamma vs Delta,Gamma vs Delta,");
printf( "Gamma vs Eta,Gamma vs Eta,Gamma vs Eta,");
printf( "Delta vs Theta,Delta vs Theta,Delta vs Theta,");
printf( "Epsilon vs Zeta,Epsilon vs Zeta,Epsilon vs Zeta,");
printf( "Epsilon vs Eta,Epsilon vs Eta,Epsilon vs Eta,");
printf( "Zeta vs Theta,Zeta vs Theta,Zeta vs Theta,");
printf( "Eta vs Theta,Eta vs Theta,Eta vs Theta");
printf( "\n" );

timeIncrement = (timeEnd - timeStart)/(increments - 1);

for idx=1:1:increments

   t = timeStart + timeIncrement*(idx - 1);

   % From some blog post in January 2024:
   a0 = [(15/2)*exp(-phi*t), 32*exp(-sigma*t), (13/2)*exp(-phi*t), 60*exp(-sigma*t), (15/2)*exp(-phi*t), 55*exp(-sigma*t)];

   % Define input and output matrices.
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

   % Find polynomials for rational functions for each echnique.
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

   % Get maximum wages.
   wMaxAlpha = get_maximum_wage( fAlpha, gAlpha );
   wMaxBeta = get_maximum_wage( fBeta, gBeta );
   wMaxGamma = get_maximum_wage( fGamma, gGamma );
   wMaxDelta = get_maximum_wage( fDelta, gDelta );
   wMaxEpsilon = get_maximum_wage( fEpsilon, gEpsilon );
   wMaxZeta = get_maximum_wage( fZeta, gZeta );
   wMaxEta = get_maximum_wage( fEta, gEta );
   wMaxTheta = get_maximum_wage( fTheta, gTheta );

   % Get switch points.
   % I only want to look at pairs of techniques that differ by one process.
   % Alpha and Beta differ in the third process.
   switchPoints1 = get_switch_points_from_prices( fAlpha, gAlpha, numerAlpha, d, S(3,3), ......
        a0Beta(3), ABeta(:,3), BBeta(:,3), -1, min( rMaxAlpha, rMaxBeta ) );
   % Alpha and Gamma differ in the second process.
   switchPoints2 = get_switch_points_from_prices( fAlpha, gAlpha, numerAlpha, d, S(2,2), ......
        a0Gamma(2), AGamma(:,2), BGamma(:,2), -1, min( rMaxAlpha, rMaxGamma ) );
   % Alpha and Epsilon differ in the first process.
   switchPoints3 = get_switch_points_from_prices( fAlpha, gAlpha, numerAlpha, d, S(1,1), ......
       a0Epsilon(1), AEpsilon(:,1), BEpsilon(:,1), -1, min( rMaxAlpha, rMaxEpsilon ) );
   % Beta and Delta differ in the second process.
   switchPoints4 = get_switch_points_from_prices( fBeta, gBeta, numerBeta, d, S(2,2), ......
        a0Delta(2), ADelta(:,2), BDelta(:,2), -1, min( rMaxBeta, rMaxDelta ) );
   % Beta and Zeta differ in the first process.
   switchPoints5 = get_switch_points_from_prices( fBeta, gBeta, numerBeta, d, S(1,1), ......
        a0Zeta(1), AZeta(:,1), BZeta(:,1), -1, min( rMaxBeta, rMaxZeta ) );
   % Gamma and Delta differ in the third process.
   switchPoints6 = get_switch_points_from_prices( fGamma, gGamma, numerGamma, d, S(3,3), ......
       a0Delta(3), ADelta(:,3), BDelta(:,3), -1, min( rMaxGamma, rMaxDelta ) );
   % Gamma and Eta differ in the first process.
   switchPoints7 = get_switch_points_from_prices( fGamma, gGamma, numerGamma, d, S(1,1), ......
       a0Eta(1), AEta(:,1), BEta(:,1), -1, min( rMaxGamma, rMaxEta ) );
   % Delta and Theta differ in the first process.
  switchPoints8 = get_switch_points_from_prices( fDelta, gDelta, numerDelta, d, S(1,1), ......
       a0Theta(1), ATheta(:,1), BTheta(:,1), -1, min( rMaxDelta, rMaxTheta ) );
   % Epsilon and Zeta differ in the third process.
   switchPoints9 = get_switch_points_from_prices( fEpsilon, gEpsilon, numerEpsilon, d, S(3,3), ......
     a0Zeta(3), AZeta(:,3), BZeta(:,3), -1, min( rMaxEpsilon, rMaxZeta ) );
   % Epsilon and Eta differ in the second process.
   switchPoints10 = get_switch_points_from_prices( fEpsilon, gEpsilon, numerEpsilon, d, S(2,2), ......
      a0Eta(2), AEta(:,2), BEta(:,2), -1, min( rMaxEpsilon, rMaxEta ) );
   % Zeta and Theta differ in the second process.
   switchPoints11 = get_switch_points_from_prices( fZeta, gZeta, numerZeta, d, S(2,2), ......
       a0Theta(2), ATheta(:,2), BTheta(:,2), -1, min( rMaxZeta, rMaxTheta ) );
   % Eta and Theta differ in the third process.
   switchPoints12 = get_switch_points_from_prices( fEta, gEta, numerEta, d, S(3,3), ......
        a0Theta(3), ATheta(:,3), BTheta(:,3), -1, min( rMaxEta, rMaxTheta ) );

   % Find wages for switch points
   wages1 = get_wages_for_switch_points(switchPoints1, fAlpha, gAlpha, rMaxAlpha, 0, "Alpha vs. Beta");
   wages2 = get_wages_for_switch_points(switchPoints2, fAlpha, gAlpha, rMaxAlpha, 0, "Alpha vs. Gamma");
   wages3 = get_wages_for_switch_points(switchPoints3, fAlpha, gAlpha, rMaxAlpha, 0, "Alpha vs. Epsilon");
   wages4 = get_wages_for_switch_points(switchPoints4, fBeta, gBeta, rMaxBeta, 0, "Beta vs. Delta");
   wages5 = get_wages_for_switch_points(switchPoints5, fBeta, gBeta, rMaxBeta, 0, "Beta vs. Zeta");
   wages6 = get_wages_for_switch_points(switchPoints6, fGamma, gGamma, rMaxGamma, 0, "Gamma vs. Delta");
   wages7 = get_wages_for_switch_points(switchPoints7, fGamma, gGamma, rMaxGamma, 0, "Gamma vs. Eta");
   wages8 = get_wages_for_switch_points(switchPoints8, fDelta, gDelta, rMaxDelta, 0, "Delta vs. Theta");
   wages9 = get_wages_for_switch_points(switchPoints9, fEpsilon, gEpsilon, rMaxEpsilon, 0, "Epsilon vs. Zeta");
   wages10 = get_wages_for_switch_points(switchPoints10, fEpsilon, gEpsilon, rMaxEpsilon, 0, "Epsilon vs Eta");
   wages11 = get_wages_for_switch_points(switchPoints11, fZeta, gZeta, rMaxZeta, 0, "Zeta vs. Theta");
   wages12 = get_wages_for_switch_points(switchPoints12, fEta, gEta, rMaxEta, 0, "Eta vs. Theta");

   % Print results for this iteration.
   printf( "%3.12f,%3.12f,%3.12f,", t, phi, sigma );
   printf( "%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,", ...
      100*rMaxAlpha, 100*rMaxBeta, 100*rMaxGamma, 100*rMaxDelta, ...
      100*rMaxEpsilon, 100*rMaxZeta, 100*rMaxEta, 100*rMaxTheta );

   if ( size( switchPoints1, 2) == 0 )
      printf( "%3.12f,%3.12f,%3.12f,", 1/0, 1/0, 1/0 );
   elseif ( size( switchPoints1, 2) == 1 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints1(1), 1/0, 1/0 );
   elseif ( size( switchPoints1, 2) == 2 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints1(1), 100*switchPoints1(2), 1/0 );
   elseif ( size( switchPoints1, 2) == 3 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints1(1), 100*switchPoints1(2), 100*switchPoints1(3) );
   endif

   if ( size( switchPoints2, 2) == 0 )
      printf( "%3.12f,%3.12f,%3.12f,", 1/0, 1/0, 1/0 );
   elseif ( size( switchPoints2, 2) == 1 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints2(1), 1/0, 1/0 );
   elseif ( size( switchPoints2, 2) == 2 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints2(1), 100*switchPoints2(2), 1/0 );
   elseif ( size( switchPoints2, 2) == 3 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints2(1), 100*switchPoints2(2), 100*switchPoints2(3) );
   endif

   if ( size( switchPoints3, 2) == 0 )
      printf( "%3.12f,%3.12f,%3.12f,", 1/0, 1/0, 1/0 );
   elseif ( size( switchPoints3, 2) == 1 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints3(1), 1/0, 1/0 );
   elseif ( size( switchPoints3, 2) == 2 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints3(1), 100*switchPoints3(2), 1/0 );
   elseif ( size( switchPoints3, 2) == 3 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints3(1), 100*switchPoints3(2), 100*switchPoints3(3) );
   endif

   if ( size( switchPoints4, 2) == 0 )
      printf( "%3.12f,%3.12f,%3.12f,", 1/0, 1/0, 1/0 );
   elseif ( size( switchPoints4, 2) == 1 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints4(1), 1/0, 1/0 );
   elseif ( size( switchPoints4, 2) == 2 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints4(1), 100*switchPoints4(2), 1/0 );
   elseif ( size( switchPoints4, 2) == 3 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints4(1), 100*switchPoints4(2), 100*switchPoints4(3) );
   endif

   if ( size( switchPoints5, 2) == 0 )
      printf( "%3.12f,%3.12f,%3.12f,", 1/0, 1/0, 1/0 );
   elseif ( size( switchPoints5, 2) == 1 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints5(1), 1/0, 1/0 );
   elseif ( size( switchPoints5, 2) == 2 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints5(1), 100*switchPoints5(2), 1/0 );
   elseif ( size( switchPoints5, 2) == 3 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints5(1), 100*switchPoints5(2), 100*switchPoints5(3) );
   endif

   if ( size( switchPoints6, 2) == 0 )
      printf( "%3.12f,%3.12f,%3.12f,", 1/0, 1/0, 1/0 );
   elseif ( size( switchPoints6, 2) == 1 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints6(1), 1/0, 1/0 );
   elseif ( size( switchPoints6, 2) == 2 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints6(1), 100*switchPoints6(2), 1/0 );
   elseif ( size( switchPoints6, 2) == 3 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints6(1), 100*switchPoints6(2), 100*switchPoints6(3) );
   endif

   if ( size( switchPoints7, 2) == 0 )
      printf( "%3.12f,%3.12f,%3.12f,", 1/0, 1/0, 1/0 );
   elseif ( size( switchPoints7, 2) == 1 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints7(1), 1/0, 1/0 );
   elseif ( size( switchPoints7, 2) == 2 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints7(1), 100*switchPoints7(2), 1/0 );
   elseif ( size( switchPoints7, 2) == 3 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints7(1), 100*switchPoints7(2), 100*switchPoints7(3) );
   endif

   if ( size( switchPoints8, 2) == 0 )
      printf( "%3.12f,%3.12f,%3.12f,", 1/0, 1/0, 1/0 );
   elseif ( size( switchPoints8, 2) == 1 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints8(1), 1/0, 1/0 );
   elseif ( size( switchPoints8, 2) == 2 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints8(1), 100*switchPoints8(2), 1/0 );
   elseif ( size( switchPoints8, 2) == 3 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints8(1), 100*switchPoints8(2), 100*switchPoints8(3) );
   endif

   if ( size( switchPoints9, 2) == 0 )
      printf( "%3.12f,%3.12f,%3.12f,", 1/0, 1/0, 1/0 );
   elseif ( size( switchPoints9, 2) == 1 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints9(1), 1/0, 1/0 );
   elseif ( size( switchPoints9, 2) == 2 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints9(1), 100*switchPoints9(2), 1/0 );
   elseif ( size( switchPoints9, 2) == 3 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints9(1), 100*switchPoints9(2), 100*switchPoints9(3) );
   endif

   if ( size( switchPoints10, 2) == 0 )
      printf( "%3.12f,%3.12f,%3.12f,", 1/0, 1/0, 1/0 );
   elseif ( size( switchPoints10, 2) == 1 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints10(1), 1/0, 1/0 );
   elseif ( size( switchPoints10, 2) == 2 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints10(1), 100*switchPoints10(2), 1/0 );
   elseif ( size( switchPoints10, 2) == 3 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints10(1), 100*switchPoints10(2), 100*switchPoints10(3) );
   endif

   if ( size( switchPoints11, 2) == 0 )
      printf( "%3.12f,%3.12f,%3.12f,", 1/0, 1/0, 1/0 );
   elseif ( size( switchPoints11, 2) == 1 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints11(1), 1/0, 1/0 );
   elseif ( size( switchPoints11, 2) == 2 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints11(1), 100*switchPoints11(2), 1/0 );
   elseif ( size( switchPoints11, 2) == 3 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints11(1), 100*switchPoints11(2), 100*switchPoints11(3) );
   endif

   if ( size( switchPoints12, 2) == 0 )
      printf( "%3.12f,%3.12f,%3.12f,", 1/0, 1/0, 1/0 );
   elseif ( size( switchPoints12, 2) == 1 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints12(1), 1/0, 1/0 );
   elseif ( size( switchPoints12, 2) == 2 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints12(1), 100*switchPoints12(2), 1/0 );
   elseif ( size( switchPoints12, 2) == 3 )
      printf( "%3.12f,%3.12f,%3.12f,", 100*switchPoints12(1), 100*switchPoints12(2), 100*switchPoints12(3) );
   endif

   printf( "%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,", ...
   wMaxAlpha, wMaxBeta, wMaxGamma, wMaxDelta, ...
   wMaxEpsilon, wMaxZeta, wMaxEta, wMaxTheta );

   if ( size( switchPoints1, 2) == 0 )
      printf( "%3.12f,%3.12f,%3.12f,", 1/0, 1/0, 1/0 );
   elseif ( size( switchPoints1, 2) == 1 )
      printf( "%3.12f,%3.12f,%3.12f,", wages1(1), 1/0, 1/0 );
   elseif ( size( switchPoints1, 2) == 2 )
      printf( "%3.12f,%3.12f,%3.12f,", wages1(1), wages1(2), 1/0 );
   elseif ( size( switchPoints1, 2) == 3 )
      printf( "%3.12f,%3.12f,%3.12f,", wages1(1), wages1(2), wages1(3) );
   endif

   if ( size( switchPoints2, 2) == 0 )
      printf( "%3.12f,%3.12f,%3.12f,", 1/0, 1/0, 1/0 );
   elseif ( size( switchPoints2, 2) == 1 )
      printf( "%3.12f,%3.12f,%3.12f,", wages2(1), 1/0, 1/0 );
   elseif ( size( switchPoints2, 2) == 2 )
      printf( "%3.12f,%3.12f,%3.12f,", wages2(1), wages2(2), 1/0 );
   elseif ( size( switchPoints2, 2) == 3 )
      printf( "%3.12f,%3.12f,%3.12f,", wages2(1), wages2(2), wages2(3) );
   endif

   if ( size( switchPoints3, 2) == 0 )
      printf( "%3.12f,%3.12f,%3.12f,", 1/0, 1/0, 1/0 );
   elseif ( size( switchPoints3, 2) == 1 )
      printf( "%3.12f,%3.12f,%3.12f,", wages3(1), 1/0, 1/0 );
   elseif ( size( switchPoints3, 2) == 2 )
      printf( "%3.12f,%3.12f,%3.12f,", wages3(1), wages3(2), 1/0 );
   elseif ( size( switchPoints3, 2) == 3 )
      printf( "%3.12f,%3.12f,%3.12f,", wages3(1), wages3(2), wages3(3) );
   endif

   if ( size( switchPoints4, 2) == 0 )
      printf( "%3.12f,%3.12f,%3.12f,", 1/0, 1/0, 1/0 );
   elseif ( size( switchPoints4, 2) == 1 )
      printf( "%3.12f,%3.12f,%3.12f,", wages4(1), 1/0, 1/0 );
   elseif ( size( switchPoints4, 2) == 2 )
      printf( "%3.12f,%3.12f,%3.12f,", wages4(1), wages4(2), 1/0 );
   elseif ( size( switchPoints4, 2) == 3 )
      printf( "%3.12f,%3.12f,%3.12f,", wages4(1), wages4(2), wages4(3) );
   endif

  if ( size( switchPoints5, 2) == 0 )
      printf( "%3.12f,%3.12f,%3.12f,", 1/0, 1/0, 1/0 );
   elseif ( size( switchPoints5, 2) == 1 )
      printf( "%3.12f,%3.12f,%3.12f,", wages5(1), 1/0, 1/0 );
   elseif ( size( switchPoints5, 2) == 2 )
      printf( "%3.12f,%3.12f,%3.12f,", wages5(1), wages5(2), 1/0 );
   elseif ( size( switchPoints5, 2) == 3 )
      printf( "%3.12f,%3.12f,%3.12f,", wages5(1), wages5(2), wages5(3) );
   endif

   if ( size( switchPoints6, 2) == 0 )
      printf( "%3.12f,%3.12f,%3.12f,", 1/0, 1/0, 1/0 );
   elseif ( size( switchPoints6, 2) == 1 )
      printf( "%3.12f,%3.12f,%3.12f,", wages6(1), 1/0, 1/0 );
   elseif ( size( switchPoints6, 2) == 2 )
      printf( "%3.12f,%3.12f,%3.12f,", wages6(1), wages6(2), 1/0 );
   elseif ( size( switchPoints6, 2) == 3 )
      printf( "%3.12f,%3.12f,%3.12f,", wages6(1), wages6(2), wages6(3) );
   endif

   if ( size( switchPoints7, 2) == 0 )
      printf( "%3.12f,%3.12f,%3.12f,", 1/0, 1/0, 1/0 );
   elseif ( size( switchPoints7, 2) == 1 )
      printf( "%3.12f,%3.12f,%3.12f,", wages7(1), 1/0, 1/0 );
   elseif ( size( switchPoints7, 2) == 2 )
      printf( "%3.12f,%3.12f,%3.12f,", wages7(1), wages7(2), 1/0 );
   elseif ( size( switchPoints7, 2) == 3 )
      printf( "%3.12f,%3.12f,%3.12f,", wages7(1), wages7(2), wages7(3) );
   endif

   if ( size( switchPoints8, 2) == 0 )
      printf( "%3.12f,%3.12f,%3.12f,", 1/0, 1/0, 1/0 );
   elseif ( size( switchPoints8, 2) == 1 )
      printf( "%3.12f,%3.12f,%3.12f,", wages8(1), 1/0, 1/0 );
   elseif ( size( switchPoints8, 2) == 2 )
      printf( "%3.12f,%3.12f,%3.12f,", wages8(1), wages8(2), 1/0 );
   elseif ( size( switchPoints8, 2) == 3 )
      printf( "%3.12f,%3.12f,%3.12f,", wages8(1), wages8(2), wages8(3) );
   endif

   if ( size( switchPoints9, 2) == 0 )
      printf( "%3.12f,%3.12f,%3.12f,", 1/0, 1/0, 1/0 );
   elseif ( size( switchPoints9, 2) == 1 )
      printf( "%3.12f,%3.12f,%3.12f,", wages9(1), 1/0, 1/0 );
   elseif ( size( switchPoints9, 2) == 2 )
      printf( "%3.12f,%3.12f,%3.12f,", wages9(1), wages9(2), 1/0 );
   elseif ( size( switchPoints9, 2) == 3 )
      printf( "%3.12f,%3.12f,%3.12f,", wages9(1), wages9(2), wages9(3) );
   endif

   if ( size( switchPoints10, 2) == 0 )
      printf( "%3.12f,%3.12f,%3.12f,", 1/0, 1/0, 1/0 );
   elseif ( size( switchPoints10, 2) == 1 )
      printf( "%3.12f,%3.12f,%3.12f,", wages10(1), 1/0, 1/0 );
   elseif ( size( switchPoints10, 2) == 2 )
      printf( "%3.12f,%3.12f,%3.12f,", wages10(1), wages10(2), 1/0 );
   elseif ( size( switchPoints10, 2) == 3 )
      printf( "%3.12f,%3.12f,%3.12f,", wages10(1), wages10(2), wages10(3) );
   endif

   if ( size( switchPoints11, 2) == 0 )
      printf( "%3.12f,%3.12f,%3.12f,", 1/0, 1/0, 1/0 );
   elseif ( size( switchPoints11, 2) == 1 )
      printf( "%3.12f,%3.12f,%3.12f,", wages11(1), 1/0, 1/0 );
   elseif ( size( switchPoints11, 2) == 2 )
      printf( "%3.12f,%3.12f,%3.12f,", wages11(1), wages11(2), 1/0 );
   elseif ( size( switchPoints11, 2) == 3 )
      printf( "%3.12f,%3.12f,%3.12f,", wages11(1), wages11(2), wages11(3) );
   endif

   if ( size( switchPoints12, 2) == 0 )
      printf( "%3.12f,%3.12f,%3.12f", 1/0, 1/0, 1/0 );
   elseif ( size( switchPoints12, 2) == 1 )
      printf( "%3.12f,%3.12f,%3.12f", wages12(1), 1/0, 1/0 );
   elseif ( size( switchPoints12, 2) == 2 )
      printf( "%3.12f,%3.12f,%3.12f", wages12(1), wages12(2), 1/0 );
   elseif ( size( switchPoints12, 2) == 3 )
      printf( "%3.12f,%3.12f,%3.12f", wages12(1), wages12(2), wages12(3) );
   endif

   printf( "\n" );
endfor

