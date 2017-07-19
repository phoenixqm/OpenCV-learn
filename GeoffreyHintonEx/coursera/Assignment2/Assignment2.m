
clear; clc;

% This will load a struct called 'data' with 4 fields in it.
load data.mat;


fieldnames(data)

% 'data.vocab' contains the vocabulary of 250 words. 
% Training, validation and test sets are in 'data.trainData', 
% 'data.validData' and 'data.testData'  respectively.


% To see the list of words in the vocabulary, 
% data.vocab

% 'data.trainData' is a matrix of 372550 X 4. This means 
% there are 372550 training cases and 4 words per training case. 
% Each entry is an integer that is the index of a word in the 
% vocabulary. So each row represents a sequence of 4 words. 

% 'data.validData' and 'data.testData' are also similar. 
% They contain 46,568 4-grams each. All three need to be separated 
% into inputs and targets and the training set needs to be split 
% into mini-batches. 

fprintf('Program paused. Press enter to continue.\n');
pause;
% --------------------------------------------------------------

[train_x, train_t, valid_x, valid_t, test_x, test_t, vocab] = load_data(100);
% This will load the data, separate it into inputs and target, and make
% mini-batches of size 100 for the training set.

fprintf('Program paused. Press enter to continue.\n');
pause;
% --------------------------------------------------------------


% This will train the model for one epoch
model = train(10, 0.1, 50, 200, 0.9);
display_nearest_words('day', model, 10);
predict_next_word('what', 'is', 'your', model, 10);
