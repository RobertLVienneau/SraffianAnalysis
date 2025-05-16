% Code for analyzing the choice of technique in a triple switching example.

clear all
%
%  schefoldFlukeDriver.m
%
% See schefieldDriver.m
%
% TODO: Write subroutines
%    To check Hawkins-Simon conditions.
%    To solve for switch points
%    To find maximum wage
%    To find fluke cases
%    To do all of these for 4-commodity model. Octave seems to be able
%      to find roots for 5th degree polynomial.
%    To find a0, A, B for Corn-Tractor model? To do all of these for this model?

% 1, to find a fluke Alpha vs. Gamm switch point on the axis for the rate of profits.
% 2, to find a fluke Alpha vs. Gamm switch point at which switch points are tangent.
%    See lines 166-170.
algorithmIndex = 2;

s1 = 1/2;        % Markup in machine industry.
s2 = 1 - s1;   % Markup in corn industry.

% s1 = 1;
% s2 = 1;

% This code is to find markups for certain fluke switch points.
% The above markups are ignored.

% Notes:
%    s1     Number of switch points (Between Alpha and Gamma)
%    0.495     0     Somewhere the switch point is on the axis for the rate of profits.
%    0.496     1
%    0.497     1     Somewhere two switch points co-incide.
%    0.498     3
%    0.499     3
%    0.5       3     Somewhere two switch points co-incide.
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

if (algorithmIndex == 1)

   % -----------------
   % Find example with switch point on the axis for the rate of profits.
   s1Initial1 = 0.496;
   s1Initial2 = 0.495;

   % Initialize a binary search.

   % Process first guess.
   s1Low = s1Initial1;
   % Set diagonal matrices.
   SAlpha = [1 - s1Low];
   SGamma = [[s1Low, 0, 0]; ...
           [0, 1 - s1Low, 0]; ...
           [0, 0, 1 - s1Low]];
   % Find polynomials for rational functions for each technique.
   [fAlpha, gAlpha, uAlpha] = get_rational_functions1( a0Alpha, AAlpha, BAlpha, dAlpha, SAlpha);
   [fGamma, gGamma, tGamma, uGamma, vGamma] = get_rational_functions3( a0Gamma, AGamma, BGamma, dGamma, SGamma);
   % Find the maximum rate of profits for the  techniques.
   rMaxAlpha = get_r_max2( fAlpha );
   rMaxGamma = get_r_max2( fGamma );
   % Find the difference
   differenceLow = rMaxGamma - rMaxAlpha

   % Process second guess.
   s1High = s1Initial2;
   % Set diagonal matrices.
   SAlpha = [1 - s1High];
   SGamma = [[s1High, 0, 0]; ...
           [0, 1 - s1High, 0]; ...
           [0, 0, 1 - s1High]];
   % Find polynomials for rational functions for each technique.
   [fAlpha, gAlpha, uAlpha] = get_rational_functions1( a0Alpha, AAlpha, BAlpha, dAlpha, SAlpha);
   [fGamma, gGamma, tGamma, uGamma, vGamma] = get_rational_functions3( a0Gamma, AGamma, BGamma, dGamma, SGamma);
   % Find the maximum rate of profits for the  techniques.
   rMaxAlpha = get_r_max2( fAlpha );
   rMaxGamma = get_r_max2( fGamma );
   % Find the difference
   differenceHigh = rMaxGamma - rMaxAlpha

   if ( differenceLow*differenceHigh < 0 )
     % Perform a binary search.
     epsilon = 10^-15;

     while ( abs( differenceHigh - differenceLow) > epsilon )
        % Use midpoint as next guess.
        s1New = (s1Low + s1High)/2;
        SAlpha = [1 - s1New];
        SGamma = [[s1New, 0, 0]; ...
           [0, 1 - s1New, 0]; ...
           [0, 0, 1 - s1New]];
        % Find polynomials for rational functions for each technique.
        [fAlpha, gAlpha, uAlpha] = get_rational_functions1( a0Alpha, AAlpha, BAlpha, dAlpha, SAlpha);
        [fGamma, gGamma, tGamma, uGamma, vGamma] = get_rational_functions3( a0Gamma, AGamma, BGamma, dGamma, SGamma);
        % Find the maximum rate of profits for the  techniques.
        rMaxAlpha = get_r_max2( fAlpha );
        rMaxGamma = get_r_max2( fGamma );
        % Find the difference
        differenceNew = rMaxGamma - rMaxAlpha;
        printf( " Next guess for s1: %1.12d, difference: %d\n", s1New, differenceNew );
        % Is this new difference the same sign as differenceLow?
        if ( differenceLow*differenceNew > 0 )
          s1Low = s1New;
          differenceLow = differenceNew;
        else
          % This new difference must be the same sign as differenceHigh.
          s1High = s1New;
          differenceHigh = differenceNew;
        endif
     endwhile

   else
     printf( "Initial guesses do not surround the solution value!\n");
   endif

