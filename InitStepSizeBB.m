function [initstepsize, info] = InitStepSizeBB(iter, initslope, fvs, Xs, GFs, Etas, stepsizes, fns, params)
% Find initial step size
%
% INPUT:
% iter : the current iteration
% initslope : the initial slope
% fvs  : previous function values, the last one is the value at the current iterate
% Xs   : previous iterates
% GFs  : previous gradients
% Etas : previous search directions
% stepsizes : previous step sizes, note that the step size for the direction Etas{end} is unknown yet
% fns : a struct that contains required function handles
% params: : a struct that contains parameters that are used
%
% OUTPUT:
% initstepsize : initial step size
% info: a struct that contains debug information
% 
% By Wen Huang

    params = SetDefaultParams(params, 'FirstIterInitStepSize', 1, 'float', 0.1, inf);
    params = SetDefaultParams(params, 'omega1', 1e-2, 'float', 0, 1);
    params = SetDefaultParams(params, 'omega2', 1e2, 'float', 1, inf);
    params = SetDefaultParams(params, 'SafeGuardTypeInBB', 1, 'int', 1, inf);
    if(iter == 0)
        initstepsize = params.FirstIterInitStepSize / sqrt(fns.Metric(Xs{1}, GFs{1}, GFs{1})); % initial step size at the very first iteration
        info.lf = 0; info.lgf = 0; info.lR = 0; info.lvt = 0; info.lhf = 0;
    else
        s = fns.ScalarTimesVector(Xs{end - 1}, stepsizes(end), Etas{end - 1}); % from Xs{end - 1} to Xs{end}
        aTgradend = fns.VecTranDiffRetAdjoint(Xs{end - 1}, s, Xs{end}, GFs{end});
        y = fns.VectorLinearCombination(Xs{end - 1}, 1, aTgradend, -1, GFs{end - 1});
        Py = fns.PreCon(Xs{end - 1}, y);
        BB2stepsize = fns.Metric(Xs{end - 1}, s, y) / fns.Metric(Xs{end - 1}, y, Py);
        
        if(params.SafeGuardTypeInBB == 2) % if nonmonotonic line search is used
            initstepsize = min([max([BB2stepsize, params.omega1]), params.omega2]);
        else
            NWinitstepsize = 2 * (fvs(end) - fvs(end-1)) / fns.Metric(Xs{end - 1}, Etas{end-1}, GFs{end-1}); % (Etas{end-1}' * GFs{end-1});
            if(NWinitstepsize <= eps)
                NWinitstepsize = stepsizes(end);
            end
            initstepsize = max([min([BB2stepsize, params.omega2 * NWinitstepsize]), params.omega1 * NWinitstepsize]);
        end
        info.lf = 0; info.lgf = 0; info.lR = 0; info.lvt = 1; info.lhf = 0;
    end
end
