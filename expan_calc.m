function Z = expan_calc(Base)
[m, n] = size(Base)
max = Base(1, 1) % Z-1 calculation
for i = 1: m 
for j = 1: n
if(Base(i, j) > max)
max = Base(i, j); 
end
end
end
Z = max + 1;