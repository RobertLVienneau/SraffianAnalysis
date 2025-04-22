% Calculates prices for a given rate of profits.
%
% r: The rate of profits.
% g: Coefficients of the polynomial in the denominator for the rational functions
%  for the wage and prices of produced commodities.
% numer: Each column has coefficients of a polynomial for the numerator of a rational function.
%
% prices: A column vector of prices.
function prices = get_prices_from_rational_functions(r, g, numer)

     numberCommodities = size(numer, 2);

     denom = polyval( g, r);
     prices = zeros( numberCommodities, 1);
     for idx = 1:1:numberCommodities
       u = numer(:,idx)';
       prices(idx) = polyval(u, r)/denom;
     endfor
end
