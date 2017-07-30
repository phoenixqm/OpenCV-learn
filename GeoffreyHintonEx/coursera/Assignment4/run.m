
%% test function visible_state_to_hidden_probabilities
describe_matrix(visible_state_to_hidden_probabilities(test_rbm_w, data_1_case));
describe_matrix(visible_state_to_hidden_probabilities(test_rbm_w, data_10_cases));
describe_matrix(visible_state_to_hidden_probabilities(test_rbm_w, data_37_cases));


%% test function hidden_state_to_visible_probabilities
describe_matrix(hidden_state_to_visible_probabilities(test_rbm_w, test_hidden_state_1_case));
describe_matrix(hidden_state_to_visible_probabilities(test_rbm_w, test_hidden_state_10_cases));
describe_matrix(hidden_state_to_visible_probabilities(test_rbm_w, test_hidden_state_37_cases));

%% test function configuration_goodness
configuration_goodness(test_rbm_w, data_1_case, test_hidden_state_1_case);
configuration_goodness(test_rbm_w, data_10_cases, test_hidden_state_10_cases);
configuration_goodness(test_rbm_w, data_37_cases, test_hidden_state_37_cases);

%% test function configuration_goodness_gradient
describe_matrix(configuration_goodness_gradient(data_1_case, test_hidden_state_1_case));
describe_matrix(configuration_goodness_gradient(data_10_cases, test_hidden_state_10_cases));
describe_matrix(configuration_goodness_gradient(data_37_cases, test_hidden_state_37_cases));

%% test cd1 with sample_bernoulli 
describe_matrix(cd1(test_rbm_w, data_1_case));
describe_matrix(cd1(test_rbm_w, data_10_cases));
describe_matrix(cd1(test_rbm_w, data_37_cases))

%% test cd1 improved 
describe_matrix(cd1_improved(test_rbm_w, data_1_case));
describe_matrix(cd1_improved(test_rbm_w, data_10_cases));
describe_matrix(cd1_improved(test_rbm_w, data_37_cases))

