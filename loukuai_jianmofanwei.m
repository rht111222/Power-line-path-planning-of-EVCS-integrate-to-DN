function [result] = loukuai_jianmofanwei(zuobiao,rl)%充电站位置，充电站容量
 




%% 充电站位置（从网页中读取）

% zuobiao=strsplit(zuobiao1,',');
zuobiao=str2num(zuobiao);
zuobiao1=zuobiao;
 zuobiao=fliplr(reshape(zuobiao,2,[])');
%%充电站位置（此处用四个点表示的多边形）
% zuobiao=[113.253,23.1321;113.253108200000,23.1325;113.253,23.1323869000000];
[xingzhuang,~]=size(zuobiao);
%画出充电站位置
% scatter(zuobiao(:,1),zuobiao(:,2));
% patch(zuobiao(:,1),zuobiao(:,2),[0.2,0.5,0.7]);

%%寻找一定范围内的开关站,作为候选开关站
%给定数据库（从数据库中读取）（当前使用csv）
sql='E:\OneDrive - zju.edu.cn\rht\广州项目数据中心\数据需求单-课题5-浙江大学\PW_BYQ.csv';
%查询的目标,所有变压器的两个坐标
Range=('BY:BZ');
[zuobiao_byq]=read_csv(sql,Range);
zuobiao_byq=table2array(zuobiao_byq);
%查询所有在充电站站址周围的点(横坐标0.0001，纵坐标0.001)
houxuan_jingdu=[];
for i=1:xingzhuang
    houxuan_jingdu=union(houxuan_jingdu,find(abs(zuobiao_byq(:,1)-zuobiao(i,1))<0.002));
end
houxuan_weidu=[];
for i=1:xingzhuang
    houxuan_weidu=union(houxuan_weidu,find(abs(zuobiao_byq(:,2)-zuobiao(i,2))<0.001));
end
%候选开关站的编号
houxuan=intersect(houxuan_jingdu,houxuan_weidu);
%候选开关站组成矩阵
zuobiao_houxuan=zuobiao_byq(houxuan,:);

%画出候选开关站的位置
% hold on
% scatter(zuobiao_byq(:,1),zuobiao_byq(:,2));
% hold on
% scatter(zuobiao_houxuan(:,1),zuobiao_houxuan(:,2));

%建模范围比所有候选点的范围更大
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
%% 转成GIS坐标
result=[];
for i=1:4
        result=[result,'('];
        result=[result,num2str(fanwei(i,1))];
        result=[result,','];
        result=[result,num2str(fanwei(i,2))];
        result=[result,')'];
       result=[result,';'];
end
%储存充电站位置，容量到本地
%储存充电站容量到本地
%储存候选点位置与编号到本地
%储存框选范围到本地
mkdir C:/test
save('C:/test/zuobiao.mat', 'zuobiao1')
save('C:/test/rongliang.mat', 'rl')
save('C:/test/houxuan.mat', 'houxuan') %储存编号，可能后期要储存ID
save('C:/test/fanwei.mat', 'fanwei')
end

function[table]=read_csv(SQL,Range)

% 导入数据
table = readtable(SQL,'Range',Range);

% 清除临时变量
clear opts

end
