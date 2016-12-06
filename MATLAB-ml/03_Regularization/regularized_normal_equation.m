clc,clear

x = load('ex5Linx.dat');
y = load('ex5Liny.dat');


plot(x,y,'o','MarkerEdgeColor','b','MarkerFaceColor','r')


x = [ones(length(x),1) x x.^2 x.^3 x.^4 x.^5];
[m n] = size(x);
n = n -1;


rm = diag([0;ones(n,1)]);   % lamda后面的矩阵
lamda = [0 1 10]';
colortype = {'g','b','r'};
sida = zeros(n+1,3);
xrange = linspace(min(x(:,2)),max(x(:,2)))';
hold on;
for i = 1:3
    sida(:,i) = inv(x'*x+lamda(i).*rm)*x'*y;%计算参数sida
    norm_sida = norm(sida)
    yrange = [ones(size(xrange)) xrange xrange.^2 xrange.^3,...
        xrange.^4 xrange.^5]*sida(:,i);
    plot(xrange',yrange,char(colortype(i)))
    hold on
end

legend('traning data', '\lambda=0', '\lambda=1','\lambda=10')

hold off