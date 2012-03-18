var Application = function () {
    return {
        setStatusMessage: function (message) {
            var statusLabel = document.getElementById("statusLabel");
            statusLabel.innerText = message;
            setTimeout(Application.clearStatusMessage, 3000);
        },
        
        clearStatusMessage: function () {
            var statusLabel = document.getElementById("statusLabel");
            statusLabel.innerText = "";
        },
        
        setLocation: function (latitude, longitude) {
            var latitudeLabel = document.getElementById("latitudeLabel");
            var longitudeLabel = document.getElementById("longitudeLabel");
            latitudeLabel.innerText = latitude;
            longitudeLabel.innerText = longitude;
            
            FakePhoneGap.stopGeolocation();
            
            var result = [latitude, longitude];
            return result.join(", ");
        },
        
        displayImage: function (data) {
            var selectedImage = document.getElementById("selectedImage");
            var debugDiv = document.getElementById("debugDiv");
            debugDiv.innerText = data.substring(0, 35) + "...";
            selectedImage.src = data;
            Application.setStatusMessage("Image changed!");
            return data;
        }
    };
}();

FakePhoneGap.setConsoleFunction(Application.setStatusMessage);
