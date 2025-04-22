% Calculates extra profits for each rate of profits in a sequence.
% rPoints: A row vector of rates of profits at which to calculate extra profits.
% f: Coefficients of the polynomial in the numerator for the rational function
%  for the wage.
% g: Coefficients of the polynomial in the denominator for the rational functions
%  for the wage and prices of produced commodities.
% numer: Each column has coefficients of a polynomial for the numerator of a rational function.
% a0: The direct labor coefficient for a process.
% a: A column vector of commodity inputs for a process, when operated at unit level.
% b: A column vector of commodity outputs for a process, when operated at unit level.
% s: The relative markup for the industry in which the process is operated.
%
% extraProfitsCurve: The extra profits obtained at each rate of profits.
function extraProfitsCurve = get_extra_profits_curve(rPoints, f, g, numer, a0, a, b, s)

   % Initialize vector for extra profits.
   numberPoints = size( rPoints, 2 );
   extraProfitsCurve = zeros(1, numberPoints );

   for idx=1:1:numberPoints
     extraProfitsCurve( idx ) = get_extra_profits( rPoints( idx ), f, g, numer, a0, a, b, s );
   endfor

end
