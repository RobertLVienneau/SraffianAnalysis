% Calculates the maximum wage.
% f: Coefficients of the polynomial in the numerator for the rational function
%  for the wage.
% g: Coefficients of the polynomial in the denominator for the rational functions
%  for the wage and prices of produced commodities.

function maxWage = get_maximum_wage(f, g)
  % Initialize
  maxWage = 0;

  n1 = size(f, 2);
  n2 = size(g, 2);
  if ( ( n1 > 0 ) && (n2 > 0 ) )
    maxWage = f(n1)/g(n2);
  endif

end
