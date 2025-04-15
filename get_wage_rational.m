% Finds the wage for a technique of production in a model of joint production.
% r: a scalar. The rate of profits. Must be between -1 and rMax, inclusive.
% f:
% g:
% rMax: a scalar. The maximum rate of profits for the technique.

function wage = get_wage_rational( r, f, g, rMax )
  % Default.
  wage = 0;
  % Figure out wage.
  if (-1 <= r) && (r < rMax)
     wage = polyval(f, r)/polyval(g, r);
  endif
end
