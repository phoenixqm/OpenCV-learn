
% function parameters: 
% a3(wd, n_hid, n_iters, learning_rate, momentum, do_early_stopping, batch_size)

% % --------------- test runs -------------------
% a3(0, 0, 0, 0, 0, false, 0);

% a3(1e7, 7, 10, 0, 0, false, 4);

% a3(0, 7, 10, 0, 0, false, 4);

% a3(0, 10, 70, 0.005, 0, false, 4);

% a3(0, 10, 70, 0.5, 0, false, 4);
% % ----------- end test runs -------------------


%% --------------- find best alpha and momentum ------------------
alpha = [0.002, 0.01, 0.05, 0.2, 1.0, 5.0, 20.0];

for i = 1:length(alpha)
    fprintf(['--------------------------------------\n' ... 
        'Run with alpha %f and momentum is zero.\n'], alpha(i));
    a3(0, 10, 70, alpha(i), 0, false, 4);
end

for i = 1:length(alpha)
    fprintf(['--------------------------------------\n' ... 
        'Run with alpha %f and momentum is 0.9.\n'], alpha(i));
    a3(0, 10, 70, alpha(i), 0.9, false, 4);
end
% %--------------- end  find best alpha and momentum -------------

%% --------------- test early stopping -------------------
a3(0, 200, 1000, 0.35, 0.9, false, 100)
a3(0, 200, 1000, 0.35, 0.9, true, 100)
% % --------------- end test early stopping  -------------

%% --------------- find best weight decay ------------------
Wd = [0, 0.0001, 0.001, 0.01, 1.0, 5.0];

for i = 1:length(Wd)
    fprintf(['--------------------------------------\n' ... 
        'Run with weight decay %f.\n'], Wd(i));
    a3(Wd(i), 200, 1000, 0.35, 0.9, false, 100);
end
% % --------------- end find best weight decay  ------------

%% --------------- find best hidden layer size ----------------
nH = [10, 30, 100, 130, 200];

for i = 1:length(nH)
    fprintf(['--------------------------------------\n' ... 
        'Run with hidden layer size %f.\n'], nH(i));
    a3(0, nH(i), 1000, 0.35, 0.9, false, 100);
end
% % --------------- end find best hidden layer size -----------

%% -------- find best hidden layer size with early stop --------
nH = [18, 37, 113, 189, 236];

for i = 1:length(nH)
    fprintf(['--------------------------------------\n' ... 
        'Run with hidden layer size %f.\n'], nH(i));
    a3(0, nH(i), 1000, 0.35, 0.9, true, 100);
end
% % ------- end find best hidden layer size with early stop ----

%%
a3(0.001, 40, 1000, 0.35, 0.9, true, 100);


