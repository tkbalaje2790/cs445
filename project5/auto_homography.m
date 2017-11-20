function H=auto_homography(Ia,Ib,threshold)
% Computes a homography that maps points from Ia to Ib
%
% Input: Ia and Ib are images
% Output: H is the homography
%
% Note: to use H in maketform, use maketform('projective', H')

% Computes correspondences and matches
[fa,da] = vl_sift(im2single(rgb2gray(Ia))) ;
[fb,db] = vl_sift(im2single(rgb2gray(Ib))) ;
matches = vl_ubcmatch(da,db) ;

numMatches = size(matches,2) ;

% Xa and Xb are 3xN matrices that contain homogeneous coordinates for the N
% matching points for each image
Xa = fa(1:2,matches(1,:)) ; Xa(3,:) = 1 ;
Xb = fb(1:2,matches(2,:)) ; Xb(3,:) = 1 ;


%% RANSAC

niter = 10000;
best_score = 0;

for t = 1:niter
    % estimate homography
    subset = vl_colsubset(1:numMatches, 4) ;
    pts1 = Xa(:, subset);
    pts2 = Xb(:, subset);
    H_t = computeHomography(pts1, pts2); % edit helper code below
    
    % score homography
    Xb_ = H_t * Xa ; % project points from first image to second using H
    du = Xb_(1,:)./Xb_(3,:) - Xb(1,:)./Xb(3,:) ;
    dv = Xb_(2,:)./Xb_(3,:) - Xb(2,:)./Xb(3,:) ;
    ok_t = sqrt(du.*du + dv.*dv) < threshold;  % you may need to play with this threshold
    score_t = sum(ok_t) ;
    
    if score_t > best_score
        best_score = score_t;
        H = H_t;
    end
end

disp(num2str(best_score))

% Optionally, you may want to re-estimate H based on inliers


%%
function H = computeHomography(pts1, pts2)
% Compute homography that maps from pts1 to pts2 using least squares solver
% 
% Input: pts1 and pts2 are 3xN matrices for N points in homogeneous
% coordinates. 
%
% Output: H is a 3x3 matrix, such that pts2~=H*pts1

N = size(pts1,2);

%normalizing points
std1_u = std(pts1(1,:));
std1_v = std(pts1(2,:));
mean1_u = mean(pts1(1,:));
mean1_v = mean(pts1(2,:));
T1 = [1/std1_u 0 0; 0 1/std1_v 0; 0 0 1]*[1 0 -mean1_u; 0 1 -mean1_v; 0 0 1];
    
std2_u = std(pts2(1,:));
std2_v = std(pts2(2,:));
mean2_u = mean(pts2(1,:));
mean2_v = mean(pts2(2,:));
T2 = [1/std2_u 0 0; 0 1/std2_v 0; 0 0 1]*[1 0 -mean2_u; 0 1 -mean2_v; 0 0 1];

pts1_norm = zeros(size(pts1));
pts2_norm = zeros(size(pts2));

for i = 1:N
    pts1_norm(:,i) = T1*pts1(:,i);
    pts2_norm(:,i) = T2*pts2(:,i);
end

% A = zeros(2*N, 9);
% for i = 1:N
%     x = pts1_norm(:, i);
%     x_p = pts2_norm(:, i);
%     
%     u = x(1);
%     v = x(2);
%     u_p = x_p(1);
%     v_p = x_p(2);
%     
%     A(2*i-1, :) = [-u, -v, -1, 0, 0, 0, u*u_p, v*u_p, u_p];
%     A(2*i, :) = [0, 0, 0, -u, -v, -1, u*v_p, v*v_p, v_p];
% end

A = []; 
for i = 1:N
    A = cat(1, A, kron(pts1_norm(:,i)', vl_hat(pts2_norm(:,i)))) ; 
end

%compute H in normalized coordinates
[~, ~, V] = svd(A);
h = V(:, end);
H_n = reshape(h, [3, 3]);

%unnormalize
H = inv(T2)*H_n*T1;