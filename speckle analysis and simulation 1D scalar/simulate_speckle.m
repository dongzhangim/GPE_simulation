create = 0;
analysis = 1;

if create==1
    for j=4:13
        X_cord = repmat((1:1:Nx),Nx,1);
        Y_cord = repmat((1:1:Nx)',1,Nx);

        phase_M = rand(Nx);

        origin = (Nx-1)/2 + 1;

        X_cord = X_cord - origin;
        Y_cord = Y_cord - origin;

        r_cord = sqrt(X_cord.^2 + Y_cord.^2);

        aperture = r_cord<(2^j);

        inten = sq(fftshift(fft2(exp(-2*pi*1i*phase_M.*aperture))))./1e15;

        save(strcat('speckle bench test data\numerical_speckle\inten_', num2str(j),'.mat'), 'inten')


    end
end

if analysis==1
    N_x = 100;
    kr = (1:1:N_x)*deltaf/k_R*2*pi;
    pow_r = zeros(10,N_x);

    rr = (1:1:N_x)*deltax*a_0;
    corr_r = zeros(10,N_x);
    cors = zeros(1,10);

    for i=4:13
        filepath = strcat('speckle bench test data\numerical_speckle\inten_', num2str(i),'.mat');
        speckle = load(filepath);
        speckle = speckle.inten;
        speckle = double(speckle);
        speckle = speckle - mean(mean(speckle));
        fsp = fftshift(fft2(speckle));
        fp = sq(fsp);

        corr = abs(fftshift(ifft2(fp)));
        [maxr,maxc] = find(fp==max(max(fp)));



        X_cord = repmat((1:1:Nx),Nx,1);
        Y_cord = repmat((1:1:Nx)',1,Nx);

        X_cord = X_cord - mean(maxc);
        Y_cord = Y_cord - mean(maxr);

        r_cord = sqrt(X_cord.^2 + Y_cord.^2);
        for k=1:N_x
            [cordr,cordc] = find(r_cord<=k & r_cord>(k-1));
            num = size(cordr,1);
            po = 0;
            co = 0;
            for j=1:num
                po  = po + fp(cordr(j),cordc(j));
                co = co + corr(cordr(j),cordc(j));
            end
            po = po/num;
            co = co/num;
            pow_r(i-3,k) = po;
            corr_r(i-3,k) = co;
        end

    %plot PSD in linear and log scale%%        
    %     figure(i)
    %     subplot(121)
    %     plot(r(3:end),pow_r(i,3:end))
    %     title('PDS')
    %     xlabel('k/k_R in radial direction')
    %     ylabel('power density')
    %     subplot(122)
    %     plot(r,log(pow_r(i,:)))
    %     title('log PDS')
    %     xlabel('k/k_R in radial direction')
    %     ylabel('log power density')


    %fit linear PSD to data
    %     figure(i)
    %     f = fit(kr(7:end)',pow_r(i,7:end)','a*max(1-x/b,0)','StartPoint',[max(pow_r(i,7:end)),4]);
    %     coe = coeffvalues(f);
    %     plot(f,kr(7:end),pow_r(i,7:end))
    %     title('fit linear PSD to data')
    %     xlabel('k/k_R in radial direction')
    %     ylabel('power density')
    %     text(5,2e11,strcat('k_m_a_x = ',num2str(coe(2))))


    %fit correlation length
    figure(i-3)
    corr_r(i-3,:) = corr_r(i-3,:)./max(corr_r(i-3,:));
    f = fit(rr',corr_r(i-3,:)','a*exp(-x^2/2/b^2)+c','StartPoint',[1.0, 2e-6,0.05]);
    coe = coeffvalues(f);

    plot(f,rr,corr_r(i-3,:))
    title('correlation function averaged in radial direction')
    xlabel('x/m')
    ylabel('correlation')
    text(0.4e-5,0.6,strcat('fit a*exp(-x^2/2/b^2), b = ',num2str(coe(2))))
    cors(i) = coe(2);
    end
end
