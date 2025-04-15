% Finds switch points at which supernormal profits are zero for a process not in the technique for the price system.
%
% f: Row vector. Coefficients of the polynomial in the numerator for the rational function
%  for the wage.
% g: Row vector. Coefficients of the polynomial in the denominator for the rational functions
%  for the wage and prices of produced commodities. Not used?
% numer: Each column has coefficients of a polynomial for the numerator of a rational function.
% d: a column vector specifying the numeraire. Not used?
% s: a relative markup. s*r is the rate of profits.
% a0: A scalar. The labor coefficient for a production process.
% a: A column vector for the input coefficients.
% b: A column vector for the soutput coefficients.
% rLowerBound:Switch points must not have a rate of profits below this.
%    Typically, -1.0 or 0.0.
% rUpperBoud: Switch points must not have a rate of profits above this.
%    Typically, the minimum of the maximum rate of profits for the two
%    techniques.
%
% switchPoints: A row vector of rates of profits for switch points, in
%    increasing order.
%
% This approach works for general joint production. Finding the
% intersection of wage curves generally does not. Christian has
% written about 'fake switch points' with Edith ???.

function switchPoints = get_switch_points_from_prices( f, g, numer, d, s, ......
     a0, a, b, rLowerBound, rUpperBound)

  % TODO: Delete commented-out parts I had for debugging.
  % f
  % g
  % numer
  % a0
  % a
  % b

  % Initialize.
  switchPoints = [];

  numberCommodities = size(f, 2) - 1;

  % Find coefficients of a polynomial.
  myPoly = zeros(1, numberCommodities + 1);

  % Go through the numerators of the price equations for the outputs.
  for idx = 1:1:numberCommodities
    for idx2 = 1:1:numberCommodities
      % For commodity number idx,
      myPoly( idx2 + 1 ) = myPoly( idx2 + 1 ) + numer(idx2, idx)*b(idx);
    endfor
  endfor

  % myPoly

  % Go through the numerator of the price equations for the inputs.
  for idx = 1:1:numberCommodities
     for idx2 = 1:1:numberCommodities
      % For commodity number idx,
      myPoly( idx2 + 1 ) = myPoly( idx2 + 1 ) - numer(idx2, idx)*a(idx);
      myPoly( idx2 ) = myPoly( idx2 ) - numer(idx2, idx)*a(idx)*s;
    endfor
  endfor

  % Go through the numberator for the wage.
  % TODO: Is this the difference of myPoly and the transpose of f?
  for idx = 1:1:(numberCommodities + 1)
     myPoly( idx ) = myPoly(idx) - f(idx)*a0;
  endfor

  % myPoly

  % Find roots of the resulting polynomial.
  points = transpose( roots(myPoly) );
  numberPoints = size(points, 2);

  % Concatenate the roots in the desired range to vector to be returned.
  for idx = 1:1:numberPoints
    if ( isreal( points(idx) ) )
      if ( ~( (points(idx) < rLowerBound) || (rUpperBound < points(idx)) ) )
        switchPoints = [ switchPoints, points(idx) ];
      endif
    endif
  endfor

  % Sort switchPoints in ascending order by the rate of profits.
  switchPoints = sort( switchPoints );

end
