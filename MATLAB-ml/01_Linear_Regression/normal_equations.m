
% reference class and blog:
%http://openclassroom.stanford.edu/MainFolder/DocumentPage.php
%       ?course=DeepLearning&doc=exercises/ex2/ex2.html
%http://www.cnblogs.com/tornadomeet/archive/2013/03/15/2961660.html

% use normal equations
x = load('ex2x.dat');
y = load('ex2y.dat');
size(x)

plot(x,y,'*')
xlabel('height')
ylabel('age')
x = [ones(size(x,1),1),x];
w = inv(x'*x)*x'*y
hold on
%plot(x,0.0639*x+0.7502) 
plot(x(:,2),0.0639*x(:,2)+0.7502)