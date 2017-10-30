clear MovData_group clear mean_acc
for s = 1:5
for t = 1:30
    count = 1;
    for time = 51:50:1000
        for eye = 1:2
            MovData_group(t,eye,count,s) = abs(oRawData_group(t,eye,time,s)-oRawData_group(t,eye,time-50,s));
            
        end
        count = count +1;
    end
end

end