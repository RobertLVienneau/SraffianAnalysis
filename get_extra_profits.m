% Get extra profits at a rate of profits, for a system of prices and a production process.
%
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
% extra_profits: revenues - costs, where costs include a charge for the rate of profits.
function extra_profits = get_extra_profits(r, f, g, numer, a0, a, b, s)

  % Mostly, I do not check in vector sizes match, for the number of commodities.
  % This function applies even if some prices are negative.

  % Get the number of commodities.
  numberCommodities = size(numer, 2);

  denom = polyval( g, r);
  wage = polyval(f, r)/denom;

  % Figure out each price.
  price = zeros(1, numberCommodities );
  for (idx = 1:1:numberCommodities)
     price(idx) = polyval( numer(:,idx)', r)/denom;
  endfor

  lhs = price*a(1:numberCommodities, 1)*( 1 + r*s) + wage*a0;
  rhs = price*b(1:numberCommodities, 1);
  extra_profits = rhs - lhs;

end
