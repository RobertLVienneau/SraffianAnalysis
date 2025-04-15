% For finding the maximum rate of profits in a model of joint production.

% TO DO: write a subroutine based on f, the numerator of the rational function defining
%    the wage.

function rMax = get_r_max( A, B)
  % I assume A and B are the same size and are square.
  % Why does S, the diagonal matrix of markups, not enter into this?
  % under general joint production, can they be rectangular?
  nRows = size(A, 1);
  % Solves the generalized eigenvalue problem.
  %     W'*A = D*W'*B
  [V, D, W] = eig(A, B);

  % w1 = W(:, 1);
  % w1'*A
  % D(1,1)*w1'*B
  %% w1' is the complex conjugate of w1.

  eigenvalues = diag( D );
  % abs( eigenvalues )
  % Get maximum in magnitude. TODO: What is the PF root?
  % perronForbeniusRoot = max( eigenvalues );
  % perronForbeniusRoot = max( abs( eigenvalues ) )
  perronForbeniusRoot = max( real( eigenvalues ) );
  % Set the maximum rate of profits.
  rMax = (1/perronForbeniusRoot) - 1;
end
