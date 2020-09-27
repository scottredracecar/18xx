# frozen_string_literal: true

require_relative '../config/game/g_18_scotland'
require_relative 'base'

module Engine
  module Game
    class G18Scotland < Base
      load_from_json(Config::Game::G18Scotland::JSON)

      DEV_STAGE = :prealpha

      AXES = { x: :letter, y: :number }.freeze

      GAME_LOCATION = 'Scotland'
      GAME_RULES_URL = 'https://www.dropbox.com/s/x0dsehrxqr1tl6w/18Chesapeake_Rules.pdf'
      GAME_DESIGNER = 'Scott Petersen'
      GAME_PUBLISHER = Publisher::INFO[:all_aboard_games]
      GAME_INFO_URL = 'https://github.com/tobymao/18xx/wiki/18Scotland'
    end
  end
end
