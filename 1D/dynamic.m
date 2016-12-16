function phi_2 = dynamic(phi,t_evo,Deltat,Beta,Nx,V,k_scale,f,deltax,deltaf,L)

 
Stop_time = t_evo;


TF_radius = (3*Beta/2)^(1/3);
xmin = -TF_radius*6/5;
xmax = TF_radius*6/5;







potential = @(x)(0/2*x.^2 + V.*sin(k_scale.*x).^2 );
%order = 2;

X = linspace(xmin,xmax,Nx);
%N_tf = int16(TF_radius/DeltaX);
%cutX = X < TF_radius;

t = 0;
% fftNx = Nx -1;
% fftphi = phi(1:fftNx);
% fftX = X(1:fftNx);
% L = L - deltax;
fftphi = phi;
Deltat = 1i*Deltat;
evo = 500;
n = 0;
draw = 1;
while (t < Stop_time)
    fftphi = time_evolve(fftphi, potential,Deltat,X,Beta,Nx,deltax,deltaf,L);
    t = t - 1i*Deltat;
    n = n + 1;
    
    if (mod(n,evo)==0 && draw == 1)
        fphi = fourier_transform(fftphi,Nx,deltax);
        %fphi = fphi./norm1d(fphi,Nx,DeltaX);
        b = fphi.*conj(fphi);
        chem = chem_pot(fftphi,X,Nx,Beta,k_scale,deltax,deltaf,V,L);
        kin = ave_kin(fftphi,Nx,deltax,deltaf,L);
        pot = ave_pot(fftphi,Nx,deltax,X,V,k_scale);
        plot(f,b);
        title(strcat(num2str(chem),'||',num2str(kin),'||',num2str(pot)));
        drawnow;
        
    end
    
end
% phi_2 = zeros(1,Nx);
% phi_2(1:fftNx) = fftphi;
% phi_2(Nx) = phi_2(1);
phi_2 = fftphi;
end