---
---

# basic namespace

window.leadpagesUX ||= {}

# onboarding script

leadpagesUX.onboarding =

  init: () ->

    @h1 = document.querySelector('.onboardingTitle h1')
    @h2 = document.querySelector('.onboardingTitle h2')
    @onboardingBody = document.querySelector('.onboardingBody')
    @questionnaireWrapper = document.querySelector('.questionnaireWrapper')
    @pathInnerWrapper = document.querySelector('.pathInnerWrapper')

    @backButton = document.querySelector('.button__back')
    @skipButton = document.querySelector('.button__skip')
    @nextButton = document.querySelector('.button__next')

    @bindings()

  bindings: ->

    _t = this

    # bind trigger functionality

    triggers = document.querySelectorAll('.triggerWrapper .trigger')

    [].forEach.call(triggers, (trigger) ->
      trigger.addEventListener('click', ->
        q = trigger.dataset.questionnaire
        if q is 'explore'
          _t.skipQuestions()
        else
          _t.questionnaire = _t.questionnaires[q][0]
          _t.startQuestions()
      )
    )

    @questionnaireWrapper.addEventListener('click', (e) ->
      srcElement = e.srcElement
      if e.srcElement.className is 'answer'
        _t.runAnswer(srcElement)
    )

    @onboardingBody.addEventListener('click', (e) ->
      srcElement = e.srcElement
      srcElementClasses = srcElement.classList
      
      if srcElementClasses.contains('button__back')
        _t.stepBack()

      else if srcElementClasses.contains('startOver')
        _t.restartQuestions()
    )



  # swapping questionnaire

  user_data: {}

  stepBack: ->
    _t = this

    if document.body.classList.contains('pathSteps')
      document.body.classList.remove('pathSteps')

      _t.user_data[_t.questionnaire[_t.currentQuestionnaireState].data] = null

      @changeHeadlines()
    
    else if @currentQuestionnaireState
      lastQuestionSet = @questionnaireWrapper.lastElementChild
      lastQuestionSet.classList.add('slideOut')
      setTimeout ( ->
        _t.questionnaireWrapper.removeChild(lastQuestionSet)

        if _t.currentQuestionnaireState is "A"
          _t.restartQuestions()

        else
          newLastQuestionSet = _t.questionnaireWrapper.lastElementChild
          _t.currentQuestionnaireState = newLastQuestionSet.dataset.state
          newLastQuestionSet.classList.remove('fadeOut')
          _t.changeHeadlines()

        try
          _t.user_data[_t.questionnaire[_t.currentQuestionnaireState].data] = null
      ), 400


  restartQuestions: ->
    @questionnaire = null
    @currentQuestionnaireState = null
    document.body.classList.remove('questionSteps')
    document.body.classList.remove('pathSteps')
    @resetHeadlines()

  startQuestions: ->
    @currentQuestionnaireState = 'A'
    @changeHeadlines()
    @addQuestions()

    document.body.classList.add('questionSteps')

  skipQuestions: ->
    @currentQuestionnaireState = 'A'
    document.body.classList.add('questionSteps')
    @addPath()

  runAnswer: (answer) ->

    _t = this

    dataType = _t.questionnaire[_t.currentQuestionnaireState].data
    answerData = answer.dataset.answer
    followup = answer.dataset.followup

    _t.user_data[dataType] = answerData

    if followup isnt 'undefined'
      @currentQuestionnaireState = followup
      @swapQuestions()
    else
      _t.addPath()

  swapQuestions: ->
    @changeHeadlines()
    @addQuestions()

  changeHeadlines: ->
    @h1.innerHTML = "<br />#{@questionnaire[@currentQuestionnaireState].h1 }"
    @h2.innerHTML = @questionnaire[@currentQuestionnaireState].h2

  resetHeadlines: ->
    @h1.innerHTML = "Welcome, Will!<br />What can we help you achieve?"
    @h2.innerHTML = "You’re going to accomplish a lot with Leadpages!  Tell us about your goals so we can customize your experience.  You can change your goal at any time."

  addPath: ->
    
    @h1.innerHTML = "<br />We recommend the Great Leadbox King path"
    @h2.innerHTML = ""

    document.body.classList.add('pathSteps')

  answerMarkup: (answer) ->
    "<span class='answer' data-answer='#{answer.data}' data-followup='#{answer.followup}'>#{answer.text}</span>"

  addQuestions: ->
    _t = this

    # all answers

    answers = @questionnaire[@currentQuestionnaireState].answers
    numQuestionSets = @questionnaireWrapper.querySelectorAll('.questionSet').length

    # build new answer

    answerHTML = "<div class='questionSet questionSet--#{@currentQuestionnaireState}' data-state='#{@currentQuestionnaireState}'>"
    [].forEach.call(answers, (answer) ->
      answerHTML += _t.answerMarkup(answer)
    )
    answerHTML += "</div>"

    # append new answer, fade out old one

    @questionnaireWrapper.lastElementChild.classList.add('fadeOut') if numQuestionSets > 0

    @questionnaireWrapper.insertAdjacentHTML('beforeend',answerHTML)

  questionnaires:
    'leadGathering': [
      'A': {
        'h1': 'What kind of website do you have?',
        'h2': 'You’re off the ground and you’ve got some traffic. That’s awesome!  Let’s start turning your visitors into leads.',
        data: 'Type of site',
        'answers': [
          {
            data: 'website',
            text: 'I sell products or services',
            followup: 'B'
          },
          {
            data: 'blog',
            text: 'I have a blog',
            followup: 'B'
          },
          {
            data: 'webinar',
            text: 'I have a webinar',
            followup: 'C'
          },
          {
            data: 'website',
            text: 'I do something else',
            followup: 'B'
          }
        ]
      },
      'B': {
        'h1': 'How much traffic does your website get?',
        'h2': 'The more visitors you have, the more leads you can convert.',
        data: 'Site traffic',
        'answers': [
          {
            data: '>10000',
            text: 'More than 10,000+ visitors/month',
            followup: 'D'
          },
          {
            data: '5001-10000',
            text: '5,001 - 10,000 visitors/month',
            followup: 'D'
          },
          {
            data: '1000-5000',
            text: '1,000 - 5,000 visitors/month',
            followup: 'D'
          },
          {
            data: '<1000',
            text: 'Less than 1000 visitors/month',
            followup: 'D'
          }
        ]
      },
      'C': {
        'h1': 'How many viewers does your webinar have?',
        'h2': 'The more viewers you have, the more leads you can convert.',
        data: 'Webinar viewers',
        'answers': [
          {
            data: '500+',
            text: '500+ viewers',
            followup: 'D'
          },
          {
            data: '100-500',
            text: '100 - 500 viewers',
            followup: 'D'
          },
          {
            data: '<100',
            text: 'Less than 100 viewers',
            followup: 'D'
          }
        ]
      },
      'D': {
        'h1': "What's your level of experience in digital marketing?",
        'h2': '',
        data: 'Experience',
        'answers': [
          {
            data: 'advanced',
            text: "I'm a digital marketing rockstar"
          },
          {
            data: 'medium',
            text: "I've done a little bit"
          },
          {
            data: 'beginner',
            text: "I'm just starting out"
          }
        ]
      }
    ],
    'landingPage': [
      'A': {
        'h1': 'Landing page?',
        'h2': 'You are a landing page!!1',
        data: 'page!!1',
        'answers': [
          {
            data: 'website',
            text: 'I sell products or services'
          },
          {
            data: 'blog',
            text: 'I have a blog'
          },
          {
            data: 'webinar',
            text: 'I have a webinar'
          },
          {
            data: 'website',
            text: 'I do something else'
          }
        ]
      }
    ],
    'idea': [
      'A': {
        'h1': 'You have idea??',
        'h2': 'I like M&Ms',
        data: 'idea tyme!',
        'answers': [
          {
            data: 'website',
            text: 'I sell products or services'
          },
          {
            data: 'blog',
            text: 'I have a blog'
          },
          {
            data: 'webinar',
            text: 'I have a webinar'
          },
          {
            data: 'website',
            text: 'I do something else'
          }
        ]
      }
    ]











