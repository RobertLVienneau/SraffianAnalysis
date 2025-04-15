% For finding coefficients of polynomials in rational functions in a 2-commodity model.
% a0: a row vector of direct labor coefficients.
% A: a square matrix of input coefficients.
% B: a square matrix of output coefficients.
% d: a column vector specifying the numeraire.
% S: a diagonal matrix.
%
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

function [f, g, t, u, v] = get_rational_functions3( a0, A, B, d, S)
  % Notice that I do not check anything even for sixe.

  % Initialize
  f = zeros(1, 4);
  g = zeros(1, 3);
  t = zeros(1, 3);
  u = zeros(1, 3);
  v = zeros(1, 3);

  AS = A*S;
  BA = B - A;

  % For t:
  AS2233 = [[AS(2,2), AS(2,3)]; ...
            [AS(3,2), AS(3,3)]];
  BA2233 = [[BA(2,2), BA(2,3)]; ...
             [BA(3,2), BA(3,3)]];

  AS2133 = [[AS(2,1), AS(2,3)]; ...
            [AS(3,1), AS(3,3)]];
  BA2133 = [[BA(2,1), BA(2,3)]; ...
            [BA(3,1), BA(3,3)]];

  AS2132 = [[AS(2,1), AS(2,2)]; ...
            [AS(3,1), AS(3,2)]];
  BA2132 = [[BA(2,1), BA(2,2)]; ...
            [BA(3,1), BA(3,2)]];

  % For u:
  AS1233 = [[AS(1,2), AS(1,3)]; ...
            [AS(3,2), AS(3,3)]];
  BA1233 = [[BA(1,2), BA(1,3)]; ...
            [BA(3,2), BA(3,3)]];

  AS1133 = [[AS(1,1), AS(1,3)]; ...
            [AS(3,1), AS(3,3)]];
  BA1133 = [[BA(1,1), BA(1,3)]; ...
            [BA(3,1), BA(3,3)]];

  AS1132 = [[AS(1,1), AS(1,2)]; ...
            [AS(3,1), AS(3,2)]];
  BA1132 = [[BA(1,1), BA(1,2)]; ...
            [BA(3,1), BA(3,2)]];

  % For v:
  AS1223 = [[AS(1,2), AS(1,3)]; ...
            [AS(2,2), AS(2,3)]];
  BA1223 = [[BA(1,2), BA(1,3)]; ...
            [BA(2,2), BA(2,3)]];

  AS1123 = [[AS(1,1), AS(1,3)]; ...
            [AS(2,1), AS(2,3)]];
  BA1123 = [[BA(1,1), BA(1,3)]; ...
            [BA(2,1), BA(2,3)]];

  AS1122 = [[AS(1,1), AS(1,2)]; ...
            [AS(2,1), AS(2,2)]];
  BA1122 = [[BA(1,1), BA(1,2)]; ...
            [BA(2,1), BA(2,2)]];

  % Set coefficients.
  f = polydet3( AS, BA);

  t = a0(1)*polydet2( AS2233, BA2233) ...
       - a0(2)*polydet2( AS2133, BA2133) ...
       + a0(3)*polydet2( AS2132, BA2132);
  u = - a0(1)*polydet2(AS1233, BA1233) ...
       + a0(2)*polydet2(AS1133, BA1133) ...
       - a0(3)*polydet2(AS1132, BA1132);
  v = a0(1)*polydet2(AS1223, BA1223 ) ...
       - a0(2)*polydet2( AS1123, BA1123 ) ...
       + a0(3)*polydet2( AS1122, BA1122 );

  g = d(1)*t + d(2)*u + d(3)*v;

end
