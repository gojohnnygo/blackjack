class window.Player extends Backbone.Collection
  model: Hand

  initialize: (@isDealer, @deck, @bank) ->
    @numHands = 0
    @currentHand = @collection[@numHands]
    @collection.on 'split', @split(hand)
    @collection.on 'bust',  @bust(hand)
    @collection.on 'stand', @stand(hand)

  hit: ->
    @get 'currentHand'.hit()

  stand: ->
    if @numHands < @collection.length
      @currentHand.set 'chosen', false
      @currentHand = @collection[++@numHands]
      @currentHand.set 'chosen', true
      @trigger('switchedHands')
    else
      @numHands = 0
      @trigger 'turnOver'

  plusBet: ->
    @currentHand.plusBet()

  minusBet: ->
    @currentHand.minusBet()

  split: (hand) ->
    @collection.add(new Hand([hand.remove()], hand.get('deck')))

  bust: (hand) ->
    @currentHand = hand
    @trigger 'bust'

  lose: ->
    @bank -= @currentHand.get 'bet'
    @collection.remove(@currentHand)
    @currentHand = null
