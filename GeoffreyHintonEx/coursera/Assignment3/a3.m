function a3(wd, n_hid, n_iters, learning_rate, ...
            momentum, do_early_stopping, batch_size)
  warning('error', 'Octave:broadcast');
  if exist('page_output_immediately')
      page_output_immediately(1); 
  end
  more off;
  model = initial_model(n_hid);
  from_data_file = load('data.mat');
  datas = from_data_file.data;
  n_training_cases = size(datas.training.inputs, 2);
  if n_iters ~= 0
      test_gradient(model, datas.training, wd)
  end

  % optimization
  theta = model_to_theta(model);
  momentum_speed = theta * 0;
  training_loss = [];
  val_loss = [];
  if do_early_stopping
    best_so_far.theta = -1; % this will be overwritten soon
    best_so_far.val_loss = inf;
    best_so_far.after_n_iters = -1;
  end
  for opt_i = 1:n_iters
    model = theta_to_model(theta);
    
    b_start = mod((opt_i-1) * batch_size, n_training_cases)+1;
    batch.inputs = datas.training.inputs(:, b_start : b_start + batch_size - 1);
    batch.targets = datas.training.targets(:, b_start : b_start + batch_size - 1);
    
    gradient = model_to_theta(d_loss_by_d_model(model, batch, wd));
    momentum_speed = momentum_speed * momentum - gradient;
    theta = theta + momentum_speed * learning_rate;

    model = theta_to_model(theta);
    training_loss = [training_loss, loss(model, datas.training, wd)];
    val_loss = [val_loss, loss(model, datas.validation, wd)];
    if do_early_stopping && val_loss(end) < best_so_far.val_loss
      best_so_far.theta = theta; % this will be overwritten soon
      best_so_far.val_loss = val_loss(end);
      best_so_far.after_n_iters = opt_i;
    end
    
    if mod(opt_i, round(n_iters/10)) == 0
      fprintf(['After %d optimization iterations, training data loss' ... 
          ' is %f, and validation data loss is %f\n'], ... 
          opt_i, training_loss(end), val_loss(end));
    end
  end
  if n_iters ~= 0 % check again, this time with more typical parameters
      test_gradient(model, datas.training, wd); 
  end 
  if do_early_stopping
    fprintf(['Early stopping: validation loss was lowest after %d iterations.' ... 
        ' We chose the model that we had then.\n'], best_so_far.after_n_iters);
    theta = best_so_far.theta;
  end
  
  % the optimization is finished. Now do some reporting.
  model = theta_to_model(theta);
  if n_iters ~= 0
    clf;
    hold on;
    plot(training_loss, 'b');
    plot(val_loss, 'r');
    legend('training', 'validation');
    ylabel('loss');
    xlabel('iteration number');
    hold off;
  end
  datas2 = {datas.training, datas.validation, datas.test};
  data_names = {'training', 'validation', 'test'};
  for data_i = 1:3
    data = datas2{data_i};
    data_name = data_names{data_i};
    fprintf('\nThe loss on the %s data is %f\n', data_name, loss(model, data, wd));
    if wd ~= 0
        fprintf(['The classification loss (i.e. without weight decay) ' ... 
                'on the %s data is %f\n'], data_name, loss(model, data, 0));
    end
    fprintf('The classification error rate on the %s data is %f\n',...
            data_name, classification_performance(model, data));
  end
end

function test_gradient(model, data, wd)
  base_theta = model_to_theta(model);
  h = 1e-2;
  correctness_threshold = 1e-5;
  analytic_gradient = model_to_theta(d_loss_by_d_model(model, data, wd));
  % Test the gradient not for every element of theta, because that's 
  % a lot of work. Test for only a few elements.
  for i = 1:100
    % 1299721 is prime and thus ensures a random-like selection of indices
    test_index = mod(i * 1299721, size(base_theta,1)) + 1; 
    analytic_here = analytic_gradient(test_index);
    theta_step = base_theta * 0;
    theta_step(test_index) = h;
    distances = [-4:-1, 1:4];
    contribution_weights = [1/280, -4/105, 1/5, -4/5, 4/5, -1/5, 4/105, -1/280];
    temp = 0;
    for index = 1:8
        t_theta = base_theta + theta_step * distances(index);
        err = loss(theta_to_model(t_theta), data, wd);
        temp = temp + err * contribution_weights(index);
    end
    fd_here = temp / h;
    diff = abs(analytic_here - fd_here);
    % fprintf('%d %e %e %e %e\n', test_index, base_theta(test_index), diff, ...
    %         fd_here, analytic_here);
    if diff < correctness_threshold
        continue;
    end
    if diff / (abs(analytic_here) + abs(fd_here)) < correctness_threshold 
        continue; 
    end
    error(sprintf(['Theta element #%d, with value %e, has finite difference ' ...
          'gradient %e but analytic gradient %e. That looks like an error.\n'], ...
          test_index, base_theta(test_index), fd_here, analytic_here));
  end
  fprintf(['Gradient test passed. That means that the gradient that ' ... 
       'your code computed is within 0.001%% of the gradient that the ' ... 
       'finite difference approximation computed, so the gradient ' ...
       'calculation procedure is probably correct.\n']);
