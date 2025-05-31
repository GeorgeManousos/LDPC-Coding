function y = mul_sh(x, shift)
if(shift==-1)
y = zeros(1, length(x));
else
y = [x(shift+1:end) x(1:shift)];
end