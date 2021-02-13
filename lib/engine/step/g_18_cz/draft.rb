# frozen_string_literal: true

require_relative '../base'

module Engine
  module Step
    module G18CZ
      class Draft < Base
        attr_reader :companies, :choices

        ACTIONS = %w[bid pass].freeze

        def setup
          @companies = @game.companies.sort
        end

        def available
          @companies
        end

        def may_purchase?(_company)
          true
        end

        def auctioning; end

        def bids
          {}
        end

        def visible?
          true
        end

        def players_visible?
          true
        end

        def name
          'Draft'
        end

        def description
          'Draft Private Companies'
        end

        def finished?
          @companies.empty? || entities.all?(&:passed?)
        end

        def actions(entity)
          return [] if finished?

          entity == current_entity ? ACTIONS : []
        end

        def process_bid(action)
          company = action.company
          player = action.entity
          price = action.price

          company.owner = player
          player.companies << company
          player.spend(price, @game.bank)

          @companies.delete(company)

          @log << "#{player.name} buys #{company.name} for #{@game.format_currency(price)}"

          action.entity.unpass!
          @round.next_entity_index!
          action_finalized
        end

        def process_pass(action)
          @log << "#{action.entity.name} passes"
          action.entity.pass!
          @round.next_entity_index!
          action_finalized
        end

        def action_finalized
          return unless finished?

          @companies.each do |c|
            @log << "#{c.name} is removed from the game"
            @game.companies.delete(c)
          end
          @round.reset_entity_index!
        end

        def committed_cash(_player, _show_hidden = false)
          0
        end

        def min_bid(company)
          return unless company

          company.value
        end
      end
    end
  end
end
