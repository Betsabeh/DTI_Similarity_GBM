function rm2=calculte_rm2(ys_orig,ys_line)
r2 = r_squared_error(ys_orig, ys_line);
r02 = squared_error_zero(ys_orig, ys_line);

rm2=r2.*(1 - sqrt(abs((r2.*r2)-(r02.*r02))));
end
%----------------------------------------------------------------------------
%--------------------------------------------------------------------------
function r2=r_squared_error(y_obs,y_pred)
    
    y_obs_mean =mean(y_obs);
    y_pred_mean =mean(y_pred);

    mult = sum((y_pred - y_pred_mean) .* (y_obs - y_obs_mean));
    mult = mult .* mult;

    y_obs_sq = sum((y_obs - y_obs_mean).*(y_obs - y_obs_mean));
    y_pred_sq = sum((y_pred - y_pred_mean) .* (y_pred - y_pred_mean) );

    r2=mult./(y_obs_sq .* y_pred_sq);
end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

function k= get_k(y_obs,y_pred)
k=sum(y_obs.*y_pred) ./(sum(y_pred.*y_pred));
end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function r0=squared_error_zero(y_obs,y_pred)
    k = get_k(y_obs,y_pred);
    y_obs_mean =mean(y_obs);
    upp = sum((y_obs - (k*y_pred)).* (y_obs - (k* y_pred)));
    down= sum((y_obs - y_obs_mean).*(y_obs - y_obs_mean));
    r0=1 - (upp /(down));
end


