

% press enter to continue, press q to quit a iteration

clear; load Datasets/dataset1;
w = learn_perceptron(neg_examples_nobias,pos_examples_nobias,w_init,w_gen_feas);

fprintf('Program paused. Press enter to continue.\n');
pause;
% --------------------------------------------------------------

clear; load Datasets/dataset2;
w = learn_perceptron(neg_examples_nobias,pos_examples_nobias,w_init,w_gen_feas);

fprintf('Program paused. Press enter to continue.\n');
pause;
% --------------------------------------------------------------

clear; load Datasets/dataset3;
w = learn_perceptron(neg_examples_nobias,pos_examples_nobias,w_init,w_gen_feas);

fprintf('Program paused. Press enter to continue.\n');
pause;
% --------------------------------------------------------------

clear; load Datasets/dataset4;
w = learn_perceptron(neg_examples_nobias,pos_examples_nobias,w_init,w_gen_feas);

fprintf('Program paused. Press enter to continue.\n');
pause;
% --------------------------------------------------------------