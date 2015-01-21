# PhelpsLab AudioAnalysis

## What is this repository for, anyway? 
The intent of this GitHub is to serve as a place to keep Phelps Lab acoustical analysis programs and files.
Unlike most of the other programs and files we use for genetic and genomic analysis, these programs often need to be transferred
  between computers outside the context of a bash shell. To that end, this database will organize and contain programs for 
  operating the RX6 playout/record, operating the RX8 playout/record, stimuli for both the RX6 and RX8, and acoustic analysis of 
  recorded songs. It will also contain documentation so that, hopefully, you understand what you are using and why at any given point.
  If you have questions about this database or are confused on its use, please contact Erin. 
  
## How do I know if I'm using the RX6 or the RX8?
If you are working in the field, you are almost certainly using the RX6. 
If you are working in the lab, you are probably but not certainly using the RX8. The RX6 has only two channels and has about 
twice the sampling frequency as the RX8. The RX8 compensates for this by having many additional channels. You can run two mice 
at a time on the RX6; the RX8 can handle as many as four at a time. The sound chambers in the audio room are nearly always 
hooked to the RX8. **Make sure you're clear on which device you're using before you pull this code**. 

## What's the difference between RPvdsEx and Matlab files?
RPvdsEx is the program that we use to operate the RX6 and RX8--that is, the machines which control our recording and playout 
software. This is what you'll be using if you are playing songs out to mice and recording their responses. On the other hand, 
Matlab is the language we use to actually analyze our acoustical recordings. Because of this, and because people are generally 
looking for only one use at a time, I have organized these programs by language. They should be in their own individual folders.

## How do I get the code onto my computer?
If you go to the folder containing, say, Matlab programs, you'll find a little button in the lower part of the right sidebar 
that is labeled "download the folder as a zip." Then unzip it and delete everything you don't need. Currently, I am trying to 
find a more streamlined way to download a single folder or category, but that will take some time. 

## Okay, I have this code that sort of kind of works, but I need to tweak it in some way. How do I do that?
FIRST: [read this guide](https://guides.github.com/activities/hello-world/#) and play around with how Github works for a bit. 
After you do that, please create your own branch labeled with your name and the changes you are making to your own code. This 
allows us to control versions and prevents you from destroying the original program while you try to make the changes you want.
If when you finish your new, tweaked program you genuinely think that the original program would work better with your changes, 
submit a pull request and I'll evaluate the changes. Remember to comment all your code so that someone who has no idea what you 
were doing or trying to do can see what you were going for! 
