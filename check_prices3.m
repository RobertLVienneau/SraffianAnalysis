% Checks price equations at iterated rates of profits for a three-commodity model.
% rInit: First rate of profits at which the solution to the price system is checked.
% rMax: Last rate of profits at which the solution to the price system is checked.
% rDivisions: Number of rate of profits at which the solution to the price system is checked.
% f: Coefficients of the polynomial in the numerator for the rational function
%  for the wage.
% g: Coefficients of the polynomial in the denominator for the rational functions
%  for the wage and prices of produced commodities.
% t: Coefficients of the polynomial in the numerator for the rational function
%  for the price of the first produced commodity.
% u:  Coefficients of the polynomial in the numerator for the rational function
%  for the price of the second produced commodity.
% v: Coefficients of the polynomial in the numerator for the rational function
%  for the price of the third produced commodity.
% a0: a row vector of direct labor coefficients.
% A: a square matrix of input coefficients.
% B: a square matrix of output coefficients.
% d: a column vector specifying the numeraire.
% S: a diagonal matrix.
% epsilon: An error tolerance.
% Returns 1 (true) if the price system is solved correctly; 0 (false) else.

function isok = check_prices3( rInit, rMax, rDivisions, f, g, t, u, v, a0, A, B, d, S, epsilon)

  % Initialize to true.
  isok = 1;

  % Calculate increment for the rate of profits.
  rIncr = (rMax - rInit)/(rDivisions - 1);

  % Check price equations at each rate of profits.
  for idx=1:1:rDivisions
     r = rIncr*(idx - 1);
     % Reset prices.
     p = zeros(1, 3);

     denom = polyval( g, r);
     w = polyval( f, r)/denom;
     p(1) = polyval(t, r)/denom;
     p(2) = polyval(u, r)/denom;
     p(3) = polyval(v, r)/denom;

     lhs = p*A*( eye(3) + r*S) + w*a0;
     rhs = p*B;
     difference = rhs - lhs;

     if (abs(difference(1)) < epsilon)
       % printf( "Supernormal profits %f in first industry.\n", difference(1) );
     else
       printf( "Supernormal profits %f at rate of profits %f (percent) in first industry not zero!\n", ...
             difference(1), 100*r );
       isok = 0;
     endif

     if (abs(difference(2)) < epsilon)
       % printf( "Supernormal profits %f in second industry.\n", difference(2) );
     else
       printf( "Supernormal profits %f at rate of profits %f (percent) in second industry not zero!\n", ...
          difference(2), 100*r );
       isok = 0;
     endif

     if (abs(difference(3)) < epsilon)
       % printf( "Supernormal profits %f in third industry.\n", difference(3) );
     else
       printf( "Supernormal profits %f at rate of profits %f (percent) in third industry not zero!\n", ...
          difference(3), 100*r );
       isok = 0;
     endif

  endfor

end
