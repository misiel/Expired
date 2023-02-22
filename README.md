# Expired 🍽
**A reminder app to track food expiration.**

**Expired** is a side project created with the purpose to understand how do Notifications work in iOS (how are they created, triggered, displayed etc.)

---
## Notes and Screenshots

The UI is pretty minimal and some things are misaligned (like the pesky UIDatePicker in the stackview in AddFoodViewController) but I just wanted to focus on the logic behind the creation of the reminders and getting the notifications to work.

I used some new UI components in this project like UIPickerView and UIDatePicker and created their delegates and data sources. This allowed me to use their values to create the Expiration notification and the User-picked Reminder notification.

Here are some screenshots of different actions and states throughout the app:
### Home (empty state) |        Home (with items)
![empty](https://user-images.githubusercontent.com/23410589/220580392-2fc48d82-a814-42d6-bc8f-5b4a454f446a.png)![homefull](https://user-images.githubusercontent.com/23410589/220580419-587c5c39-212b-410e-894b-235987867097.png)


### Swipe to Delete
![swipe](https://user-images.githubusercontent.com/23410589/220580096-db0321e3-8a89-4bcf-af8b-c9291ff0de1c.png)


### Add Food Screen 
![addfood](https://user-images.githubusercontent.com/23410589/220580472-2826b715-2fbb-40df-ab71-aca4f0327f72.png)


### Notification Reminder
![noti](https://user-images.githubusercontent.com/23410589/220580495-10add279-7412-4009-90af-75c8e3aec72c.png)

