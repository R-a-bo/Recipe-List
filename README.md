
### Summary: Include screen shots or a video of your app highlighting its features
[Main screen](/main_screen.png)
[Recipe detail](/recipe_detail.png)

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
I chose to prioritize a strong caching and concurrent image fetching system. My reason for this is that doing so is necessary to provide a smooth scrolling experience with any hitches, a bedrock element of a good user experience. There are many possible pitfalls, such as:
- If all recipe images were fetched instead of just the ones on the screen, there could easily be too many threads or too much network work.
- If the images were not cached to memory, the app would forever be having to do large amounts of work as the user scrolls up and down.
- If the images were not cached to disk, the fetches would have to be repeated every time the app was started (or even more frequently if the cache has to drop images because of memory concerns).
- If the cache didn't use NSCache or a similar mechanism, the app could run out of memory by trying to cache too much image data.
- If the cache weren't threadsafe, it could cause crashes by being accessed from different threads at the same time.
- If the Tasks to fetch images off of the network were not cancelled upon the relevant UI leaving the screen, the system could freeze because of having too mahy Tasks open when the user quickly scrolls.

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
Not sure. I focused on making sure the caching worked well and that the UI ran smoothly.

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
The cache does not invalidate entries for any reason. It would be helpful to do something simple like automatically invalidating entries that are too old to ensure that out of date images are not presented to the user.

### Weakest Part of the Project: What do you think is the weakest part of your project?
The UI is pretty simple. If I had more time I would have liked to add some UI sheen, to have the YouTube videos embedded into recipe detail page, and to use a webview to display the source recipe in the app.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.