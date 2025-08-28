# ReadBook

ReadBook is an application for reading and organizing books. The project is implemented in Swift and Xcode. The app provides data storage for books and handles local file management. Store book information using CoreData. Save and load local files using FileManager.

## Technologies
- Swift 
- Xcode 
- UIKit 
- CoreData
- FileManager
- MVVM

## Data Storage
- **CoreData:** Stores book information such as title, author, start/end dates, rating, and comments.
- **FileManager:** Handles storing local files such as book cover images.

## Features

### Main Screen
The main screen has three buttons:
- View the Library (read books)
- View the Wishlist
- Add a new book
  
<img src="readbookImage/home.jpg" width="250"/> 

### Add Book
- When clicked on the button, you will be offered two options: Manual search or Online search.
  
<img src="readbookImage/select.png" width="230"/>

- Online search: opens a screen with searchBar.
- You need to enter a query in the searchBar and the found options will be displayed.
- Clicking on the cell opens a screen with filled fields, you can save this workbook.
  
<img src="readbookImage/search.png" width="230"/>   <img src="readbookImage/searchBook.png" width="230"/>

- Manual Search: opens a screen to fill in book details.
  
<img src="readbookImage/new.jpg" width="230"/>     <img src="readbookImage/newLibrary.jpg" width="230"/>

- Required fields: Author and Title.
- If saving to the Library, additional required fields: End Date and Rating.
- If any required field is missing, an alert appears.
- There are two buttons to select the book category: Library or Wishlist.
  - Switching between categories hides or shows fields related to read books (Start Date, End Date, Rating, Comment).

 <img src="readbookImage/alert.jpg" width="230"/>
 
### Library
- Books are displayed in a table organized by sections, where each section represents one month.
- Swipe left on a cell to delete a book from both the table and the database.
- Tap a cell to view detailed information about the book.
- Delete/Update cover
  
<img src="readbookImage/library.jpg" width="230"/> <img src="readbookImage/deleteBook.jpg" width="230"/> <img src="readbookImage/deleteCover.jpg" width="230"/>

### Wishlist
- Like a library, but book are displayed in a simple table without sections.

<img src="readbookImage/wishlist2.jpg" width="230"/>



