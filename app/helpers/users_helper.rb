module UsersHelper

  def meta_pluralize number, noun, plural = nil
    raw("<span>#{number || 0}</span>" + ((number == 1 || number =~ /%r^1(\.0+)?$/ ) ? noun : (plural || noun.pluralize)))
  end

end