function [eokxx,eokyy,eokxy] = computeHstrainOkada92(rcv,Xg,Yg,ss,ds)
% compute horizontal strains from dislocations using okada92
% INPUTS
% rcv - unicycle source object
% Xg, Yg - locations at which you want to calculate strains
% ss,ds - strike-slip and dip-slip
% OUTPUTS - eokxx,eokyy,eokxy - strain tensor at Xg,Yg
% Rishav Mallick, EOS, 2018

Eok = [];
for k=1:rcv.N
    xd = Xg(:) - rcv.x(k,1);
    yd = Yg(:) - rcv.x(k,2);
    zd = 0.*xd;
    % calculate strain from strikeslip source
    [~,~,Ecalcss,~]=unicycle.greens.computeOkada92(ss(k),xd(:),yd(:),zd(:),rcv.earthModel.G,rcv.earthModel.nu, ...
        -rcv.x(k,3),rcv.dip(k)/180*pi,rcv.L(k),rcv.W(k),'s',0,rcv.strike(k)/180*pi);
    Ecalcss=reshape(Ecalcss,length(xd),3,3);
    % calculate strain from dipslip source
    [~,~,Ecalcds,~]=unicycle.greens.computeOkada92(ds(k),xd(:),yd(:),zd(:),30e9,.25, ...
        -rcv.x(k,3),rcv.dip(k)/180*pi,rcv.L(k),rcv.W(k),'d',0,rcv.strike(k)/180*pi);
    Ecalcds=reshape(Ecalcds,length(xd),3,3);
    if k ==1
        Eok = Ecalcss + Ecalcds;
    else 
        Eok = Eok+Ecalcss +Ecalcds;
    end
end
eokxx = Eok(:,1,1);
eokyy = Eok(:,2,2);
eokxy = Eok(:,1,2);

end