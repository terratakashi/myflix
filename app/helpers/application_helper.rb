module ApplicationHelper
  def options_for_video_review(selected = nil)
    options_for_select(5.downto(1).map { |i| [pluralize(i, "Star"), i] }, selected)
  end
end
