function [eta2, stepsize, x2, f2, gradf2, slopex2, LSinfo, status] = linesearch(eta1, x1, fvs, ngfs, gradf1, initslope, initstepsize, iter, fns, params)
% This function apply the backtracking algorithm to find an appropriate step size.
%
% INPUT:
% eta1 : search direction
% x1   : current iterate
% fvs  :  previous function values, the last one is the function value at the current iterate
% gradf1 : gradient at the current iterate
% initslope : the initial slope
% initstepsize : the initial step size
% fns : a struct that contains required function handles
%     fns.f(x) : return objective function value at x.
%     fns.Grad(x) : return the gradient of objection function at x.
% params: : a struct that contains parameters that are used
%     alpha : the coefficient in the Armijo condition
%     ratio1 : the shrinking parameter 0 < ratio1 <= ratio2 < 1
%     ratio2 : the shrinking parameter 0 < ratio1 <= ratio2 < 1
%     lsmaxiter : the max numbers of iteration in the backtracking algorithm
%
% OUTPUT:
% eta2 : step size * search direction
% stepsize : desired step size
% x2  : next iterate x + eta2
% f2  : function value at the next iterate
% gradf2 : gradient at the next iterate
% slopex2 : slope at the accepted step size
% LSinfo : Debug information in line search algorithm
%      LSinfo.lf : the number of function evaluations
%      LSinfo.lgf: the number of gradient evaluations
% status : 0 means success
%          1 means line search fails with inner iterations reaches its max number of iterations
%          2 means the numerical errors dominates the computation
% 
    params = SetDefaultParams(params, 'alpha', 1e-4, 'float', 0, 0.5);
    params = SetDefaultParams(params, 'ratio1', 0.01, 'float', 0, 1);
    params = SetDefaultParams(params, 'ratio2', 0.99, 'float', 0, 1);
    params = SetDefaultParams(params, 'lsmaxiter', 30, 'int', 1, 100);
    params = SetDefaultParams(params, 'Accuracy', 0, 'float', 0, 1);
    params = SetDefaultParams(params, 'm', 1, 'int', 1, inf);
    
    if(ngfs(end) > params.Accuracy)
        f1 = fvs(end);
    else
        start = max([1, length(fvs) - params.m + 1]);
        f1 = max(fvs(start:end));
    end
    stepsize1 = initstepsize;
    eta2 = fns.ScalarTimesVector(x1, stepsize1, eta1);
    [x2, x1, eta2] = fns.Retraction(x1, eta2);
    [f2, x2] = fns.f(x2);
    btiter = 0;
    status = 0;
    while((f2 > f1 + stepsize1 * params.alpha * initslope && btiter < params.lsmaxiter))% || min(x2.main{1}(:)) < 0 || min(x2.main{2}(:)) < 0 || min(x2.main{3}(:)) < 0)
        if(btiter == 0)
            stepsize2 = - initslope * stepsize1 * stepsize1 / 2 / (f2 - f1 - initslope * stepsize1);
            stepsize2 = min([params.ratio2 * initstepsize, max([stepsize2, initstepsize * params.ratio1])]);
        else
            ab = [1 / stepsize1 / stepsize1, -1 / prestepsize / prestepsize; ...
                - prestepsize / stepsize1 / stepsize1, stepsize1 / prestepsize / prestepsize] * ...
                [f2 - f1 - initslope * stepsize1; pref2 - f1 - initslope * prestepsize] / (stepsize1 - prestepsize);
            stepsize2 = (-ab(2) + sqrt(ab(2) * ab(2) - 3 * ab(1) * initslope)) / 3 / ab(1);
            stepsize2 = min([params.ratio2 * initstepsize, max([stepsize2, initstepsize * params.ratio1])]);
            if(abs(stepsize2 == stepsize1) < eps) % numerical error takes effect
                break;
            end
        end
        prestepsize = stepsize1;
        pref2 = f2;
        
        eta2 = fns.ScalarTimesVector(x1, stepsize2, eta1);
        [x2, x1, eta2] = fns.Retraction(x1, eta2);
        [f2, x2] = fns.f(x2);
        stepsize1 = stepsize2;
        btiter = btiter + 1;
    end
%     [min(x2.main{1}(:)) < 0, min(x2.main{2}(:)) < 0, min(x2.main{3}(:)) < 0]%%--
    stepsize = stepsize1;
    [gradf2, x2] = fns.Grad(x2);
    [TReta1, eta2, x1, x2] = fns.VecTranDiffRet(x1, eta2, x2, eta1);
    slopex2 = fns.Metric(x2, gradf2, TReta1);
    if(btiter >= params.lsmaxiter)
%         fprintf('warning: line search fails at iter:%d!\n', iter);
        status = 1;
    end
    if(fns.Dist(x2, x1) == 0)
        status = 2;
    end
    LSinfo.lf = 1 + btiter; LSinfo.lgf = 1; LSinfo.lR = 1 + btiter; LSinfo.lvt = 1;
end

