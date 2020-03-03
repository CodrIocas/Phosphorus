function ave()
%
[ds,Ident] = xlsread('Earthchem_vol_P.xlsx','I2:X111265');

AGE=ds(:,1);
SiO2=ds(:,3);
MgO=ds(:,11);
P2O5=ds(:,15);

sampleN=length(AGE);

for i = 1:1:sampleN     % remove komatiites
    if  MgO(i) >= 17;
        P2O5(i)=nan;
    end
end

for i = 1:1:sampleN     % basaltic rocks
    if  SiO2(i) > 56 | SiO2(i) < 43;
        P2O5(i)=nan;
    end
end

for i = 1:1:sampleN    % remove very young rocks
    if AGE(i) <= 50;
        P2O5(i)=nan;
    end
end
%
OutlierH=quantile(P2O5(~isnan(P2O5)),0.975);   % remove outliers for the whole dataset
OutlierL=quantile(P2O5(~isnan(P2O5)),0.025);

for i = 1:1: sampleN;
    if P2O5(i)>OutlierH | P2O5(i)<OutlierL
        P2O5(i)=nan;
    end
end

% remove outliers for each 200 Myr-bin

low = 3400;       %
high = 3600;       % 
movestep = 200;
sampleN=length(AGE);

for j = 1:1:(low/movestep)   
    
    BinAB=[];
    
    for i = 1:1:sampleN
        if AGE(i) >= low & AGE(i) <= high
            BinAB(i)=P2O5(i);
        else
            BinAB(i)=nan;
        end
    end
    
    OutlierH=quantile(BinAB(~isnan(BinAB)),0.85);
    OutlierL=quantile(BinAB(~isnan(BinAB)),0.15);
    
    for i = 1:1: sampleN;   % use the 15th-85th percentile
        if BinAB(i)>OutlierH | BinAB(i)<OutlierL
            P2O5(i)=nan;
        end
    end
    
    low = low - movestep;
    high = high - movestep;
    
end

Clip_ds=dataset(Ident,AGE,P2O5);

Group_data = grpstats(Clip_ds,'Ident',{'mean'});    % Gridding

export(Group_data,'XLSFile','Group_data.xlsx');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T=xlsread('Group_data.xlsx');

AGE=T(:,2);
P2O5=T(:,3);
sampleN=length(AGE);

low = 3350;       % lower limit of window
high = 3650;       % upper limit of window
movestep = 50;

for j = 1:1:((low+high)/2/movestep+1)   
    
    Run=j
    dataAB=[];
    BinAB=[];
    AB_mean=0;
    AB_sigma=0;
    
    for i = 1:1:sampleN
        if AGE(i) >= low & AGE(i) <= high
            BinAB(i)=P2O5(i);
        else
            BinAB(i)=nan;
        end
    end
    %
    OutlierH=quantile(BinAB(~isnan(BinAB)),0.975);
    OutlierL=quantile(BinAB(~isnan(BinAB)),0.025);
    
    for i = 1:1: sampleN;   % remove the outliers
        if BinAB(i)>OutlierH | BinAB(i)<OutlierL
            P2O5(i)=nan;
        end
    end
        
    dataAB=BinAB(~isnan(BinAB));
    n(j)=length(dataAB);
    
    if n(j)>=4       % less than 4 samples will not be calculated.
        BSmean_AB = bootstrp(10000, @mean, dataAB);
    else
        BSmean_AB = [];
    end
    
    result(j,1)=(low+high)/2;    %age
    result(j,2)=mean(BSmean_AB);       %mean
    result(j,3)=2*std(BSmean_AB);      %standard errors
    result(j,4)=n(j);
    
    low = low - movestep;
    high = high - movestep;
    
end


figure(1)
errorbar(result(:,1),result(:,2),result(:,3));

csvwrite('BS_gird_P2O5.csv',result);

end

