% Calculates levels of operations for each process.
% c: A column vector of consumption goods. If g is zero,
%    the column vector of required net output.
% g: The steady-state rate of growth.
% a0: The row vector of direct labor coefficients.
% A: The square input matrxi.
% B: The square output matrix.
% scalePerWorker: 1, if levels should be scaled per worker.
%
% q: The column vector of levels of operation of the processes. If
%   B is the identity matrix, the quantities of gross outputs per worker.
% isok: 1, if all elements of q are non-negqtive.
%
% I do not check for consistency of the sizes of matrices. Nor do I
% check that g is within a certain interval.

function [q, isok] = get_quantity_flows(c, g, a0, A, B, scalePerWorker)

  %
  numberCommodities = size( a0, 2 );

  if ( scalePerWorker )
     % Find consumption per worker.
     cpw = 1/(a0*inv(B - (1 + g)*A)*c);
     q = cpw*inv(B - (1 + g)*A)*c;
  else
     q = inv(B - (1 + g)*A)*c;
  endif

  isok = 1;
  for idx = 1:1:numberCommodities
    isok = isok && ( q( idx ) >= 0 );
  endfor

end
