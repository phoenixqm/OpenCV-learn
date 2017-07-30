function ret = cd1_improved(rbm_w, visible_data)
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

----- NOW IMPROVE IT -------------
If you go through the math (either on your own on with your fellow students 
on the forum), you'll see that sampling the hidden state that results from 
the "reconstruction" visible state is useless: it does not change the expected 
value of the gradient estimate that CD-1 produces; it only increases its 
variance. More variance means that we have to use a smaller learning rate, 
and that means that it'll learn more slowly; in other words, we don't want 
more variance, especially if it doesn't give us anything pleasant to compensate 
for that slower learning. Let's modify the CD-1 implementation to simply no 
longer do that sampling at the hidden state that results from the "reconstruction" 
visible state. Instead of a sampled state, we'll simply use the conditional 
probabilities. Of course, the configuration goodness gradient function expects 
a binary state, but you've probably already implemented it in such a way that 
it can gracefully take probabilities instead of binary states. If not, now 
would be a good time to do that. 

%}

vs0 = sample_bernoulli(visible_data);
hp1 = 1./(exp(-rbm_w * vs0)+1);
hs1 = sample_bernoulli(hp1);

vp1 = 1./(exp(-rbm_w' * hs1)+1);
vs1 = sample_bernoulli(vp1);

hp2 = 1./(exp(-rbm_w * vs1)+1);
% hs2 = sample_bernoulli(hp2);

d1 = configuration_goodness_gradient(vs0, hs1);
d2 = configuration_goodness_gradient(vs1, hp2);

ret = d1 - d2;

end
