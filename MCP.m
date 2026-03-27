function Phi = MCP(x, lambda, gamma)

    Phi = (gamma*lambda^2/2).*ones(size(x));
    T = find(abs(x)<=gamma*lambda);
    Phi(T) = lambda.*abs(x(T))-x(T).^2./(2*gamma);

end
