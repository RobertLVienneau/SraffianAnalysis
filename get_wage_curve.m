% Calculates a wage curve.
% rStart: The first rate of profits at which the wage curve is to be calculated.
% rIncrement: The increment of the rate of profits for each iteration.
% numberIncrements: Number of points for which to calculate the wage curve.
% f: Coefficients of polynomial in numerator for rational function for the wage.
% g: Coefficients of polynomial in denominator for rational function for the wage.
% rMax: The maximum rate of profits for the technique.
%
% rPoints: A row vector of rates of profits. The number of elements may be
%   less thn numberIncrements if the specification leads to mesh points
%   at rate of profits greater than the maximum rate.
% wageCurve: A row vector of the corresponding wages.

function [rPoints, wageCurve] = get_wage_curve( rStart, rIncrement, numberIncrements, ...
     f, g, rMax)

  % Initialize outputs.
  rPoints = zeros(1, numberIncrements );
  wageCurve = zeros(1, numberIncrements);

  % Construct the wage curve.
  for idx = 1:1:numberIncrements
    r = rStart + rIncrement*(idx - 1);
    rPoints( idx ) = r;
    wageCurve( idx ) = get_wage_rational( r, f, g, rMax );
  endfor

  % Eliminate trailing zeros, if any.
  idx = 1;
  while ( wageCurve(idx) > 0 )
     idx = idx + 1;
   endwhile
   if ( ~( idx > numberIncrements ))
       rPoints = rPoints( 1: idx);
       wageCurve = wageCurve( 1:idx);
   endif

end
