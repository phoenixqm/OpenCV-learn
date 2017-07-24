function [h, y] = ThreeTimeRNN(wxh, whh, why, bh, by, x)

g = inline('1./(1+exp(-z))');


h1 = g(x(1)*wxh + bh);
y1 = h1*why + by;            % linear
h2 = g(x(2)*wxh + h1*whh + bh);
y2 = h2*why + by;
h3 = g(x(3)*wxh + h2*whh + bh);
y3 = h3*why + by;


h = [h1, h2, h3];
y = [y1, y2, y3];

