module RecordIdentifierHelper
  include ActionView::RecordIdentifier

  def css_id(*args)
    "##{dom_id(*args)}"
  end
end
