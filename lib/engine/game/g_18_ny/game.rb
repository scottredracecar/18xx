# frozen_string_literal: true

require_relative 'map'
require_relative 'meta'
require_relative 'entities'

module Engine
  module Game
    module G18NY
      class Game < Game::Base
        include_meta(G18NY::Meta)
        include G18NY::Entities
        include G18NY::Map

        CAPITALIZATION = :incremental
        HOME_TOKEN_TIMING = :operate

        CURRENCY_FORMAT_STR = '$%d'

        BANK_CASH = 12_000

        CERT_LIMIT = { 2 => 28, 3 => 20, 4 => 16, 5 => 13, 6 => 11 }.freeze

        STARTING_CASH = { 2 => 900, 3 => 600, 4 => 450, 5 => 360, 6 => 300 }.freeze

        MIN_BID_INCREMENT = 5
        MUST_BID_INCREMENT_MULTIPLE = true

        SELL_BUY_ORDER = :sell_buy

        GAME_END_CHECK = { bank: :full_or, custom: :immediate }.freeze

        ALL_COMPANIES_ASSIGNABLE = true

        # Two lays with one being an upgrade. Tile lays cost 20
        TILE_LAYS = [
          { lay: true, upgrade: true, cost: 20, cannot_reuse_same_hex: true },
          { lay: true, upgrade: :not_if_upgraded, cost: 20, cannot_reuse_same_hex: true },
        ].freeze

        TRACK_RESTRICTION = :permissive

        MARKET = [
          %w[70 75 80 90 100p 110 125 150 175 200 230 260 300 350 400
             450 500],
          %w[65 70 75 80x 90p 100 110 125 150 175 200 230 260 300 350
             400 450],
          %w[60 65 70 75x 80p 90 100 110 125 150 175 200 230 260 300 350
             400],
          %w[55 60 65 70x 75p 80 90 100 110 125 150 175],
          %w[50 55 60 65x 70p 75 80 90 100 110 125],
          %w[40 50 55 60x 65p 70 75 80 90 100],
          %w[30 40 50 55x 60 65 70 75 80],
          %w[20 30 40 50x 55 60 65 70],
          %w[10 20 30 40 50 55 60],
          %w[0c 10 20 30 40 50],
          %w[0c 0c 10 20 30],
        ].freeze

        MARKET_TEXT = Base::MARKET_TEXT.merge(par_1: 'Minor Corporation Par',
                                              par: 'Major Corporation Par')
        STOCKMARKET_COLORS = Base::STOCKMARKET_COLORS.merge(par_1: :gray, par: :red).freeze

        PHASES = [
          {
            name: '2H',
            train_limit: { minor: 2, major: 4 },
            tiles: [:yellow],
            operating_rounds: 1,
            status: %w[float_20],
          },
          {
            name: '4H',
            on: '4H',
            train_limit: { minor: 2, major: 4 },
            tiles: %i[yellow green],
            operating_rounds: 2,
            status: %w[float_30 can_buy_companies],
          },
          {
            name: '6H',
            on: '6H',
            train_limit: { minor: 1, major: 3 },
            tiles: %i[yellow green],
            operating_rounds: 2,
            status: %w[float_40 can_buy_companies],
          },
          {
            name: '12H',
            on: '12H',
            train_limit: { minor: 1, major: 2 },
            tiles: %i[yellow green brown],
            operating_rounds: 3,
            status: %w[float_50],
          },
          {
            name: '5DE',
            on: '5DE',
            train_limit: { major: 2 },
            tiles: %i[yellow green brown],
            operating_rounds: 3,
            status: %w[fullcap float_60],
          },
          {
            name: 'D',
            on: 'D',
            train_limit: { major: 2 },
            tiles: %i[yellow green brown gray],
            operating_rounds: 3,
            status: %w[fullcap float_60],
          },
        ].freeze

        TRAINS = [{ name: '2H', num: 11, distance: 2, price: 100, rusts_on: '6H' },
                  { name: '4H', num: 6, distance: 4, price: 200, rusts_on: '5DE' },
                  { name: '6H', num: 4, distance: 6, price: 300, rusts_on: 'D' },
                  {
                    name: '12H',
                    num: 2,
                    distance: 12,
                    price: 600,
                    events: [{ type: 'remove_corporations' }, { type: 'nyc_formation' }],
                  },
                  { name: '12H', num: 1, distance: 12, price: 600, events: [{ type: 'capitalization_round' }] },
                  {
                    name: '5DE',
                    num: 2,
                    distance: [{ nodes: %w[city offboard town], pay: 5, visit: 99, multiplier: 2 }],
                    price: 800,
                  },
                  { name: 'D', num: 20, distance: 99, price: 1000 }].freeze

        def stock_round
          Round::Stock.new(self, [
            G18NY::Step::BuySellParShares,
          ])
        end

        def issuable_shares(entity)
          return [] if !entity.corporation? || entity.type != :major

          max_issuable = entity.num_player_shares - entity.num_market_shares
          return [] unless max_issuable.positive?

          bundles_for_corporation(entity, entity, shares: entity.shares_of(entity).first(max_issuable))
        end

        def redeemable_shares(entity)
          return [] if !entity.corporation? || entity.type != :major

          [@share_pool.shares_of(entity).find { |s| s.price <= entity.cash }&.to_bundle].compact
        end

        def check_sale_timing(_entity, corporation)
          return true if corporation.name == 'NYC'

          super
        end

        def can_par?(corporation, _parrer)
          return false if corporation.name == 'NYC'

          super
        end

        def can_hold_above_limit?(_entity)
          true
        end
      end
    end
  end
end
