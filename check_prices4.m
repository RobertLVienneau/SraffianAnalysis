% Check prices equations at iterated rates of profits for a four-commodity model.
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
% x: Coefficients of the polynomial in the numerator for the rational function
%  for the price of the fourth produced commodity.
% a0: a row vector of direct labor coefficients.
% A: a square matrix of input coefficients.
% B: a square matrix of output coefficients.
% d: a column vector specifying the numeraire.
% S: a diagonal matrix.
% epsilon: An error tolerance.
% Returns 1 (true) if the price system is solved correctly; 0 (false) else.

function isok = check_prices4( rInit, rMax, rDivisions, f, g, t, u, v, x, a0, A, B, d, S, epsilon)

  % Initialize to true.
  isok = 1;

  % Calculate increment for the rate of profits.
  rIncr = (rMax - rInit)/(rDivisions - 1);

  % Check price equations at each rate of profits.
  for idx=1:1:rDivisions
     r = rIncr*(idx - 1);
     % Reset prices.
     p = zeros(1, 4);

     denom = polyval( g, r);
     w = polyval( f, r)/denom;
     p(1) = polyval(t, r)/denom;
     p(2) = polyval(u, r)/denom;
     p(3) = polyval(v, r)/denom;
     p(4) = polyval(x, r)/denom;

     % TODO: Thie way of checking the first term does not work.
     % w = (f(1)*r)/(g(1));
     % p(1) = (t(1))/(g(1));
     % p(2) = (u(1))/(g(1));
     % p(3) = (v(1))/(g(1));
     % p(4) = (x(1))/(g(1));

     lhs = p*A*( eye(4) + r*S) + w*a0;
     % lhs = p*A*(r*S) + w*a0;
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

     if (abs(difference(4)) < epsilon)
       % printf( "Supernormal profits %f in fourth industry.\n", difference(3) );
     else
       printf( "Supernormal profits %f at rate of profits %f (percent) in fourth industry not zero!\n", ...
          difference(4), 100*r );
       isok = 0;
     endif

  endfor


end
