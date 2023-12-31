function output_data = K64_Impedance_Control_matlab()
    figure(1);  clf;       % Create an empty figure to update later
    subplot(411)
    h1 = plot([0],[0]);
    h1.XData = []; h1.YData = [];
    ylabel('Position (rad)');
    
    subplot(412)
    h2 = plot([0],[0]);
    h2.XData = []; h2.YData = [];
    ylabel('Velocity (rad/s)');
    
    subplot(413)
    h3 = plot([0],[0]);
    h3.XData = []; h3.YData = [];
    ylabel('Voltage (V)');
    
    subplot(414)
    h4 = plot([0],[0]);
    h4.XData = []; h4.YData = [];
    ylabel('Current (A)');
    
    % This function will get called any time there is new data from
    % the FRDM board. Data comes in blocks, rather than one at a time.
    function my_callback(new_data)
        t = new_data(:,1);   % time
        angle = new_data(:,2); % position
        vel = new_data(:,3); % velocity
        voltage = new_data(:,4); % voltage
        current = new_data(:,5); % current
        N = length(angle);
        
        h1.XData(end+1:end+N) = t;   % Update subplot 1
        h1.YData(end+1:end+N) = angle;
        h2.XData(end+1:end+N) = t;   % Update subplot 2
        h2.YData(end+1:end+N) = vel;
        h3.XData(end+1:end+N) = t;   % Update subplot 3
        h3.YData(end+1:end+N) = voltage;
        h4.XData(end+1:end+N) = t;   % Update subplot 4
        h4.YData(end+1:end+N) = current;
    end
    
    frdm_ip  = '192.168.1.100';     % FRDM board ip
    frdm_port= 11223;               % FRDM board port  
    params.callback = @my_callback; % callback function
    params.timeout  = 2;            % end of experiment timeout
    
    % The example program provided takes two arguments
%     v1 = 1.0;           % pwm applied for first second 
%     v2 = -1.0;           % pwm applied for second second
%     input = [v1 v2];    % input sent to FRDM board
%     output_size = 3;    % number of outputs expected


    angle_desire  = 1;      % Desired angle in rad
    R_motor       = 1.852;	% Resistance of motor
    Kb            = 0.005;	% Kb (Back EMF)
    Kp            = 3;      % Kp proportional gain of current control
    Ki            = 0.1;    % Ki Integration gain of current control
    Kv            = 0.0;    % Kv friction coe
    K             = 0.01;	% KP of impedance
    D             = 0.001;	% KD of impedance
    ExpTime       = 3;      % Expriement time in second
    
    input = [angle_desire R_motor Kb Kp Ki Kv K D ExpTime];
    output_size = 5;
   
    output_data = RunExperiment(frdm_ip,frdm_port,input,output_size,params);
    
end



