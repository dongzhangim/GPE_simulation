i=4;
filepath = strcat('speckle bench test data/numerical_speckle/inten_', num2str(i),'.mat');
speckle = load(filepath);
speckle = speckle.inten;



mom_evo = zeros(8,2,200);
prof_evo = zeros(8,2,200);
mean_m = zeros(8,2,200);
mean_p = zeros(8,2,200);
final_phi = zeros(8,2,Nx);


kicks = [0.5,1,2,3,4,5,10,20];

for mk=1:8
    phi_mk = phi_dress;
    phi_mk = phi_mk.*repmat(exp(-1i*k_R*kicks(mk)*X),3,1);
    
    

    phi = phi_mk;

    for i=1:200
        phi_1 = dynamic(phi,1e-2,1e-5,c0,c2,Nx,0,0,0,k_scale,f,deltax,deltaf,L,2*detuning,xmin,xmax,k_R,detuning);

        fp1 = sq(fourier_transform(phi_1(1,:),Nx,deltax));
        fp2 = sq(fourier_transform(phi_1(2,:),Nx,deltax));

        mean_mom1 = integr(f.*fp1,Nx,deltaf)/integr(fp1,Nx,deltaf);
        mean_mom2 = integr(f.*fp2,Nx,deltaf)/integr(fp2,Nx,deltaf);

        mean_prof1 = integr(X.*sq(phi_1(1,:)),Nx,deltax)/integr(sq(phi_1(1,:)),Nx,deltax);
        mean_prof2 = integr(X.*sq(phi_1(2,:)),Nx,deltax)/integr(sq(phi_1(2,:)),Nx,deltax);

        mom_evo(mk,1,i) = sqrt(integr((f-mean_mom1).^2.*fp1,Nx,deltaf)/integr(fp1,Nx,deltaf));
        mom_evo(mk,2,i) = sqrt(integr((f-mean_mom2).^2.*fp2,Nx,deltaf)/integr(fp2,Nx,deltaf));

        prof_evo(mk,1,i) = sqrt(integr((X-mean_prof1).^2.*sq(phi_1(1,:)),Nx,deltax)/integr(sq(phi_1(1,:)),Nx,deltax));
        prof_evo(mk,2,i) = sqrt(integr((X-mean_prof2).^2.*sq(phi_1(2,:)),Nx,deltax)/integr(sq(phi_1(2,:)),Nx,deltax));

        mean_m(mk,1,i) = mean_mom1;
        mean_m(mk,2,i) = mean_mom2;

        mean_p(mk,1,i) = mean_prof1;
        mean_p(mk,2,i) = mean_prof2;





                %plot(f(1,3500:4500)./k_spacing,fp(1,3500:4500))


        phi = phi_1;

        save(strcat('C:\Experiments\simulation results\1d speckle spinor\12072018kick_evolve_with_soc_no_speckle/phi_',num2str(mk),'_',num2str(i),'.mat'),'phi_1')

    end

    final_phi(mk,:,:) = reshape(phi(1:2,:),[1,2,Nx]);
    save('C:\Experiments\simulation results\1d speckle spinor\12072018kick_evolve_with_soc_no_speckle/mom_evo.mat','mom_evo')
    save('C:\Experiments\simulation results\1d speckle spinor\12072018kick_evolve_with_soc_no_speckle/prof_evo.mat','prof_evo')
    save('C:\Experiments\simulation results\1d speckle spinor\12072018kick_evolve_with_soc_no_speckle/final_phi.mat','final_phi')
    save('C:\Experiments\simulation results\1d speckle spinor\12072018kick_evolve_with_soc_no_speckle/mean_m.mat','mean_m')
    save('C:\Experiments\simulation results\1d speckle spinor\12072018kick_evolve_with_soc_no_speckle/mean_p.mat','mean_p')
   
end
