function latlon = mirrorball2latlon( mirrorball_hdr )
%MIRRORBALL2LATLON Converts a mirrorball image to an equilateral projection
    offset1 = pi/2; % offset used later to center image
    offset2 = 0;
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
    phi_ball = phi_ball + offset1;
    phi_ball(phi_ball > pi) = phi_ball(phi_ball > pi) - 2*pi;
    phi_ball(phi_ball < -pi) = phi_ball(phi_ball < -pi) + 2*pi;
    
    % Reshape matrices
    phi_ball = reshape(phi_ball, rows*cols, 1);
    theta_ball = reshape(theta_ball, rows*cols, 1);
    mirrorball_hdr = reshape(mirrorball_hdr, rows*cols, 1, dim);
    
    [phis, thetas] = meshgrid([pi:-2*pi/719:-pi], 0:pi/359:pi);
    phis = phis + offset2;
    phis(phis > pi) = phis(phis > pi) - 2*pi;
    phis(phis < -pi) = phis(phis < -pi) + 2*pi;
%     I = thetas;
%     m = I - min(I(:));
%     m = max(m(:));
%     imwrite(255*(I-min(I(:))) ./ m, cmap, './results/theta_eq.jpg');
%     I = phis;
%     m = I - min(I(:));
%     m = max(m(:));
%     imwrite(255*(I-min(I(:))) ./ m, cmap, './results/phi_eq.jpg');
    
    latlon = zeros(size(thetas));
    for i = 1:dim
        F = scatteredInterpolant(phi_ball, theta_ball, mirrorball_hdr(:,i));
        latlon(:,:,i) = F(phis, thetas);
    end
        
end
