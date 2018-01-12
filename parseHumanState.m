function [ parsed_state] = parseHumanState( filename_dumpState )
%PARSEHUMANSTATE parses the state coming from a YARP file of HDE repo
% (https://github.com/robotology/human-dynamics-estimation) into a Matlab
% struct.  Taylored for a model with 66 DoFs.
%
% Input:
% - filename_dumpState: name of the file.log
% Output:
% - parsed_state: parsed human state in a Matlab struct
%
% The parser is built on the following thrift:

% struct HumanState {
%     1: Vector positions;
%     2: Vector velocities;
%     3: Vector3 baseOriginWRTGlobal;
%     4: Quaternion baseOrientationWRTGlobal;
%     5: Vector baseVelocityWRTGlobal;
% }


fileID = fopen(filename_dumpState);

numberOfDoFs = 66;

formatSpec = '%d %f %f'; % added one more %f

% position
formatSpec = [formatSpec, ''];
for i = 1 : numberOfDoFs
    formatSpec = [formatSpec, '%f '];
end
formatSpec = [formatSpec, ''];

% velocity
formatSpec = [formatSpec, ''];
for i = 1 : numberOfDoFs
    formatSpec = [formatSpec, '%f '];
end
formatSpec = [formatSpec, ''];

% base position
for i = 1 : 7
    formatSpec = [formatSpec, '%f '];
end

% base velocity
formatSpec = [formatSpec, ''];
for i = 1 : 6
    formatSpec = [formatSpec, '%f '];
end
formatSpec = [formatSpec, ''];


C = textscan(fileID, formatSpec, ...
    'MultipleDelimsAsOne', 1, 'Delimiter', {'(',')','\b'});

numOfSamples = length(C{1});
parsed_state.time = C{3}'; % 3 instead of 2
parsed_state.time = parsed_state.time - repmat(parsed_state.time(1), size(parsed_state.time));
parsed_state.jointNames = {
    'jL5S1_rotx'...
    'jL5S1_roty'...
    'jL5S1_rotz'...
    'jL4L3_rotx'...
    'jL4L3_roty'...
    'jL4L3_rotz'...
    'jL1T12_rotx'...
    'jL1T12_roty'...
    'jL1T12_rotz'...
    'jT9T8_rotx'...
    'jT9T8_roty'...
    'jT9T8_rotz'...
    'jT1C7_rotx'...
    'jT1C7_roty'...
    'jT1C7_rotz'...
    'jC1Head_rotx'...
    'jC1Head_roty'...
    'jC1Head_rotz'...
    'jRightC7Shoulder_rotx'...
    'jRightC7Shoulder_roty'...
    'jRightC7Shoulder_rotz'...
    'jRightShoulder_rotx'...
    'jRightShoulder_roty'...
    'jRightShoulder_rotz'...
    'jRightElbow_rotx'...
    'jRightElbow_roty'...
    'jRightElbow_rotz'...
    'jRightWrist_rotx'...
    'jRightWrist_roty'...
    'jRightWrist_rotz'...
    'jLeftC7Shoulder_rotx'...
    'jLeftC7Shoulder_roty'...
    'jLeftC7Shoulder_rotz'...
    'jLeftShoulder_rotx'...
    'jLeftShoulder_roty'...
    'jLeftShoulder_rotz'...
    'jLeftElbow_rotx'...
    'jLeftElbow_roty'...
    'jLeftElbow_rotz'...
    'jLeftWrist_rotx'...
    'jLeftWrist_roty'...
    'jLeftWrist_rotz'...
    'jRightHip_rotx'...
    'jRightHip_roty'...
    'jRightHip_rotz'...
    'jRightKnee_rotx'...
    'jRightKnee_roty'...
    'jRightKnee_rotz'...
    'jRightAnkle_rotx'...
    'jRightAnkle_roty'...
    'jRightAnkle_rotz'...
    'jRightBallFoot_rotx'...
    'jRightBallFoot_roty'...
    'jRightBallFoot_rotz'...
    'jLeftHip_rotx'...
    'jLeftHip_roty'...
    'jLeftHip_rotz'...
    'jLeftKnee_rotx'...
    'jLeftKnee_roty'...
    'jLeftKnee_rotz'...
    'jLeftAnkle_rotx'...
    'jLeftAnkle_roty'...
    'jLeftAnkle_rotz'...
    'jLeftBallFoot_rotx'...
    'jLeftBallFoot_roty'...
    'jLeftBallFoot_rotz'
    };
parsed_state.qj = zeros(numberOfDoFs, numOfSamples);
parsed_state.dqj = zeros(numberOfDoFs, numOfSamples);
parsed_state.basePose = zeros(7, numOfSamples);
parsed_state.baseVelocity = zeros(7, numOfSamples);

startingIndex = 3; %3 instead of 2
for i = 1 : numberOfDoFs
    parsed_state.qj(i,:) = C{startingIndex + i}';
end
startingIndex = startingIndex + numberOfDoFs;
for i = 1 : numberOfDoFs
    parsed_state.dqj(i,:) = C{startingIndex + i}';
end
startingIndex = startingIndex + numberOfDoFs;
for i = 1 : 7
    parsed_state.basePose(i,:) = C{startingIndex + i}';
end
startingIndex = startingIndex + 7;
for i = 1 : 6
    parsed_state.baseVelocity(i,:) = C{startingIndex + i}';
end
end

