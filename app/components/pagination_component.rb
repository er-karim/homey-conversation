class PaginationComponent < ViewComponent::Base
  def initialize(current_page:, total_pages:)
    @current_page = current_page.to_i
    @total_pages = total_pages.to_i
  end

  private

  attr_reader :current_page, :total_pages

  def page_numbers
    return [] if total_pages <= 1

    visible_pages = [ 1 ]

    if total_pages > 1
      start_page = [ current_page - 2, 2 ].max
      end_page = [ current_page + 2, total_pages - 1 ].min

      visible_pages << "..." if start_page > 2
      visible_pages.concat((start_page..end_page).to_a)
      visible_pages << "..." if end_page < total_pages - 1
      visible_pages << total_pages
    end

    visible_pages.uniq
  end
end
