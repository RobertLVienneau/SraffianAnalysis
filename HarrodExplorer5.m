% Code for analyzing the choice of technique.
clear all

% For exploring Harrod-neutral technical progress in Alpha and Delta.
theta = 0.8;   % For Alpha
phi = 0.096;     % For Delta
t = 1;

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

printf( "\n" );
printf( "time," );
printf( "Alpha max r (percent),Beta max r (percent),Gamma max r (percent),Delta max r (percent)," );

printf( "Alpha vs Beta r (percent),Alpha vs Beta r (Percent)," );
printf( "Alpha vs Gamma r (percent),Alpha vs Gamma r (Percent)," );
printf( "Beta vs Delta r (percent),Beta vs Delta r (Percent)," );
printf( "Delta vs Gamma r (percent),Delta vs Gamma r (percent)," );

printf( "Alpha max w,Beta max w,Gamma max w,Delta max w," );

printf( "Alpha vs Beta w,Alpha vs Beta w," );
printf( "Alpha vs Gamma w,Alpha vs Gamma w," );
printf( "Beta vs Delta w,Beta vs Delta w," );
printf( "Delta vs Gamma w,Delta vs Gamma w" );
printf( "\n" );

timeStart = 5.0;
timeEnd = 6.0;
increments = 20;

% timeStart = 5.951214122;
% imeEnd = 5.951214122;
% increments = 2;

timeIncrement = (timeEnd - timeStart)/(increments - 1);

