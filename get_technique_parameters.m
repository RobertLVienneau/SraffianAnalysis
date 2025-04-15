% Defines a technique from a larger specificaion of technology.
%   processes: A row vector of indeices to processes in the technique.
%   a0: A row vector of labor coefficients.
%   A: A rectangular matrix of commodity inputs.
%   B: A rectangular matrix of commodity outputs.
%   s: A row vector of relative markups.
%
% a0Out: A row vector of labor coefficients.
% AOut: A square matrix of commodity inputs.
% BOut: A square matrix of commodity outputs.
% SOut: A diagonal square matrix of relative markups.

% TODO: Check inputs for consistency in sizes.
% What about the columne vector for the numeriare.

function [a0Out, AOut, BOut, SOut] = get_technique_parameters( processes, a0, A, B, s )

  numberCommodities = size( processes, 2);
  % Initialize space for the outputs.
  a0Out = zeros(1, numberCommodities );
  AOut = zeros( numberCommodities );
  BOut = zeros( numberCommodities );
  SOut = zeros( numberCommodities );

  % Set the parameters.
  for idx = 1: 1: numberCommodities
    a0Out( idx ) = a0( processes( idx ) );
    AOut(:, idx ) = A( 1:numberCommodities, processes( idx ) );
    BOut(:, idx ) = B( 1:numberCommodities, processes( idx ) );
    SOut( idx, idx ) = s( processes(idx ) );
  endfor

end
