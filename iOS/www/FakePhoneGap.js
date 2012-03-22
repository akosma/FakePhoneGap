var FakePhoneGap = function () {
    
    var imageData = [];
    var geolocationCallback = null;
    var openPhotoLibraryCallback = null;
    var consoleCallback = null;
    
    return {
        setConsoleFunction: function (callback) {
            consoleCallback = callback;
        },
        
        log: function (message) {
            if (consoleCallback) {
                consoleCallback(message);
            }
        },
        
        openPhotoLibrary: function(callback) {
            openPhotoLibraryCallback = callback;
            window.location = "fakephonegap://openphotolibrary";
        },
            
        startGeolocation: function (callback) {
            geolocationCallback = callback;
            window.location = "fakephonegap://startgeolocation";
        },
            
        stopGeolocation: function () {
            window.location = "fakephonegap://stopgeolocation";
        },
            
        locationUpdated: function (latitude, longitude) {
            if (geolocationCallback) {
                return geolocationCallback(latitude, longitude);
            }
        },
        
        appendImageData: function (data) {
            // This method is required because UIWebKit (the embedded
            // engine that displays web pages inside of iOS apps)
            // silently kills scripts that take more than 10 MB to
            // execute; hence, we need to pass the image data in small
            // chunks, store everything in an array, and then trigger
            // the display later.
            imageData.push(data);
        },
            
        imageDataReady: function () {
            var data = ["data:image/jpg;base64", imageData.join("")];
            var srcText = data.join(",");
            if (openPhotoLibraryCallback) {
                openPhotoLibraryCallback(srcText);
            }
            imageData = [];
        }
    };
}();
