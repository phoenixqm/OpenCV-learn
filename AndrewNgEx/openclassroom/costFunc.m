function[jVal, gradient] = costFunc(theta, x, y, m)
   g = inline('1.0 ./ (1.0 + exp(-z))'); 
   h = g(x*theta);
   err = h - y;
   jVal =(1/m)*sum(-y.*log(h) - (1-y).*log(1-h));
   gradient = x' * err / m;
end
