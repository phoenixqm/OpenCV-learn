function G = configuration_goodness(rbm_w, visible_state, hidden_state)

% <rbm_w> is a matrix of size <number of hidden units> by <number of visible units>
% <visible_state> is a binary matrix of size <number of visible units> by 
%   <number of configurations that we're handling in parallel>.
% <hidden_state> is a binary matrix of size <number of hidden units> by 
%   <number of configurations that we're handling in parallel>.

% This returns a scalar: the mean over cases of the goodness (negative energy) 
% of the described configurations.


% % ------ use loop      --------
% m = size(visible_state,2);
% G = 0;
% 
% for i = 1:m
%     v = visible_state(:,i);
%     h = hidden_state(:,i);
%     w = rbm_w .* (h*v');
%     G = G + sum(sum(w));
% end
% 
% G = G/m;
% G
% % ------ end use loop  -------


% ------ use matrix ---------------

m = size(visible_state,2);
M = (rbm_w * visible_state) .* hidden_state;

G = sum(sum( M )) / m;
G

% % ----- end use matrix    -------


end
