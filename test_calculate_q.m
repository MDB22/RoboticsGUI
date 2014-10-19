%%finding q from various starting positions

P_final = [-10; 25; 400];
RPY_final = [0; 0; 0];

q_new_array = [];
error_array = [];
i = 0;

for q10 = -170:50:170
    for q20 = -170:50:170
        for q30 = -80:50:80
            for q40 = -80:90:80
                for q50 = -10:1:-10
                    for q60 = -8:1:-8
                        i=i+1;
                        %fprintf('---------------------------------');
                        q_start = [q10;q20;q30;q40;q50;q60];
                        [q_new, error] = calculate_q(q_start, P_final, RPY_final);
                        abs_error = abs(error(1))+abs(error(2))+abs(error(3))+abs(error(4))+abs(error(5))+abs(error(6));
                        if ((abs_error<10)&&(~out_of_range(q_new,min_angle,max_angle)))
                            q_new_array(:,size(q_new_array,2)+1)=q_new;
                            error_array(:,size(error_array,2)+1)=error;
                            q_new;
                            error;
                        end
                    end
                end
            end
        end
    end
end
q_new_array
close all;
figure;
plot(q_new_array(1,:))
hold on
plot(q_new_array(2,:),'r')
plot(q_new_array(3,:),'g')
plot(q_new_array(4,:),'k')
plot(q_new_array(5,:),'b.')
plot(q_new_array(6,:),'r.')


% plot(q_new_array(1,:))
% hold on
% plot(q_new_array(2,:),'r')
% plot(q_new_array(3,:),'g')
% plot(q_new_array(4,:),'k')
% plot(q_new_array(5,:),'b.')
% plot(q_new_array(6,:),'r.')