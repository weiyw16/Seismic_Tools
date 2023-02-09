%% f-k filtering P/S wave separation
clc; clear;

%% parameter
nt = 3001; nr = 126;
dt = 0.002; dr = 20; or = 150;
t = 0:dt:dt*(nt-1); x = or:dr:dr*(nr-1)+or; 

mid_p = 65; 
k11 = 5.78; k12 = 9.38; k21 = 4.78; k22 = 9.38; %% change here

%% data
load demo_vsp_vzvx.mat

%% fk transform vz

[spec,f,kx] = fktran(vz,t,x);
% nfre = 389;
% sscut = 0.5 * max(max(imag(spec)));
% imagesc(kx, f(1:nfre), abs(imag(spec(1:nfre, :)) ), [0, sscut]); 

% filtering
freq_length = length(spec(:,1));
spec_p = spec; spec_s = spec;
for ix = 1:65
    freq_low_bound = abs( ceil((ix-65).* k11) +1);
    spec_p(freq_low_bound:freq_length, ix ) = 0;
    spec_s(1:freq_low_bound, ix ) = 0;
end
for ix = 65:mid_p
    spec_p(1:freq_length, ix ) = 0;
end
for ix = mid_p:length(kx)
    freq_low_bound = abs( ceil((ix-mid_p).* k12) +1);
    spec_p(freq_low_bound:freq_length, ix ) = 0;
    spec_s(1:freq_low_bound, ix ) = 0;
end

[seis_p_out_1,t_p_out,x_p_out] = ifktran(spec_p,f,kx);
[seis_s_out_1,t_s_out,x_s_out] = ifktran(spec_s,f,kx);

%% fk transform vx
[spec,f,kx] = fktran(vx,t,x);

freq_length = length(spec(:,1));
spec_p = spec; spec_s = spec;
for ix = 1:65
    freq_low_bound = abs( ceil((ix-65).* k21) +1);
    spec_p(freq_low_bound:freq_length, ix ) = 0;
    spec_s(1:freq_low_bound, ix ) = 0;
end
for ix = 65:mid_p
    spec_p(1:freq_length, ix ) = 0;
end
for ix = mid_p:length(kx)
    freq_low_bound = abs( ceil((ix-mid_p).* k22) +1);
    spec_p(freq_low_bound:freq_length, ix ) = 0;
    spec_s(1:freq_low_bound, ix ) = 0;
end
    
[seis_p_out_2,t_p_out,x_p_out] = ifktran(spec_p,f,kx);
[seis_s_out_2,t_s_out,x_s_out] = ifktran(spec_s,f,kx);

%% output 
seis_p_out = seis_p_out_1(1:nt, 1:nr) + seis_p_out_2(1:nt, 1:nr);
seis_s_out = seis_s_out_1(1:nt, 1:nr) + seis_s_out_2(1:nt, 1:nr);






%% plot
figure
set(gcf,'Position',[100 100 1200 300]); 
nrow = 1; ncol = 3; sscut_conv = 2e-14;
ifxlable = 1; nd1 = 350; 
nd = 1050; nt0 = 50; ndt = 500;
nt1 = (nd1 + 50) * 0.002; ddt = 500 * 0.002;

  h11 = subplot(1, 4, 1);
      imagesc(vz(nd1:nd1+nd, :), [-1e-14, 1e-14]);  
      if ifxlable; xlabel('Depth (km)'); end
      ylabel('Time (s)');
      set(gca,'ytick',nt0:ndt:nd); set(gca,'yticklabel',{nt1, nt1 + ddt, nt1 + 2 * ddt});
      set(gca,'xtick',20:40:100); set(gca,'xticklabel',{0.900, 1.700, 2.500});
      title('Vz')

   h12 = subplot(1, 4, 2);
      imagesc(vx(nd1:nd1+nd, :), [-1e-14, 1e-14]);  
      if ifxlable; xlabel('Depth (km)'); end
      set(gca,'ytick',nt0:ndt:nd); set(gca,'yticklabel',{nt1, nt1 + ddt, nt1 + 2 * ddt});
      set(gca,'xtick',20:40:100); set(gca,'xticklabel',{0.900, 1.700, 2.500});
      title('Vx')
     
   h13 = subplot(1, 4, 3);
      imagesc(seis_s_out(nd1:nd1+nd, :), [-sscut_conv, sscut_conv]);  
      if ifxlable; xlabel('Depth (km)'); end
      ylabel('Time (s)');
      set(gca,'ytick',nt0:ndt:nd); set(gca,'yticklabel',{nt1, nt1 + ddt, nt1 + 2 * ddt});
      set(gca,'xtick',20:40:100); set(gca,'xticklabel',{0.900, 1.700, 2.500});
      title('P')
 
   h14 = subplot(1, 4, 4);
      imagesc(seis_p_out(nd1:nd1+nd, :), [-sscut_conv, sscut_conv]);  
      if ifxlable; xlabel('Depth (km)'); end
      set(gca,'ytick',nt0:ndt:nd); set(gca,'yticklabel',{nt1, nt1 + ddt, nt1 + 2 * ddt});
      set(gca,'xtick',20:40:100); set(gca,'xticklabel',{0.900, 1.700, 2.500});
      title('S')
 
colormap(seismic(2)); % may require CREWES tools
  

