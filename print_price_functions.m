% For echoing coefficients of polynomials for rational functions for prices.
% nCommodities: Number of commodities.
% f: Coefficients of the polynomial in the numerator for the rational function
%  for the wage.
% g: Coefficients of the polynomial in the denominator for the rational functions
%  for the wage and prices of produced commodities.
% numer: Each column has coefficients of a polynomial for the numerator of a rational function.

function print_price_functions( nCommodities, f, g, numer)

  printf( "Polynomial for numerator of rational function for the wage:\n");
  for idx = 1:1:nCommodities + 1
    printf( " Coefficient for rate of profits to the %d: %f\n", ...
       nCommodities + 1 - idx, f(idx) );
  endfor

  printf( "Polynomial for denominator of rational function for the wage:\n");
  for idx = 1:1:nCommodities
    printf( " Coefficient for rate of profits to the %d: %f\n", ...
       nCommodities - idx, g(idx) );
  endfor

  for idx = 1:1:nCommodities
    printf( "Polynomial for numerator of rational function for commodity number %d:\n", idx);
    for idx2 = 1:1:nCommodities
      printf( " Coefficient for rate of profits to the %d: %f\n", ...
       nCommodities - idx2, numer( idx2, idx ) );
    endfor
  endfor


end
