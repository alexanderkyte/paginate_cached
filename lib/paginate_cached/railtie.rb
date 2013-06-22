require 'paginate_cached/paginate_cached.rb'

ActiveSupport.on_load(:action_controller) do
    include PaginateCached::ControllerHelpers
end
