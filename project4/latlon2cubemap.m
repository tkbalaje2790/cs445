function cubemap = latlon2cubemap( )
    offset = -pi/2;
    cmap = parula(256);

    equirectangular = im2double(imread('./results/equirectangular.jpg'));
    [rows, cols, dim] = size(equirectangular);
    
    [phis, thetas] = meshgrid([-pi:2*pi/(cols-1):pi], 0:pi/(rows-1):pi);
    I = phis;
    m = I - min(I(:));
    m = max(m(:));
    imwrite(255*(I-min(I(:))) ./ m, cmap, './results/phi_eq.jpg');
    figure(2),imagesc(I), axis image, colormap default
    I = thetas;
    m = I - min(I(:));
    m = max(m(:));
    imwrite(255*(I-min(I(:))) ./ m, cmap, './results/theta_eq.jpg');
    figure(3),imagesc(I), axis image, colormap default
    phi_er = reshape(phis, rows*cols, 1);
    phi_er = phi_er+offset;
    phi_er(phi_er > pi) = phi_er(phi_er > pi) -2*pi;
    phi_er(phi_er < -pi) = phi_er(phi_er < -pi) +2*pi;
    theta_er = reshape(thetas, rows*cols, 1);
    equirectangular = reshape(equirectangular, rows*cols, 1, dim);
    
    X = zeros(4*180, 3*180);
    Y = zeros(4*180, 3*180);
    Z = zeros(4*180, 3*180);
    % +Y
    [x,z] = meshgrid(-1:2/179:1, -1:2/179:1);
    X(1:180,181:360) = x;
    Y(1:180,181:360) = 1;
    Z(1:180,181:360) = z;
    % +Z
    [x,y] = meshgrid(-1:2/179:1, 1:-2/179:-1);
    X(181:360,181:360) = x;
    Y(181:360,181:360) = y;
    Z(181:360,181:360) = 1;
    % +X
    [z,y] = meshgrid(1:-2/179:-1, 1:-2/179:-1);
    X(181:360,361:540) = 1;
    Y(181:360,361:540) = y;
    Z(181:360,361:540) = z;
    % -Y
    [x,z] = meshgrid(-1:2/179:1, 1:-2/179:-1);
    X(361:540,181:360) = x;
    Y(361:540,181:360) = -1;
    Z(361:540,181:360) = z;
    % -Z
    [x,y] = meshgrid(-1:2/179:1, -1:2/179:1);
    X(541:720,181:360) = x;
    Y(541:720,181:360) = y;
    Z(541:720,181:360) = -1;
    % -X
    [z,y] = meshgrid(-1:2/179:1, 1:-2/179:-1);
    X(181:360,1:180) = -1;
    Y(181:360,1:180) = y;
    Z(181:360,1:180) = z;
    
    maskcm = (X ~= 0) | (Y~= 0 ) | (Z~= 0);
    figure(3),imagesc(maskcm), axis image, colormap default
   
    % Normalize direction vector
    m = sqrt(X.*X + Y.*Y + Z.*Z);
    X = X ./ m;
    Y = Y ./ m;
    Z = Z ./ m;
   
    theta_cm = acos(Y); % Get the theta coord for this pixel
    phi_cm = atan2(Z, X); % Get the phi coord for this pixel
    phi_cm = phi_cm .* ~isnan(phi_cm); % Remove any NaN entries
    figure(7),imagesc(maskcm.*phi_cm), axis image, colormap default
    figure(8),imagesc(maskcm.*theta_cm + ~maskcm.*pi/2), axis image, colormap default
    
    cubemap = zeros(size(theta_cm));
    for i = 1:dim
        F = scatteredInterpolant(phi_er, theta_er, equirectangular(:,i));
        cubemap(:,:,i) = maskcm.*F(phi_cm, theta_cm);
    end
        
end
