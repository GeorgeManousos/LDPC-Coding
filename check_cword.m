function out = check_cword(Base, Z, c)
[m, n] = size(Base);

syn = zeros(1, m*Z); %H * C^T
for i=1:m
    for j=1:n
    syn((i-1)*Z + 1:i*Z) = mod(syn((i-1)*Z + 1:i*Z) + mul_sh(c((j-1)*Z + 1:j*Z), Base(i, j)), 2);
    end
end

if any(syn)
    out = 0;
else
    out = 1;
    end