function create_espm2d(xd,zd,T,patchslabname)
% function to create and save an ESPM fault geometries as a
% unicycle seg file
% INPUTS
% xd - horizontal location of coupling transition (m)
% zd - depth of coupling transition (+ve number) (m)
% T - slab thickness (m)
% patchslabname - name.seg
% Rishav Mallick, EOS, 2019

dip = atan2d(abs(zd),xd);
xh = -T*tand(dip/2);
v_plate = 1;
fault_length = 10000e3;
fault_width = 1e8;

% write patch file
fileID = fopen(patchslabname,'w');
fprintf(fileID,'%s\n','#patch file generated automatically - 2D ramp model, constant patch size');
fprintf(fileID,'%s\n',...
    '# n  Vpl      x1              x2   x3   Length       Width   Strike  Dip  Rake      L0       W0        qL  qW');
% deep dislocation
fprintf(fileID,'%d %.9f %.9f %.9f %.9f %.9f %.9f %.9f %.9f %.9f %.9f %.9f %d %d\n',...
    1, v_plate,-fault_length/2, xd,    zd,fault_length,fault_width, 0,   dip, 90, fault_length, fault_width, 1.0, 1.0);

% bottom dislocation
fprintf(fileID,'%d %.9f %.9f %.9f %.9f %.9f %.9f %.9f %.9f %.9f %.9f %.9f %d %d\n',...
    2, -v_plate,-fault_length/2, xh,    T,fault_length,fault_width, 0,   dip, 90, fault_length, fault_width, 1.0, 1.0);

% bottom dislocation
fprintf(fileID,'%d %.9f %.9f %.9f %.9f %.9f %.9f %.9f %.9f %.9f %.9f %.9f %d %d\n',...
    2, -v_plate,-fault_length/2, xh - fault_width,    T,fault_length,fault_width, 0,   0, 90, fault_length, fault_width, 1.0, 1.0);

fclose(fileID);
end