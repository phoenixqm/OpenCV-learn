%% do assignment init
a4_init

%% test function visible_state_to_hidden_probabilities
describe_matrix(visible_state_to_hidden_probabilities(test_rbm_w, data_1_case));
describe_matrix(visible_state_to_hidden_probabilities(test_rbm_w, data_10_cases));
describe_matrix(visible_state_to_hidden_probabilities(test_rbm_w, data_37_cases));
% output 1724.967611

%% test function hidden_state_to_visible_probabilities
describe_matrix(hidden_state_to_visible_probabilities(test_rbm_w, test_hidden_state_1_case));
describe_matrix(hidden_state_to_visible_probabilities(test_rbm_w, test_hidden_state_10_cases));
describe_matrix(hidden_state_to_visible_probabilities(test_rbm_w, test_hidden_state_37_cases));
% output 4391.169583

%% test function configuration_goodness
configuration_goodness(test_rbm_w, data_1_case, test_hidden_state_1_case);
configuration_goodness(test_rbm_w, data_10_cases, test_hidden_state_10_cases);
configuration_goodness(test_rbm_w, data_37_cases, test_hidden_state_37_cases); 
% output -18.3914

%% test function configuration_goodness_gradient
describe_matrix(configuration_goodness_gradient(data_1_case, test_hidden_state_1_case));
describe_matrix(configuration_goodness_gradient(data_10_cases, test_hidden_state_10_cases));
describe_matrix(configuration_goodness_gradient(data_37_cases, test_hidden_state_37_cases)); 
% output 3166.216216

%% test cd1 with sample_bernoulli 
describe_matrix(cd1(test_rbm_w, data_1_case));
describe_matrix(cd1(test_rbm_w, data_10_cases));
describe_matrix(cd1(test_rbm_w, data_37_cases)); % output -4669.675676

%% test cd1 improved 
describe_matrix(cd1_improved(test_rbm_w, data_1_case));
describe_matrix(cd1_improved(test_rbm_w, data_10_cases));
describe_matrix(cd1_improved(test_rbm_w, data_37_cases)); % output -4716.094972

%% test a4_main, using RBM as part of NN
% a4_main(n_hid, lr_rbm, lr_classification, n_iterations)
lrs = 0.0001;
for i = 1:20
    fprintf(['--------------------------------------\n' ... 
        'Run with lr_classification %f.\n'], lrs);
    a4_main(300, .02, lrs, 1000);
    lrs = lrs * 2;
end

%% test a4_main, using RBM as part of NN cont
% a4_main(n_hid, lr_rbm, lr_classification, n_iterations)
lrs = 0.05;
for i = 1:20
    fprintf(['--------------------------------------\n' ... 
        'Run with lr_classification %f.\n'], lrs);
    a4_main(300, .02, lrs, 1000);
    lrs = lrs+0.01;
end
% ans 0.09 with test set classification error 0.065889

%% test run the best parameter
a4_main(300, .02, 0.09, 1000);



%% clac partition function on small_test_rbm_w
% this answer ref http://www.hankcs.com/ml/nnml-rbm.html
% I still do NOT know why it should be like this (TODO)

B = zeros(2^10, 10);
for i = 0:2^10-1
    B(i+1,:) = de2bi(i, 10);
end

A = exp(B*small_test_rbm_w);
lp = log(sum(prod(A+1,2)));
lp

