class window.Hand extends Backbone.Collection
  model: Card

  initialize: (cards, @deck, @isDealer) ->
    @hitCount = 0
    @bet = 5

  split: ->
    if @collection[0] == @collection[1] and @hitCount == 0
      @trigger 'split'

  doubleDown: ->
    if @hitCount == 0
      @hit()
      @hitCount = -1

  hit: ->
    if @hitCount != -1
      @add(@deck.pop())
      @calcScore()
      @hitCount++

  calcScore: ->
    if Math.min(scores[0], scores[1]) > 21
      @trigger 'bust'
    else if Math.min(scores[0], scores[1]) > 16
      if @isDealer
        @trigger 'stand'

  stand: ->
    @trigger 'stand'

  dealerPlay: ->
    while (scores[0] < 17 or scores[1] < 17)
      @hit()

  plusBet: ->
    @bet += 5

  minusBet: ->
    @bet -= 5

  hasAce: -> @reduce (memo, card) ->
    memo or card.get('value') is 1
  , 0

  minScore: -> @reduce (score, card) ->
    score + if card.get 'revealed' then card.get 'value' else 0
  , 0

  scores: ->
    # The scores are an array of potential scores.
    # Usually, that array contains one element. That is the only score.
    # when there is an ace, it offers you two scores - the original score, and score + 10.
    [@minScore(), @minScore() + 10 * @hasAce()]
