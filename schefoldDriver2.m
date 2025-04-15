% Code for analyzing the choice of technique in a triple switching example.

clear all

% TODO: Write subroutines
%    To check Hawkins-Simon conditions.
%    To solve for switch points
%    To find maximum wage
%    To find fluke cases
%    To do all of these for 4-commodity model. Octave seems to be able
%      to find roots for 5th degree polynomial.
%    To find a0, A, B for Corn-Tractor model? To do all of these for this model?


s1 = 1/2;        % Markup in machine industry.
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



printf( "\n" );
printf( "s1,max r Alpha (percent),max r Gamma (percent), r (percent), r (percent), r (percent), max w Alpha, max w Gamma, w1, w2, w3\n");

s1Start = 0.495;
s1End = 0.505;
increments = 100;

s1Increment = (s1End - s1Start)/(increments - 1);

for idx=1:1:increments

   s1 = s1Start + s1Increment*(idx - 1);
   s2 = 1 - s1;

   SAlpha = [s2];
   SGamma = [[s1, 0, 0]; ...
        [0, s2, 0]; ...
        [0, 0, s2]];

   % Find polynomials for rational functions for each echnique.
   [fAlpha, gAlpha, uAlpha] = get_rational_functions1( a0Alpha, AAlpha, BAlpha, dAlpha, SAlpha);
   [fGamma, gGamma, tGamma, uGamma, vGamma] = get_rational_functions3( a0Gamma, AGamma, BGamma, dGamma, SGamma);

   % Find the maximum rate of profits for the techniques.
   rMaxAlpha = get_r_max2( fAlpha );
   rMaxGamma = get_r_max2( fGamma );

   % Get maximum wages.
   wMaxAlpha = get_maximum_wage( fAlpha, gAlpha );
   wMaxGamma = get_maximum_wage( fGamma, gGamma );

   % Get switch points.
   [nSwitchPoints2, switchPoints2] = get_switch_points( ...
       fAlpha, gAlpha, fGamma, gGamma, 0, min( rMaxAlpha, rMaxGamma ) );

    wagesForSwitchPoint2 = zeros(1, nSwitchPoints2 );
    if ( ~( nSwitchPoints2 == 0) )
         for idx = 1:1:nSwitchPoints2
             wagesForSwitchPoint2( idx ) = get_wage_rational( ...
                 switchPoints2( idx ), fAlpha, gAlpha, rMaxAlpha );
          endfor
    endif

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

endfor;

