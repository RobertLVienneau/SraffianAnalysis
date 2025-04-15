% Code for analyzing the choice of technique.

clear all

% TODO: Write subroutines
%    To check Hawkins-Simon conditions.
%    To find maximum wage
%    To find fluke cases
%    To do all of these for 4-commodity model. Octave seems to be able
%      to find roots for 5th degree polynomial.
%    To find a0, A, B for Corn-Tractor model? To do all of these for this model?


% % Circulating capital example, with reverse substitution of labor.
% a0Alpha = [1, 16/25];
% AAlpha = [[9/20, 1/625]; ...
%     [2, 12/25]];
% BAlpha = eye(2);
%
% a0Beta = [1, 16/25];
% ABeta = [[9/20, 0.0167642]; ...
%      [2, 27/400]];
% BBeta = eye(2);
%
% % Numeraire
% dAlpha = [0; 1];
% dBeta = [0; 1];


% Fixed capital example.
% a0Alpha = [1/5, 1.505];
% AAlpha = [[1/8, 0.0833929]; ...
%           [ 0, 1]];
% BAlpha = [[0, 1]; [1, 0]];
%
% a0Beta = [1/5, 1.505, 7/5];
% ABeta = [[1/8, 0.0833929, 7/20]; ...
%       [ 0, 1, 0]; ...
%       [0, 0, 1]];
% BBeta = [[0, 1, 1]; ...
%         [1, 0, 0]; ...
%         [0, 1, 0]];

% Fixed capital, double switching example.
a0Alpha = [1/5, 1.75];
AAlpha = [[1/8, 0.015]; ...
          [ 0, 1]];
BAlpha = [[0, 1]; [1, 0]];

a0Beta = [1/5, 1.75, 7/5];
ABeta = [[1/8, 0.015, 7/20]; ...
       [ 0, 1, 0]; ...
       [0, 0, 1]];
BBeta = [[0, 1, 1]; ...
         [1, 0, 0]; ...
         [0, 1, 0]];

% Numeraire
dAlpha = [1; 0];
dBeta = [1; 0; 0];


% Number of increments to use when plotting wage curves.
rIncrements = 200;
% rIncrements = 5;
% Start with -1? Then 1. Start with 0? Then 0;
% negativeOne = 1;
negativeOne = 0;



% Find polynomials for rational functions for each echnique.
[fAlpha, gAlpha, uAlpha, vAlpha] = get_rational_functions2( a0Alpha, AAlpha, BAlpha, dAlpha, eye(2));
[fBeta, gBeta, tBeta, uBeta, vBeta] = get_rational_functions3( a0Beta, ABeta, BBeta, dBeta, eye(3));


% Find the maximum rate of profits for the two techniques.
% rMaxAlpha = get_r_max( AAlpha, BAlpha );
rMaxAlpha = get_r_max2( fAlpha );
% rMaxBeta = get_r_max( ABeta, BBeta );
rMaxBeta = get_r_max2( fBeta );

% rMaxAlpha - rMaxBeta;

rMax = max( rMaxAlpha, rMaxBeta );

% Check polynomials for prices.
if ~ check_prices2( 0, rMaxAlpha, rIncrements, fAlpha, gAlpha, uAlpha, vAlpha, ...
    a0Alpha, AAlpha, BAlpha, dAlpha, eye(2), 10^-4)
    printf( "Error in finding rational functions for Alpha!\n");
    % quit(1);
end

if ~ check_prices3( 0, rMaxBeta, rIncrements, fBeta, gBeta, tBeta, uBeta, vBeta, ...
    a0Beta, ABeta, BBeta, dBeta, eye(3), 10^-4)
    printf( "Error in finding rational functions for Beta!\n");
    % quit(1);
end

printf( "\n\nParameters for Alpha price system:\n" );
print_price_parameters( 2, a0Alpha, AAlpha, BAlpha, dAlpha, eye(2) );
printf( "\nRational functions for Alpha:\n" );
print_price_functions(2, fAlpha, gAlpha, [uAlpha', vAlpha' ] );

printf( "\n\nParameters for Beta price system:\n" );
print_price_parameters( 3, a0Beta, ABeta, BBeta, dBeta, eye(3) );
printf( "\nRational functions for Beta:\n" );
print_price_functions(3, fBeta, gBeta, [tBeta', uBeta', vBeta' ] );

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
  wagesAlpha( idx ) = get_wage( r, a0Alpha, AAlpha, BAlpha, eye(2), dAlpha, rMaxAlpha );
  % wagesAlpha( idx ) = get_wage_rational( r, fAlpha, gAlpha, rMaxAlpha );

  % Find corresponding wage for Beta for the rate of profits.
  wagesBeta( idx ) = get_wage( r, a0Beta, ABeta, BBeta, eye(3), dBeta, rMaxBeta );
  % wagesBeta( idx ) = get_wage_rational( r, fBeta, gBeta, rMaxBeta );
endfor


% Plot wage curves.
axes( 'FontSize', 15, 'Box', 'on', 'NextPlot', 'add' );
hold on
plot( rr, wagesAlpha, 'blue', 'LineWidth', 2 );
if (nSwitchPoints > 0)
    plot( switchPoints, wagesForSwitchPoint, "oblack", 'MarkerFaceColor', 'black');
endif
plot( rr, wagesBeta, 'red', 'LineWidth', 2 );
xlabel( 'Rate of Profits (Percent)', 'FontWeight', 'bold', ...
   'FontSize', 20, 'FontName', 'Times New Roman');
ylabel( 'Wage (Busheles per Person-Year)', 'FontWeight', 'bold', ...
    'FontSize', 20, 'FontName', 'Times New Roman');
hold off

% % Plot difference between wage curves
% plot( rr, wagesBeta - wagesAlpha, 'blue' );
% hold on
% xlabel( 'Rate of Profits (Percent)' );
% ylabel( 'Difference in Wage (Busheles per Person-Year)' );
% hold off



