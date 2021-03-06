%% initialise
close all; clear;
% addpaths
addpath('~/Documents/MATLAB/mathworks/');
addpath('~/Documents/MATLAB/mathworks/arctic_mapping_tools/');
addpath('~/Documents/MATLAB/mathworks/climate_data_toolbox/');
addpath('~/Documents/MATLAB/mathworks/bedmachine/');
addpath('~/Documents/MATLAB/mathworks/climate_data_toolbox/cdt_data/');
addpath('~/Documents/MATLAB/mathworks/cptcmap/');

% load data
% cryosat
A = readmatrix('/Users/thomas/OneDrive - University of Leeds/manuscripts/gris_runoff/accept_in_principle/data_files/slater_et_al_2021_ncomms_fig2_cryosat.csv','Range',2);
t_cryosat = A(:,1); dh_cryosat = A(:,2); dh_cryosat_err = A(:,3); clear A
% imau fdm
A = readmatrix('/Users/thomas/OneDrive - University of Leeds/manuscripts/gris_runoff/accept_in_principle/data_files/slater_et_al_2021_ncomms_fig2_imau_fdm.csv','Range',2);
t_imau_fdm = A(:,1); dh_imau_fdm = A(:,2);

% aux data
load('/Volumes/eartsl/gris_smb/cs_grn_dhdt_fill.mat','gridx','gridy','gmask'); % ice sheet mask
load('~/Documents/eartsl/work/misc/zmask_gris.mat','zmask_gris'); % ice sheet zwally basin definitions
load('/Volumes/eartsl/gris_smb/continent_outlines.mat','gx','gy'); % ice sheet outline
load('/Volumes/eartsl/gris_smb/melt_zone_mask1116.mat','melt_zone_mask1116') % facies mask
load('/Volumes/eartsl/gris_smb/runoff_pc_area.mat'); % runoff mask
load('~/Documents/eartsl/work/gris_smb/paper_figs/data/fig2a.mat','summer_start','summer_end'); % season definitions
runoff_pc_area_cs2 = griddata(rxx,ryy,runoff_pc_area,gridx,gridy,'nearest'); % regrid to 5km resolution for plotting
% define facies mask for plotting
facies_mask = nan(size(gridx));
facies_mask(runoff_pc_area_cs2>0) = 2;
facies_mask(melt_zone_mask1116==1) = 1;
facies_mask(melt_zone_mask1116==3) = 3;

%% make plot
fig = figure('units','centimeters','position',[0 0 180 90]/10);
delete(gca)
ha = tight_subplot(1,4,.025,[.2 .1],[.1 .1]);
hapos1 = get(ha(1),'position'); hapos2 = get(ha(2),'position'); hapos3 = get(ha(3),'position'); hapos4 = get(ha(4),'position');
delete(ha)

ax = axes('position',[hapos1(1),hapos1(2),hapos3(1)+hapos3(3),hapos1(4)]);

% elevation change plot
hold on;
axis([2011,2021,-7,1])
% shade summer
vfill(summer_start,summer_end,rgb('gray'),'edgecolor','none','facealpha',.2)
% plot time series
% imau fdm
p2 = plot(t_imau_fdm,dh_imau_fdm-1,'.-','color',rgb('light teal'),'markersize',10,'markerfacecolor',rgb('light teal'),'linewidth',1);
% cryosat
[l,p] = boundedline(t_cryosat,dh_cryosat,dh_cryosat_err,'-','alpha','color',rgb('ocean blue'),'linewidth',1);
plot(t_cryosat,dh_cryosat,'.','color',rgb('ocean blue'),'markersize',10);

xlabel(ax,'Year'); ylabel(ax,'Elevation change (m)');
set(ax,'xtick',[2011:2021],'ytick',[-7:1:1],'fontsize',10)
ntitle({'   CryoSat-2','',''},'location','sw','color',rgb('ocean blue'),'fontsize',10)
ntitle({'   IMAU-FDM',''},'location','sw','color',rgb('light teal'),'fontsize',10)
box on;

% map inset
ax2 = axes('position',[hapos4(1)+.075,hapos4(2),hapos4(3),hapos4(4)]); set(ax2,'visible','off'); hold on
cmapmm = [158,154,200;117,107,177;84,39,143]/255; cmapmm = flipud(cmapmm);
greenland('patch','edgecolor','none','facecolor',rgb('gray'));
h = imagesc(gridx(1,:),gridy(:,1),facies_mask); set(h,'alphadata',~isnan(facies_mask));
caxis([1 3])
colormap(ax2,cmapmm)
axis equal
axis([-1e6 .9e6 -3.5e6 -.5e6])
box on;
hold on;
contour(gridx(1,:),gridy(:,1),zmask_gris,[1.1 1.2 1.3 1.4 2.1 2.2 3.1 3.2 3.3 4.1 4.2 4.3 5.0 6.1 6.2 7.1 7.2 8.1 8.2],'w','linewidth',.2)
contour(gridx(1,:),gridy(:,1),zmask_gris,'k','linewidth',.4)
plot(gx,gy,'k','linewidth',.4)

text(-.4e6,-3.75e6,'Ablation','color',cmapmm(1,:),'fontsize',8);
text(-.4e6,-4e6,'Runoff','color',cmapmm(2,:),'fontsize',8);
text(-.4e6,-4.25e6,'Dry snow','color',cmapmm(3,:),'fontsize',8);
text(-0.8e5,-2.45e6,'6.2','color','w','fontsize',5);
text(-1.2e5,-2e6,'7.2','color','w','fontsize',5);
text(-1.5e5,-.575e6,'1','color','k','fontsize',8);
text(6.5e5,-1.1e6,'2','color','k','fontsize',8);
text(7.5e5,-2.3e6,'3','color','k','fontsize',8);
text(2.7e5,-2.85e6,'4','color','k','fontsize',8);
text(-1.3e5,-3.5e6,'5','color','k','fontsize',8);
text(-6.5e5,-2.7e6,'6','color','k','fontsize',8);
text(-6e5,-2.2e6,'7','color','k','fontsize',8);
text(-6e5,-1.7e6,'8','color','k','fontsize',8);
