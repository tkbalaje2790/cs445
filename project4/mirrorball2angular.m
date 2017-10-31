function angular = mirrorball2angular( mirrorball_hdr )
%MIRRORBALL2ANGULAR Converts an mirrorball image to an angular  projection
    offset = pi/2;
    cmap = parula(256);

    mirrorball_hdr = im2double(mirrorball_hdr);
    [rows, cols, dim] = size(mirrorball_hdr);
    assert(rows==cols,'Mirror ball image must be square!');
    
    %Create cubemap image here
    [X, Y] = meshgrid(1:cols, 1:rows);
    X = (X-cols/2)/(cols/2); % X now holds the x coord of each pixel
    Y = -(Y-cols/2)/(cols/2); % Y now holds the y coord of each pixel
    Z = sqrt(1-(X.*X + Y.*Y)); % Z = sqrt(1-(x^2+y^2)) for each pixel
    Z(imag(Z) ~= 0) = 0; % remove imaginary z coords (those outside of sphere)
    mask = Z ~= 0;
    X = mask .* X;
    Y = mask .* Y;
    
    N = cat(4, X, Y, Z); % N represents surface normal for pixel
    V = zeros(size(N)); % V is view vector at each pixel
    V(:,:,3) = -1;
    R = V - repmat(2 .* -Z, 1, 1, 1, 3) .* N; % R holds reflection vector for each pixel
    theta_ball = acos(R(:,:,3)); % Get the theta coord for this pixel
    phi_ball = atan2(R(:,:,2), R(:,:,1)); % Get the phi coord for this pixel
    % Offset phi values
    phi_ball = phi_ball + offset;
    phi_ball(phi_ball > pi) = phi_ball(phi_ball > pi) - 2*pi;
    phi_ball(phi_ball < -pi) = phi_ball(phi_ball < -pi) + 2*pi;
    
    % Image display/write
    I = mask.*phi_ball - pi*~mask;
    figure(5),imagesc(I), axis image, colormap default
%     m = I - min(I(:));
%     m = max(m(:));
%     imwrite(255*(I-min(I(:))) ./ m, cmap, './results/phi_mb_ang.jpg');
    I = mask.*theta_ball;
    figure(6),imagesc(I), axis image, colormap default
%     m = I - min(I(:));
%     m = max(m(:));
%     imwrite( 255*(I-min(I(:))) ./ m, cmap, './results/theta_mb_ang.jpg');
    
    % Reshape matrices
    phi_ball = reshape(phi_ball, rows*cols, 1);
    theta_ball = reshape(theta_ball, rows*cols, 1);
    mirrorball_hdr = reshape(mirrorball_hdr, rows*cols, 1, dim);
    
    %Create Angular image
    rows = 720;
    cols = 720;
    [X, Y] = meshgrid(1:rows, 1:cols);
    X = (X-cols/2)/(cols/2); % X now holds the x coord of each pixel
    Y = -(Y-cols/2)/(cols/2); % Y now holds the y coord of each pixel
    R = sqrt(X.*X + Y.*Y); % R holds radius (polar coords)
    phi_ang = atan2(Y, X);
    phi_ang = phi_ang+offset;
    phi_ang(phi_ang > pi) = phi_ang(phi_ang > pi) -2*pi;
    phi_ang(phi_ang < -pi) = phi_ang(phi_ang < -pi) +2*pi;
    theta_ang = R .* pi;
    mask = R <= 1;
    
    % Image display/write
    I = mask.*phi_ang - pi*~mask;
    figure(7),imagesc(I), axis image, colormap default
%     m = I - min(I(:));
%     m = max(m(:));
%     imwrite( 255*(I-min(I(:))) ./ m, cmap, './results/phi_ang.jpg');
    I = mask.*theta_ang;
    figure(8),imagesc(I), axis image, colormap default
%     m = I - min(I(:));
%     m = max(m(:));
%     imwrite( 255*(I-min(I(:))) ./ m, cmap, './results/theta_ang.jpg');
    
    angular = zeros(rows, cols, 3);
    for i = 1:dim
        F = scatteredInterpolant(phi_ball, theta_ball, mirrorball_hdr(:,i));
        angular(:,:,i) = mask.*F(phi_ang, theta_ang);
    end
        
end
