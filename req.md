# admin
    - auth
        * login
    - users
        * mark user as admin
        * view all
        * block ?skip
    - locations
        * create
        * view all
        * update
        * delete
    - vehicleClass 
        * create
        * view all
        * update
        * delete
    - vehicles
        * create
        * view all
        * update
        * delete
    - bookings
        * view all
        * cancel
    - invoice
        * create (trigger)
        * view all
        * delete ?skip
    - payment
        * view all
        * delete ?skip
    - coupon
        * create
        * view
        * update
        * delete
        * add coupon for user/company
    - company
        * create
        * view all
        * delete

# customer apis
    - auth
        * signup
        * login
        * forgot password
    - user
        * edit user
        * view user data ?dont need user by id
    - home
        * view vehicles at location on date (public)
    - booking
        * create booking
        * view all bookings of user
        * cancel booking ?skip
    - invoice
        * view all invoices
    - payment
        * create payment
        * view all payments
    - coupon
        * view all coupons
        * use coupon

# frontend
    + admin
        - auth
            * login
        - users
            * create / edit
            * view all
        - locations
            * create / edit
            * view all (delete)
        - vehicleClass
            * create / edit
            * view all (delete)
        - vehicles
            * create / edit
            * view all (delete)
        - bookings
            * view all (cancel)
        - invoice
            * view all
        - payment
            * view all
        - coupon
            * create / edit
            * view all (delete)
        - company
            * create / edit
            * view all (delete)
    + user
        - auth
            * signup / login
        - user
            * edit profile / onboarding
            * view profile
        - home
            * view vehicles at location on date (public)
        - booking
            * view all bookings
            * make booking (apply coupon / view all coupons)
        - invoice
            * view all invoices (view all payments for invoice)
            * make payment

# frontend pages
/
/login
/profile
/profile/edit
/trip/create
/trip/all

