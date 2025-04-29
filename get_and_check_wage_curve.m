% Calculates and checks a wage curve.
%
% rStart: The first rate of profits at which the wage curve is to be calculated.
% rIncrement: The increment of the rate of profits for each iteration.
% numberIncrements: Number of points for which to calculate the wage curve.
% f: Coefficients of the polynomial in the numerator for the rational function
%  for the wage.
% g: Coefficients of the polynomial in the denominator for the rational functions
%  for the wage and prices of produced commodities.
% numer: Each column has coefficients of a polynomial for the numerator of a rational function.
% a0: a row vector of direct labor coefficients.
% A: a square matrix of input coefficients.
% B: a square matrix of output coefficients.
% d: a column vector specifying the numeraire.
% S: a diagonal matrix.
% epsilon: An error tolerance.
% echoWarning: 1, if a warning should be echoed to standard out when the price system is not solved correctly.
% techniqueName: The name of the technique, for the error message.
%
% rPoints: A row vector of rates of profits. The number of elements may be
%   less than numberIncrements if the specification leads to mesh points
%   with a negative wage or negative prices.
% wageCurve: A row vector of the corresponding wages.
% prices: Each column contains the prices at the corresponding rate of profits.
% isok: 1 (true) if the price system is solved correctly; 0 (false) else.
function [rPoints, wageCurve, prices, isok] = get_and_check_wage_curve( rStart, rIncrement, numberIncrements, ...
   f, g, numer, a0, A, B, d, S, epsilon, echoWarning, techniqueName)

  % Initialize outputs.
  rPoints1 = zeros(1, numberIncrements );
  rPoints = [];
  wageCurve = [];
  prices = [];
  isok = 1;

  printf( "Checking solution of price system for %s.\n", techniqueName );

  % Get the number of commodities.
  numberCommodities = size(numer, 2);

  % Create mesh for rate of profits.
  % (I could do this as I go through the next loop.)
  for idx = 1:1:numberIncrements
    r = rStart + rIncrement*(idx - 1);
    rPoints1( idx ) = r;
  endfor

  % Go through mesh.
  for idx = 1:1:numberIncrements
     r = rPoints1( idx );
     % Figure out the wage.
     denom = polyval( g, r);
     wage = polyval(f, r)/denom;
     % Figure out each price.
     price = zeros(1, numberCommodities );
     for (idx2 = 1:1:numberCommodities)
        price(idx2) = polyval( numer(:,idx2)', r)/denom;
     endfor
     % Check that the wage and all prices are non-negative.
     isNonnegative = (wage >= 0);
     for (idx2 = 1:1:numberCommodities)
       isNonnegative = isNonnegative && (price(idx2) >= 0);
     endfor
     % Concatenate any economically meaningful point on the wage curve.
     if (isNonnegative)
        rPoints = [rPoints, r];
        wageCurve = [wageCurve, wage];
        prices = [prices, price'];
        % For economically meaningful points, check that prices are correct.
        lhs = price*A*( eye(numberCommodities) + r*S) + wage*a0;
        rhs = price*B;
        difference = rhs - lhs;
        for (idx2 = 1:1:numberCommodities)
           if (abs(difference(idx2)) < epsilon)
               % printf( "Supernormal profits %f in industry numer idx2.\n", difference(idx2), idx2 );
           else
               printf( "Supernormal profits %f at rate of profits %f (percent) in industry numer %d not zero!\n", ...
                  difference(idx2), 100*r, idx2 );
               isok = 0;
           endif
        endfor
     endif
  endfor

  if ( (~isok) && echoWarning )
     printf( "Error in finding rational functions for %s!\n", techniqueName);
  endif

end