elseif (algorithmIndex == 2)

   % -----------------
   % Find example with wage curves tangent at repeating switch points.

   % s1Initial1 = 0.5;
   % s1Initial2 = 0.501;

   s1Initial1 = 0.496;
   s1Initial2 = 0.5;


   % Initialize a binary search.

   % Process first guess.
   s1Low = s1Initial1;
   % Set diagonal matrices.
   SAlpha = [1 - s1Low];
   SGamma = [[s1Low, 0, 0]; ...
           [0, 1 - s1Low, 0]; ...
           [0, 0, 1 - s1Low]];
   % Find polynomials for rational functions for each technique.
   [fAlpha, gAlpha, uAlpha] = get_rational_functions1( a0Alpha, AAlpha, BAlpha, dAlpha, SAlpha);
   [fGamma, gGamma, tGamma, uGamma, vGamma] = get_rational_functions3( a0Gamma, AGamma, BGamma, dGamma, SGamma);
   % Find the maximum rate of profits for the  techniques.
   rMaxAlpha = get_r_max2( fAlpha );
   rMaxGamma = get_r_max2( fGamma );
   % Get switch points.
   [nSwitchPointsLow, switchPoints2] = get_switch_points( ...
      fAlpha, gAlpha, fGamma, gGamma, 0, min( rMaxAlpha, rMaxGamma ) );

   % Process second guess.
   s1High = s1Initial2;
   % Set diagonal matrices.
   SAlpha = [1 - s1High];
   SGamma = [[s1High, 0, 0]; ...
           [0, 1 - s1High, 0]; ...
           [0, 0, 1 - s1High]];
   % Find polynomials for rational functions for each technique.
   [fAlpha, gAlpha, uAlpha] = get_rational_functions1( a0Alpha, AAlpha, BAlpha, dAlpha, SAlpha);
   [fGamma, gGamma, tGamma, uGamma, vGamma] = get_rational_functions3( a0Gamma, AGamma, BGamma, dGamma, SGamma);
   % Find the maximum rate of profits for the  techniques.
   rMaxAlpha = get_r_max2( fAlpha );
   rMaxGamma = get_r_max2( fGamma );
   % Get switch points.
   [nSwitchPointsHigh, switchPoints2] = get_switch_points( ...
      fAlpha, gAlpha, fGamma, gGamma, 0, min( rMaxAlpha, rMaxGamma ) );

   if ( ~( nSwitchPointsLow == nSwitchPointsHigh ) )
     while ( ~( nSwitchPointsLow == nSwitchPointsHigh ) )
        % Use midpoint as next guess.
        s1New = (s1Low + s1High)/2;
        SAlpha = [1 - s1New];
        SGamma = [[s1New, 0, 0]; ...
           [0, 1 - s1New, 0]; ...
           [0, 0, 1 - s1New]];
        % Find polynomials for rational functions for each technique.
        [fAlpha, gAlpha, uAlpha] = get_rational_functions1( a0Alpha, AAlpha, BAlpha, dAlpha, SAlpha);
        [fGamma, gGamma, tGamma, uGamma, vGamma] = get_rational_functions3( a0Gamma, AGamma, BGamma, dGamma, SGamma);
        % Find the maximum rate of profits for the  techniques.
        rMaxAlpha = get_r_max2( fAlpha );
        rMaxGamma = get_r_max2( fGamma );
        % Get switch points.
        [nSwitchPointsNew, switchPoints2] = get_switch_points( ...
              fAlpha, gAlpha, fGamma, gGamma, 0, min( rMaxAlpha, rMaxGamma ) );
        printf( " Next guess for s1: %1.12d, number of switch points: %d\n", s1New, nSwitchPointsNew );

        if ( nSwitchPointsLow == nSwitchPointsNew )
          s1Low = s1New;
          nSwitchPointsLow = nSwitchPointsNew;
        else
          s1High = s1New;
          nSwitchPointsHigh = nSwitchPointsNew;
        endif


     endwhile
   else
       printf( "Initial guesses do not surround the solution value!\n");
   endif

endif





