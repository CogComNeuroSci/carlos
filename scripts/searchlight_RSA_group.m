%load ../data/RawData_group
for s = 1:size(MovData_group,4)
    for i = 1:size(MovData_group,3)
        diss(:,:,i,s) = squareform(pdist(MovData_group(:,:,i,s),'euclidean'));
        diss_cond1(i,s) = mean(mean(diss(1:10,1:10,i,s)));
        diss_cond2(i,s) = mean(mean(diss(11:20,11:20,i,s)));   
        diss_cond3(i,s) = mean(mean(diss(21:30,21:30,i,s)));        
    end
end

figure
  plot(mean(diss_cond1,2))
  hold on
  plot(mean(diss_cond2,2))
  plot(mean(diss_cond3,2))