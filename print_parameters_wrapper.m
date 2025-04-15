% Echoes parameters and coefficiengs of polynonimals for rational functions to standard out.
% a0: a row vector of direct labor coefficients.
% A: a square matrix of input coefficients.
% B: a square matrix of output coefficients.
% d: a column vector specifying the numeraire.
% S: a diagonal matrix.
% f: Coefficients of the polynomial in the numerator for the rational function
%  for the wage.
% g: Coefficients of the polynomial in the denominator for the rational functions
%  for the wage and prices of produced commodities.
% numer: Each column has coefficients of a polynomial for the numerator of a rational function.
% techniqueName: The name of the technique, for the error message.
function print_parameters_wrapper(a0, A, B, d, S, f, g, numer, techniqueName)
  numberCommodities = size( a0, 2);

  printf( "\n\nParameters for the %s price system:\n", techniqueName );
  print_price_parameters( numberCommodities, a0, A, B, d, S);

  printf( "\nRational functions for %s:\n", techniqueName );
  print_price_functions( numberCommodities, f, g, numer);

end