end

function ret = logistic(input)
  ret = 1 ./ (1 + exp(-input));
end

function ret = log_sum_exp_over_rows(a)
  % This computes log(sum(exp(a), 1)) in a numerically stable way
  maxs_small = max(a, [], 1);
  maxs_big = repmat(maxs_small, [size(a, 1), 1]);
  ret = log(sum(exp(a - maxs_big), 1)) + maxs_small;
end

function ret = loss(model, data, wd)
  % model.input_to_hid is a matrix of size n_hid by #input i.e. 256. 
  % It contains the weights from the input units to the hidden units.
  
  % model.hid_to_class is a matrix of size #classes i.e. 10 by n_hid
  % It contains the weights from the hidden units to the softmax units.
  
  % data.inputs is a matrix of size #inputs i.e. 256 by #cases. 
  % Each column describes a different data case. 
  
  % data.targets is a matrix of size #classes i.e. 10 by #cases. 
  % Each column describes a different data case. It contains a one-of-N 
  % encoding of the class, i.e. one element in column is 1 and others are 0.
	 
  % Before we can calculate the loss, we need to calculate a variety of 
  % intermediate values, like the state of the hidden units.
  
  % input to the hidden units, i.e. before the logistic. 
  % size: <number of hidden units> by <number of data cases>
  hid_input = model.input_to_hid * data.inputs; 
  
  % output of the hidden units, i.e. after the logistic. 
  % size: <number of hidden units> by <number of data cases>
  hid_output = logistic(hid_input); 
  
  % input to the components of the softmax. 
  % size: <number of classes, i.e. 10> by <number of data cases>
  class_input = model.hid_to_class * hid_output; 
  
  % The following three lines of code implement the softmax.
  % However, it's written differently from what the lectures say.
  % What we do here is equivalent, but this is more numerically stable. 
  % Octave isn't well prepared to deal with really large numbers.
  class_normalizer = log_sum_exp_over_rows(class_input); % size: 1 by #cases
  
  % log of probability of each class. 
  % size: <number of classes, i.e. 10> by <number of data cases>
  log_class_prob = class_input - repmat(class_normalizer, [size(class_input, 1), 1]); 
  
  % probability of each class. Each column (i.e. each case) sums to 1. 
  % size: <number of classes, i.e. 10> by <number of data cases>
  class_prob = exp(log_class_prob); 
  
  % select the right log class probability using that sum; 
  % then take the mean over all data cases.
  classification_loss = -mean(sum(log_class_prob .* data.targets, 1)); 
  
  % weight decay loss: E = 1/2 * wd_coeffecient * theta^2
  wd_loss = sum(model_to_theta(model).^2)/2*wd; 
  ret = classification_loss + wd_loss;
end

