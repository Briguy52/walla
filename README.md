Hi! For this project (basic messaging/posting iOS app), I focused on creating a Firebase backend and then integrating that with the frontend.

Here's a list of my specific backend classes:
-Basic.swift (contains helper methods for current time, all Firebase references, etc. to be used by rest of the backend)
-UserBackend.swift (contains helper methods for logging in/creating users, retrieving and setting user data such as email, etc.)
-RequestBackend.swift (contains methods for retrieving/parsing/filtering/posting Requests/Posts)
-ConvoBackend.swift (very similar to RequestBackend, but for Conversations and Messages)
-ConvoModel.swift (a struct for the the contents of a Conversation)
-RequestModel.swift (a struct for the contents of a Request)

I also integrated our backend- that meant populating fields/labels/cells with my backend query results and also pushing new content to the backend (new messages, new posts, updating user information, etc.). For these classes, you can ignore the frontend code (stuff like setting cell dimensions, background colors, etc. as that's what my partner worked on). 

For instance, in ViewDetails.swift, I worked on initRequestInfo() and setImage() which populates the screen from a Request Model as well as buildRef(), createConvoHash(), createSingleConvoRef(), and goToMessages() which starts a conversation with the author and then segues to the Conversation tab.   

Similar classes include:
-HomeViewController.swift (displays a feed of active posts from my backend)
-MessageViewController.swift (messaging UI displaying messages within a conversation)
-ConvoViewController.swift (table view displaying all active conversations)
-MyProfileViewController.swift (user profile displaying user info)
-MainSettings.swift settings page for enabling/disabling push notifications, etc.)
-WriteMessage.swift (page for creating a new Request)

