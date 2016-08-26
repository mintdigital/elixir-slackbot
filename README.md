Rex
============

What is Rex?
------------

You feed Rex information your team needs to know, and Rex uses it to answer questions employees have.

For small-medium sized companies focusing on growth, Rex helps you record and distribute important internal information your workforce needs. Using Rex to handle low-value queries frees your team up to focus on the things that really matter.

Docker setup
-------------

1. Install [Docker for Mac](https://docs.docker.com/engine/installation/mac/) if you haven't already.

2. Install [Docker Compose](https://docs.docker.com/compose/install/) if you haven't already.

3. In Terminal, go to your projects directory and clone the project:

        cd ~/Documents/Projects/
        git clone git@github.com:mintdigital/rexbot.git


4. Build Docker

        docker-compose build

6. Run the tests

        docker-compose run server mix test

8. Run the app!

        docker-compose up

Further setup
-------------

There are further steps that we need to undertake in order for this to fully work.
I will outline them in the near future.
