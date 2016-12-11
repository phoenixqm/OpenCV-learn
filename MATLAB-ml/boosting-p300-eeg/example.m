%function example
%--------------------------------------------------------------------------
% In this example the LogitBoosting algorithm is run in a cross-validation 
% loop. After each cross-validation iteration the mean classification
% accuracy is plotted vs. the number of boosting steps.
%
% Author: Ulrich Hoffmann - EPFL, 2005
% Copyright: Ulrich Hoffmann - EPFL
%--------------------------------------------------------------------------

% data contains a 3D matrix x of preprocessed EEG epochs (samplerate 128 Hz)
% and labels y
% dimensions of x are n_channels*n_timepoints*n_epochs
% ordering and positions of electrodes are in Pos32Electrodes.locs
% y is 1 if the corresponding epoch is a P300, 0 otherwise
load data;

% keep only most discriminative channels
channels = [1 2 4 5 6 8 9 10 12 13 14 18 19 21 22 23 25 26 27 29 30 31 ...
            32];
x = x(channels,:,:);
% reshape x into feature vectors
x = reshape(x,size(x,1)*size(x,2),size(x,3));
n_channels = length(channels);

% prepare index sets for cross-validation
n_permutations = 5;
n_epochs = size(x,2);
testsetsize = round(n_epochs / 10);
[trainsets, testsets] = crossValidation(1:n_epochs, testsetsize, ...
                                       n_permutations);
% cross-validation loop
correct = [];
for i = 1:n_permutations
    
    % draw data from CV index sets
    train_x = x(:, trainsets(i,:));
    train_y = y(:, trainsets(i,:));
    test_x  = x(:, testsets(i,:));
    test_y  = y(:, testsets(i,:));    
    
    % train classifier and apply to test data
    l = LogitBoost(180, 0.05, 1);
    l = train(l, train_x, train_y, n_channels);
    p = classify(l, test_x);    

    % evaluate classification accuracy 
    i0 = find(p <= 0.5);
    i1 = find(p > 0.5);
    est_y = zeros(size(p));
    est_y(i0) = 0;
    est_y(i1) = 1;
    for j = 1:size(est_y,1)
        n_correct(j) = length(find(est_y(j,:) == test_y));
    end
    p_correct = n_correct / size(est_y,2);
    correct = [correct ; p_correct];    
    
    % plot number of steps vs. classification accuracy 
    if (i>1)
        plot(mean(correct));
        xlabel('number of boosting iterations');
        ylabel('classification accuracy');
        drawnow;
    end
    
end