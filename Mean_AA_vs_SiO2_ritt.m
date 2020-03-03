function ave()

Step = 'Reading the data...'

T = xlsread('Earthchem_vol_P.xlsx','J2:Z111265');

AGE=T(:,1);
SiO2=T(:,3);
MgO=T(:,11);
Element=T(:,15);
Ritt=T(:,17);
sampleN=length(SiO2);

OutlierH=quantile(Element,0.9995);
OutlierL=quantile(Element,0.0005);

for i = 1:1: sampleN;   % remove the outliers
    if Element(i)>OutlierH | Element(i)<OutlierL
        Element(i)=nan;
    end
end

X1= 43;
X2 = 45;
step = 2;

for Alkali=1:1:6;
    a=[1 2 3 4 5 6 7];
    
    AA = Element;
    low = X1;
    high = X2;
    sampleN=length(AGE);
    
    for i = 1:1:sampleN   %constrain value in specific lithology.
        
        if Ritt(i) >= a(Alkali) & Ritt(i) <= a(Alkali+1);                   %confine the rock type
            AA(i)=AA(i);
        else
            AA(i)=nan;
        end
    end
    
    OutlierH=quantile(AA(~isnan(AA)),0.975);
    OutlierL=quantile(AA(~isnan(AA)),0.025);
    
    for i = 1:1: sampleN;   % remove the very high or very low value
        if AA(i)>OutlierH | AA(i)<OutlierL
            AA(i)=nan;
        end
    end
    
    n=[];
    
    for j = 1:1:20
        
        dataAA=[];
        BinAA=[];
        AA_mean=0;
        AA_sigma=0;
        
        for i = 1:1:sampleN   %constrain value in specific age range.
            
            if SiO2(i) >= low & SiO2(i) <= high
                BinAA(i)=AA(i);
            else
                BinAA(i)=nan;
            end
        end
        
        dataAA=BinAA(~isnan(BinAA));
        AA_mean=mean(dataAA);
        AA_sigma=std(dataAA);
        n(j)=length(dataAA);
        dataAA=[];
         
        result(j,1)=(low+high)/2;    %age
        result(j,2)=AA_mean;       %mean
        result(j,3)=2*AA_sigma/sqrt(n(j));      %standard error
        result(j,4)=n(j);
        
        low = low+step;
        high = high+step;
        
    end
    
%     figure(Alkali)
%     errorbar(result(:,1),result(:,2),result(:,3));    
    output(:,:,Alkali)=result(:,:);
    
end

csvwrite('Mean_ritt_1.5.csv',output(:,:,1));
csvwrite('Mean_ritt_2.5.csv',output(:,:,2));
csvwrite('Mean_ritt_3.5.csv',output(:,:,3));
csvwrite('Mean_ritt_4.5.csv',output(:,:,4));
csvwrite('Mean_ritt_5.5.csv',output(:,:,5));
csvwrite('Mean_ritt_6.5.csv',output(:,:,6));

end

