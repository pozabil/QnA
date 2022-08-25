module ApplicationHelper
  def short_filename(file)
    name_length = 30

    if file.filename.to_s.length > name_length
      file.filename.to_s[0, (name_length - 2 - file.filename.extension_with_delimiter.length)] + '..' + file.filename.extension_with_delimiter
    else
      file.filename.to_s
    end
  end
end
