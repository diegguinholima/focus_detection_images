pkg load signal;
pkg load image;



function out = sample_mean(samples)

	total = 0;

	for s = samples
		total = total + cell2mat(s);
	end

	out = total / size(samples, 2);

endfunction

function out = sd(samples)

	mean = sample_mean(samples);
	dev2 = 0;

	for s = samples
		dev2 = dev2 + (cell2mat(s) - mean) * (cell2mat(s) - mean);
	end

	dev2 = dev2 / size(samples, 2);
	dev = sqrt(dev2);

	out = dev;

endfunction


function out = isRGB(img)
	[w h c] = size(img);

	if c == 1
		out = false;
	else
		out = true;
	end

endfunction

function score = focus_c_2(img)

	h = -ones(8, 8);
	h(3:6, 3:6) = 3;

	c = sum( sum( img.^2, 1), 2) / 2;

	img_conv = uint8(conv2(h, img));

	x = sum( sum( img_conv.^2, 1), 2);

	f = (x^2) / ( x^2 + (c/2)^2 );

	score = f * 100;

endfunction

function score = focus_c(img)

	h = -ones(8, 8);
	h(3:6, 3:6) = 3;

	c = sum( sum( img.^2, 1), 2) / 2;

	img_conv = uint8(conv2(h, img));

	x = sum( sum( img_conv.^2, 1), 2);

	f = (x^2) / ( x^2 + c^2 );

	score = f * 100;

endfunction

function score = focus_fullpower(img)

	h = -ones(8, 8);
	h(3:6, 3:6) = 3;

	full_power = sum( sum( img.^2, 1), 2);

	img_conv = uint8(conv2(h, img));

	x = sum( sum( img_conv.^2, 1), 2);

	f = x/full_power;

	score = f * 100;

endfunction

function score = focus_new_mask(img)

	h = -ones(5, 5);
	h(2:4, 2:4) = 2;
	h(3, 3) = 0;

	full_power = sum( sum( img.^2, 1), 2);

	img_conv = uint8(conv2(h, img));

	x = sum( sum( img_conv.^2, 1), 2);

	f = x/full_power;

	score = f * 100;

endfunction

arg_list = argv ();
alg = str2num(arg_list{1});
n_images = str2num(arg_list{2});

good_f = {};
bad_f = {};

x = 1;

while x <= n_images
	filename = strcat('focused/', 'img', num2str(x), '.jpg');

	I1 = imread(filename);

	if isRGB(I1)
		I1 = rgb2gray(I1);
		I1 =  I1;
	end

	if alg == 1
		f1 = focus_c_2(I1);
	elseif alg == 2
		f1 = focus_c(I1);
	elseif alg == 3
		f1 = focus_fullpower(I1);
	else
		f1 = focus_new_mask(I1);
	end

	good_f{x} = f1;

	goodNorm(x)=good_f{x};

	I2 = imsmooth(I1, 'Gaussian', 5);

	if alg == 1
		f2 = focus_c_2(I2);
	elseif alg == 2
		f2 = focus_c(I2);
	elseif alg == 3
		f2 = focus_fullpower(I2);
	else
		f2 = focus_new_mask(I2);
	end

	bad_f{x} = f2;

	badNorm(x)=bad_f{x};

	x++;
end

disp(n_images);

% x = 1;
%while x <= n_images
%	disp(good_f{x});
%	x++;
%end

%x = 1;
%while x <= n_images
%	disp(bad_f{x});
%	x++;
%end

%disp('========');
%good_f
mediaboa = mean(goodNorm);
%mediaboa
desviobom = std(goodNorm);
%desviobom

% bad_f
mediaruim = mean(badNorm);
%mediaruim
desvioruim = std(badNorm);
%desvioruim

%disp('MEDIA ZERO BOM');

x = 1;
while x <= n_images
	medVarGood(x) = (goodNorm(x)-mediaboa)/desviobom;
	disp(medVarGood(x));
	x++;
end

%mediaboa = mean(medVarGood);
%mediaboa
%desviobom = std(medVarGood);
%desviobom

%disp('========');

%disp('MEDIA ZERO RUIM');

x = 1;
while x <= n_images
	medVarBad(x) = (badNorm(x)-mediaruim)/desvioruim;
	disp(medVarBad(x));
	x++;
end

%mediaruim = mean(medVarBad);
%mediaruim
%desvioruim = std(medVarBad);
%desvioruim
