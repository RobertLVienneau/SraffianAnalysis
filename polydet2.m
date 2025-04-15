% Expresses the determinant of a 2x2 mtarix as a polynomial.
%
% Consider the matrix B - r*A. Its determinant is a 2nd degree polynomial.
% A:
% B:
%
% p:

function p = polydet2( A, B)

  % Allocate space
  p = zeros(1, 3);

  p(1) = det(A);

  T1 = [[A(1,1), A(1,2)]; ...
        [B(2,1), B(2,2)]];

  T2 = [[B(1,1), B(1,2)]; ...
        [A(2,1), A(2,2)]];

  p(2) = - det(T1) - det(T2);

  p(3) = det(B);

end
