% Code for finding a fluke switch point in which the Beta, Delta, Zeta and Theta wage curves intersect.
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

% Define Beta, Delta, Zeta, and Theta
[a0Beta, ABeta, BBeta, S] = ...
    get_technique_parameters( [1, 3, 6], a0, A, B, [s1, s1, s2, s2, s3, s3] );
[a0Delta, ADelta, BDelta, S] = ...
    get_technique_parameters( [1, 4, 6], a0, A, B, [s1, s1, s2, s2, s3, s3] );
[a0Zeta, AZeta, BZeta, S] = ...
    get_technique_parameters( [2, 3, 6], a0, A, B, [s1, s1, s2, s2, s3, s3] );
[a0Theta, ATheta, BTheta, S] = ...
    get_technique_parameters( [2, 4, 6], a0, A, B, [s1, s1, s2, s2, s3, s3] );

% -----------------
sigmaInitial1 = 2.3;
sigmaInitial2 = 5;

% Initialize a binary search.

% Process first guess.
sigmaLow = sigmaInitial1;

% Set row vector of labor coefficients
a0 = [(15/2)*exp(-phi*t), 32*exp(-sigmaLow*t), (13/2)*exp(-phi*t), 60*exp(-sigmaLow*t), (15/2)*exp(-phi*t), 55*exp(-sigmaLow*t)];

% Set matrices
[a0Beta, ABeta, BBeta, S] = ...
    get_technique_parameters( [1, 3, 6], a0, A, B, [s1, s1, s2, s2, s3, s3] );
[a0Delta, ADelta, BDelta, S] = ...
    get_technique_parameters( [1, 4, 6], a0, A, B, [s1, s1, s2, s2, s3, s3] );
[a0Zeta, AZeta, BZeta, S] = ...
    get_technique_parameters( [2, 3, 6], a0, A, B, [s1, s1, s2, s2, s3, s3] );
[a0Theta, ATheta, BTheta, S] = ...
    get_technique_parameters( [2, 4, 6], a0, A, B, [s1, s1, s2, s2, s3, s3] );

% Find polynomials for rational functions for each technique.
[fBeta, gBeta, numerBeta] = get_rational_functions( a0Beta, ABeta, BBeta, d, S);
[fDelta, gDelta, numerDelta] = get_rational_functions( a0Delta, ADelta, BDelta, d, S);
[fZeta, gZeta, numerZeta] = get_rational_functions( a0Zeta, AZeta, BZeta, d, S);
[fTheta, gTheta, numerTheta] = get_rational_functions( a0Theta, ATheta, BTheta, d, S);

% Find the maximum rate of profits for the techniques.
rMaxBeta = get_r_max2( fBeta );
rMaxDelta = get_r_max2( fDelta );
rMaxZeta = get_r_max2( fZeta );
rMaxTheta = get_r_max2( fTheta );

% Get switch points between Beta & Delta and Zeta & Theta
% Beta and Delta differ in the second process.
switchPoints4 = get_switch_points_from_prices( fBeta, gBeta, numerBeta, d, S(2,2), ......
     a0Delta(2), ADelta(:,2), BDelta(:,2), 0, min( rMaxBeta, rMaxDelta ) );
% Zeta and Theta differ in the second process.
switchPoints11 = get_switch_points_from_prices( fZeta, gZeta, numerZeta, d, S(2,2), ......
     a0Theta(2), ATheta(:,2), BTheta(:,2), -1, min( rMaxZeta, rMaxTheta ) );

% Find the difference
differenceLow = switchPoints4(1) - switchPoints11(1);


% Process second guess.
sigmaHigh = sigmaInitial2;

% Set row vector of labor coefficients
a0 = [(15/2)*exp(-phi*t), 32*exp(-sigmaHigh*t), (13/2)*exp(-phi*t), 60*exp(-sigmaHigh*t), (15/2)*exp(-phi*t), 55*exp(-sigmaHigh*t)];

% Set matrices
[a0Beta, ABeta, BBeta, S] = ...
    get_technique_parameters( [1, 3, 6], a0, A, B, [s1, s1, s2, s2, s3, s3] );
[a0Delta, ADelta, BDelta, S] = ...
    get_technique_parameters( [1, 4, 6], a0, A, B, [s1, s1, s2, s2, s3, s3] );
[a0Zeta, AZeta, BZeta, S] = ...
    get_technique_parameters( [2, 3, 6], a0, A, B, [s1, s1, s2, s2, s3, s3] );
[a0Theta, ATheta, BTheta, S] = ...
    get_technique_parameters( [2, 4, 6], a0, A, B, [s1, s1, s2, s2, s3, s3] );

