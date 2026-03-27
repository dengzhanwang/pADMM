function Phi = SCAD(x, lambda, gamma)

    Phi = (-1.*x.^2 + 2*gamma*lambda.*abs(x)-lambda^2)./(2*gamma-2);
    T = find(abs(x)<=lambda);
    Phi(T) = lambda.*abs(x(T));
    T1 = find(abs(x)> gamma*lambda);
    Phi(T1) = ((gamma+1)*lambda^2/2) .* ones(size(T1,1),1);

end
