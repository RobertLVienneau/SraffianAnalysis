% Code for analyzing the choice of technique.

clear all

% Specify relative markups.
% s1 = 0.5;
% s2 = 1 - s1;

% Notes:
%   s1                  r1                     r2
%   0.1               N/A                   N/A
%   0.2               N/A                   N/A
%   0.22              N/A                   N/A
%   0.2217       102.488237221462      104.201557911726
%   0.222        101.527508167361      105.280965014837
%   0.23         96.019475139212       114.002640195466
%   0.25         91.877680841331       126.612817222255
%   0.3          88.593645046693       154.219492292835
%   0.5          93.161732388010       333.752085618730
%   0.6          100.719552335346           N/A
%   0.7          112.682801792233           N/A
%   0.75         121.161662258708           N/A
%   0.99         255.359113254926           N/A

s1 = 1;
s2 = 1;

S = [[s1, 0]; ...
   [0, s2]];

% Specify technology from which to select techniques.
% The following is from Bruno, Burmeister & Sheshinski (1966)
a0 = [1, 33/50, 1/100];
A = [[ 0, 1/50, 71/100] ; ...
     [ 1/10, 3/10, 0]];
B =[[1, 0, 0];
    [0, 1, 1]];

% The next is from Garegnani (1966)
% a0 = [89/10, 9/50, 3/2];
% A = [[ 0, 1/2, 1/4] ; ...
%      [ 379/423, 1/10, 5/12]];
% B =[[1, 0, 0];
%     [0, 1, 1]];

% The second commodity is the numeraire.
d = [0;1];

% Define Alpha, Beta

a0Alpha = [a0(1), a0(2)];
AAlpha = [A(:,1), A(:,2)];
BAlpha = [B(:,1), B(:,2)];

a0Beta = [a0(1), a0(3)];
ABeta = [A(:,1), A(:,3)];
BBeta = [B(:,1), B(:,3)];


% Number of increments to use when plotting wage curves.
rIncrements = 200;
% Start with -1? Then 1. Start with 0? Then 0;
negativeOne = 0;

% ------------------------

% Find polynomials for rational functions for each echnique.
[fAlpha, gAlpha, uAlpha, vAlpha] = get_rational_functions2( a0Alpha, AAlpha, BAlpha, d, S);
[fBeta, gBeta, uBeta, vBeta] = get_rational_functions2( a0Beta, ABeta, BBeta, d, S);

% Find the maximum rate of profits for the two techniques.
rMaxAlpha = get_r_max2( fAlpha );
rMaxBeta = get_r_max2( fBeta );

rMax = max( rMaxAlpha, rMaxBeta );

% Get maximum wages.
wMaxAlpha = get_maximum_wage( fAlpha, gAlpha );
wMaxBeta = get_maximum_wage( fBeta, gBeta );

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

printf( "\n\nParameters for Alpha price system:\n" );
print_price_parameters( 2, a0Alpha, AAlpha, BAlpha, d, S );
printf( "\nRational functions for Alpha:\n" );
print_price_functions(2, fAlpha, gAlpha, [uAlpha', vAlpha' ] );

printf( "\n\nParameters for Beta price system:\n" );
print_price_parameters( 2, a0Beta, ABeta, BBeta, d, S );
printf( "\nRational functions for Beta:\n" );
print_price_functions(2, fBeta, gBeta, [uBeta', vBeta' ] );

% Get switch points.
[nSwitchPoints, switchPoints] = get_switch_points( ...
    fAlpha, gAlpha, fBeta, gBeta, 0, min( rMaxAlpha, rMaxBeta ) );

wagesForSwitchPoint = zeros(1, nSwitchPoints );
if ( nSwitchPoints == 0)
     printf( "No Switch Points Exist\n" );
else
     printf( "\nSwitch Points\n" );
     for idx = 1:1:nSwitchPoints
         wagesForSwitchPoint( idx ) = get_wage_rational( ...
             switchPoints( idx ), fAlpha, gAlpha, rMaxAlpha );

         printf( "  Rate of profits: %f,  Wage: %f\n", ...
            switchPoints(idx), wagesForSwitchPoint(idx) );
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
  % wagesAlpha( idx ) = get_wage( r, a0Alpha, AAlpha, BAlpha, eye(2), dAlpha, rMaxAlpha );
  wagesAlpha( idx ) = get_wage_rational( r, fAlpha, gAlpha, rMaxAlpha );

  % Find corresponding wage for Beta for the rate of profits.
  % wagesBeta( idx ) = get_wage( r, a0Beta, ABeta, BBeta, eye(3), dBeta, rMaxBeta );
  wagesBeta( idx ) = get_wage_rational( r, fBeta, gBeta, rMaxBeta );
endfor

% Plot wage curves.
axes( 'FontSize', 15, 'Box', 'on', 'NextPlot', 'add' );
hold on
plot( rr, wagesAlpha, 'blue', 'LineWidth', 2 );
if (nSwitchPoints > 0)
    plot( switchPoints, wagesForSwitchPoint, "oblack", 'MarkerFaceColor', 'black');
endif
plot( rr, wagesBeta, 'red', 'LineWidth', 2 );
xlabel( 'Scale Factor for the Rate of Profits (Percent)', 'FontWeight', 'bold', ...
   'FontSize', 20, 'FontName', 'Times New Roman');
ylabel( 'Wage (Busheles per Person-Year)', 'FontWeight', 'bold', ...
    'FontSize', 20, 'FontName', 'Times New Roman');
hold off


printf( "\n" );
printf( "s1,max r Alpha (percent),max r Beta (percent), r (percent), r (percent), max w Alpha, max w Beta, w1, w2\n");

   if ( nSwitchPoints == 0 )
      printf( "%1.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f\n", ...
         s1, 100*rMaxAlpha, 100*rMaxBeta, 1/0, 1/0, wMaxAlpha, wMaxBeta, ...
            1/0, 1/0);
   elseif ( nSwitchPoints == 1 )
      printf( "%1.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f\n", ...
         s1, 100*rMaxAlpha, 100*rMaxBeta, 100*switchPoints(1), 1/0, wMaxAlpha, wMaxBeta, ...
            wagesForSwitchPoint(1), 1/0);
   elseif ( nSwitchPoints == 2 )
      printf( "%1.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f,%3.12f\n", ...
         s1, 100*rMaxAlpha, 100*rMaxBeta, 100*switchPoints(1), 100*switchPoints(2), wMaxAlpha, wMaxBeta, ...
            wagesForSwitchPoint(1), wagesForSwitchPoint(2));
   endif
