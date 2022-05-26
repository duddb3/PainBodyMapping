function Pain = ProcessPainMap(img)
    % Read in images
    fprintf('Reading in images...')
    I = imread(img);
    T = imread('Template_Fixed.png');
    T = T(:,:,1);
    fprintf('done\n')
    
    % Get mask for body area
    body = imfill(T<128,'holes');
    body = bwpropfilt(body,'perimeter',2);


    % Crop off top 3 inches
    I(1:900,:,:) = [];
    % Crop off bottom inch
    I(end-299:end,:,:) = [];
    % Crop off 2/3 inch from left
    I(:,1:200,:) = [];
    % Crop off 2/3 inch from right
    I(:,end-199:end,:) = [];


    % Get pain areas
    red = ((I(:,:,1)+1)./(I(:,:,2)+1))>1;


    % Remove from red channel to get outline for registration
    Ik = I(:,:,1);
    Ik(red) = 255;
    fprintf('Registering to template...')
    [opt,met] = imregconfig('multimodal');
    tform = imregtform(Ik,T,'similarity',opt,met);
    fprintf('done\n')

    % Transform pain areas to template space
    Pain = imwarp(red,tform,'OutputView',imref2d(size(T)),'FillValue',0);
    % Fill in and smooth pain areas
    Pain = imfill(Pain,'holes');
    Pain = imgaussfilt(double(Pain),15);
    % Remove pain areas not on template body
    Pain(body==0) = 0;
    save(strrep(img,'.png','.mat'),'Pain')

    cmap = colormap(hot(256));
%     cmap = ones(256,3);
%     cmap(:,2:3) = repmat(linspace(1,0,256)',1,2);
    Pain_rgb = ind2rgb(gray2ind(Pain,size(cmap,1)),cmap);
    imshow(T),hold on
    h = imshow(Pain_rgb);
    hold off
    alpha = 0.5;
    set(h,'AlphaData',alpha)
    imwrite(frame2im(getframe(gca)),strrep(img,'.png','_Realigned.png'))
    close(gcf)

end
