function [result] = loukuai_jianmofanwei(zuobiao,rl)%���վλ�ã����վ����
 




%% ���վλ�ã�����ҳ�ж�ȡ��

% zuobiao=strsplit(zuobiao1,',');
zuobiao=str2num(zuobiao);
zuobiao1=zuobiao;
 zuobiao=fliplr(reshape(zuobiao,2,[])');
%%���վλ�ã��˴����ĸ����ʾ�Ķ���Σ�
% zuobiao=[113.253,23.1321;113.253108200000,23.1325;113.253,23.1323869000000];
[xingzhuang,~]=size(zuobiao);
%�������վλ��
% scatter(zuobiao(:,1),zuobiao(:,2));
% patch(zuobiao(:,1),zuobiao(:,2),[0.2,0.5,0.7]);

%%Ѱ��һ����Χ�ڵĿ���վ,��Ϊ��ѡ����վ
%�������ݿ⣨�����ݿ��ж�ȡ������ǰʹ��csv��
sql='E:\OneDrive - zju.edu.cn\rht\������Ŀ��������\��������-����5-�㽭��ѧ\PW_BYQ.csv';
%��ѯ��Ŀ��,���б�ѹ������������
Range=('BY:BZ');
[zuobiao_byq]=read_csv(sql,Range);
zuobiao_byq=table2array(zuobiao_byq);
%��ѯ�����ڳ��վվַ��Χ�ĵ�(������0.0001��������0.001)
houxuan_jingdu=[];
for i=1:xingzhuang
    houxuan_jingdu=union(houxuan_jingdu,find(abs(zuobiao_byq(:,1)-zuobiao(i,1))<0.002));
end
houxuan_weidu=[];
for i=1:xingzhuang
    houxuan_weidu=union(houxuan_weidu,find(abs(zuobiao_byq(:,2)-zuobiao(i,2))<0.001));
end
%��ѡ����վ�ı��
houxuan=intersect(houxuan_jingdu,houxuan_weidu);
%��ѡ����վ��ɾ���
zuobiao_houxuan=zuobiao_byq(houxuan,:);

%������ѡ����վ��λ��
% hold on
% scatter(zuobiao_byq(:,1),zuobiao_byq(:,2));
% hold on
% scatter(zuobiao_houxuan(:,1),zuobiao_houxuan(:,2));

%��ģ��Χ�����к�ѡ��ķ�Χ����
neidian=[zuobiao;zuobiao_houxuan];
fanwei(1,1)=min(neidian(:,1))-0.0001;
fanwei(1,2)=max(neidian(:,2))+0.0005;
fanwei(2,1)=min(neidian(:,1))-0.0001;
fanwei(2,2)=min(neidian(:,2))-0.0005;
fanwei(4,1)=max(neidian(:,1))+0.0001;
fanwei(4,2)=max(neidian(:,2))+0.0005;
fanwei(3,1)=max(neidian(:,1))+0.0001;
fanwei(3,2)=min(neidian(:,2))-0.0005;
% patch(fanwei(:,1),fanwei(:,2),[0.2,0.5,0.7]);
% hold on
% scatter(neidian(:,1),neidian(:,2));
%% ת��GIS����
result=[];
for i=1:4
        result=[result,'('];
        result=[result,num2str(fanwei(i,1))];
        result=[result,','];
        result=[result,num2str(fanwei(i,2))];
        result=[result,')'];
       result=[result,';'];
end
%������վλ�ã�����������
%������վ����������
%�����ѡ��λ�����ŵ�����
%�����ѡ��Χ������
mkdir C:/test
save('C:/test/zuobiao.mat', 'zuobiao1')
save('C:/test/rongliang.mat', 'rl')
save('C:/test/houxuan.mat', 'houxuan') %�����ţ����ܺ���Ҫ����ID
save('C:/test/fanwei.mat', 'fanwei')
end

function[table]=read_csv(SQL,Range)

% ��������
table = readtable(SQL,'Range',Range);

% �����ʱ����
clear opts

end
