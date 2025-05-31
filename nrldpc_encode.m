function cword = nrldpc_encode(Base, Z, msg)
[m, n] = size(Base);
cword = zeros(1, n*Z); % codeword length = columns of Base matrix * Z
cword(1:(n-m)*Z) = msg; % message length = (columns - rows of Base matrix) * Z

% double-diagonal encoding
temp = zeros(1, Z);
for i = 1:4 % row 1 to 4
    for j = 1:n-m % message columns
        temp = mod(temp + mul_sh(msg((j-1)*Z + 1 : j*Z), Base(i, j)), 2);
    end
end

if(Base(2, n-m+1)==-1)
    p1_sh = Base(3, n-m+1);
else
    p1_sh = Base(2, n-m+1);
end

cword((n-m)*Z + 1:(n-m+1)*Z) = mul_sh(temp, Z-p1_sh); % p1 calculation

% Find p2, p3, p4
for i = 1:3
    temp = zeros(1, Z);
    for j = 1:n-m+i
        temp = mod(temp + mul_sh(cword((j-1)*Z  + 1:j*Z), Base(i, j)), 2);
    end
    cword((n-m+i)*Z + 1:(n-m+i+1)*Z)= temp;
end

% Remaining parities
for i = 5:m
    temp = zeros(1, Z);
    for j = 1:n-m+4
        temp = mod(temp + mul_sh(cword((j-1)*Z + 1:j*Z), Base(i, j)), 2);
    end
    cword((n-m+i-1)*Z + 1:(n-m+i)*Z) = temp;
end



