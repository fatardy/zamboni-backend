# admin
    - auth
        [x] login
    - users
        [ ] mark user as admin
        [ ] view all
        [ ] block ?skip
    - locations
        [x] create
        [x] view all
        [x] update
        [x] delete
    - vehicleClass 
        [x] create
        [x] view all
        [x] update
        [x] delete
    - vehicles
        [x] create
        [x] view all
        [x] update
        [x] delete
    - trips
        [ ] view all
        [ ] cancel
    - invoice
        [ ] create (trigger)
        [x] view all
        [-] delete ?skip
    - payment
        [x] view all
        [-] delete ?skip
    - coupon
        [x] create
        [x] view
        [x] update
        [x] delete
        [ ] add coupon for user/company
    - firms
        [x] create
        [x] view all
        [x] update !done, but not required
        [x] delete

# customer apis
    - auth
        [x] authorize
        [x] send otp
        [x] verify otp
    - user
        [x] view user data
        [x] get user data
    - home
        [x] view all locations (public)
        [x] view available vehicles at location on date (public)
        [ ] view all vehicles mark unavailable ones also
    - trip
        [x] create 
        [x] view all trips of user
        [-] cancel trip ?skip
        [x] end trip
    - invoice
        [-] view all invoices ?detail on trip 
    - payment
        [ ] create payment
        [ ] view all payments
    - coupon
        [ ] view all coupons
        [ ] use coupon

# frontend
    + admin
        - auth
            [ ] login
        - users
            [ ] create / edit
            [ ] view all
        - locations
            [ ] create / edit
            [ ] view all (delete)
        - vehicleClass
            [ ] create / edit
            [ ] view all (delete)
        - vehicles
            [ ] create / edit
            [ ] view all (delete)
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

