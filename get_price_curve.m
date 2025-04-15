% Calculates prices at given rates of profits.
% rMesh: The rates of profits.
% u: Coefficients of polynomial in numerator for rational function for the price.
% g: Coefficients of polynomial in denominator for rational function for the price.
% rMax: Maximum rate of profits.
%
% priceCurve: A row vector of the corresponding wages.

function priceCurve = get_price_curve( rMesh, u, g, rMax )

  numberPoints = size( rMesh, 2);

  % Initialize outputs.
  priceCurve = zeros(1, numberPoints);

  % Construct the price curve.
  for idx = 1:1:numberPoints
    priceCurve( idx ) = get_wage_rational( rMesh(idx), u, g, rMax );
  endfor

end
