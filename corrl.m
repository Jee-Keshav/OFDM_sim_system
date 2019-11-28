function corrl(y,x)     %(y<x)
xl = length(x)
yl = length(y)

x1=[zeros(1,yl-1) x];

for i=1:xl
    x2 = x1(i:i+yl-1);
    z(i)=sum(x2.*y) /sqrt( sum(x2.*x2) * sum(y.*y) );
end
[val,I] = max(z);
ind = I-yl+1

result = x(I-yl+1:I)
