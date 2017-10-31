function cubemap = mirrorball2cubemap( mirrorball_hdr )
%MIRRORBALL2CUBEMAP Converts a mirrorball image to a cubemap projection
    offset = pi/2; % offsets used later to center images
    
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
    theta_ball = acos(R(:,:,2)); % Get the theta coord for this pixel
    phi_ball = atan2(R(:,:,3), R(:,:,1)); % Get the phi coord for this pixel
    % Offset phi values
    phi_ball = phi_ball + offset;
    phi_ball(phi_ball > pi) = phi_ball(phi_ball > pi) - 2*pi;
    phi_ball(phi_ball < -pi) = phi_ball(phi_ball < -pi) + 2*pi;
    
    % Image display/write
    Rim = reshape(R, rows,cols,3);
    figure(9),imagesc(Rim), axis image, colormap default
%     imwrite(Rim, './results/reflection_mb.jpg');
    Nim = reshape(N, rows,cols,3);
    figure(9),imagesc(Nim), axis image, colormap default
%     imwrite(Nim, './results/normal_mb.jpg');
    I = mask.*phi_ball - pi*~mask;
    figure(5),imagesc(I), axis image, colormap default
%     m = I - min(I(:));
%     m = max(m(:));
%     imwrite(255*(I-min(I(:))) ./ m, cmap, './results/phi_mb.jpg');
    I = mask.*theta_ball;
    figure(6),imagesc(I), axis image, colormap default
%     m = I - min(I(:));
%     m = max(m(:));
%     imwrite( 255*(I-min(I(:))) ./ m, cmap, './results/theta_mb.jpg');
    
    % Reshape matrices
    phi_ball = reshape(phi_ball, rows*cols, 1);
    theta_ball = reshape(theta_ball, rows*cols, 1);
    mirrorball_hdr = reshape(repmat(mask, 1,1,3) .* mirrorball_hdr, rows*cols, 1, dim);
    
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
    figure(3),imagesc(maskcm), axis image, colormap gray
    
    % Normalize direction vector
    m = sqrt(X.*X + Y.*Y + Z.*Z);
    X = X ./ m;
    Y = Y ./ m;
    Z = Z ./ m;
    
    N = cat(4, X, Y, Z);
    Nim = reshape(N, size(X,1),size(X,2),3);
    figure(10),imagesc(Nim), axis image, colormap default
%     imwrite(Nim, './results/normal_cm.jpg');
   
    theta_cm = acos(Y); % Get the theta coord for this pixel
    phi_cm = atan2(Z, X); % Get the phi coord for this pixel
    phi_cm = phi_cm .* ~isnan(phi_cm); % Remove any NaN entries
    phi_cm = phi_cm+offset;
    phi_cm(phi_cm > pi) = phi_cm(phi_cm > pi) -2*pi;
    phi_cm(phi_cm < -pi) = phi_cm(phi_cm < -pi) +2*pi;
    phi_cm(phi_cm == 0) = pi;
    phi_cm(maskcm.*phi_cm == 0) = 2*pi;
    
    % Image display/write
    I = maskcm.*phi_cm;
    figure(7),imagesc(I), axis image, colormap default
%     m = I - min(I(:));
%     m = max(m(:));
%     imwrite(255*(I-min(I(:))) ./ m, cmap, './results/phi_cm.jpg');
    
    I = maskcm.*theta_cm + ~maskcm.*pi/2;
    figure(8),imagesc(I), axis image, colormap default
%     m = I - min(I(:));
%     m = max(m(:));
%     imwrite(255*(I-min(I(:))) ./ m, cmap, './results/theta_cm.jpg');
    
    cubemap = zeros(size(theta_cm));
    for i = 1:dim
        F = scatteredInterpolant(phi_ball, theta_ball, mirrorball_hdr(:,i));
        cubemap(:,:,i) = maskcm.*F(phi_cm, theta_cm);
    end
        
end
