
function startDictation(obj,evt) {
    if (window.hasOwnProperty('webkitSpeechRecognition'))
    {
        var recognition = new webkitSpeechRecognition();

        recognition.continuous = true;
        recognition.interimResults = true;
        // recognition.lang = "en-US";
        document.getElementById('index_input').placeholder = "Recording...";
        recognition.start();
        recognition.onresult = function (e)
        {
            document.getElementById('index_input').placeholder = "";
            document.getElementById('index_input').value = e.results[0][0].transcript;
            recognition.stop();
            // document.getElementById('labnol').submit();
        };

        recognition.onerror = function(e) {
            recognition.stop();
        }

        event.preventDefault();

        //event.stopPropagation();
    }

}
