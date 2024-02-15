module Order::Positionable
  extend ActiveSupport::Concern

  included do
    acts_as_list

    private
      def set_default_position_after_create?
        position != default_position
      end
  end
end
