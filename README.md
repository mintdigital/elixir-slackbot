Rex Slack Bot
============

What is this?
------------

This project is a simple slack bot built in Elixir. You are able to ask the bot a question and it should respond with a response that it _thinks_ you may be after. We use ElasticSearch to perform the matching between the question posed and the question we have a stored answer for. It also comes with a few canned responses for given pieces of text. Some examples are Hello, Thanks, Woof (our ambassador mascot was a dog 🐶.) You can see a full list of canned responses [here](https://github.com/mintdigital/elixir-slackbot/blob/master/lib/rex_bot/matcher.ex#L53-L67).

This codebase could be used to control any type of chat system. This particular codebase excels well when trying to intemperate a users request and responding with a predictable response.

Where did this come from?
-------------

This project was born from a Mint Web App Weekender idea. The problem we were attempting to solve was simple

> I am fed up of repeating company specific information to employees.

This is when Rex was born. A definition of rex:

> You feed Rex information your team needs to know, and Rex uses it to answer questions employees have.
>
> For small-medium sized companies focusing on growth, Rex helps you record and distribute important internal information your workforce needs. Using Rex to handle low-value queries frees your team up to focus on the things that really matter.

If you want to read more information on the actual idea, feel free to read [Why we killed the Slack chatbot we built for small businesses](https://medium.com/mint-digital/why-we-killed-the-slack-chatbot-we-built-for-small-businesses-e4572dd64d9) by [Stuart Waterman](https://twitter.com/stu_waterman).

Is it Production ready?
-------------

- This codebase could be deployed on something like  heroku tomorrow and it will work out of the box. But, as described, we use ElasticSearch. We feel this would not be sufficient for production use. It is unpredictable in whether it would match or not. You can configure it as best you can but we were were not happy it would be 100% reliable. Rex was not something we wanted to pursue for many reasons. Yet, if we were to carry on with it we would look to have made use of a Python NLP library. This would allow us to have a lot more control over this.

- There is no logging on a response to a user at the moment. If you pushed it live you would have no idea what responses are being returned to the user. This makes it hard to know if the user is having a good or bad experience.

- Finally, it is using Docker as a container. We chose to use Elixir so that we could exploit it's concurrency and split the work across many nodes. Docker doesn't allow you to do that. If you want to understand more about this problem please see [Elixir deployments on AWS](https://medium.com/mint-digital/elixir-deployments-on-aws-ee787aa02a9d).

- Not everybody uses Slack. You may want to look at supporting many platforms, although as an MVP we believe slack is sufficient.

Technical setup
-------------

### Creating slack application

1. First you will want to follow the instructions on [Bot Users](https://api.slack.com/bot-users). You are looking to create a new "Custom bot user".

2. Once you have filled out the Integration Settings you will receive a API token, keep this safe for when you update your `.env` file in the installation steps.

3. Final thing you need to do is find the `team_id`. There is no easy way to find this, the best way I found was to make an API call.
  - Create a test token [here](https://api.slack.com/custom-integrations/legacy-tokens)
  - Then test the `auth.test` method by clicking the [Test Method](https://api.slack.com/methods/auth.test/test) button.
  - You should see a JSON response, with one of the fields being `team_id`. Again, keep this safe for when you create your first record later.

### Installation

1. Install [Docker for Mac](https://docs.docker.com/engine/installation/mac/) if you haven't already.

2. Install [Docker Compose](https://docs.docker.com/compose/install/) if you haven't already.

3. In Terminal, go to your projects directory and clone the project:

        cd ~/Documents/Projects/
        git clone git@github.com:mintdigital/elixir-slackbot.git

4. Copy the environment files

        cp .env.example .env

5. Change the values in `.env` file.

6. Build Docker

        docker-compose build

7. Install Dependencies

        docker-compose run server mix deps.get

9. Run the app!

        docker-compose up

If Mix hangs when running this, please try `docker-compose run server bash -c "mix compile 1>&1"` before hand. There is a known [issue](https://github.com/elixir-lang/elixir/issues/3342) on the Elixir Lang GitHub repository.

### Creating your first record

Run:
```
  docker-compose run server iex -S mix
```

Then:

_Don't forget to replace `{your_index_name}` with the value you added against `ELASTICSEARCH_INDEX_NAME` in your `.env` file. And replace `{your_team_id}` with the team id you kept safe from earlier 😉._

```
    alias Tirexs.HTTP, as: THTTP

    # Create the index
    THTTP.put("/{your_index_name}")

    # Add questions to the index
    THTTP.put("/{your_index_name}/questions/1", [
      question: "Where is the nearest Post Office to the UK office?",
      answer:   "Around the corner, near sainsburys",
      team:     "{your_team_id}",
    ])

    # Check if it worked
    Elasticsearch.HTTP.run_search(
      "Where is the nearest Post Office to the UK office?",
      "{your_team_id}"
    )
```

Granted, this is not an ideal way to input questions. We had a seperate web UI service which connected to the same ElasticSearch service which achieved this. Unfortunately this is not open sourced right now.

Testing
-------------

Once you have done all of the above, you should be able to manually test the bot is working.

1. run `docker-compose up`
2. Return to your Slack account.
3. Search for your bot in the _Direct Messages_ list.
4. Send a private message of `Woof`. You should see `Woof back atcha!` as a response.

If you wanted to test the record you created above simply send a private message of `Post Office` and it should return the response of `Around the corner, near sainsburys`.

Deployment
-------------

Clearly you cannot use the testing approach as you have above otherwise this would require you to always have your computer online, and pretty soon your local ElasticSearch service will fill up with sensetive data. So you will need a deployment solution.

You can deploy this application in any way you choose. As long as it has internet access and supports docker deployments.

We personally chose to use AWS ElasticBeanstalk but you could use Heroku, Digital Ocean or something similar.
