# TODO: Refactor this model to use an internal Game Model instead
# of containing the game logic directly.
class window.Table extends Backbone.Model
  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'players', []

    # instantiate players
    for i in [0...1]
      player = new Player(false, 100)
      player.add(new Hand([deck.pop(), deck.pop()], @deck))
      player.on 'bust', @bust(player)
      player.on 'turnOver', @stand(player)
      player.on 'switchedHands', @trigger 'update'
      @get 'players'.push(player)

    #set current player
    @set 'currentPlayer', @get 'players'[0]

    #instantiate dealer
    dealer = new Player(true)
    dealer.add(new Hand([deck.pop(), deck.pop()], @deck))
    dealer.on 'bust', @dealerBust
    dealer.on 'stand', @dealerStand
    @set 'dealer', dealer

  bust: (player) ->
    player.lose()

  stand: (player) ->
    # in the player
    #   how many hands
    #     if last hand
    #       go to next player
    #         if last player
    #           go to to dealer

  dealerBust: ->
    #go through round
    #give bets back.
    `
    players.forEach(function(player) {
      player.win()
    });
    `


  dealerStand: ->
