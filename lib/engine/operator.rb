# frozen_string_literal: true

require_relative 'entity'

module Engine
  module Operator
    include Entity

    attr_accessor :rusted_self, :coordinates
    attr_reader :color, :city, :loans, :logo, :simple_logo, :operating_history, :text_color, :tokens, :trains

    def init_operator(opts)
      @cash = 0
      @trains = []
      @operating_history = {}
      # phase rusts happen before a train actually buys, so there is a race condition
      # where buying a train rusts yourself and it looks like you must buy a train
      @rusted_self = false
      @logo = "/logos/#{opts[:logo]}.svg"
      @simple_logo = opts[:simple_logo] ? "/logos/#{opts[:simple_logo]}.svg" : @logo
      @coordinates = opts[:coordinates]
      @city = opts[:city]
      @tokens = opts[:tokens].map { |price| Token.new(self, price: price) }
      @loans = []
      @color = opts[:color]
      @text_color = opts[:text_color] || '#ffffff'
    end

    def operator?
      true
    end

    def runnable_trains
      @trains.reject(&:operated)
    end

    def operated?
      !@operating_history.empty?
    end

    def next_token
      @tokens.find { |t| !t.used }
    end

    def find_token_by_type(type = nil)
      type ||= :normal
      @tokens.find { |t| !t.used && t.type == type }
    end

    def tokens_by_type
      @tokens.reject(&:used).uniq(&:type)
    end

    def unplaced_tokens
      @tokens.reject(&:city)
    end

    def placed_tokens
      @tokens.select(&:city)
    end
  end
end
