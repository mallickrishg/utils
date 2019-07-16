function create_espmcurved2d(xd,zd,ng,T,patchfname,patchslabname)
% function to create and save an ESPM with curved fault geometries as a
% unicycle seg file
% INPUTS
% xd - horizontal location of coupling transition (m)
% zd - depth of coupling transition (+ve number) (m)
% ng - number of sub faults in the curved segments (generally 100)
% T - slab thickness (m)
% patchfname - name.seg
% patchslabname - name.seg
% Rishav Mallick, EOS, 2019

x0 = 0; %This is hardcoded in to make calculations easier 
wdeep = 10000e3;% down-dip length of driving faults

R = (xd^2 + zd^2)/(2*zd);% radius of circle
z0 = R;
% calculate slope and intercept of line connectinf (x0,z0) -> (xd,zd)
m = (zd - z0)/(xd - x0);
c = z0 - m*x0;

% find position of (xb,zb) -> slab bottom
xb = (m*(R-c) + sqrt(m^2*(c-R)^2 - (1+m^2)*((c-R)^2 - (R-T)^2)))/(1+m^2);
zb = m*xb + c;

% create circle function
circz = @(x,x0,z0,r) -sqrt(r^2 - (x-x0).^2) + z0;

xtop = linspace(0,xd,ng);
ztop = circz(xtop,x0,z0,R);
xbot = linspace(0,xb,ng);
zbot = circz(xbot,x0,z0,(R-T));
%% plate-boundary fault
%initialize arrays
xf = [];zf=[];dip=[];w=[];
% write patch file
fileID = fopen(patchfname,'w');
fprintf(fileID,'%s\n','#patch file generated automatically - 2D ramp model, constant patch size');
    
for i = 1:(length(xtop)-1)
    xf(i) = xtop(i);
    zf(i) = ztop(i);
    dip(i) = -atan2d(ztop(i+1)-ztop(i),xtop(i+1)-xtop(i));
    w(i) = sqrt((ztop(i+1)-ztop(i))^2 + (xtop(i+1)-xtop(i))^2);
    
    v_plate = 1;
    fault_length=10000e3;
    npatchl = 1;
    patch_length = fault_length/npatchl;
    fprintf(fileID,'%s\n',...
        '# n  Vpl      x1              x2   x3   Length       Width   Strike  Dip  Rake      L0       W0        qL  qW');
    fprintf(fileID,'%d %.9f %.9f %.9f %.9f %.9f %.9f %.9f %.9f %.9f %.9f %.9f %d %d\n',...
        1, v_plate,-fault_length/2, xf(i),    zf(i),fault_length,w(i), 0,   -dip(i), 90, patch_length, w(i), 1.0, 1.0);
end

fclose(fileID);
%% create unicycle fault for the "slab"
fileID = fopen(patchslabname,'w');
fprintf(fileID,'%s\n','#patch file generated automatically - 2D ramp model, constant patch size');
fprintf(fileID,'%d %.9f %.9f %.9f %.9f %.9f %.9f %.9f %.9f %.9f %.9f %.9f %d %d\n',...
    1, v_plate,-fault_length/2,xtop(end),ztop(end),fault_length,wdeep,...
    0,-dip(end),90,patch_length,wdeep,1.0,1.0);
%initialize arrays
xf = [];zf=[];dip=[];w=[];
    
for i = 1:(length(xbot)-1)
    xf(i) = xbot(i);
    zf(i) = zbot(i);
    dip(i) = -atan2d(zbot(i+1)-zbot(i),xbot(i+1)-xbot(i));
    w(i) = sqrt((zbot(i+1)-zbot(i))^2 + (xbot(i+1)-xbot(i))^2);
    
    fprintf(fileID,'%s\n',...
        '# n  Vpl      x1              x2   x3   Length       Width   Strike  Dip  Rake      L0       W0        qL  qW');
    fprintf(fileID,'%d %.9f %.9f %.9f %.9f %.9f %.9f %.9f %.9f %.9f %.9f %.9f %d %d\n',...
        1, v_plate,-fault_length/2, xf(i),    zf(i),fault_length,w(i), 0,   -dip(i), 90, patch_length, w(i), 1.0, 1.0);
end
% deep slab
fprintf(fileID,'%d %.9f %.9f %.9f %.9f %.9f %.9f %.9f %.9f %.9f %.9f %.9f %d %d\n',...
    1, v_plate,-fault_length/2,xbot(end),zbot(end),fault_length,wdeep,...
    0,-dip(end),90,patch_length,wdeep,1.0,1.0);
% flat slab west of trench
fprintf(fileID,'%d %.9f %.9f %.9f %.9f %.9f %.9f %.9f %.9f %.9f %.9f %.9f %d %d\n',...
    1, v_plate,-fault_length/2,-wdeep,T,fault_length,wdeep,...
    0,0,90,patch_length,wdeep,1.0,1.0);
fclose(fileID);
end