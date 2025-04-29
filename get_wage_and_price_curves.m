% Calculates wage and price curves.
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
% isWageAll: 1, if the wage and price curves should be calculated for all mesh points with
%    a non-negative wage; 0, if the wage and price curves should be calculated only for mesh
%    points in which wages and all prices are non-negative.
%    You probably want 0 for certain models of rent.
%
% rPoints: A row vector of rates of profits. The wage and price curves are calculated
%   at each mesh point. The number of elements may be less than numberIncrements
%   if the specification leads to mesh points with a negative wage or negative prices.
% wageCurve: A row vector of the corresponding wages.
% priceCurves: Each column contains the prices at the corresponding rate of profits.
%

function [rPoints, wageCurve, priceCurves] = get_wage_and_price_curves( ...
     rStart, rIncrement, numberIncrements, f, g, numer, isWageAll )

  % Get the number of commodities.
  n1 = size( f, 2 ) - 1;
  n2 = size( g, 2 );
  n3 = size( numer, 1 );
  n4 = size( numer, 2);

  if ((n1 != n2) || (n1 != n3) || (n1 != n4))
    printf( "*** Warning: Inconsistent matrix sizes in function polydet! ***\n" );
  endif
  numberCommodities = min( [n1, n2, n3, n4] );

  % Allocate space;
  rPoints1 = zeros(1, numberIncrements );
  rPoints = [];
  wageCurve = [];
  priceCurves = [];
  % for idx = 1:1:numberCommodities
  %  priceCurves = [priceCurves, []];
  % endfor

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
     % Check that the wage is non-negative.
     isNonnegative = (wage >= 0);
     % Do I insist that all prices should be non-negative?
     if (!isWageAll)
        for (idx2 = 1:1:numberCommodities)
          isNonnegative = isNonnegative && (price(idx2) >= 0);
        endfor
     endif

     % Concatenate any economically meaningful point on the wage curve.
     if (isNonnegative)
        rPoints = [rPoints, r];
        wageCurve = [wageCurve, wage];
        if ( size( priceCurves, 2 ) == 0 )
           priceCurves = price';
        else
           priceCurves = [priceCurves, price'];
        endif
     endif

  endfor

end
