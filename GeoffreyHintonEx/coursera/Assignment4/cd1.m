function ret = cd1(rbm_w, visible_data)
% <rbm_w> is a matrix <number of hidden units> by <number of visible units>
% <visible_data> is a (possibly but not necessarily binary) matrix of size
%  <number of visible units> by <number of data cases>
% The returned value is the gradient approximation produced by CD-1.  
%  It's of the same shape as <rbm_w>.

%{
The variation that we're using here is the one where every time after calculating 
a conditional probability for a unit, we sample a state for the unit from that 
conditional probability (using the functionsample_bernoulli), and then we forget 
about the conditional probability. There are other variations where we do 
less sampling, but for now, we're going to do sampling everywhere: we'll sample 
a binary state for the hidden units conditional on the data; we'll sample a binary 
state for the visible units conditional on that binary hidden state (this is 
sometimes called the "reconstruction" for the visible units); and we'll sample 
a binary state for the hidden units conditional on that binary visible 
"reconstruction" state. Then we base our gradient estimate on all those sampled 
binary states. This is not the best strategy, but it is the simplest, so for 
now we use it. The conditional probability functions will be useful for the Gibbs 
update. The configuration goodness gradient function will be useful twice, for CD-1:

  We use it once on the given data and the hidden state that it gives rise to. 
  That gives us the direction of changing the weights that will make the data 
  have greater goodness, which is what we want to achieve.

We also use it on the "reconstruction" visible state and the hidden state that 
it gives rise to. That gives us the direction of changing the weights that will 
make the reconstruction have greater goodness, so we want to go in the opposite
direction, because we want to make the reconstruction have less goodness.

%}

vs0 = sample_bernoulli(visible_data);
hp1 = 1./(exp(-rbm_w * vs0)+1);
hs1 = sample_bernoulli(hp1);

vp1 = 1./(exp(-rbm_w' * hs1)+1);
vs1 = sample_bernoulli(vp1);

hp2 = 1./(exp(-rbm_w * vs1)+1);
hs2 = sample_bernoulli(hp2);

d1 = configuration_goodness_gradient(vs0, hs1);
d2 = configuration_goodness_gradient(vs1, hs2);

ret = d1 - d2;

end
