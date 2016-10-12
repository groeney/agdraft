Worker.create(first_name: "Bob", last_name: "Smith", email: "worker@example.com", password: "password")
james = Worker.create(first_name: "James", last_name: "Example", email: "james@example.com", password: "password")
james.notifications << FactoryGirl.create_list(:notification, 10)