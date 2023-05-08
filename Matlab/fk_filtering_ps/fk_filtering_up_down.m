%% VSP up- and down-going wave separation for SEAM data
% Yanwen Wei @ 2023-5-6

% requirements:
% 1. functions: fktran, ifktran
% 2. binary data with size of n1*n2
%    example data ep_ep0010250.data is the No.10250 shot of SEAM open VSP data
%    example data ep_ep0003446.data is the No.10250 shot of SEAM open VSP data


clc; clear all; close all;
lng = 0; fontsize = 10;
%% set parameters
n1 = 2001; n2 = 467;
t0 = 0; dt = 0.008; nt = n1;
x0 = 0; dx = 0.008; nx = n2;
t = t0:dt:(nt-1)*dt + t0;
x = x0:dx:(nx-1)*dx + x0;

%%  read in data
pathf = 'ep_ep0010250.data';
bid = fopen(pathf, 'rb');
fid = fread(bid, n1*n2, 'float');
indata  = reshape(fid, [n1, n2]);

%% Up and down going separate

readydata = indata;
ntpad = 2048; nxpad=512;
[spec,f,kx] = fktran(readydata,t,x, ntpad, nxpad);

figure; set(gcf,'Position',[1000 600 600 400]);
ift = 500; 
imagesc(kx, f(1:ift), 20*log10(abs(spec(1:ift, :)))); 
xlabel('Wavenumber (1/m)'); ylabel('Frequency (Hz)');

% up 
spec_u = spec;
spec_u(:, floor(nxpad/2):nxpad) = 0;
[seis_u_out, t_u_out, x_u_out] = ifktran(spec_u, f, kx, ntpad, nxpad);


figure; set(gcf,'Position',[1000 600 600 400]);
ift = 500; 
imagesc(kx, f(1:ift), 20*log10(abs(spec_u(1:ift, :)))); %, [-scale1, scale1])
xlabel('Wavenumber (1/m)'); ylabel('Frequency (Hz)');

% down
spec_d = spec;
spec_d(:, 1:floor(nxpad/2)) = 0;
[seis_d_out, t_d_out, x_d_out] = ifktran(spec_d, f, kx, ntpad, nxpad);


figure; set(gcf,'Position',[1000 600 600 400]);
ift = 500; 
imagesc(kx, f(1:ift), 20*log10(abs(spec_d(1:ift, :)))); %, [-scale1, scale1])
xlabel('Wavenumber (1/m)'); ylabel('Frequency (Hz)');


%% plot wavefields
% parameters
alsc=0.05; ct1 = 1; ct2 = floor(nt/2);  x1 = 1; x2 = 450; %%%% modify here !!!

% plot
figure; set(gcf,'Position',[300 0 300 1000]); % [left bottom width height]
scale1 = alsc*max(max(seis_u_out));
imagesc(seis_u_out(ct1:ct2, x1:x2), [-scale1, scale1])
if lng
    xlabel('深度 (米)'); ylabel('时间 (秒)')
else
    xlabel('Depth (m)'); ylabel('Time (s)')
end
set(findobj('FontSize',fontsize),'FontSize',fontsize);
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',2);
set(gca,'xtick',21:40:nx); set(gca,'xticklabel',x(21:40:nx));
set(gca,'ytick',201:200:nt); set(gca,'yticklabel',t(201:200:nt));
title('Up-going wave');
colormap('gray');


figure; set(gcf,'Position',[600 0 300 1000]); % [left bottom width height]
scale1 = alsc*max(max(seis_d_out));
imagesc(seis_d_out(ct1:ct2, x1:x2), [-scale1, scale1])
if lng
    xlabel('深度 (米)'); ylabel('时间 (秒)')
else
    xlabel('Depth (m)'); ylabel('Time (s)')
end
set(findobj('FontSize',fontsize),'FontSize',fontsize);
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',2);
set(gca,'xtick',21:40:nx); set(gca,'xticklabel',x(21:40:nx));
set(gca,'ytick',201:200:nt); set(gca,'yticklabel',t(201:200:nt));
title('Down-going wave');
colormap('gray');

figure; set(gcf,'Position',[900 0 300 1000]); % [left bottom width height]
scale1 = alsc*max(max(readydata));
imagesc(readydata(ct1:ct2, x1:x2), [-scale1, scale1])
if lng
    xlabel('深度 (米)'); ylabel('时间 (秒)')
else
    xlabel('Depth (m)'); ylabel('Time (s)')
end
set(findobj('FontSize',fontsize),'FontSize',fontsize);
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',2);
set(gca,'xtick',21:40:nx); set(gca,'xticklabel',x(21:40:nx));
set(gca,'ytick',201:200:nt); set(gca,'yticklabel',t(201:200:nt));
title('Original wavefield');
colormap('gray');

