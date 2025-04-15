% Code for finding fluke switch points.

clear all

% For exploring Harrod-neutral technical progress in Alpha and Delta.
theta = 4.2;   % For Alpha
phi = 0.4;     % For Delta
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

% -----------------
% Find example with switch point for Beta and Delta on the wage axis..
phiInitial1 = 0.001;
phiInitial2 = 5;

% Initialize a binary search.

% Process first guess.
phiLow = phiInitial1;
% Set matrices
a0 = [1*exp(1 - theta*t), (2/5)*exp(1 - phiLow*t), (33/50)*exp(1 - theta*t), (1/100)*exp(1 - phiLow*t)];
a0Beta = [a0(1), a0(4)];
a0Delta = [a0(2), a0(4)];
% Find polynomials for rational functions for each technique.
[fBeta, gBeta, uBeta, vBeta] = get_rational_functions2( a0Beta, ABeta, BBeta, d, S);
[fDelta, gDelta, uDelta, vDelta] = get_rational_functions2( a0Delta, ADelta, BDelta, d, S);
% Get maximum wages.
wMaxBeta = get_maximum_wage( fBeta, gBeta );
wMaxDelta = get_maximum_wage( fDelta, gDelta );
% Find the difference
differenceLow = wMaxDelta - wMaxBeta;


% Process second guess.
phiHigh = phiInitial2;
% Set matrices
a0 = [1*exp(1 - theta*t), (2/5)*exp(1 - phiHigh*t), (33/50)*exp(1 - theta*t), (1/100)*exp(1 - phiHigh*t)];
a0Beta = [a0(1), a0(4)];
a0Delta = [a0(2), a0(4)];
% Find polynomials for rational functions for each technique.
[fBeta, gBeta, uBeta, vBeta] = get_rational_functions2( a0Beta, ABeta, BBeta, d, S);
[fDelta, gDelta, uDelta, vDelta] = get_rational_functions2( a0Delta, ADelta, BDelta, d, S);
% Get maximum wages.
wMaxBeta = get_maximum_wage( fBeta, gBeta );
wMaxDelta = get_maximum_wage( fDelta, gDelta );
% Find the difference
differenceHigh = wMaxDelta - wMaxBeta;

if ( differenceLow*differenceHigh < 0 )
  % Perform a binary search.
  epsilon = 10^-15;

  while ( abs( differenceHigh - differenceLow) > epsilon )
     % Use midpoint as next guess.
     phiNew = (phiLow + phiHigh)/2;
     % Set matrices
     a0 = [1*exp(1 - theta*t), (2/5)*exp(1 - phiNew*t), (33/50)*exp(1 - theta*t), (1/100)*exp(1 - phiNew*t)];
     a0Beta = [a0(1), a0(4)];
     a0Delta = [a0(2), a0(4)];
     % Find polynomials for rational functions for each technique.
     [fBeta, gBeta, uBeta, vBeta] = get_rational_functions2( a0Beta, ABeta, BBeta, d, S);
     [fDelta, gDelta, uDelta, vDelta] = get_rational_functions2( a0Delta, ADelta, BDelta, d, S);
     % Get maximum wages.
     wMaxBeta = get_maximum_wage( fBeta, gBeta );
     wMaxDelta = get_maximum_wage( fDelta, gDelta );
     % Find the difference
     differenceNew = wMaxDelta - wMaxBeta;
     printf( " Next guess for phi: %1.12d, difference: %d\n", phiNew, differenceNew );
     % Is this new difference the same sign as differenceLow?
     if ( differenceLow*differenceNew > 0 )
       phiLow = phiNew;
       differenceLow = differenceNew;
     else
       % This new difference must be the same sign as differenceHigh.
       phiHigh = phiNew;
       differenceHigh = differenceNew;
     endif
  endwhile

else
  printf( "Initial guesses do not surround the solution value!\n");
endif

% -----------------
