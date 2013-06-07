# -*- coding: utf-8 -*-

module ApplicationHelper
  def title
    base_title = "rExamination"
      if @title.nil?
        "#{base_title}"
      else
        "#{base_title} | #{@title}"
      end
  end

  def list_tag(hash)
    content_tag(:ul) do
      hash.map do |category, sub_categories|
        h content_tag(:li, category.title+list_tag(sub_categories))
      end.join
    end
  end
end
