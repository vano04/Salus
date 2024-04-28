# Salus

## Description

### What it does
Salus is an app that simplifies complex ingredient labels, providing you with essential information about what’s in your food.

### Tech used
Swift, apple-ocr, gpt-4, microsoft-phi-3, openai-api

### Challenges faced
Originally, we wanted to use GPT 4 or Apple's built in vision models for OCR and Microsoft's new SLM Phi-3 to scan blood pressure monitors in order to send the data into a health app, but the text detection was not accurate enough in either model to make it feasible.

For this reason we pivoted to reading and explaining nutrition labels as this is something that doesn't require such high accuracy but instead needs knowledge of different ingredients which LLM's do well.

However our biggest challenges came from building out the front-end as none of us had experience in building an app and integrating the GPT-4 API as it is not directly supported yet by OpenAI and the packages the bring support to it do not have support for the latest GPT-4 vision API.

### Future feature implementation

Fixing image API call to use GPT-4-turbo to describe harmful ingredients 

Adding a context aware chat feature after scanning image 

Publishing to App Store 

Implementing Apple's built in vision models for OCR and Microsoft's new SLM Phi-3 quantized models so that health data never leaves the device 

Expanding to other image-detection cases like reading a blood pressure monitor 

Expanding to android and other platforms

**Proof of concept:**
![Screenshot 2024-04-28 095949](https://github.com/vano04/Salus/assets/91144975/6da298c5-a8d7-4d9b-83a3-06f14d1359f9)

## Installing Salus
Clone github repo

Steps for installing to iphone through xcode

(Future sideloading build/app store)

## Using Salus
Open app

(Give access to health app?)

Take picture

Read measurements and send to health app

### Credits
Ivan, Jin, Manuel

### License
MIT License
Copyright 2024 Manuel Braje

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
