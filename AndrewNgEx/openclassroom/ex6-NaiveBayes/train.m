% train.m
% Exercise 6: Naive Bayes text classifier

clear all; close all; clc

% store the number of training examples
numTrainDocs = 700;

% store the dictionary size
numTokens = 2500;

% read the features matrix
M = dlmread('train-features.txt', ' ');
spmatrix = sparse(M(:,1), M(:,2), M(:,3), numTrainDocs, numTokens);
train_matrix = full(spmatrix);

% train_matrix now contains information about the words within the emails
% the i-th row of train_matrix represents the i-th training email
% for a particular email, the entry in the j-th column tells
% you how many times the j-th dictionary word appears in that email



% read the training labels
train_labels = dlmread('train-labels.txt');
% the i-th entry of train_labels now indicates whether document i is spam


% Find the indices for the spam and nonspam labels
spam_indices = find(train_labels);
nonspam_indices = find(train_labels == 0);

% Calculate probability of spam
prob_spam = length(spam_indices) / numTrainDocs;

% Sum the number of words in each email by summing along each row of
% train_matrix
email_lengths = sum(train_matrix, 2);
% Now find the total word counts of all the spam emails and nonspam emails
spam_wc = sum(email_lengths(spam_indices));
nonspam_wc = sum(email_lengths(nonspam_indices));

% Calculate the probability of the tokens in spam emails
% note: sum(A) returns a row vector with the sum over each column.
prob_tokens_spam = (sum(train_matrix(spam_indices, :)) + 1) ./ ...
    (spam_wc + numTokens);
% Now the k-th entry of prob_tokens_spam represents phi_(k|y=1)

% Calculate the probability of the tokens in non-spam emails
prob_tokens_nonspam = (sum(train_matrix(nonspam_indices, :)) + 1)./ ...
    (nonspam_wc + numTokens);
% Now the k-th entry of prob_tokens_nonspam represents phi_(k|y=0)

