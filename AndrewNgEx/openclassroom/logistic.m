x = load('ex4x.dat');
y = load('ex4y.dat');

% find returns the indices of the
% rows meeting the specified condition
pos = find(y == 1); neg = find(y == 0);

m = length(y);
x = [ones(m, 1), x]; %add a column of ones to x

% Assume the features are in the 2nd and 3rd
% columns of x
plot(x(pos, 2), x(pos,3), '+'); hold on
plot(x(neg, 2), x(neg, 3), 'o')

g = inline('1.0 ./ (1.0 + exp(-z))'); 

theta = zeros(size(x,2),1);

MAX_ITR = 20

for i = 1:MAX_ITR
  h = g(x*theta);
  err = h - y;
  grad = x' * err / m;

  hess = (1/m).*x' * diag(h) * diag(1-h) * x;
  
  theta = theta - hess\grad;
    
   % Calculate J (for testing convergence)
   J(i) =(1/m)*sum(-y.*log(h) - (1-y).*log(1-h));
    
end

theta

% Plot Newton's method result
% Only need 2 points to define a line, so choose two endpoints
plot_x = [min(x(:,2))-2,  max(x(:,2))+2];
% Calculate the decision boundary line
plot_y = (-1./theta(3)).*(theta(2).*plot_x +theta(1));
plot(plot_x, plot_y)
legend('Admitted', 'Not admitted', 'Decision Boundary')
hold off

% Plot J
figure
plot(0:MAX_ITR-1, J, 'o--', 'MarkerFaceColor', 'r', 'MarkerSize', 8)
xlabel('Iteration'); ylabel('J')
% Display J
J