for idx=1:1:increments

     t = timeStart + timeIncrement*(idx - 1);

     % Set matrices
     a0 = [1*exp(1 - theta*t), (2/5)*exp(1 - phi*t), (33/50)*exp(1 - theta*t), (1/100)*exp(1 - phi*t)];
     a0Alpha = [a0(1), a0(3)];
     a0Beta = [a0(1), a0(4)];
     a0Gamma = [a0(2), a0(3)];
     a0Delta = [a0(2), a0(4)];

     % Find polynomials for rational functions for each technique.
     [fAlpha, gAlpha, uAlpha, vAlpha] = get_rational_functions2( a0Alpha, AAlpha, BAlpha, d, S);
     [fBeta, gBeta, uBeta, vBeta] = get_rational_functions2( a0Beta, ABeta, BBeta, d, S);
     [fGamma, gGamma, uGamma, vGamma] = get_rational_functions2( a0Gamma, AGamma, BGamma, d, S);
     [fDelta, gDelta, uDelta, vDelta] = get_rational_functions2( a0Delta, ADelta, BDelta, d, S);
     % Find the maximum rate of profits for the techniques.
     rMaxAlpha = get_r_max2( fAlpha );
     rMaxBeta = get_r_max2( fBeta );
     rMaxGamma = get_r_max2( fGamma );
     rMaxDelta = get_r_max2( fDelta );
     % Find the maximum wage.
     wMaxAlpha = get_maximum_wage( fAlpha, gAlpha );
     wMaxBeta = get_maximum_wage( fBeta, gBeta );
     wMaxGamma = get_maximum_wage( fGamma, gGamma );
     wMaxDelta = get_maximum_wage( fDelta, gDelta );

     % Get switch points
     % Only pairs of techniques that differ in one process are considered:
     % Alpha and Beta, Alpha and Gamma, Beta and Delta, Gamma and Delta.

     [nSwitchPoints1, switchPoints1] = get_switch_points( ...
        fAlpha, gAlpha, fBeta, gBeta, 0, min( rMaxAlpha, rMaxBeta ) );

     wagesForSwitchPoint1 = zeros(1, nSwitchPoints1 );
     if (~( nSwitchPoints1 == 0))
        for idx = 1:1:nSwitchPoints1
            wagesForSwitchPoint1( idx ) = get_wage_rational( ...
                switchPoints1( idx ), fAlpha, gAlpha, rMaxAlpha );
        endfor
      endif

     [nSwitchPoints2, switchPoints2] = get_switch_points( ...
        fAlpha, gAlpha, fGamma, gGamma, 0, min( rMaxAlpha, rMaxGamma ) );

     wagesForSwitchPoint2 = zeros(1, nSwitchPoints2 );
     if (~( nSwitchPoints2 == 0))
        for idx = 1:1:nSwitchPoints2
            wagesForSwitchPoint2( idx ) = get_wage_rational( ...
                switchPoints2( idx ), fAlpha, gAlpha, rMaxAlpha );
        endfor
      endif

     [nSwitchPoints3, switchPoints3] = get_switch_points( ...
        fBeta, gBeta, fDelta, gDelta, 0, min( rMaxBeta, rMaxDelta ) );

     wagesForSwitchPoint3 = zeros(1, nSwitchPoints3 );
     if (~( nSwitchPoints3 == 0))
        for idx = 1:1:nSwitchPoints3
            wagesForSwitchPoint3( idx ) = get_wage_rational( ...
                switchPoints3( idx ), fBeta, gBeta, rMaxBeta );
        endfor
      endif

     [nSwitchPoints4, switchPoints4] = get_switch_points( ...
        fGamma, gGamma, fDelta, gDelta, 0, min( rMaxGamma, rMaxDelta ) );

     wagesForSwitchPoint4 = zeros(1, nSwitchPoints4 );
     if (~( nSwitchPoints4 == 0))
        for idx = 1:1:nSwitchPoints4
            wagesForSwitchPoint4( idx ) = get_wage_rational( ...
                switchPoints4( idx ), fGamma, gGamma, rMaxGamma );
        endfor
      endif

      % Echo results to stanard out.
      printf( "%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,",
         t,100*rMaxAlpha,100*rMaxBeta,100*rMaxGamma,100*rMaxDelta );

      if ( nSwitchPoints1 == 0 )
         printf( "%3.12f,%3.12f,",
            1/0, 1/0 );
      elseif (nSwitchPoints1 == 1 )
         printf( "%3.12f,%3.12f,",
            100*switchPoints1(1), 1/0 );
      elseif (nSwitchPoints1 == 2 )
         printf( "%3.12f,%3.12f,",
            100*switchPoints1(1), 100*switchPoints1(2) );
      endif

      if ( nSwitchPoints2 == 0 )
         printf( "%3.12f,%3.12f,",
            1/0, 1/0 );
      elseif (nSwitchPoints2 == 1 )
         printf( "%3.12f,%3.12f,",
            100*switchPoints2(1), 1/0 );
      elseif (nSwitchPoints2 == 2 )
         printf( "%3.12f,%3.12f,",
            100*switchPoints2(1), 100*switchPoints2(2) );
      endif

      if ( nSwitchPoints3 == 0 )
         printf( "%3.12f,%3.12f,",
            1/0, 1/0 );
      elseif (nSwitchPoints3 == 1 )
         printf( "%3.12f,%3.12f,",
            100*switchPoints3(1), 1/0 );
      elseif (nSwitchPoints3 == 2 )
         printf( "%3.12f,%3.12f,",
            100*switchPoints3(1), 100*switchPoints3(2) );
      endif

      if ( nSwitchPoints4 == 0 )
         printf( "%3.12f,%3.12f,",
            1/0, 1/0 );
      elseif (nSwitchPoints4 == 1 )
         printf( "%3.12f,%3.12f,",
            100*switchPoints4(1), 1/0 );
      elseif (nSwitchPoints4 == 2 )
         printf( "%3.12f,%3.12f,",
            100*switchPoints4(1), 100*switchPoints4(2) );
      endif

      printf( "%3.12f,%3.12f,%3.12f,%3.12f,",
         wMaxAlpha,wMaxBeta,wMaxGamma,wMaxDelta );

       if ( nSwitchPoints1 == 0 )
         printf( "%3.12f,%3.12f,",
            1/0, 1/0 );
      elseif (nSwitchPoints1 == 1 )
         printf( "%3.12f,%3.12f,",
            wagesForSwitchPoint1(1), 1/0 );
      elseif (nSwitchPoints1 == 2 )
         printf( "%3.12f,%3.12f,",
            wagesForSwitchPoint1(1),wagesForSwitchPoint1(2) );
      endif

       if ( nSwitchPoints2 == 0 )
         printf( "%3.12f,%3.12f,",
            1/0, 1/0 );
      elseif (nSwitchPoints2 == 1 )
         printf( "%3.12f,%3.12f,",
            wagesForSwitchPoint2(1), 1/0 );
      elseif (nSwitchPoints2 == 2 )
         printf( "%3.12f,%3.12f,",
            wagesForSwitchPoint2(1),wagesForSwitchPoint2(2) );
      endif

       if ( nSwitchPoints3 == 0 )
         printf( "%3.12f,%3.12f,",
            1/0, 1/0 );
      elseif (nSwitchPoints3 == 1 )
         printf( "%3.12f,%3.12f,",
            wagesForSwitchPoint3(1), 1/0 );
      elseif (nSwitchPoints3 == 2 )
         printf( "%3.12f,%3.12f,",
            wagesForSwitchPoint3(1),wagesForSwitchPoint3(2) );
      endif

      if ( nSwitchPoints4 == 0 )
         printf( "%3.12f,%3.12f",
            1/0, 1/0 );
      elseif (nSwitchPoints4 == 1 )
         printf( "%3.12f,%3.12f",
            wagesForSwitchPoint4(1), 1/0 );
      elseif (nSwitchPoints4 == 2 )
         printf( "%3.12f,%3.12f",
            wagesForSwitchPoint4(1),wagesForSwitchPoint4(2) );
      endif
      printf( "\n" );

endfor


