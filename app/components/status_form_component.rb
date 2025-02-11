class StatusFormComponent < ViewComponent::Base
  def initialize(form:)
    @form = form
  end

  private

  attr_reader :form
end
