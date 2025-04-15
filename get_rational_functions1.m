% For finding coefficients of polynomials in rational functions in a 1-commodity model.
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
% u: Coefficients of the polynomial in the numerator for the rational function
%  for the price of the first produced commodity.
% v:  Coefficients of the polynomial in the numerator for the rational function
%  for the price of the second produced commodity.
%

function [f, g, u] = get_rational_functions1( a0, A, B, d, S)
  % Notice that I do not check anything even for sixe.

  % Initialize
  f = zeros(1, 2);
  g = zeros(1, 1);
  u = zeros(1, 1);

  % p*a11*(1 + r*s) + w*a0 = p*b11
  % p*d = 1
  %
  % p*(b11 - a11*(1 + r*s) = w*a0
  % p = w*a0*(b11 - a11*(1 + r*s))^(-1)
  % p*d = 1 = w*a0*(b11 - a11*(1 + r*s))^(-1)*d
  % w = 1/( a0*(b11 - a11*(1 + r*s))^(-1)*d )
  % w = (b11 - a11*(1 + r*s))/(a0*d)
  %
  % w = (-a11*s*r + (b11 - a11))/(a0*d)
  % p = 1/d

  f(1) = -A(1, 1)*S(1,1);
  f(2) = B(1,1) - A(1,1);
  g(1) = a0(1)*d(1);
  u(1) = 1;

end
