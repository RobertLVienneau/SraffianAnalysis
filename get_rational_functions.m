% Finds coefficients of polynomials for one, tweo, and three commodity models.
% a0: A row vector of labor coefficients.
% A: A square matrix of commodity inputs.
% B: A square matrix of commodity outputs.
% d: A column vector specifying the numeraire.
% S: A diagonal square matrix of relative markups.
%
% f: Coefficients of the polynomial in the numerator for the rational function
%  for the wage.
% g: Coefficients of the polynomial in the denominator for the rational functions
%  for the wage and prices of produced commodities.
% numer: Each column has coefficients of a polynomial for the numerator of a rational function.
%
% TODO: Check inputs for consistency in sizes.
%

function [f, g, numer] = get_rational_functions( a0, A, B, d, S)

  numberCommodities = size( a0, 2);

  % Allocate space.
  f = zeros(1, numberCommodities + 1);
  g = zeros(1, numberCommodities);
  numer = zeros(numberCommodities, numberCommodities);

  if ( numberCommodities == 1 )
     [f, g, u] = get_rational_functions1( a0, A, B, d, S);
     numer = u;
  elseif ( numberCommodities == 2 )
      [f, g, u, v] = get_rational_functions2( a0, A, B, d, S);
      numer( :, 1 ) = u;
      numer( :, 2 ) = v;
  elseif ( numberCommodities == 3 )
       [f, g, t, u, v] = get_rational_functions3( a0, A, B, d, S);
      numer( :, 1 ) = t;
      numer( :, 2 ) = u;
      numer( :, 3 ) = v;
  elseif ( numberCommodities == 4 )
       [f, g, t, u, v, x] = get_rational_functions4( a0, A, B, d, S);
      numer( :, 1 ) = t;
      numer( :, 2 ) = u;
      numer( :, 3 ) = v;
      numer( :, 4 ) = x;
  else
     printf ( "*** Number of commodities, %d, is not 1, 2, 3. or 4! ***\n", numberCommodities );
  endif

end
