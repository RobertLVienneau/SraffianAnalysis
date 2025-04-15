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
% u: Coefficients of the polynomial in the numerator for the rational function
%  for the price of the first produced commodity.
% v:  Coefficients of the polynomial in the numerator for the rational function
%  for the price of the second produced commodity.
%
% For prices of production,
% The wage is
%
% The price of the first produced commodity is
%
% The price of the second produced commodity is
%

function [f, g, u, v] = get_rational_functions2( a0, A, B, d, S)
  % Notice that I do not check anything even for sixe.

  % Initialize
  f = zeros(1, 3);
  g = zeros(1, 2);
  u = zeros(1, 2);
  v = zeros(1, 2);

  % Create matricces for further use.
  T1 = [[A(1, 1), B(1, 2)]; [A(2,1), B(2,2)]];
  T2 = [[B(1, 1), A(1, 2)];[B(2,1), A(2, 2)]];

  T3 = [[a0(1, 1), a0(1, 2)]; [S(1,1)*A(2,1), S(2,2)*A(2,2)]];
  T4 = [[a0(1, 1), a0(1, 2)]; [B(2,1) - A(2,1), B(2,2) - A(2,2)]];

  T5 = [[a0(1, 1), a0(1, 2)]; [S(1,1)*A(1,1), S(2,2)*A(1,2)]];
  T6 = [[a0(1, 1), a0(1, 2)]; [B(1,1) - A(1,1), B(1,2) - A(1,2)]];

  % Set coefficients.
  f(1) = S(1, 1)*S(2,2)*det(A);
  f(2) = (S(1,1) + S(2,2))*det(A) - S(1,1)*det(T1) - S(2,2)*det(T2);
  f(3) = det(A) - det(T1) - det(T2) + det(B);

  u(1) = - det(T3);
  u(2) = det(T4);

  v(1) = det(T5);
  v(2) = -det(T6);

  g(1) = d(1)*u(1) + d(2)*v(1);
  g(2) = d(1)*u(2) + d(2)*v(2);

end
