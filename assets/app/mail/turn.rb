# frozen_string_literal: true

require_relative '../view/log.rb'
require_relative '../view/game/players.rb'
require_relative '../view/game/spreadsheet.rb'

class Turn < Snabberb::Component
  needs :game_data
  needs :game_url
  needs :game, store: true, default: nil

  def render
    @game = Engine::Game.load(@game_data)

    store(:game, @game, skip: true)

    h(:div, [
      render_link,
      h(View::Log, log: @game.log.last(20)),
      h(View::Game::Players, game: @game),
      h(View::Game::Spreadsheet, game: @game),
    ])
  end

  def render_link
    props = {
      attrs: { href: @game_url },
    }

    h(:a, props, "Go To Game #{@game_data[:id]}")
  end
end