function ret = d_loss_by_d_model(model, data, wd)
  % input parameter is same with loss function
  % The returned object is supposed to be exactly like parameter <model>, 
  % i.e. it has fields ret.input_to_hid and ret.hid_to_class. 
  % However, the contents of those matrices are gradients (d loss by d model parameter), 
  % instead of model parameters.
	 
  % This is the only function that you're expected to change. Right now, 
  % it just returns a lot of zeros, which is obviously not the correct output. 
  % Your job is to replace that by a correct computation.
  
  ret.input_to_hid = model.input_to_hid * 0;
  ret.hid_to_class = model.hid_to_class * 0;
  
  % model.input_to_hid is a matrix of size n_hid by #input i.e. 256. 
  % It contains the weights from the input units to the hidden units.
  
  % model.hid_to_class is a matrix of size #classes i.e. 10 by n_hid
  % It contains the weights from the hidden units to the softmax units.
  
  % data.inputs is a matrix of size #inputs i.e. 256 by #cases. 
  % Each column describes a different data case. 
  
  % data.targets is a matrix of size #classes i.e. 10 by #cases. 
  % Each column describes a different data case. It contains a one-of-N 
  % encoding of the class, i.e. one element in column is 1 and others are 0.
	 
  % Before we can calculate the loss, we need to calculate a variety of 
  % intermediate values, like the state of the hidden units.
  
  % input to the hidden units, i.e. before the logistic. 
  % size: <number of hidden units> by <number of data cases>
  hid_input = model.input_to_hid * data.inputs; 
  
  % output of the hidden units, i.e. after the logistic. 
  % size: <number of hidden units> by <number of data cases>
  hid_output = logistic(hid_input); 
  
  % input to the components of the softmax. 
  % size: <number of classes, i.e. 10> by <number of data cases>
  class_input = model.hid_to_class * hid_output; 
  
  % The following three lines of code implement the softmax.
  % However, it's written differently from what the lectures say.
  % What we do here is equivalent, but this is more numerically stable. 
  % Octave isn't well prepared to deal with really large numbers.
  class_normalizer = log_sum_exp_over_rows(class_input); % size: 1 by #cases
  
  % log of probability of each class. 
  % size: <number of classes, i.e. 10> by <number of data cases>
  log_class_prob = class_input - repmat(class_normalizer, [size(class_input, 1), 1]); 
  
  % probability of each class. Each column (i.e. each case) sums to 1. 
  % size: <number of classes, i.e. 10> by <number of data cases>
  class_prob = exp(log_class_prob); 
  
  m = size(data.inputs, 2);
  
  % Z2 = Theta1 * X
  % A2 = sigmoid(Z2)
  % O = Theta2 * A2
  % P = softmax(O)
  
  % dLdTheta2 = dLdO * dOdTheta2 + lambda * Theta2
  %           = (P-Y) * A2          % sum for every case
  % dLdTheta1 = dLdO * dOdA2 * dA2dZ2 * dZ2dTheta1 + lambda * Theta1
  %           = (P-Y) * Theta2 * A2(1-A2) * X
  
  % Delta3 = (P-Y)
  Delta3 = class_prob - data.targets;
  
  dLdTheta2 = Delta3 * hid_output';
  ret.hid_to_class = (1/m) .* dLdTheta2 + wd * model.hid_to_class;
  
  % Delta2 = (P-Y) * Theta2 * A2(1-A2)
  Delta2 = (model.hid_to_class' * Delta3) .* hid_output .* (1-hid_output);
  dLdTheta1 = Delta2 * data.inputs';
  ret.input_to_hid = (1/m) .* dLdTheta1 + wd * model.input_to_hid;
end

function ret = model_to_theta(model)
  % This function takes a model (or gradient in model form), and turns it 
  % into one long vector. See also theta_to_model.
  input_to_hid_transpose = transpose(model.input_to_hid);
  hid_to_class_transpose = transpose(model.hid_to_class);
  ret = [input_to_hid_transpose(:); hid_to_class_transpose(:)];
end

function ret = theta_to_model(theta)
  % This function takes a model (or gradient) in the form of one long vector 
  % (maybe produced by model_to_theta), and restores it to the structure format,
  % i.e. with fields .input_to_hid and .hid_to_class, both matrices.
  n_hid = size(theta, 1) / (256+10);
  ret.input_to_hid = transpose(reshape(theta(1: 256*n_hid), 256, n_hid));
  ret.hid_to_class = reshape(theta(256 * n_hid + 1 : size(theta,1)), n_hid, 10).';
end

function ret = initial_model(n_hid)
  n_params = (256+10) * n_hid;
  as_row_vector = cos(0:(n_params-1));
  
  % We don't use random initialization, for this assignment. 
  % This way, everybody will get the same results.
  ret = theta_to_model(as_row_vector(:) * 0.1); 
end

function ret = classification_performance(model, data)
  % This returns the fraction of data cases that is incorrectly classified by the model.
  hid_input = model.input_to_hid * data.inputs; 
  hid_output = logistic(hid_input); 
  class_input = model.hid_to_class * hid_output; 
  
  [dump, choices] = max(class_input); % choices is integer: the chosen class, plus 1.
  [dump, targets] = max(data.targets); % targets is integer: the target class, plus 1.
  ret = mean(double(choices ~= targets));
end