% Find polynomials for rational functions for each technique.
[fBeta, gBeta, numerBeta] = get_rational_functions( a0Beta, ABeta, BBeta, d, S);
[fDelta, gDelta, numerDelta] = get_rational_functions( a0Delta, ADelta, BDelta, d, S);
[fZeta, gZeta, numerZeta] = get_rational_functions( a0Zeta, AZeta, BZeta, d, S);
[fTheta, gTheta, numerTheta] = get_rational_functions( a0Theta, ATheta, BTheta, d, S);

% Find the maximum rate of profits for the techniques.
rMaxBeta = get_r_max2( fBeta );
rMaxDelta = get_r_max2( fDelta );
rMaxZeta = get_r_max2( fZeta );
rMaxTheta = get_r_max2( fTheta );

% Get switch points between Beta & Delta and Zeta & Theta
% Beta and Delta differ in the second process.
switchPoints4 = get_switch_points_from_prices( fBeta, gBeta, numerBeta, d, S(2,2), ......
     a0Delta(2), ADelta(:,2), BDelta(:,2), 0, min( rMaxBeta, rMaxDelta ) );
% Zeta and Theta differ in the second process.
switchPoints11 = get_switch_points_from_prices( fZeta, gZeta, numerZeta, d, S(2,2), ......
     a0Theta(2), ATheta(:,2), BTheta(:,2), -1, min( rMaxZeta, rMaxTheta ) );

% Find the difference
differenceHigh = switchPoints4(1) - switchPoints11(1);

if ( differenceLow*differenceHigh < 0 )
   % Perform a binary search.
   epsilon = 10^-15;

   while ( abs( differenceHigh - differenceLow) > epsilon )
     % Use midpoint as next guess.
     sigmaNew = (sigmaLow + sigmaHigh)/2;

     % Set row vector of labor coefficients
     a0 = [(15/2)*exp(-phi*t), 32*exp(-sigmaNew*t), (13/2)*exp(-phi*t), ...
          60*exp(-sigmaNew*t), (15/2)*exp(-phi*t), 55*exp(-sigmaNew*t)];

   % Set matrices
   [a0Beta, ABeta, BBeta, S] = ...
        get_technique_parameters( [1, 3, 6], a0, A, B, [s1, s1, s2, s2, s3, s3] );
   [a0Delta, ADelta, BDelta, S] = ...
        get_technique_parameters( [1, 4, 6], a0, A, B, [s1, s1, s2, s2, s3, s3] );
   [a0Zeta, AZeta, BZeta, S] = ...
        get_technique_parameters( [2, 3, 6], a0, A, B, [s1, s1, s2, s2, s3, s3] );
   [a0Theta, ATheta, BTheta, S] = ...
        get_technique_parameters( [2, 4, 6], a0, A, B, [s1, s1, s2, s2, s3, s3] );

    % Find polynomials for rational functions for each technique.
    [fBeta, gBeta, numerBeta] = get_rational_functions( a0Beta, ABeta, BBeta, d, S);
    [fDelta, gDelta, numerDelta] = get_rational_functions( a0Delta, ADelta, BDelta, d, S);
    [fZeta, gZeta, numerZeta] = get_rational_functions( a0Zeta, AZeta, BZeta, d, S);
    [fTheta, gTheta, numerTheta] = get_rational_functions( a0Theta, ATheta, BTheta, d, S);

     % Find the maximum rate of profits for the techniques.
     rMaxBeta = get_r_max2( fBeta );
     rMaxDelta = get_r_max2( fDelta );
     rMaxZeta = get_r_max2( fZeta );
     rMaxTheta = get_r_max2( fTheta );

     % Get switch points between Beta & Delta and Zeta & Theta
     % Beta and Delta differ in the second process.
     switchPoints4 = get_switch_points_from_prices( fBeta, gBeta, numerBeta, d, S(2,2), ......
          a0Delta(2), ADelta(:,2), BDelta(:,2), 0, min( rMaxBeta, rMaxDelta ) );
     % Zeta and Theta differ in the second process.
     switchPoints11 = get_switch_points_from_prices( fZeta, gZeta, numerZeta, d, S(2,2), ......
          a0Theta(2), ATheta(:,2), BTheta(:,2), -1, min( rMaxZeta, rMaxTheta ) );

     % Find the difference
     differenceNew = switchPoints4(1) - switchPoints11(1);

     printf( " Next guess for sigma: %1.12d, difference: %d\n", sigmaNew, differenceNew );
      % Is this new difference the same sign as differenceLow?
     if ( differenceLow*differenceNew > 0 )
       sigmaLow = sigmaNew;
       differenceLow = differenceNew;
     else
       % This new difference must be the same sign as differenceHigh.
       sigmaHigh = sigmaNew;
       differenceHigh = differenceNew;
     endif
   endwhile

else
  printf( "Initial guesses do not surround the solution value!\n");

endif



