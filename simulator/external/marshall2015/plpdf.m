function pdf = plpdf(x, tau, xmin, xmax)
% PLPDF calculates the probability density function (PDF) of a truncated power-law distribution.
%
% Syntax:
%   pdf = plpdf(x, tau, xmin, xmax)
%
% Input:
%   x: Values at which to compute the PDF.
%   tau: Power-law exponent.
%   xmin: Minimum value for the power-law distribution.
%   xmax: Maximum value for the power-law distribution.
%
% Output:
%   pdf: Probability density function (PDF) values corresponding to the input x.

% Ensure that x, xmin, and xmax are all row vectors
x = reshape(x, 1, []);
xmin = reshape(xmin, 1, []);
xmax = reshape(xmax, 1, []);

% Calculate the PDF using the truncated power-law formula
pdf = zeros(size(x));
valid_range = x >= xmin & x <= xmax;
pdf(valid_range) = (tau - 1) ./ (xmax^(1 - tau) - xmin^(1 - tau)) .* x(valid_range).^(-tau);

% Set PDF values to zero outside the valid range
pdf(x < xmin | x > xmax) = 0;

% Normalize the PDF
pdf = pdf / sum(pdf);

end