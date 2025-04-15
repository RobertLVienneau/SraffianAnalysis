% Code for finding a fluke switch point in which the Alpha and Beta wage curves are tangent.
clear all

% For exploring Harrod-neutral change in Alpha and Theta techniques.
phi = 0;       % Rate of growth of productivity for Alpha.
sigma = 4.292372532;     % Rate of growth of productivity for Theta.
t = 1;

% Do I need to run this more than once?

% Competitive markets. Simplifies calculation of switch points.

s1 = 1;
s2 = 1;
s3 = 1;

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

% Define Alpha and Beta
[a0Alpha, AAlpha, BAlpha, S] = ...
    get_technique_parameters( [1, 3, 5], a0, A, B, [s1, s1, s2, s2, s3, s3] );
[a0Beta, ABeta, BBeta, S] = ...
    get_technique_parameters( [1, 3, 6], a0, A, B, [s1, s1, s2, s2, s3, s3] );

% -----------------
sigmaInitial1 = 0.1;
sigmaInitial2 = 1;

% Initialize a binary search.

% Process first guess.
sigmaLow = sigmaInitial1;

% Set row vector of labor coefficients
a0 = [(15/2)*exp(-phi*t), 32*exp(-sigmaLow*t), (13/2)*exp(-phi*t), 60*exp(-sigmaLow*t), (15/2)*exp(-phi*t), 55*exp(-sigmaLow*t)];

% Set matrices
[a0Alpha, AAlpha, BAlpha, S] = ...
    get_technique_parameters( [1, 3, 5], a0, A, B, [s1, s1, s2, s2, s3, s3] );
[a0Beta, ABeta, BBeta, S] = ...
    get_technique_parameters( [1, 3, 6], a0, A, B, [s1, s1, s2, s2, s3, s3] );

% Find polynomials for rational functions for each echnique.
[fAlpha, gAlpha, numerAlpha] = get_rational_functions( a0Alpha, AAlpha, BAlpha, d, S);
[fBeta, gBeta, numerBeta] = get_rational_functions( a0Beta, ABeta, BBeta, d, S);

% Find the maximum rate of profits for the techniques.
rMaxAlpha = get_r_max2( fAlpha );
rMaxBeta = get_r_max2( fBeta );

% Get switch points between Alpha and Beta
switchPoints1 = get_switch_points_from_prices( fAlpha, gAlpha, numerAlpha, d, S(3,3), ......
     a0Beta(3), ABeta(:,3), BBeta(:,3), 0, min( rMaxAlpha, rMaxBeta ) );
% Count the number of switch points.
nSwitchPointsLow = size( switchPoints1, 2 );


% Process second guess.
sigmaHigh = sigmaInitial2;

% Set row vector of labor coefficients
a0 = [(15/2)*exp(-phi*t), 32*exp(-sigmaHigh*t), (13/2)*exp(-phi*t), ...
   60*exp(-sigmaHigh*t), (15/2)*exp(-phi*t), 55*exp(-sigmaHigh*t)];

% Set matrices
[a0Alpha, AAlpha, BAlpha, S] = ...
    get_technique_parameters( [1, 3, 5], a0, A, B, [s1, s1, s2, s2, s3, s3] );
[a0Beta, ABeta, BBeta, S] = ...
    get_technique_parameters( [1, 3, 6], a0, A, B, [s1, s1, s2, s2, s3, s3] );

% Find polynomials for rational functions for each echnique.
[fAlpha, gAlpha, numerAlpha] = get_rational_functions( a0Alpha, AAlpha, BAlpha, d, S);
[fBeta, gBeta, numerBeta] = get_rational_functions( a0Beta, ABeta, BBeta, d, S);

% Find the maximum rate of profits for the techniques.
rMaxAlpha = get_r_max2( fAlpha );
rMaxBeta = get_r_max2( fBeta );

% Get switch points between Alpha and Beta
switchPoints1 = get_switch_points_from_prices( fAlpha, gAlpha, numerAlpha, d, S(3,3), ......
     a0Beta(3), ABeta(:,3), BBeta(:,3), 0, min( rMaxAlpha, rMaxBeta ) );
% Count the number of switch points.
nSwitchPointsHigh = size( switchPoints1, 2 );

if ( ~( nSwitchPointsLow == nSwitchPointsHigh ) )
  while ( ~( nSwitchPointsLow == nSwitchPointsHigh ) )
     % Use midpoint as next guess.
     sigmaNew = (sigmaLow + sigmaHigh)/2;

     % Set row vector of labor coefficients
     a0 = [(15/2)*exp(-phi*t), 32*exp(-sigmaNew*t), (13/2)*exp(-phi*t), ...
          60*exp(-sigmaNew*t), (15/2)*exp(-phi*t), 55*exp(-sigmaNew*t)];

     % Set matrices
     [a0Alpha, AAlpha, BAlpha, S] = ...
         get_technique_parameters( [1, 3, 5], a0, A, B, [s1, s1, s2, s2, s3, s3] );
     [a0Beta, ABeta, BBeta, S] = ...
         get_technique_parameters( [1, 3, 6], a0, A, B, [s1, s1, s2, s2, s3, s3] );

      % Find polynomials for rational functions for each echnique.
      [fAlpha, gAlpha, numerAlpha] = get_rational_functions( a0Alpha, AAlpha, BAlpha, d, S);
      [fBeta, gBeta, numerBeta] = get_rational_functions( a0Beta, ABeta, BBeta, d, S);

       % Find the maximum rate of profits for the techniques.
       rMaxAlpha = get_r_max2( fAlpha );
       rMaxBeta = get_r_max2( fBeta );

       % Get switch points between Alpha and Beta
       switchPoints1 = get_switch_points_from_prices( fAlpha, gAlpha, numerAlpha, d, S(3,3), ......
          a0Beta(3), ABeta(:,3), BBeta(:,3), 0, min( rMaxAlpha, rMaxBeta ) );
       % Count the number of switch points.
       nSwitchPointsNew = size( switchPoints1, 2 );

       printf( " Next guess for sigma: %1.12d, number of switch points: %d\n", ...
           sigmaNew, nSwitchPointsNew );

       if ( nSwitchPointsLow == nSwitchPointsNew )
         sigmaLow = sigmaNew;
         nSwitchPointsLow = nSwitchPointsNew;
       else
         sigmaHigh = sigmaNew;
         nSwitchPointsHigh = nSwitchPointsNew;
       endif

  endwhile
else
    printf( "Initial guesses do not surround the solution value!\n");
endif


