
%http://openclassroom.stanford.edu/MainFolder/DocumentPage.php
%       ?course=DeepLearning&doc=exercises/ex3/ex3.html

%%method 1: Gradient descent
x = load('ex3x.dat');
y = load('ex3y.dat');

x = [ones(size(x,1),1) x];
meanx = mean(x);
sigmax = std(x);
x(:,2) = (x(:,2)-meanx(2))./sigmax(2);
x(:,3) = (x(:,3)-meanx(3))./sigmax(3);

figure
itera_num = 100; % count of iteration
sample_num = size(x,1); % number of samples
alpha = [0.01, 0.03, 0.1, 0.3, 1, 1.3]; % learn rates to check
plotstyle = {'b', 'r', 'g', 'k', 'b--', 'r--'};

theta_grad_descent = zeros(size(x(1,:)));
for alpha_i = 1:length(alpha) % check which rate is better
    theta = zeros(size(x,2),1); %theta init with 0s
    Jtheta = zeros(itera_num, 1);
    for i = 1:itera_num     % begin iteration      
        Jtheta(i) = (1/(2*sample_num)).*(x*theta-y)'*(x*theta-y); %Jtheta
        grad = (1/sample_num).*x'*(x*theta-y);
        theta = theta - alpha(alpha_i).*grad;
    end
    plot(0:49, Jtheta(1:50),char(plotstyle(alpha_i)),'LineWidth', 2)
    hold on
    
    if(1 == alpha(alpha_i)) 
        theta_grad_descent = theta
    end
end
legend('0.01','0.03','0.1','0.3','1','1.3');
xlabel('Number of iterations')
ylabel('Cost function')


price_grad_descend = theta_grad_descent'*[1 (1650-meanx(2))/sigmax(2) (3-meanx(3)/sigmax(3))]'
                                     
                                     
%%method 2: normal equations
x = load('ex3x.dat');
y = load('ex3y.dat');
x = [ones(size(x,1),1) x];

theta_norequ = inv((x'*x))*x'*y
price_norequ = theta_norequ'*[1 1650 3]'