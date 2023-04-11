# CopWatch_backend

Backend for CopWatch app using Swift Vapor framework and fluent.

Database requests should use camelCase for keys instead of snake_case. 

Install Docker on your system to run and test
your Vapor app in a production-like environment.

Note: This file is intended for testing and does not
implement best practices for a production deployment.

Learn more: https://docs.docker.com/compose/reference/

Open terminal in project folder to run the following commands:

   Build images: docker-compose build
      Start app: docker-compose up app
 Start database: docker-compose up db
 Run migrations: docker-compose run migrate
       Stop all: docker-compose down (add -v to wipe db)

Once the container is up, start the project in xCode.
