%metropolis: XY 
% xy 
%parameter setting
function metropolis_1D

%晶格长度
n=4;
%温度
T=(0.1:0.1:10); 
beta=1./T;
%耦合常数
J2=1;
%弛豫步数
Thermal=10000;   
%采样敿
sampling=50000;  
%采样间隔
interval=1;    
%预分酿
m_sampling=zeros(1,sampling);
e_sampling=zeros(1,sampling);
m=zeros(1,length(T));
m2=zeros(1,length(T));
e=zeros(1,length(T));
cv=zeros(1,length(T));

%邻居结构
[nbor]=neighbor(n);
fid=fopen('metro_L4.txt','w')
for t=1:1:length(beta)
    fprintf('temperature is %f\n',T(t));
    [ising]=generate(n);%生成
    for j=1:Thermal%弛豫
        [ising]=flip_spin(ising,nbor,n,beta(t),J2);
    end
    for j=1:sampling%采样
        for kk=1:interval
            [ising]=flip_spin(ising,nbor,n,beta(t),J2); 
        end
        %sample
        m_sampling(j)=abs(sum(ising))/n;
        [e_sampling(j)]=calculate(ising,nbor,n,J2);
    end
    %average
    e(t)=mean(e_sampling);
    m(t)=mean(m_sampling);
    err_e(t)=std(e_sampling)/sqrt(length(m_sampling-1));
    err_m(t)=std(e_sampling)/sqrt(length(m_sampling-1));
fprintf(fid,'%f %f %f\n',T(t),m(t),err_m(t));
end
hold off
figure(1)
plot(T,e,'ro:'); xlabel('T'); ylabel('E');   hold on

figure(2)
plot(T,m,'ro');   xlabel('T'); ylabel('M');     hold on


%--------------------------------------------------------------------------
function [ising]=generate(n)
%ising=ones(n,1);
ising=ones(n,1) *2*pi*rand()-pi;

function [nbor]=neighbor(n)
nbor=zeros(n,2);
for ispin=1:n
    nbor(ispin,1)=ispin+1;%右邻屿
    nbor(ispin,2)=ispin-1;%左邻屿
    if ispin==1
        nbor(ispin,2)=n;  %左邻屿
    end
    if ispin==n
        nbor(ispin,1)=1;  %右邻屿
    end
end

function [ising]=flip_spin(ising,nbor,n,beta,J2)

cen=unidrnd(n);%当前

%deE=2 * J2 * ising(cen) * ( ising(nbor(cen,1)) + ising(nbor(cen,2)) ) ;
oldE= -cos(ising(cen)- ( ising(nbor(cen,1)))) -cos(ising(cen)- ( ising(nbor(cen,2))));
alpha = pi*rand();
newtheta= 2*alpha - ising(cen) ;
newE= -cos(newtheta- ( ising(nbor(cen,1)))) -cos(newtheta- ( ising(nbor(cen,2))));
deE= newE -oldE;
if rand<exp(-deE*beta)
    ising(cen)=newtheta;
end

function [energy]=calculate(ising,nbor,n,J2)
energy=0.0;

for i=1:n
    
    energy=energy - -cos(ising(i)- ( ising(nbor(i,1))));

end

energy=energy/(n);