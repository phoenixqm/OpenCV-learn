% Exercise 8: SVM Nonlinear classification

clear all; close all; clc

% Load training features and labels
[y, x] = libsvmread('ex8a.txt');

% gamma in RBF kernel
gamma = 100;

% Libsvm options
% -s 0 : classification
% -t 2 : RBF kernel
% -g : gamma in RBF kernel

model = svmtrain(y, x, sprintf('-s 0 -t 2 -g %g', gamma));

% Display training accuracy     
[predicted_label, accuracy, decision_values] = svmpredict(y, x, model);

% Plot training data and decision boundary
% add 't' to draw colorful depth
plotboundary(y, x, model, 't');

title(sprintf('\\gamma = %g', gamma), 'FontSize', 14);





