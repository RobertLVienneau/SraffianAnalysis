% Finds the wage for a technique of production in a model of joint production.
% r: a scalar. The rate of profits. Must be between -1 and rMax, inclusive.
% a0: a row vector of direct labor coefficients.
% A: a square matrix of input coefficients.
% B: a square matrix of output coefficients.
% S: A diagonal matrix of markups.
% d: a column vector specifying the numeraire.
% rMax: a scalar. The maximum rate of profits for the technique.
%
% p*A*(I + r*S) + w*a0 = p*B
% p*( B - A*(I + r*S) ) = w*a0
% p = w*a0*inv( B - A*(I + r*S)*A )
% p*d = 1 = w*a0*inv( B - (I + r*S) )*d
% w = 1/( a0*inv( B - A*(I + r*S) )*d )

function wage = get_wage( r, a0, A, B, S, d, rMax )
  % Default.
  wage = 0;
  % Figure out wage.
  n = size( a0, 2);
  if (-1 <= r) && (r < rMax)
     wage = 1/( a0*inv( B - A*(eye(n) + r*S) )*d );
  endif
end
