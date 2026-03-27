function fns = subprolemX(A, b,beta1,beta2,Lambda1,Lambda2,U,V,X,H, fns)
    fns.f = @(x)f(x, A, b,beta1,beta2,Lambda1,Lambda2,U,V,X,H);
    fns.Grad = @(x)Grad(x, fns, A, b,beta1,beta2,Lambda1,Lambda2,U,V,X,H);
    % fns.HessEta = @(x, v)HessianEta(x, fns, v, A, b);
    fns.PreCon = @(x, v)Preconditioner(x, v);
end

function [output, x] = Grad(x, fns, A, b,beta1,beta2,Lambda1,Lambda2,U,V,X,H)
    [egf, x] = EucGrad(x, A, b,beta1,beta2,Lambda1,Lambda2,U,V,X,H);
    [output, x] = fns.EucGradToGrad(x, egf);
end

% function [output, x] = HessianEta(x, fns, v, A, b,beta1,beta2,Lambda1,Lambda2,U,V,X,H)
%     [eHv, x] = EucHessianEta(x, v, A, b,beta1,beta2,Lambda1,Lambda2,U,V,X,H);
%     [output, x] = fns.EucHvToHv(x, v, eHv);
% end

function [output, x] = f(x, A, b,beta1,beta2,Lambda1,Lambda2,U,V,X,H)
    x.Axb = A * x.main-b;
    %c = H*x.main-b;
    output = sum(1-1./(1+x.Axb.^2))+ beta1*norm(U-H *(x.main)+Lambda1./beta1,'fro')^2/2+...
         beta2*norm(V-H*(x.main)+Lambda2./beta2,'fro')^2./2+norm( x.main-X,'fro')^2./2;
end

function [output, x] = EucGrad(x, A, b,beta1,beta2,Lambda1,Lambda2,U,V,X,H)
    [a,~] = size(x.main);
    [c,~]  = size(A);
    t1 = zeros(a,1);
    for i = 1:c
        t1 = t1 + 2*(x.Axb(i,:))./(1+(x.Axb(i,:))^2).^2.*A(i,:)';
       % t1= t1 + 2*(A(i,:)*x.main-b(i,1))./(1+(A(i,:)*x.main-b(i,1))^2).^2.*A(i,:)';
    end
    % output.main = t1 + (beta1+beta2)*H'*H*x.main +x.main-H'*(beta1*U+beta2*V+Lambda1+Lambda2)-X;
    output.main = t1 + H'*((beta1+beta2)*H*x.main -(beta1*U+beta2*V+Lambda1+Lambda2))-X+x.main;
end

% function [output, x] = EucHessianEta(x, v, A, b)
%     output.main = A * v.main;
% end
% 
function output = Preconditioner(x, v)
    output = v;
end
