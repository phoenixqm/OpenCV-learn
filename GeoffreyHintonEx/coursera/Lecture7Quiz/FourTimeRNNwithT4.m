function [h, y] = FourTimeRNNwithT4(wxh, whh, why, bh, by, x, t4)

g = inline('1./(1+exp(-z))');


h1 = g(x(1)*wxh + bh);

h2 = g(x(2)*wxh + h1*whh + bh);

h3 = g(x(3)*wxh + h2*whh + bh);

h4 = g(x(4)*wxh + h3*whh + bh);

y4 = h4*why + by;

y4

h = [h1, h2, h3, h4];
h

err = t4 - y4;

E = sum(err.^2*0.5);

E

dEdy4 = -(t4-y4);
dy4dh4 = why;
dh4dh3 = h4*(1-h4)*whh;
dh3dh2 = h3*(1-h3)*whh;
dh2dh1 = h2*(1-h2)*whh;
dh1dx1 = h1*(1-h1)*wxh;

dEdx1 = dEdy4*dy4dh4*dh4dh3*dh3dh2*dh2dh1*dh1dx1;
dEdx1
