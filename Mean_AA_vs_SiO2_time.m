function secular()

Step = 'Reading the data...'

T = xlsread('Earthchem_vol_P.xlsx','J2:Z111265');

AGE=T(:,1);
SiO2=T(:,3);
Element=T(:,15);
sampleN=length(SiO2);

OutlierH=quantile(Element,0.9975);
OutlierL=quantile(Element,0.0025);

for i = 1:1: sampleN;   % remove the outliers
    if Element(i)>OutlierH | Element(i)<OutlierL
        Element(i)=nan;
    end
end

X1= 75;
X2 = 77;
movestep = 33;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AA=Element;

low = X1;
high = X2;

for i = 1:1: sampleN;
    if AGE(i)>=0 & AGE(i)<=541         % Phanerozoic
        AA(i)=AA(i);
    else
        AA(i)=nan;
    end
end

nA=[];

for j = 1:1:movestep
    
    Step = j
    dataAA=[];
    BinAA=[];
    BSmean_AA=[];
    
    for i = 1:1:sampleN   %constrain value in specific SiO2 range.
        
        if SiO2(i) >= low & SiO2(i) <= high
            BinAA(i)=AA(i);
        else
            BinAA(i)=nan;
        end
    end
    
    OutlierH=quantile(BinAA(~isnan(BinAA)),0.95);
    OutlierL=quantile(BinAA(~isnan(BinAA)),0.05);
    
    for i = 1:1: sampleN;   % remove the outliers
        if BinAA(i)>OutlierH | BinAA(i)<OutlierL
            BinAA(i)=nan;
            SiO2(i)=nan;
        end
    end
    
    dataAA=BinAA(~isnan(BinAA));
    nA(j)=length(dataAA);
    
    % Bootstrap estimation for mean and standard error
    
    BSmean_AA = bootstrp(5000, @mean, dataAA);
    
    result1(j,1)=(low+high)/2;    %age
    result1(j,2)=mean(BSmean_AA);       %mean
    result1(j,3)=2*std(BSmean_AA);      %standard error
    result1(j,4)=nA(j);
    
    low = low-1;      %define the bin size (step width)
    high = high-1;    %define the bin size (step width)
    
end

figure(1)
eb1=errorbar(result1(:,1),result1(:,2),result1(:,3));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AA=Element;

low = X1;
high = X2;

for i = 1:1: sampleN;
    if AGE(i)>=800 & AGE(i)<=2000         % Proterozoic
        AA(i)=AA(i);
    else
        AA(i)=nan;
    end
end

nA=[];

for j = 1:1:movestep
    
    Step = j
    dataAA=[];
    BinAA=[];
    BSmean_AA=[];
    
    for i = 1:1:sampleN
        
        if SiO2(i) >= low & SiO2(i) <= high
            BinAA(i)=AA(i);
        else
            BinAA(i)=nan;
        end
    end
    
    OutlierH=quantile(BinAA(~isnan(BinAA)),0.95);
    OutlierL=quantile(BinAA(~isnan(BinAA)),0.05);
    
    for i = 1:1: sampleN;   % remove the outliers
        if BinAA(i)>OutlierH | BinAA(i)<OutlierL
            BinAA(i)=nan;
            SiO2(i)=nan;
        end
    end
    
    dataAA=BinAA(~isnan(BinAA));
    nA(j)=length(dataAA);
    
    % Bootstrap estimation for mean and standard error
    
    BSmean_AA = bootstrp(5000, @mean, dataAA);
    
    result2(j,1)=(low+high)/2;    %age
    result2(j,2)=mean(BSmean_AA);       %mean
    result2(j,3)=2*std(BSmean_AA);      %standard error
    result2(j,4)=nA(j);
    
    low = low-1;      %define the bin size (step width)
    high = high-1;    %define the bin size (step width)
    
end

figure(2)
eb2=errorbar(result2(:,1),result2(:,2),result2(:,3));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AA=Element;

low = X1;
high = X2;

for i = 1:1: sampleN;
    if AGE(i)>=2450 & AGE(i)<=4000         % Archean
        AA(i)=AA(i);
    else
        AA(i)=nan;
    end
end

nA=[];

for j = 1:1:movestep
    
    Step = j
    dataAA=[];
    BinAA=[];
    BSmean_AA=[];
    
    for i = 1:1:sampleN
        
        if SiO2(i) >= low & SiO2(i) <= high
            BinAA(i)=AA(i);
        else
            BinAA(i)=nan;
        end
    end
    
    OutlierH=quantile(BinAA(~isnan(BinAA)),0.95);
    OutlierL=quantile(BinAA(~isnan(BinAA)),0.05);
    
    for i = 1:1: sampleN;   % remove the outliers
        if BinAA(i)>OutlierH | BinAA(i)<OutlierL
            BinAA(i)=nan;
            SiO2(i)=nan;
        end
    end
    
    dataAA=BinAA(~isnan(BinAA));
    nA(j)=length(dataAA);
    
    % Bootstrap estimation for mean and standard error
    
    BSmean_AA = bootstrp(5000, @mean, dataAA);
    
    result3(j,1)=(low+high)/2;    %age
    result3(j,2)=mean(BSmean_AA);       %mean
    result3(j,3)=2*std(BSmean_AA);      %standard error
    result3(j,4)=nA(j);
    
    low = low-1;      %define the bin size (step width)
    high = high-1;    %define the bin size (step width)
    
end

figure(3)
eb3=errorbar(result3(:,1),result3(:,2),result3(:,3));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


result=[result1,result2,result3];

csvwrite('Mean_P2O5_vs_SiO2_all.csv',result);

end

