% Exercise 5 -- Linear Regression with regularization
clear all; close all; %clc

% Load data from a two-column ascii file

clear all; close all; clc
x = load('ex5Linx.dat'); y = load('ex5Liny.dat');

m = length(y); % number of training examples

% Plot the training data
figure;
plot(x, y, 'o', 'MarkerFacecolor', 'r', 'MarkerSize', 8);

% Our features are all powers of x from x^0 to x^5
x = [ones(m, 1), x, x.^2, x.^3, x.^4, x.^5];
theta = zeros(size(x(1,:)))'; % initialize fitting parameters

% The regularization parameter
lambda = 0;

% Closed form solution from normal equations
L = lambda.*eye(6); % the extra regularization terms
L(1) = 0;
theta = (x' * x + L)\x' * y
norm_theta = norm(theta)

% Plot the linear fit
hold on;
% Our training data was only a few points, so we need
% to create a denser array of x-values for plotting
x_vals = (-1:0.05:1)';
features = [ones(size(x_vals)), x_vals, x_vals.^2, x_vals.^3,...
          x_vals.^4, x_vals.^5];
plot(x_vals, features*theta, '--', 'LineWidth', 2)
legend('Training data', '5th order fit')
hold off


