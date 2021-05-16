# Personalizable CoreML MNIST trained with Triplet-loss

This application interface will let the user to add numbers to the database and evaluate them respectively.

Two ML Models are provided in the application. If the user clicks the switch "Use CreateML MNIST", the application will 
load the apple's MNIST mlmodel. 

### How to use?

- Clone the repository to your folder. 
- Connect your device or run using simulator. 
- Click on Add Dataset because the application has a raw MNIST model and isnt trained on numbers. 
- Add whatever you want on the canvas. (Doesnt need to be numbers)
- Once the dataset is stored, you can click on evaluate.
- During the evaluation, the model will take the feature vector difference from your drawing in the dataset and 
  the drawing during the test and give you the label of the least distance. 

The GIF below suggests how to add dataset. 

![](https://media.giphy.com/media/kC7kfQx4XIuWprIpws/giphy.gif)

The GIF below suggests how to test using the added dataset. 

![](https://media.giphy.com/media/H1G0wnXhyMbzspIidH/giphy.gif)



### Future scope

During the latest WWDC apple introduced on-device training. This project was created to use the feature and 
train the model on-device. Currently, ONNX support is limited which restricts us from harnessing the custom layers and custom modelling capabilities of TensorFlow, PyTorch and Apache MXNet. Will be updating soon.
