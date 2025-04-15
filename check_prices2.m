% Checks prices equations at iterated rates of profits for a two-commodity model.
% f: Coefficients of the polynomial in the numerator for the rational function
%  for the wage.
% g: Coefficients of the polynomial in the denominator for the rational functions
%  for the wage and prices of produced commodities.
% u: Coefficients of the polynomial in the numerator for the rational function
%  for the price of the first produced commodity.
% v:  Coefficients of the polynomial in the numerator for the rational function
%  for the price of the second produced commodity.
% a0: a row vector of direct labor coefficients.
% A: a square matrix of input coefficients.
% B: a square matrix of output coefficients.
% d: a column vector specifying the numeraire.
% S: a diagonal matrix.
% epsilon: An error tolerance.
% Returns 1 (true) if the price system is solved correctly; 0 (false) else.

function isok = check_prices2( rInit, rMax, rDivisions, f, g, u, v, a0, A, B, d, S, epsilon)

  % Initialize to true.
  isok = 1;

  % Calculate increment for the rate of profits.
  rIncr = (rMax - rInit)/(rDivisions - 1);

  % Check price equations at each rate of profits.
  for idx=1:1:rDivisions
    r = rIncr*(idx - 1);
    % Reset prices.
     p = zeros(1, 2);

     denom = polyval( g, r);
     w = polyval( f, r)/denom;
     p(1) = polyval(u, r)/denom;
     p(2) = polyval(v, r)/denom;
     lhs = p*A*( eye(2) + r*S) + w*a0;
     rhs = p*B;
     difference = rhs - lhs;

     if (abs(difference(1)) < epsilon)
       % printf( "Supernormal profits %f in first industry.\n", difference(1) );
     else
       printf( "Supernormal profits %f in first industry not zero!\n", difference(1) );
       isok = 0;
     endif

     if (abs(difference(2)) < epsilon)
       % printf( "Supernormal profits %f in second industry.\n", difference(2) );
     else
       printf( "Supernormal profits %f in second industry not zero!\n", difference(2) );
       isok = 0;
     endif

  endfor

  % printf( "epsilon: %f\n", epsilon );

end
