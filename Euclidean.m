function fs = Euclidean()
    fprintf('Domain Euclidean Space\n');
    fs.RandInManifold = @RandInManifold;
    fs.Metric = @Metric;
    fs.Projection = @Projection;
    fs.ScalarTimesVector = @ScalarTimesVector;
    fs.VectorLinearCombination = @VectorLinearCombination;
    fs.Retraction = @Retraction;
    fs.InvRetraction = @InvRetraction;
    fs.VecTranDiffRet = @VecTranDiffRet;
    fs.VecTranDiffRetAdjoint = @VecTranDiffRetAdjoint;
    fs.Dist = @Dist;
    fs.VectorTransport = @VectorTransport;
    fs.InverseVectorTransport = @InverseVectorTransport;
    
    fs.EucGradToGrad = @EucGradToGrad;
    fs.EucHvToHv = @EucHvToHv;
end

function x = RandInManifold(n, m, num)
    if(nargin == 1)
        x.main = randn(n, 1);
    elseif(nargin == 2)
        x.main = randn(n, m);
    else
        x.main = randn(n, m, num);
    end
end

function [output, x] = Metric(x, v1, v2)
    output = v1.main(:)' * v2.main(:);
end

function [output, x] = Projection(x, eta)
    output.main = eta.main;
end

function output = ScalarTimesVector(x, s1, eta1)
    output.main = s1 * eta1.main;
end

function output = VectorLinearCombination(x, s1, eta1, s2, eta2)
    output.main = s1 * eta1.main + s2 * eta2.main;
end

function [output, x, eta] = Retraction(x, eta)
    output.main = x.main + eta.main;
end

function [output, x, y] = InvRetraction(x, y)
    output.main = y.main - x.main;
end

function [vx, dx, x, y] = VecTranDiffRet(x, dx, y, vx)
end

function [vy, dx, x, y] = VecTranDiffRetAdjoint(x, dx, y, vy)
end

function [output, x, y] = Dist(x, y)
    output = norm(y.main - x.main, 'fro');
end

function [vx, dx, x, y] = VectorTransport(x, dx, y, vx)
end

function [vy, dx, x, y] = InverseVectorTransport(x, dx, y, vy)
end

function [gf, x] = EucGradToGrad(x, egf)
    gf = egf;
end

function [Hv, x] = EucHvToHv(x, etax, eHv)
    Hv = eHv;
end

