# Wordpress + LAMP with Docker
Setup a Docker Wordpress LAMP (Linux, Apache, MySQL, PHP) Stack

### Install

If you use linux, just run builder.sh with root privileges and it will build and deploy the docker container:

``` chmod +x builder.sh ```

``` sudo ./builder.sh ```


MySQL credentials will be created automatically and printed at the end of the installation. It is recommended to save them in case you need it.

![image](https://user-images.githubusercontent.com/32111208/122814432-8c985980-d2aa-11eb-9dd1-eb0021805b12.png)


Now you just need to choose your language and your website's personal data.

![image](https://user-images.githubusercontent.com/32111208/122815431-d0d82980-d2ab-11eb-82b7-07ea0f3ac238.png)

![image](https://user-images.githubusercontent.com/32111208/122815550-fbc27d80-d2ab-11eb-8cb4-32cd630c4911.png)


After clicking on "Install Wordpress", you can start using it!

![image](https://user-images.githubusercontent.com/32111208/122815763-46dc9080-d2ac-11eb-89bb-3fc5e31a1638.png)


### Uninstall

``` chmod +x destroy.sh ```

``` sudo ./destroy.sh ```
