ClassRoster
===========
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/jakehawken/ClassRoster?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
This project was my first complete app, created for an introductory iOS course at Code Fellows.

The assignment was to create an application that lets you view and manage the class roster. It needed a main view controller with a table view of all the students and teachers, and a detail view controller, triggered when any of the individual students is selected from the table view. The detail view controller needed to display all the relevant information about the person, including name, student ID, GitHub username, and a profile picture.

<img src="https://dl.dropboxusercontent.com/u/1705617/Screenshot%202014-09-06%2014.21.53.png" width="217" height="352" title="Main View Controller" style="float:left"></img>
<img src="https://dl.dropboxusercontent.com/u/1705617/Screenshot%202014-09-06%2014.21.18.png" width="217" height="352" title="Detail View Controller" style="float:left"></img>

<sub> Left to right: Main View Controller, Detail View Controller. </sub>

<h4> On first run </h4>
A plist file was created from data on our class website. The first time the app runs, the app needed to use a plist or some other static list to generate an array of "Person" objects, which each contain all of the values relevant to each person: first name, last name, student ID number, profile picture, GitHub username, GitHub avatar, role (student or teacher), profile picture, and a Boolean variable called isNewPerson which tracks whether or not the student is a new addition. (This value for all of the Person objects generated from the plist is "false.")

The app needed to have data persistence, such that every subsequent time the app was run it needed to pull the data from disk rather than generating the array from the plist all over again. This was accomplished using NSKeyedArchiver.

<h4>Image/Camera Usage</h4>
Within the detail view controller, the user needed to be able to choose a new photo from the phone's photo library (or from the camera), and first and last name fields needed to be editable text fields. There also needed to be a GitHub button which, when pressed, prompted the user for their GitHub username, used that username to build a URL, downloaded the user's public JSON data, then use that JSON file to find and download the user's avatar image, which would then replace the user's existing profile photo. <i>None of this could block the main thread, or the assignment would receive no credit. </i>

<img src="https://dl.dropboxusercontent.com/u/1705617/Screenshot%202014-09-06%2015.06.25.png" width="217" height="352" title="Add Github Username" style="float:left"></img>

I wanted changes made in the detail view controller to be saved to disk, but since the function for saving to disk is in the main view controller, I had to add the main vc as a delegate of the detail vc, adding the save function to the delegate protocol. After experimenting with several options, I eventually found that calling the save function in the detail view controller's viewWillDisappear view method was the smoothest and also the most logical option.

Also according to assignment requirements, my app makes full use of auto layout and constraints to ensure that my app is clear and sensibly laid out in all orientations and on all devices.

<img src="http://i.gyazo.com/081c333d32753672b7ccd1f9ba5a2b8a.gif" width="296" height="304" title="Auto Layout"></img>

<h3>BONUS:</h3>
Though not required for the assignment, I decided that I wanted to add an "Add Student" button to the main view controller to allow the addition of new students to the class roster that were not in the original plist file. Rather than create a third view controller for this specific case, I created a separate segue to the detail view controller which creates a new Person with default attributes (first name: "First", last name: "Last", student ID: "00000000", etc), with the isNewPerson value set to "true." I added logic to the detail vc to check the isNewPerson value, and if it's true to require (via an alert view controller) to give the new student a new student ID number.

<img src="http://i.gyazo.com/9d51d62988949bf6b42bc3ab449f1175.gif" width="285" height="293" title="Auto Layout"></img>

I created a function in my main view controller called addStudent which appends a Person object to the main class roster array. I set the main view controller as a delegate of the detail view controller, and added the addStudent function to the delegate protocols in the detail view controller. If the new person has been given a student ID number other than "0000000", then when the user returns to the main view controller, the addStudent function is called from the viewWillDisappear method, seamlessly adding the student to the class roster array and saving the data to disk.

Enjoy!
