The model is classifying a given image to see if its either a Dodge Challenger, a Chevrolet Camaro or a Ford Mustang. I am using a Database of images I found online, I screenshoted them from google images. the three classes are Mustang, Challenger, and Camaro. I gave around 30images per class of various color cars and different angles.

One of the strategies I used to get better results is getting more images of mostly just the front of the cars which is the most identifying part of the cars. I also went from around 10 images per class to 30.
It seems to fail when displaying the rear of the cars even though I tried adding a good amount of references. to fix it I figured simpler would be beter.
the hardest class to train at the begining was the camaro and mustang since they are very similar. luckily it was a simple enough fix of adding more images.
it was more difficult to get decent performance when adding more classes, my guess is because a car is a very general term, four wheels headlights windshield and so on which I think made it hard for the model to identify the details.
The model if fairly robust when dealing with the mustang and camaro but with tthe challenger it seems to be a little weaker. for the mustang and camaro u can show it any angle of the front side of the car and it gets it right pretty well.
I was really surprised how well it learned the mustang class, it has about the same amount of examples yet its consistently a 100-98% certainty on it. 

Link to video demostration: https://youtu.be/qithr-IB4R8

-Daniel Munoz Calderon,