require 'ruboty'
require 'ruboty/leyak_core/brain_wrapper'

module Ruboty
  module LeyakCore
    module Actions
      class Base < Ruboty::Actions::Base
        private

        def messages
          @messages ||= []
        end

        def store
          @store ||= Ruboty::LeyakCore::BrainWrapper.new(message.robot.brain, self.class.get_store_namespace)
        end

        class << self
          def store_namespace(name)
            @store_namespace = name.to_s
          end

          def get_store_namespace
            @store_namespace
          end
        end
      end
    end
  end
end
