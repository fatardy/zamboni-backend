# DB SETUP:
    * create user:
    ```CREATE USER 'ardy'@'localhost' IDENTIFIED BY 'asdfQWER12#';```
    * grant privilages:
    ```GRANT CREATE, ALTER, DROP, INSERT, UPDATE, DELETE, SELECT, REFERENCES, RELOAD on *.* TO 'ardy'@'localhost' WITH GRANT OPTION;```
    * flush grant tables:
    ```FLUSH PRIVILAGES;```

# DB CMD line connection:
    * mysql -u ardy -pasdfQWER12# zamboni
    * mysql -u root -pasdfqwer12#

    https://stackoverflow.com/questions/17631363/delete-records-after-15-minutes