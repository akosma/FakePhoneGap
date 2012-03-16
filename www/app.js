var setStatusMessage = function (message) {
    var statusLabel = document.getElementById("statusLabel");
    statusLabel.innerText = message;
    setTimeout(clearStatusMessage, 3000);
};

var clearStatusMessage = function () {
    var statusLabel = document.getElementById("statusLabel");
    statusLabel.innerText = "";
};

var setLocation = function (latitude, longitude) {
    var latitudeLabel = document.getElementById("latitudeLabel");
    var longitudeLabel = document.getElementById("longitudeLabel");
    latitudeLabel.innerText = latitude;
    longitudeLabel.innerText = longitude;
    
    FakePhoneGap.stopGeolocation();
    
    var result = [latitude, longitude];
    return result.join(", ");
};

var displayImage = function (data) {
    var selectedImage = document.getElementById("selectedImage");
    var debugDiv = document.getElementById("debugDiv");
    debugDiv.innerText = data.substring(0, 35) + "...";
    selectedImage.src = data;
    setStatusMessage("Image changed!");
    return data;
};

FakePhoneGap.init(setStatusMessage);
