ClassRoster
===========
This project was my first complete app, created for an introductory iOS course at Code Fellows.

The assignment was to create an application that lets you view and manage the class roster. It needed a main view controller with a table view of all the students and teachers, and a detail view controller, triggered when any of the individual students is selected from the table view. The detail view controller needs to display all the relevant information about the person, including name, student ID, GitHub username, and a profile picture.

A plist file was created from data on our class website. The first time the app runs, the app needed to use a plist or some other static list to generate an array of "Person" objects, which each contain all of the values relevant to each person: first name, last name, student ID number, profile picture, GitHub username, GitHub avatar, role (student or teacher), profile picture, and a Boolean value which tracks whether or not the student is a new addition. (This value for all of the Person objects generated from the plist is "false.")

The app needed to have data persistence, such that every subsequent time the app was run it needed to pull the data from disk rather than generating the array from the plist all over again. This was accomplished using NSKeyedArchiver.

Within the detail view controller, the user needed to be able to choose a new photo from the phone's photo library (or from the camera), and first and last name fields needed to be editable text fields. There also needed to be a GitHub button which, when pressed, prompted the user for their GitHub username, used that username to build a URL, downloaded the user's public JSON data, then use that JSON file to find and download the user's avatar image, which would then replace the user's existing profile photo.

I wanted changes made in the detail view controller to be saved to disk, but since the function for saving to disk is in the main view controller, I had to add the main vc as a delegate of the detail vc, adding the save function to the delegate protocol. After experimenting with several options, I eventually found that calling the save function in the detail view controller's viewWillDisappear view method was the smoothest and also the most logical option.
