# frozen_string_literal: true

require_relative '../config/game/g_18_new_england'
require_relative 'base'

module Engine
  module Game
    class G18NewEngland < Base

      DEV_STAGE = :prealpha

      load_from_json(Config::Game::G18NewEngland::JSON)

      GAME_RULES_URL = 'https://docs.google.com/document/d/1hgh1_-RMgEnQI1XlodT_6UpPU5ZnEZtMT6Yg5TOuXOw'
      GAME_DESIGNER = 'Scott Petersen'
      GAME_PUBLISHER = :all_aboard_games

      SELL_BUY_ORDER = :sell_buy
      MUST_BUY_TRAIN = :never # majors are required, fix this

      HOME_TOKEN_TIMING = :float
      MUST_BUY_TRAIN = :always # mostly true, needs custom code
      POOL_SHARE_DROP = :none
      SELL_MOVEMENT = :left_block_pres
      SELL_AFTER = :operate
      SELL_BUY_ORDER = :sell_buy
      EBUY_DEPOT_TRAIN_MUST_BE_CHEAPEST = true
      GAME_END_CHECK = { stock_market: :current_or, bank: :full_or }.freeze

      TILE_LAYS = [{ lay: true, upgrade: true }, { lay: true, upgrade: :not_if_upgraded, cost: 20 }].freeze


    end
  end
end
