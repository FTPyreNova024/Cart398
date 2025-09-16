    // More API functions here:
    // https://github.com/googlecreativelab/teachablemachine-community/tree/master/libraries/image

    // the link to your model provided by Teachable Machine export panel
    const URL = "./my_model/";

    let model, webcam, labelContainer, maxPredictions;

    // Load the image model and setup the webcam
    async function init() {
        const modelURL = URL + "model.json";
        const metadataURL = URL + "metadata.json";

        model = await tmImage.load(modelURL, metadataURL);
        maxPredictions = model.getTotalClasses();

        const flip = true;
        webcam = new tmImage.Webcam(200, 200, flip);
        await webcam.setup();
        await webcam.play();
        window.requestAnimationFrame(loop);

        // Create a container for webcams if not exists
        let webcamContainer = document.getElementById("webcam-container");
        let webcamWrapper = document.getElementById("webcam-wrapper");
        if (!webcamWrapper) {
            webcamWrapper = document.createElement("div");
            webcamWrapper.id = "webcam-wrapper";
            webcamWrapper.style.display = "flex";
            webcamContainer.appendChild(webcamWrapper);
        }

        // Place the new webcam to the right of the current one
        let webcamCanvas = webcam.canvas;
        webcamCanvas.style.marginLeft = "20px";
        webcamWrapper.appendChild(webcamCanvas);

        labelContainer = document.getElementById("label-container");
        for (let i = 0; i < maxPredictions; i++) {
            const div = document.createElement("div");
            div.className = `pie-section-${i + 1}`;
            div.style.width = "60px";
            div.style.height = "60px";
            div.style.borderRadius = "50%";
            div.style.background = "conic-gradient(#4caf50 0% 0%, #ddd 0% 100%)";
            div.style.display = "inline-block";
            div.style.margin = "10px";
            div.style.position = "relative";
            div.innerHTML = `<span style="position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);font-size:12px;"></span>`;
            labelContainer.appendChild(div);
        }
    }

    async function loop() {
        webcam.update();
        await predict();
        window.requestAnimationFrame(loop);
    }

    // run the webcam image through the image model
    async function predict() {
        const prediction = await model.predict(webcam.canvas);
        for (let i = 0; i < maxPredictions; i++) {
            const percent = Math.round(prediction[i].probability * 100);
            const classPrediction = prediction[i].className + ": " + percent + "%";
            // Update pie chart style
            labelContainer.childNodes[i].style.background = 
                `conic-gradient(#4caf50 0% ${percent}%, #ddd ${percent}% 100%)`;
            // Update label in center
            labelContainer.childNodes[i].querySelector("span").innerHTML = classPrediction;
        }
    }
