function [nextId_temp,cars_tracking_array_temp]=tracking_calculation(frame,Detector,BlobAnalyser,cars_tracking_array,nextId)

[centroids,b_boxes,~]=detectObjects(frame,Detector,BlobAnalyser);
cars_tracking_array=predictNewLocationsOfTracks(cars_tracking_array);
[assignments, unassignedTracks, unassignedDetections]=detectionToTrackAssignment(cars_tracking_array,centroids);
cars_tracking_array=updateAssignedTracks(assignments,cars_tracking_array,centroids,b_boxes);
cars_tracking_array=updateUnassignedTracks(unassignedTracks,cars_tracking_array);
deleteLostTracks(cars_tracking_array);
[nextId_temp,cars_tracking_array_temp]=createNewTracks(cars_tracking_array,unassignedDetections,centroids,b_boxes,nextId);

end