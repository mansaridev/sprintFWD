module ErrorHandler
    extend ActiveSupport::Concern
  
    included do
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    end
  
    private
  
    def record_not_found(exception)
  
      model_name = exception.message.match(/Couldn't find (\w+)/)[1].underscore.humanize
      flash[:alert] = t('flash.not_found', model: model_name)
      redirect_to root_path
    end
  end
  