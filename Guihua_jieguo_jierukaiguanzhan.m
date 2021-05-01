function display = Guihua_jieguo_jierukaiguanzhan()
         load( 'C:\test1\zuobiao.mat','zuobiao1' )
         zuobiao = fliplr( reshape( zuobiao1, 2, [  ] )' );
         zuobiao_zhongxin = mean( zuobiao, 1 );
         zuobiao = [ zuobiao; zuobiao_zhongxin ];
         zuizhe = 15;
         load( 'C:\test1\rongliang.mat','rl'  )
         rongliang = rl;
         load( 'C:\test1\houxuan.mat','houxuan'  )
         num_houxuan = houxuan;
         sql = 'C:\test1\PW_BYQ.csv' ;
         Range = ('BY:BZ');
         Range1 = ('BV:BV');
         [zuobiao_byq] = read_csv( sql, Range );
         zuobiao_byq = table2array( zuobiao_byq );
         houxuan = zuobiao_byq( houxuan, : );
         [rongliang_byq] = read_csv( sql, Range1 );
         rongliang_byq = table2array( rongliang_byq );
         houxuan_rongliang = rongliang_byq( num_houxuan, : );
         houxuan_rongliang = houxuan_rongliang / 10;
         load( 'C:\test1\fanwei.mat','fanwei' )
         weifig = double( rgb2gray( imread( 'C:\test1\map.png' ) ) );
         size_weifig = size( weifig );
         n = 1;
         for i = 1:size_weifig( 1 )
             for j = 1:size_weifig( 2 )
                 if weifig( i, j )>100 && weifig( i, j )<200
                     zhangai_heng( n, 1 ) = j;
                     zhangai_zong( n, 1 ) = size_weifig( 1 ) - i + 1;
                     n = n + 1;
                 end
             end
         end
         zhangai = [ zhangai_heng, zhangai_zong ];
         huanyuan = 255 * ones( size_weifig( 1 ), size_weifig( 2 ) );
         for i = 1:length( zhangai )
             huanyuan( (zhangai_zong( i )), zhangai_heng( i ) ) = 100;
         end
         area = [ 0, size_weifig( 2 ); 0, size_weifig( 1 ) ];
         [I,~] = size( houxuan );
         wei_houxuan = [  ];
         for i = 1:I
             wei_houxuan( i, : ) = map2wei( fanwei, houxuan( i, : ), size_weifig );
         end
         [J,~] = size( zuobiao );
         wei_zuobiao = [  ];
         for j = 1:J
             wei_zuobiao( j, : ) = map2wei( fanwei, zuobiao( j, : ), size_weifig );
         end
         i = 1;
         while i<=length( wei_zuobiao( :, 1 ) )
             if ~(checkpoint( wei_zuobiao( i, : ), huanyuan ))
                 wei_zuobiao( i, : ) = [  ];
             else
                 i = i + 1;
             end
         end
         fanwei1( 1, 1 ) = max( wei_zuobiao( :, 1 ) );
         fanwei1( 1, 2 ) = max( wei_zuobiao( :, 2 ) );
         fanwei1( 2, 1 ) = min( wei_zuobiao( :, 1 ) );
         fanwei1( 2, 2 ) = min( wei_zuobiao( :, 2 ) );
         while (length( wei_zuobiao )==0)
             randzuobiao( 1, 1 ) = fanwei1( 2, 1 ) + rand( 1 ) * (fanwei1( 1, 1 ) - fanwei1( 2, 1 ));
             randzuobiao( 1, 2 ) = fanwei1( 2, 2 ) + rand( 1 ) * (fanwei1( 1, 2 ) - fanwei1( 2, 2 ));
             if (checkpoint( randzuobiao, huanyuan ))
                 wei_zuobiao = randzuobiao;
             end
         end
         [num_zuobiao,~] = size( wei_zuobiao );
         [num_houxuan,~] = size( houxuan );
         goalPoint = zeros( zuizhe, 2, num_zuobiao, num_houxuan );
         for i = 1:length( wei_houxuan( :, 1 ) )
             for j = 1:length( wei_zuobiao( :, 1 ) )
%          for i = 1:1
%              for j = 1:1
                 obstacleR = 0.5;
                 [goalPoint1,jbzy1,get_in1] = rengongshichang( area, wei_zuobiao( j, : ), wei_houxuan( i, : ), zhangai );
                 if jbzy1==0
                     [sumDistance( j, i ),zzgoalPoint] = optimization_road( goalPoint1, obstacleR, zhangai, huanyuan );
                     num_zx( j, i ) = length( zzgoalPoint( :, 1 ) );
                     goalPoint( 1:num_zx( j, i ), :, j, i ) = zzgoalPoint;
                 else
                     [goalPoint2,jbzy2,get_in2] = rengongshichang( area, wei_houxuan( i, : ), wei_zuobiao( j, : ), zhangai );
                     ch = 0;
                     for ifi = 1:length( goalPoint1( :, 1 ) )
                         for ifj = 1:length( goalPoint2( :, 1 ) )
                             if (norm( goalPoint1( ifi, : ) - goalPoint2( ifj, : ) )<obstacleR)
                                 ch = 1;
                             end
                         end
                     end
                     if ch==1||jbzy2==0
                         [sumDistance( j, i ),zzgoalPoint] = optimization_road( [ goalPoint1; flipud( goalPoint2 ) ], obstacleR, zhangai, huanyuan );
                         num_zx( j, i ) = length( zzgoalPoint( :, 1 ) );
                         goalPoint( 1:num_zx( j, i ), :, j, i ) = zzgoalPoint;
                     else
                         goalPoint3 = RRT( huanyuan, get_in1( end, : ), get_in2( end, : ) );
                         [sumDistance( j, i ),zzgoalPoint] = optimization_road( [ goalPoint1; flipud( goalPoint3 ); flipud( goalPoint2 ) ], obstacleR, zhangai, huanyuan );
                         num_zx( j, i ) = length( zzgoalPoint( :, 1 ) );
                         goalPoint( 1:num_zx( j, i ), :, j, i ) = zzgoalPoint;
                     end
                 end
             end
         end
         [minsumDistance,minindex] = min( sumDistance, [  ], 1 );
         [mminsumDistance,mminindex] = sort( minsumDistance );
         yjr = 0;
         jr = 0;
         while (yjr<rongliang)
             jr = jr + 1;
             yjr = yjr + houxuan_rongliang( mminindex( jr ) );
             index_jieru( jr ) = mminindex( jr );
             jieru_num_point( jr ) = num_zx( minindex( mminindex( jr ) ), mminindex( jr ) );
             jieru_point( 1:jieru_num_point( jr ), :, jr ) = goalPoint( 1:num_zx( minindex( mminindex( jr ) ), mminindex( jr ) ), :, minindex( mminindex( jr ) ), mminindex( jr ) );
             jieru_rl( jr ) = houxuan_rongliang( mminindex( jr ) );
         end
         display = [  ];
         for i = 1:jr
             for j = 1:jieru_num_point( i )
                 display_s = wei2map( fanwei, jieru_point( j, :, i ), size_weifig );
                 display = [ display, '(' ];
                 display = [ display, num2str( display_s( 1 ) ) ];
                 display = [ display, ',' ];
                 display = [ display, num2str( display_s( 2 ) ) ];
                 display = [ display, ')' ];
             end
             display = [ display, ';' ];
         end
         for i=1:jr
             display=[display,jieru_rl(jr)];
             display=[display,num2str(jieru_rl(jr))];
             display=[display,','];
         end
end
         function table = read_csv(SQL,Range)
             table = readtable( SQL, 'Range', Range );
             clear opts
         end
         function wei = map2wei(fanwei,map,size)
             heng = round( size( 2 ) * (map( 1 ) - min( fanwei( :, 1 ) )) / (max( fanwei( :, 1 ) ) - min( fanwei( :, 1 ) )) );
             zong = round( size( 1 ) * (map( 2 ) - min( fanwei( :, 2 ) )) / (max( fanwei( :, 2 ) ) - min( fanwei( :, 2 ) )) );
             wei = [ heng, zong ];
         end
         function map = wei2map(fanwei,wei,size)
             heng = wei( 1 ) * (max( fanwei( :, 1 ) ) - min( fanwei( :, 1 ) )) / size( 2 ) + min( fanwei( :, 1 ) );
             zong = wei( 2 ) * (max( fanwei( :, 2 ) ) - min( fanwei( :, 2 ) )) / size( 1 ) + min( fanwei( :, 2 ) );
             map = [ heng, zong ];
         end
         function checkout = checkpoint(point,map)
             checkout = true;
             if ~(point( 1 )>=1 && point( 1 )<=size( map, 2 ) && point( 2 )>=1 && point( 2 )<=size( map, 1 ) && map( point( 2 ), point( 1 ) )==255)
                 checkout = false;
             end
         end
         function [goalPoint,jbzy,get_in] = rengongshichang(area,startPoint,finalPoint,obstaclePoint)
             Katt = 10;
             Krep = 5;
             obstacleR1 = 0.5;
             influenceDistance = 5;
             stepSize = 1;
             purposeDistance = stepSize;
             counter = 1000;
             obstacleNum = size( obstaclePoint, 1 );
             currentPoint = startPoint;
             goalPoint( 1, : ) = currentPoint;
             constT = 10;
             a = 0.99;
             IfTrappedcounter = 0;
             IfTrappedcounterWhile = 0;
             IfTrappedcounterWhile2 = 0;
             IfTrappedcounterWhile3 = 0;
             f_step = [ 1, 1 ];
             f_step_num = [  ];
             get_in = [  ];
             get_in_num = [  ];
             sf = [ 1, 1 ];
             jl = [  ];
             jbzy = 0;
             jj = 1;
             while (jj<counter)
                 if jj==15
                     m = 1;
                 end
                 angle = compute_angle( currentPoint, finalPoint, obstaclePoint, obstacleNum );
                 angleGoal = angle( 1 );
                 [Fattx,Fatty] = compute_Attract( currentPoint, finalPoint, Katt, angleGoal, influenceDistance );
                 [Frepx,Frepy] = compute_repulsion( currentPoint, obstaclePoint, Krep, angle, obstacleNum, influenceDistance );
                 Fsumx = Fattx + Frepx;
                 Fsumy = Fatty + Frepy;
                 angleNextStep = atan2( Fsumy, Fsumx );
                 if (jj>2)
                     ifTrapped( jj ) = norm( goalPoint( jj, : ) - goalPoint( jj - 2, : ) );
                 end
                 if (((jj>2) && (ifTrapped( jj )<0.05)) || ((Fsumx==0) && (Fsumy==0)))
                     T = constT;
                     IfTrappedcounter = IfTrappedcounter + 1;
                     jTrapped = jj;
                     get_in = [ get_in; goalPoint( jTrapped, : ) ];
                     [a,~] = size( get_in );
                     if a>1
                         for iiii = 1:a - 1
                             jl( iiii ) = norm( get_in( iiii, : ) - goalPoint( jTrapped, : ) );
                         end
                         ngd = find( jl==min( jl ) );
                         if min( jl )<=1
                             get_in_num( ngd ) = get_in_num( ngd ) + 1;
                             get_in = get_in( 1:a - 1, : );
                         else
                             get_in_num( a ) = 1;
                         end
                     else
                         get_in_num( 1 ) = 1;
                     end
                     if a>1
                         bdx = abs( Fatty ) / (abs( Fatty ) + abs( Fattx ));
                         bdy = abs( Fattx ) / (abs( Fatty ) + abs( Fattx ));
                         bd = find( [ abs( Fattx ), abs( Fatty ) ]==min( abs( Fattx ), abs( Fatty ) ) );
                         why = bd( 1 );
                         if get_in_num( ngd )>=3
                             sf = 5 .* [ 2, 2 ];
                             sf( 1 ) = sf( 1 ) * (1 + get_in_num( ngd ) / 5) * max( 0.5, bdx );
                             sf( 2 ) = sf( 2 ) * (1 + get_in_num( ngd ) / 5) * max( 0.5, bdy );
                             f_step = 5 .* [ 1, 1 ];
                             f_step( 1 ) = f_step( 1 ) * (1 + get_in_num( ngd ) / 5) * max( 0.5, bdx );
                             f_step( 2 ) = f_step( 2 ) * (1 + get_in_num( ngd ) / 5) * max( 0.5, bdy );
                         else
                             sf = 5 .* [ 2, 2 ];
                             f_step = 5 .* [ 1, 1 ];
                         end
                     end
                     num_th = 0;
                     while (1)
                         num_th = num_th + 1;
                         if num_th>80
                             jbzy = 1;
                             break
                         end
                         ifObtained = 0;
                         ifCollided = 0;
                         IfTrappedcounterWhile = IfTrappedcounterWhile + 1;
                         randomAngle = 2 * pi * rand( 1 );
                         randomPoint( 1 ) = currentPoint( 1 ) + f_step( 1 ) * stepSize * cos( randomAngle );
                         randomPoint( 2 ) = currentPoint( 2 ) + f_step( 2 ) * stepSize * sin( randomAngle );
                         for ii = 1:obstacleNum
                             randomObstacle = norm( randomPoint - obstaclePoint( ii, : ) );
                             if (randomObstacle<=obstacleR1 + f_step * stepSize)
                                 ifCollided = 1;
                                 break
                             end
                         end
                         if (ifCollided==1)
                             IfTrappedcounterWhile = IfTrappedcounterWhile - 1;
                             continue
                         end
                         Uattbefore = compute_attField( currentPoint, finalPoint, Katt, influenceDistance );
                         Urepbefore = compute_repField( currentPoint, obstaclePoint, Krep, obstacleNum, influenceDistance );
                         Uattrandom = compute_attField( randomPoint, finalPoint, Katt, influenceDistance );
                         Ureprandom = compute_repField( randomPoint, obstaclePoint, Krep, obstacleNum, influenceDistance );
                         Ubefore = Urepbefore;
                         Urandom = Ureprandom;
                         Udeerta( IfTrappedcounterWhile ) = Urandom - Ubefore;
                         if (Udeerta( IfTrappedcounterWhile )<=0)
                             IfTrappedcounterWhile2 = IfTrappedcounterWhile2 + 1;
                             nextPoint = randomPoint;
                             ifObtained = 1;
                         else
                             IfTrappedcounterWhile3 = IfTrappedcounterWhile3 + 1;
                             T = T * a;
                             p( IfTrappedcounter ) = exp( -Udeerta( IfTrappedcounterWhile ) / T );
                             randomP( IfTrappedcounter ) = rand( 1 );
                             if (p( IfTrappedcounter )>randomP( IfTrappedcounter ))
                                 nextPoint = randomPoint;
                                 ifObtained = 1;
                             end
                         end
                         if (ifObtained==1)
                             jj = jj + 1;
                             currentPoint = nextPoint;
                             goalPoint( jj, : ) = currentPoint;
                         end
                         runDistance = goalPoint( jj, : ) - goalPoint( jTrapped, : );
                         if ((abs( runDistance( 1 ) )>(stepSize * sf( 1 ))) && (abs( runDistance( 2 ) )>(stepSize * sf( 2 ))))
                             break
                         end
                     end
                 else
                     nextPoint( 1 ) = currentPoint( 1 ) + stepSize * cos( angleNextStep );
                     nextPoint( 2 ) = currentPoint( 2 ) + stepSize * sin( angleNextStep );
                     currentPoint = nextPoint;
                     jj = jj + 1;
                     goalPoint( jj, : ) = currentPoint;
                 end
                 nextGoal( jj ) = norm( currentPoint - finalPoint );
                 if (nextGoal( jj )<purposeDistance)
                     jbzy = 0;
                     break
                 end
                 if jbzy==1
                     break
                 end
                 if jj==1000
                     jbzy = 1;
                     break
                 end
             end
         end
         function [sumDistance,goalPoint2] = optimization_road(goalPoint,obstacleR,obstaclePoint,huanyuan)
             ii = 1;
             i2 = 1;
             jj = length( goalPoint( :, 1 ) );
             obstacleNum = length( obstaclePoint( :, 1 ) );
             iTest = 2;
             goalPoint2( i2, : ) = goalPoint( ii, : );
             DisToObstacle = 2 * obstacleR;
             while ii<=jj
                 iTest = ii + 1;
                 line( 1, : ) = goalPoint( ii, : );
                 if (iTest>=jj)
                     if (iTest>jj)
                         break
                     else
                         goalPoint2( i2 + 1, : ) = goalPoint( jj, : );
                     end
                 end
                 fhyq = [  ];
                 for iiTest = ii + 1:jj
                     if iiTest==592 && ii==590
                         aaa = 1;
                     end
                     line( 2, : ) = goalPoint( iiTest, : );
                     checkLine = collisionChecking( line( 1, : ), line( 2, : ), huanyuan );
                     if (checkLine==1)
                         fhyq = [ fhyq, iiTest ];
                     end
                 end
                 i2 = i2 + 1;
                 goalPoint2( i2, : ) = goalPoint( fhyq( end ), : );
                 ii = fhyq( end );
             end
             sumDistance = 0;
             for ii = 2:length( goalPoint2( :, 1 ) )
                 sumDistance = sumDistance + norm( goalPoint2( ii, : ) - goalPoint2( ii - 1, : ) );
             end
         end
         function feasible = collisionChecking(startPose,goalPose,map)
             feasible = true;
             dir = atan2( goalPose( 1 ) - startPose( 1 ), goalPose( 2 ) - startPose( 2 ) );
             for r = 0:0.5:sqrt( sum( (startPose - goalPose) .^ 2 ) )
                 posCheck = startPose + r .* [ sin( dir ), cos( dir ) ];
                 if ~(feasiblePoint( ceil( posCheck ), map ) && feasiblePoint( floor( posCheck ), map ) && feasiblePoint( [ ceil( posCheck( 1 ) ), floor( posCheck( 2 ) ) ], map ) && feasiblePoint( [ floor( posCheck( 1 ) ), ceil( posCheck( 2 ) ) ], map ))
                     feasible = false;
                     break
                 end
                 if ~feasiblePoint( [ floor( goalPose( 1 ) ), ceil( goalPose( 2 ) ) ], map )
                     feasible = false;
                 end
             end
         end
         function feasible = feasiblePoint(point,map)
             feasible = true;
             if ~(point( 1 )>=1 && point( 1 )<=size( map, 2 ) && point( 2 )>=1 && point( 2 )<=size( map, 1 ) && map( point( 2 ), point( 1 ) )==255)
                 feasible = false;
             end
         end
         function angle = compute_angle(currentPoint,finalPoint,obstaclePoint,obstacleNum)
             x = finalPoint( 1 ) - currentPoint( 1 );
             y = finalPoint( 2 ) - currentPoint( 2 );
             angle( 1 ) = atan2( y, x );
             for ii = 1:obstacleNum
                 x = obstaclePoint( ii, 1 ) - currentPoint( 1 );
                 y = obstaclePoint( ii, 2 ) - currentPoint( 2 );
                 angle( ii + 1 ) = atan2( y, x );
             end
         end
         function Uatt = compute_attField(currentPoint,finalPoint,Katt,influenceDistance)
             r = norm( finalPoint - currentPoint );
             if (r<=influenceDistance)
                 Uatt = 0.5 * Katt * r * r;
             else
                 Uatt = influenceDistance * Katt * r;
             end
         end
         function [Fattx,Fatty] = compute_Attract(currentPoint,finalPoint,Katt,angleGoal,influenceDistance)
             r = norm( currentPoint - finalPoint );
             if (r<=influenceDistance)
                 Fattx = Katt * r * cos( angleGoal );
                 Fatty = Katt * r * sin( angleGoal );
             else
                 Fattx = influenceDistance * Katt * cos( angleGoal );
                 Fatty = influenceDistance * Katt * sin( angleGoal );
             end
         end
         function Urep = compute_repField(currentPoint,obstaclePoint,Krep,obstacleNum,influenceDistance)
             for ii = 1:obstacleNum
                 Robstacle = norm( currentPoint - obstaclePoint( ii, : ) );
                 if Robstacle<influenceDistance
                     sumU( ii ) = 0.5 * Krep * ((1 / Robstacle - 1 / influenceDistance) ^ 2);
                 else
                     sumU( ii ) = 0;
                 end
             end
             Urep = sum( sumU );
         end
         function [Frepx,Frepy] = compute_repulsion(currentPoint,obstaclePoint,Krep,angle,obstacleNum,influenceDistance)
             for ii = 1:obstacleNum
                 currentObstacle = norm( currentPoint - obstaclePoint( ii, : ) );
                 if currentObstacle>influenceDistance
                     Yrepx( ii ) = 0;
                     Yrepy( ii ) = 0;
                 else
                     Y1( ii ) = -Krep * ((1 - currentObstacle / influenceDistance) / (currentObstacle / influenceDistance)) * (1 / ((currentObstacle / influenceDistance) ^ 2));
                     Yrepx( ii ) = Y1( ii ) * cos( angle( ii + 1 ) );
                     Yrepy( ii ) = Y1( ii ) * sin( angle( ii + 1 ) );
                 end
             end
             Frepx = sum( Yrepx );
             Frepy = sum( Yrepy );
         end
